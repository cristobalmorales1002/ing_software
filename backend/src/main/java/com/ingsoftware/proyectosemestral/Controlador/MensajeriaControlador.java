package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.MensajeEnviadoDto;
import com.ingsoftware.proyectosemestral.DTO.MensajeEnvioDto;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Servicio.MensajeriaServicio;
import com.ingsoftware.proyectosemestral.Servicio.UsuarioServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mensajes")
@CrossOrigin(origins = "*")
public class MensajeriaControlador {

    @Autowired
    private MensajeriaServicio mensajeriaServicio;

    @Autowired
    private UsuarioServicio usuarioServicio;

    @PostMapping("/enviar")
    public ResponseEntity<?> enviarMensaje(@RequestBody MensajeEnvioDto dto) {
        try {
            Usuario emisor = obtenerUsuarioAutenticado();

            if (dto.isEnviarATodos() || (dto.getEnviarARol() != null && !dto.getEnviarARol().isEmpty())) {
                if (!emisor.tieneRol("ROLE_ADMIN")) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN)
                            .body("Error: No tienes permisos de Administrador para realizar envíos masivos o por rol.");
                }
            }

            mensajeriaServicio.enviarMensaje(emisor.getIdUsuario(), dto);

            return ResponseEntity.ok("Mensaje enviado exitosamente.");

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al enviar mensaje: " + e.getMessage());
        }
    }


    @GetMapping("/entrada")
    public ResponseEntity<?> verBandejaEntrada() {
        try {
            Usuario usuario = obtenerUsuarioAutenticado();
            return ResponseEntity.ok(mensajeriaServicio.obtenerBandejaEntrada(usuario.getIdUsuario()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al obtener bandeja de entrada.");
        }
    }


    @GetMapping("/enviados") // Ejemplo de tu ruta
    public ResponseEntity<?> obtenerEnviados() {

        // El servicio ahora devuelve DTOs, así que esto compilará correctamente
        try {
            Usuario usuario = obtenerUsuarioAutenticado();
            List<MensajeEnviadoDto> enviados = mensajeriaServicio.obtenerEnviados(usuario.getIdUsuario());

            return ResponseEntity.ok(enviados);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al obtener mensajes enviados.");
        }
    }

    @PostMapping("/leer/{idDestinatarioMensaje}")
    public ResponseEntity<?> marcarComoLeido(@PathVariable Long idDestinatarioMensaje) {
        try {
            mensajeriaServicio.leerMensaje(idDestinatarioMensaje);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al marcar mensaje: " + e.getMessage());
        }
    }

    @GetMapping("/noleidos/cantidad")
    public ResponseEntity<?> contarNoLeidos() {
        try {
            Usuario usuario = obtenerUsuarioAutenticado();
            long cantidad = mensajeriaServicio.contarNoLeidos(usuario.getIdUsuario());
            return ResponseEntity.ok(cantidad);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private Usuario obtenerUsuarioAutenticado() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated()) {
            throw new RuntimeException("Usuario no autenticado");
        }

        String rutLogueado = auth.getName();

        return usuarioServicio.buscarPorRut(rutLogueado)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado en la base de datos con RUT: " + rutLogueado));
    }
}