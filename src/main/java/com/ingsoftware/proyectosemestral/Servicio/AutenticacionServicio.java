package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Seguridad.SolicitudAutenticacion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

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

        // Genera un token único (UUID es una buena opción)
        String token = UUID.randomUUID().toString();
        // Establece la expiración (ej. 1 hora desde ahora)
        LocalDateTime expiracion = LocalDateTime.now().plusHours(1);

        // Guarda el token y la expiración en el usuario
        usuario.setTokenRecuperacion(token);
        usuario.setToken_rec_expiracion(expiracion);
        usuarioRepositorio.save(usuario);

        // Envía el correo
        enviarCorreoRecuperacion(usuario.getEmail(), token);
    }

    public void resetearClave(String token, String nuevaContrasena) {
        Usuario usuario = usuarioRepositorio.findByTokenRecuperacion(token)
                .orElseThrow(() -> new RuntimeException("Token de recuperación inválido o no encontrado"));

        // Valida que el token no haya expirado
        if (usuario.getToken_rec_expiracion().isBefore(LocalDateTime.now())) {
            // Limpia el token expirado por seguridad
            usuario.setTokenRecuperacion(null);
            usuario.setToken_rec_expiracion(null);
            usuarioRepositorio.save(usuario);
            throw new RuntimeException("El token de recuperación ha expirado");
        }

        // Actualiza la contraseña (encriptándola)
        usuario.setContrasena(codificadorDeContrasena.encode(nuevaContrasena));
        // Limpia el token y la expiración para que no se pueda reusar
        usuario.setTokenRecuperacion(null);
        usuario.setToken_rec_expiracion(null);
        usuarioRepositorio.save(usuario);
    }

    private void enviarCorreoRecuperacion(String destinatario, String token) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(destinatario);
        mensaje.setSubject("Recuperación de Contraseña - Proyecto Cáncer Gástrico");

        String urlReseteo = "http://localhost:8080/api/autenticacion/reset-clave?token=" + token;

        mensaje.setText("Para resetear tu contraseña con Postman, usa el siguiente token:\n" + token +
                "\n\n(Este es el enlace que se usaría con un frontend: " + urlReseteo + ")");

        remitenteDeCorreo.send(mensaje);
    }
}
