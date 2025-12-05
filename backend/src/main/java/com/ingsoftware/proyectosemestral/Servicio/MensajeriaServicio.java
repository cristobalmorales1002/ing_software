package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.MensajeBandejaDto;
import com.ingsoftware.proyectosemestral.DTO.MensajeEnviadoDto;
import com.ingsoftware.proyectosemestral.DTO.MensajeEnvioDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class MensajeriaServicio {

    @Autowired
    private MensajeRepositorio mensajeRepositorio;
    @Autowired
    private DestinatarioMensajeRepositorio destinatarioRepositorio;
    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Autowired
    private JavaMailSender mailSender;

    @Transactional
    public void enviarMensaje(Long emisorId, MensajeEnvioDto dto) {
        Usuario emisor = usuarioRepositorio.findById(emisorId)
                .orElseThrow(() -> new RuntimeException("Emisor no encontrado"));

        Mensaje mensaje = Mensaje.builder()
                .asunto(dto.getAsunto())
                .contenido(dto.getContenido())
                .fechaEnvio(LocalDateTime.now())
                .emisor(emisor)
                .build();

        mensaje = mensajeRepositorio.save(mensaje);

        Set<Usuario> usuariosDestino = new HashSet<>();

        if (dto.isEnviarATodos()) {
            usuariosDestino.addAll(usuarioRepositorio.findAll());
        }
        else if (dto.getEnviarARol() != null && !dto.getEnviarARol().isEmpty()) {
            List<Usuario> todos = usuarioRepositorio.findAll();
            for(Usuario u : todos){
                if(u.tieneRol(dto.getEnviarARol())) {
                    usuariosDestino.add(u);
                }
            }
        }

        if (dto.getDestinatariosIds() != null) {
            List<Usuario> especificos = usuarioRepositorio.findAllById(dto.getDestinatariosIds());
            usuariosDestino.addAll(especificos);
        }

        usuariosDestino.remove(emisor);

        for (Usuario destinatario : usuariosDestino) {

            DestinatarioMensaje dm = DestinatarioMensaje.builder()
                    .mensaje(mensaje)
                    .destinatario(destinatario)
                    .leido(false)
                    .eliminado(false)
                    .build();
            destinatarioRepositorio.save(dm);

            enviarNotificacionCorreo(emisor, destinatario, mensaje);
        }
    }

    private void enviarNotificacionCorreo(Usuario emisor, Usuario receptor, Mensaje mensaje) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, "utf-8");

            helper.setTo(receptor.getEmail());
            helper.setSubject("Nuevo Mensaje: " + mensaje.getAsunto());

            String htmlMsg = String.format(
                    "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; max-width: 600px; background-color: #ffffff;'>" +
                            "  <h2 style='color: #0056b3; border-bottom: 2px solid #0056b3; padding-bottom: 10px;'>Nuevo Mensaje Recibido</h2>" +
                            "  <p style='font-size: 14px; color: #555;'>Hola <strong>%s</strong>,</p>" +
                            "  <p style='font-size: 14px; color: #555;'>Tienes un nuevo mensaje de <strong>%s %s</strong> en la plataforma.</p>" +
                            "  " +
                            "  <div style='background-color: #f8f9fa; padding: 15px; border-left: 4px solid #0056b3; margin: 20px 0;'>" +
                            "    <p style='margin: 0 0 10px 0; font-weight: bold; color: #333;'>Asunto: %s</p>" +
                            "    <p style='margin: 0; color: #555; font-style: italic;'>\"%s\"</p>" +
                            "  </div>" +
                            "  " +
                            "  <p style='font-size: 14px; color: #555;'>Para responder, por favor ingresa a tu cuenta.</p>" +
                            "  <div style='text-align: center; margin-top: 25px;'>" +
                            "    <a href='http://localhost:3000/login' style='background-color: #0056b3; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;'>Ir a la Plataforma</a>" +
                            "  </div>" +
                            "  <hr style='border: 0; border-top: 1px solid #eee; margin: 30px 0;'>" +
                            "  <p style='font-size: 12px; color: #999; text-align: center;'>Proyecto Cáncer Gástrico - Notificaciones Automáticas</p>" +
                            "</div>",
                    receptor.getNombres(),
                    emisor.getNombres(),
                    emisor.getApellidos(),
                    mensaje.getAsunto(),
                    mensaje.getContenido()
            );

            helper.setText(htmlMsg, true);

            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            System.err.println("Error enviando correo a: " + receptor.getEmail() + " Error: " + e.getMessage());
        }
    }

    public void leerMensaje(Long idDestinatarioMensaje) {
        DestinatarioMensaje dm = destinatarioRepositorio.findById(idDestinatarioMensaje)
                .orElseThrow(() -> new RuntimeException("Mensaje no encontrado"));

        if(!dm.isLeido()){
            dm.setLeido(true);
            dm.setFechaLectura(LocalDateTime.now());
            destinatarioRepositorio.save(dm);
        }
    }

    public List<MensajeBandejaDto> obtenerBandejaEntrada(Long idUsuario) {
        List<DestinatarioMensaje> mensajesCrudos = destinatarioRepositorio
                .findByDestinatario_IdUsuarioAndEliminadoFalseOrderByMensaje_FechaEnvioDesc(idUsuario);

        return mensajesCrudos.stream()
                .map(dm -> MensajeBandejaDto.builder()
                        .id(dm.getId())
                        .asunto(dm.getMensaje().getAsunto())
                        .contenido(dm.getMensaje().getContenido())
                        .fechaEnvio(dm.getMensaje().getFechaEnvio())
                        .nombreEmisor(dm.getMensaje().getEmisor().getNombres() + " " + dm.getMensaje().getEmisor().getApellidos())
                        .emailEmisor(dm.getMensaje().getEmisor().getEmail())
                        .leido(dm.isLeido())
                        .build())
                .collect(Collectors.toList());
    }

    public List<MensajeEnviadoDto> obtenerEnviados(Long idUsuario) {
        // 1. Obtenemos las entidades desde la BD
        List<Mensaje> mensajes = mensajeRepositorio.findByEmisor_IdUsuarioOrderByFechaEnvioDesc(idUsuario);

        // 2. Las convertimos a DTOs incluyendo el resumen de nombres
        return mensajes.stream()
                .map(m -> MensajeEnviadoDto.builder()
                        .id(m.getId())
                        .asunto(m.getAsunto())
                        .contenido(m.getContenido())
                        .fechaEnvio(m.getFechaEnvio())
                        .destinatariosResumen(
                                m.getDestinatarios() == null ? "Sin destinatarios" : // Protección contra nulos
                                        m.getDestinatarios().stream()
                                                .map(dm -> dm.getDestinatario().getNombres()) // Obtenemos el nombre
                                                .collect(Collectors.joining(", ")) // Los unimos con comas
                        )
                        .build())
                .collect(Collectors.toList());
    }

    public long contarNoLeidos(Long idUsuario) {
        return destinatarioRepositorio.countByDestinatario_IdUsuarioAndLeidoFalseAndEliminadoFalse(idUsuario);
    }
}