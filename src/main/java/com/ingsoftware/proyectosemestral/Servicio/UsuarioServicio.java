package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.UsuarioActualizarDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioCreateDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioResponseDto;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

import java.security.SecureRandom;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UsuarioServicio {

    private final UsuarioRepositorio usuarioRepositorio;
    private final RolRepositorio rolRepositorio;
    private final PasswordEncoder passwordEncoder;
    private final RegistroServicio registroServicio;
    private final JavaMailSender remitenteDeCorreo; // Inyección para enviar emails

    @Autowired
    public UsuarioServicio(UsuarioRepositorio usuarioRepositorio,
                           RolRepositorio rolRepositorio,
                           PasswordEncoder passwordEncoder,
                           RegistroServicio registroServicio,
                           JavaMailSender remitenteDeCorreo) {
        this.usuarioRepositorio = usuarioRepositorio;
        this.rolRepositorio = rolRepositorio;
        this.passwordEncoder = passwordEncoder;
        this.registroServicio = registroServicio;
        this.remitenteDeCorreo = remitenteDeCorreo;
    }

    public List<UsuarioResponseDto> getAll() {
        return usuarioRepositorio.findAll().stream()
                .map(this::toResponseDto)
                .collect(Collectors.toList());
    }

    public UsuarioResponseDto getById(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        return toResponseDto(u);
    }

    @Transactional
    public UsuarioResponseDto create(UsuarioCreateDto dto) {
        usuarioRepositorio.findByRut(dto.getRut()).ifPresent(x -> {
            throw new RuntimeException("RUT ya registrado");
        });
        usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> {
            throw new RuntimeException("Email ya registrado");
        });

        // Generar contraseña aleatoria segura
        String contrasenaTemporal = generarContrasenaAleatoria();

        Usuario u = new Usuario();
        u.setRut(dto.getRut());
        u.setNombres(dto.getNombres());
        u.setApellidos(dto.getApellidos());
        u.setEmail(dto.getEmail());
        u.setTelefono(dto.getTelefono());

        // Guardar la contraseña encriptada
        u.setContrasena(passwordEncoder.encode(contrasenaTemporal));

        u.setActivo(true);

        Rol rol = rolRepositorio.findByNombre(dto.getRol())
                .orElseThrow(() -> new RuntimeException("Rol no existe: ".concat(dto.getRol())));
        u.getRoles().add(rol);

        Usuario saved = usuarioRepositorio.save(u);

        // Enviar correo de bienvenida con la contraseña
        enviarCorreoBienvenida(saved, contrasenaTemporal);

        return toResponseDto(saved);
    }

    @Transactional
    public UsuarioResponseDto update(Long id, UsuarioCreateDto dto) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));

        if (!u.getRut().equals(dto.getRut())) {
            usuarioRepositorio.findByRut(dto.getRut()).ifPresent(x -> { throw new RuntimeException("RUT ya en uso"); });
            u.setRut(dto.getRut());
        }
        if (!u.getEmail().equals(dto.getEmail())) {
            usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> { throw new RuntimeException("Email ya en uso"); });
            u.setEmail(dto.getEmail());
        }

        u.setNombres(dto.getNombres());
        u.setApellidos(dto.getApellidos());
        u.setTelefono(dto.getTelefono());

        // Solo actualizamos contraseña si el admin la envía explícitamente (reset manual)
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        }

        Rol nuevoRol = rolRepositorio.findByNombre(dto.getRol())
                .orElseThrow(() -> new RuntimeException("Rol no existe: " + dto.getRol()));
        u.getRoles().clear();
        u.getRoles().add(nuevoRol);

        Usuario saved = usuarioRepositorio.save(u);
        return toResponseDto(saved);
    }

    @Transactional
    public void desactivate(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(false);
        usuarioRepositorio.save(u);
    }

    @Transactional
    public void activate(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(true);
        usuarioRepositorio.save(u);
    }

    @Transactional
    public UsuarioResponseDto updateProfile(String rut, UsuarioActualizarDto dto) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con RUT: " + rut));

        if (dto.getEmail() != null && !dto.getEmail().isBlank() && !dto.getEmail().equals(u.getEmail())) {
            usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> {
                throw new RuntimeException("Email ya registrado");
            });
            u.setEmail(dto.getEmail());
        }

        if (dto.getTelefono() != null) {
            u.setTelefono(dto.getTelefono());
        }

        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        }

        Usuario saved = usuarioRepositorio.save(u);
        return toResponseDto(saved);
    }

    private UsuarioResponseDto toResponseDto(Usuario u) {
        String rolNombre = u.getRoles().stream()
                .findFirst()
                .map(Rol::getNombre)
                .orElse("SIN_ROL");

        return UsuarioResponseDto.builder()
                .usuarioId(u.getIdUsuario())
                .rut(u.getRut())
                .nombres(u.getNombres())
                .apellidos(u.getApellidos())
                .email(u.getEmail())
                .telefono(u.getTelefono())
                .rol(rolNombre)
                .estadoU(u.isActivo() ? "ACTIVO" : "INACTIVO")
                .build();
    }

    // MÉTODOS PRIVADOS PARA CORREO Y CONTRASEÑA

    private String generarContrasenaAleatoria() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10; i++) { // Contraseña de 10 caracteres
            int index = random.nextInt(caracteres.length());
            sb.append(caracteres.charAt(index));
        }
        return sb.toString();
    }

    private void enviarCorreoBienvenida(Usuario usuario, String contrasenaTemporal) {
        try {
            MimeMessage mensaje = remitenteDeCorreo.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mensaje, "utf-8");

            helper.setTo(usuario.getEmail());
            helper.setSubject("Bienvenido a la Plataforma - Credenciales de Acceso");

            String htmlMsg = String.format(
                    "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; max-width: 600px;'>" +
                            "  <h2 style='color: #0056b3;'>¡Bienvenido/a %s!</h2>" +
                            "  <p style='font-size: 14px; color: #555;'>Su cuenta en la plataforma de investigación ha sido creada exitosamente.</p>" +
                            "  <div style='background-color: #f8f9fa; padding: 15px; border-radius: 5px; border-left: 4px solid #0056b3; margin: 20px 0;'>" +
                            "    <p style='margin: 5px 0;'><strong>Usuario (RUT):</strong> %s</p>" +
                            "    <p style='margin: 5px 0;'><strong>Contraseña Temporal:</strong> <span style='font-family: monospace; font-size: 16px; color: #d63384;'>%s</span></p>" +
                            "  </div>" +
                            "  <p style='font-size: 14px; color: #555;'><strong>Importante:</strong> Esta contraseña fue generada automáticamente.</p>" +
                            "  <p style='font-size: 14px; color: #555;'>Si desea cambiarla por una de su preferencia, por favor utilice la opción <strong>'Recuperar Contraseña'</strong> en la pantalla de inicio de sesión.</p>" +
                            "  <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>" +
                            "  <p style='font-size: 12px; color: #999;'>Proyecto Cáncer Gástrico Ci2030</p>" +
                            "</div>",
                    usuario.getNombres(),
                    usuario.getRut(),
                    contrasenaTemporal
            );

            helper.setText(htmlMsg, true);
            remitenteDeCorreo.send(mensaje);

        } catch (MessagingException e) {
            // Loguear el error pero no detener la creación del usuario, o lanzar excepción según preferencia
            System.err.println("Error al enviar correo de bienvenida: " + e.getMessage());
        }
    }
}