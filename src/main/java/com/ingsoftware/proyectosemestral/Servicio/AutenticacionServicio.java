package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Seguridad.SolicitudAutenticacion;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;

@Service
public class AutenticacionServicio {

    @Autowired
    private AuthenticationManager gestorAutenticacion;

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Autowired
    private PasswordEncoder codificadorDeContrasena;

    @Autowired
    private JavaMailSender remitenteDeCorreo;

    public UserDetails iniciarSesion(SolicitudAutenticacion solicitud) {
        Authentication autenticacion = gestorAutenticacion.authenticate(
                new UsernamePasswordAuthenticationToken(solicitud.getRut(), solicitud.getContrasena()));

        SecurityContextHolder.getContext().setAuthentication(autenticacion);
        return (UserDetails) autenticacion.getPrincipal();
    }

    public void solicitarRecuperacionClave(String email) {
        Usuario usuario = usuarioRepositorio.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con email: " + email));

        String token = generarTokenNumerico();

        LocalDateTime expiracion = LocalDateTime.now().plusHours(1);

        usuario.setTokenRecuperacion(token);
        usuario.setToken_rec_expiracion(expiracion);
        usuarioRepositorio.save(usuario);

        enviarCorreoRecuperacion(usuario.getEmail(), token);
    }

    public void resetearClave(String token, String nuevaContrasena) {
        Usuario usuario = usuarioRepositorio.findByTokenRecuperacion(token)
                .orElseThrow(() -> new RuntimeException("Código de recuperación inválido o no encontrado"));


        if (usuario.getToken_rec_expiracion().isBefore(LocalDateTime.now())) {
            usuario.setTokenRecuperacion(null);
            usuario.setToken_rec_expiracion(null);
            usuarioRepositorio.save(usuario);
            throw new RuntimeException("El código de recuperación ha expirado");
        }

        usuario.setContrasena(codificadorDeContrasena.encode(nuevaContrasena));
        usuario.setTokenRecuperacion(null);
        usuario.setToken_rec_expiracion(null);
        usuarioRepositorio.save(usuario);
    }

    private void enviarCorreoRecuperacion(String destinatario, String token) {
        try {
            MimeMessage mensaje = remitenteDeCorreo.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mensaje, "utf-8");

            helper.setTo(destinatario);
            helper.setSubject("Código de Recuperación - Proyecto Cáncer Gástrico");

            String htmlMsg = String.format(
                    "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; max-width: 600px;'>" +
                            "  <h2 style='color: #333;'>Recuperación de Contraseña</h2>" +
                            "  <p style='font-size: 14px; color: #555;'>Hola,</p>" +
                            "  <p style='font-size: 14px; color: #555;'>Has solicitado restablecer tu contraseña. Usa el siguiente código de verificación:</p>" +
                            "  <div style='margin: 25px 0; text-align: center;'>" +
                            "    <span style='font-size: 36px; font-weight: bold; color: #0056b3; letter-spacing: 8px; background-color: #f8f9fa; padding: 10px 20px; border-radius: 5px; border: 1px dashed #0056b3;'>%s</span>" +
                            "  </div>" +
                            "  <p style='font-size: 14px; color: #555;'>Este código expirará en <strong>1 hora</strong>.</p>" +
                            "  <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>" +
                            "  <p style='font-size: 12px; color: #999;'>Si no solicitaste este cambio, por favor ignora este correo.</p>" +
                            "</div>",
                    token
            );

            helper.setText(htmlMsg, true);

            remitenteDeCorreo.send(mensaje);
        } catch (MessagingException e) {
            throw new RuntimeException("Error al enviar el correo de recuperación", e);
        }
    }

    private String generarTokenNumerico() {
        SecureRandom random = new SecureRandom();
        int numero = 100000 + random.nextInt(900000);
        return String.valueOf(numero);
    }
}