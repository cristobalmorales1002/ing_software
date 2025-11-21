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

import java.security.SecureRandom; // Importante para números aleatorios seguros
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

        // --- CAMBIO: GENERACIÓN DE TOKEN NUMÉRICO DE 6 DÍGITOS ---
        String token = generarTokenNumerico();

        // Expiración: 1 hora (o puedes bajarlo a 15 min si es solo un código numérico)
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
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(destinatario);
        mensaje.setSubject("Código de Recuperación - Proyecto Cáncer Gástrico");

        // Mensaje más amigable para código corto
        String textoMensaje = String.format(
                "Hola,\n\n" +
                        "Has solicitado restablecer tu contraseña.\n" +
                        "Tu código de verificación es: %s\n\n" +
                        "Este código expirará en 1 hora.\n" +
                        "Si no solicitaste este cambio, ignora este correo.",
                token
        );

        mensaje.setText(textoMensaje);
        remitenteDeCorreo.send(mensaje);
    }

    // --- MÉTODO HELPER PARA GENERAR EL CÓDIGO ---
    private String generarTokenNumerico() {
        SecureRandom random = new SecureRandom();
        // Genera un número entre 100000 y 999999
        int numero = 100000 + random.nextInt(900000);
        return String.valueOf(numero);
    }
}