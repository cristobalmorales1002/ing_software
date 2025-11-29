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
import org.springframework.transaction.annotation.Transactional;


import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UsuarioServicio {

    private final UsuarioRepositorio usuarioRepositorio;
    private final RolRepositorio rolRepositorio;
    private final PasswordEncoder passwordEncoder;
    private final RegistroServicio registroServicio;
    private final JavaMailSender remitenteDeCorreo;

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
        return usuarioRepositorio.findAll().stream().map(this::toResponseDto).collect(Collectors.toList());
    }

    public UsuarioResponseDto getById(Long id) {
        Usuario u = usuarioRepositorio.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        return toResponseDto(u);
    }

    @Transactional
    public UsuarioResponseDto create(UsuarioCreateDto dto) {
        usuarioRepositorio.findByRut(dto.getRut()).ifPresent(x -> { throw new RuntimeException("RUT ya registrado"); });
        usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> { throw new RuntimeException("Email ya registrado"); });

        String contrasenaTemporal = generarContrasenaAleatoria();

        Usuario u = new Usuario();
        u.setRut(dto.getRut());
        u.setNombres(dto.getNombres());
        u.setApellidos(dto.getApellidos());
        u.setEmail(dto.getEmail());
        u.setTelefono(dto.getTelefono());
        u.setContrasena(passwordEncoder.encode(contrasenaTemporal));
        u.setActivo(true);

        Rol rol = rolRepositorio.findByNombre(dto.getRol())
                .orElseThrow(() -> new RuntimeException("Rol no existe: ".concat(dto.getRol())));
        u.getRoles().add(rol);

        Usuario saved = usuarioRepositorio.save(u);
        enviarCorreoBienvenida(saved, contrasenaTemporal);
        return toResponseDto(saved);
    }

    @Transactional
    public UsuarioResponseDto update(Long id, UsuarioCreateDto dto) {
        Usuario u = usuarioRepositorio.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
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
        Usuario u = usuarioRepositorio.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(false);
        usuarioRepositorio.save(u);
    }

    @Transactional
    public void activate(Long id) {
        Usuario u = usuarioRepositorio.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(true);
        usuarioRepositorio.save(u);
    }

    @Transactional
    public UsuarioResponseDto updateProfile(String rut, UsuarioActualizarDto dto) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con RUT: " + rut));

        if (dto.getTelefono() != null) {
            u.setTelefono(dto.getTelefono());
        }

        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        }

        Usuario saved = usuarioRepositorio.save(u);
        return toResponseDto(saved);
    }

    // --- CAMBIO PRINCIPAL AQUÍ ---
    @Transactional
    public void solicitarCambioEmail(String rut, String nuevoEmail, String passwordActual) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // 1. Validar contraseña por seguridad
        if (!passwordEncoder.matches(passwordActual, u.getContrasena())) {
            throw new RuntimeException("La contraseña actual es incorrecta.");
        }

        // 2. Validar que el nuevo email no esté ocupado
        if (usuarioRepositorio.findByEmail(nuevoEmail).isPresent()) {
            throw new RuntimeException("El correo electrónico ya está registrado en el sistema.");
        }

        // 3. Generar Token
        String token = generarTokenNumerico();
        u.setTokenCambioEmail(token);
        u.setTokenCambioEmailExpiracion(LocalDateTime.now().plusMinutes(15));

        usuarioRepositorio.save(u);

        // 4. Enviar correo al NUEVO destinatario para verificar que existe
        enviarCorreoTokenEmail(nuevoEmail, token);
    }

    @Transactional(readOnly = true)
    public void validarTokenEmail(String rut, String token) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        if (u.getTokenCambioEmail() == null || !u.getTokenCambioEmail().equals(token)) {
            throw new RuntimeException("Token inválido");
        }
        if (u.getTokenCambioEmailExpiracion().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("El token ha expirado");
        }
    }

    @Transactional
    public void confirmarCambioEmail(String rut, String token, String nuevoEmail) {
        validarTokenEmail(rut, token);

        // Doble chequeo por si alguien se registró en el intertanto
        usuarioRepositorio.findByEmail(nuevoEmail).ifPresent(x -> {
            throw new RuntimeException("El nuevo correo ya está registrado por otro usuario");
        });

        Usuario u = usuarioRepositorio.findByRut(rut).get();
        String emailAntiguo = u.getEmail();

        u.setEmail(nuevoEmail);
        u.setTokenCambioEmail(null);
        u.setTokenCambioEmailExpiracion(null);

        usuarioRepositorio.save(u);

        registroServicio.registrarAccion(u, "CAMBIO_EMAIL",
                "Cambió correo de " + emailAntiguo + " a " + nuevoEmail);
    }

    @Transactional
    public void actualizarFoto(String rut, byte[] bytesFoto) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        u.setFotoPerfil(bytesFoto);
        usuarioRepositorio.save(u);
    }

    private UsuarioResponseDto toResponseDto(Usuario u) {
        String rolNombre = u.getRoles().stream()
                .findFirst()
                .map(Rol::getNombre)
                .orElse("SIN_ROL");

        String imagenBase64 = null;
        if (u.getFotoPerfil() != null && u.getFotoPerfil().length > 0) {
            imagenBase64 = java.util.Base64.getEncoder().encodeToString(u.getFotoPerfil());
        }

        return UsuarioResponseDto.builder()
                .usuarioId(u.getIdUsuario())
                .rut(u.getRut())
                .nombres(u.getNombres())
                .apellidos(u.getApellidos())
                .email(u.getEmail())
                .telefono(u.getTelefono())
                .rol(rolNombre)
                .estadoU(u.isActivo() ? "ACTIVO" : "INACTIVO")
                .fotoBase64(imagenBase64)
                .build();
    }

    private String generarContrasenaAleatoria() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 10; i++) {
            int index = random.nextInt(caracteres.length());
            sb.append(caracteres.charAt(index));
        }
        return sb.toString();
    }

    private String generarTokenNumerico() {
        SecureRandom random = new SecureRandom();
        int numero = 100000 + random.nextInt(900000);
        return String.valueOf(numero);
    }

    private void enviarCorreoBienvenida(Usuario usuario, String contrasenaTemporal) {
        try {
            MimeMessage mensaje = remitenteDeCorreo.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mensaje, "utf-8");
            helper.setTo(usuario.getEmail());
            helper.setSubject("Bienvenido a la Plataforma - Credenciales de Acceso");

            String htmlMsg = String.format(
                    "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; max-width: 600px;'>" +
                            "  <h2 style='color: #333;'>Bienvenido/a %s</h2>" +
                            "  <p style='font-size: 14px; color: #555;'>Su cuenta ha sido creada exitosamente.</p>" +
                            "  <p style='font-size: 14px; color: #555;'>A continuación sus credenciales temporales:</p>" +
                            "  <div style='margin: 25px 0; text-align: center;'>" +
                            "    <span style='font-size: 24px; font-family: monospace; font-weight: bold; color: #0056b3; letter-spacing: 2px; background-color: #f8f9fa; padding: 15px 25px; border-radius: 5px; border: 1px dashed #0056b3;'>%s</span>" +
                            "  </div>" +
                            "  <p style='font-size: 14px; color: #555;'><strong>Usuario:</strong> %s</p>" +
                            "  <p style='font-size: 14px; color: #555;'>Le recomendamos cambiar su contraseña al iniciar sesión.</p>" +
                            "  <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>" +
                            "  <p style='font-size: 12px; color: #999;'>Plataforma de Investigación Cáncer Gástrico</p>" +
                            "</div>",
                    usuario.getNombres(),
                    contrasenaTemporal,
                    usuario.getRut()
            );

            helper.setText(htmlMsg, true);
            remitenteDeCorreo.send(mensaje);
        } catch (MessagingException e) {
            System.err.println("Error al enviar correo de bienvenida: " + e.getMessage());
        }
    }

    private void enviarCorreoTokenEmail(String destinatario, String token) {
        try {
            MimeMessage mensaje = remitenteDeCorreo.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mensaje, "utf-8");
            helper.setTo(destinatario);
            helper.setSubject("Código de Verificación - Cambio de Correo");

            String htmlMsg = String.format(
                    "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px; max-width: 600px;'>" +
                            "  <h2 style='color: #333;'>Cambio de Correo</h2>" +
                            "  <p style='font-size: 14px; color: #555;'>Se ha solicitado usar este correo para una cuenta existente.</p>" +
                            "  <p style='font-size: 14px; color: #555;'>Use el siguiente código para confirmar:</p>" +
                            "  <div style='margin: 25px 0; text-align: center;'>" +
                            "    <span style='font-size: 36px; font-weight: bold; color: #0056b3; letter-spacing: 8px; background-color: #f8f9fa; padding: 10px 20px; border-radius: 5px; border: 1px dashed #0056b3;'>%s</span>" +
                            "  </div>" +
                            "  <p style='font-size: 14px; color: #555;'>Este código expira en <strong>15 minutos</strong>.</p>" +
                            "  <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>" +
                            "  <p style='font-size: 12px; color: #999;'>Si usted no solicitó esto, por favor ignore este correo.</p>" +
                            "</div>",
                    token
            );

            helper.setText(htmlMsg, true);
            remitenteDeCorreo.send(mensaje);
        } catch (MessagingException e) {
            throw new RuntimeException("Error al enviar token de email", e);
        }
    }


    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepositorio.findByEmail(email);
    }

    public UsuarioResponseDto getByRut(String rut) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + rut));
        return toResponseDto(u);
    }

    public Optional<Usuario> buscarPorRut(String rut) {
        return usuarioRepositorio.findByRut(rut);
    }
}