package com.ingsoftware.proyectosemestral.Controlador;

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
@CrossOrigin(origins = "*") // Ajusta según tu configuración de CORS si es necesario
public class MensajeriaControlador {

    @Autowired
    private MensajeriaServicio mensajeriaServicio;

    @Autowired
    private UsuarioServicio usuarioServicio;

    /**
     * Endpoint para enviar mensajes.
     * Maneja envío individual, múltiple, por rol (solo admin) y a todos (solo admin).
     */
    @PostMapping("/enviar")
    public ResponseEntity<?> enviarMensaje(@RequestBody MensajeEnvioDto dto) {
        try {
            // 1. Obtener el usuario autenticado real
            Usuario emisor = obtenerUsuarioAutenticado();

            // 2. Validación de seguridad para envíos masivos
            if (dto.isEnviarATodos() || (dto.getEnviarARol() != null && !dto.getEnviarARol().isEmpty())) {
                // Verificamos si tiene el rol ADMIN usando tu método existente en Usuario.java
                if (!emisor.tieneRol("ROLE_ADMIN")) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN)
                            .body("Error: No tienes permisos de Administrador para realizar envíos masivos o por rol.");
                }
            }

            // 3. Llamar al servicio con el ID real del emisor
            mensajeriaServicio.enviarMensaje(emisor.getIdUsuario(), dto);

            return ResponseEntity.ok("Mensaje enviado exitosamente.");

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al enviar mensaje: " + e.getMessage());
        }
    }

    /**
     * Obtiene la bandeja de entrada del usuario logueado.
     */
    @GetMapping("/entrada")
    public ResponseEntity<?> verBandejaEntrada() {
        try {
            Usuario usuario = obtenerUsuarioAutenticado();
            return ResponseEntity.ok(mensajeriaServicio.obtenerBandejaEntrada(usuario.getIdUsuario()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al obtener bandeja de entrada.");
        }
    }

    /**
     * Obtiene los mensajes enviados por el usuario logueado.
     */
    @GetMapping("/enviados")
    public ResponseEntity<?> verEnviados() {
        try {
            Usuario usuario = obtenerUsuarioAutenticado();
            // Necesitarás agregar este método en tu Servicio si no lo pusiste,
            // es: mensajeRepositorio.findByEmisor_IdUsuarioOrderByFechaEnvioDesc(id)
            return ResponseEntity.ok(mensajeriaServicio.obtenerEnviados(usuario.getIdUsuario()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al obtener mensajes enviados.");
        }
    }

    /**
     * Marca un mensaje específico como leído.
     */
    @PostMapping("/leer/{idDestinatarioMensaje}")
    public ResponseEntity<?> marcarComoLeido(@PathVariable Long idDestinatarioMensaje) {
        try {
            // Opcional: Podrías validar aquí que el mensaje pertenece al usuario logueado
            // para mayor seguridad, pero el servicio lo buscará por ID.
            mensajeriaServicio.leerMensaje(idDestinatarioMensaje);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al marcar mensaje: " + e.getMessage());
        }
    }

    /**
     * Obtiene la cantidad de mensajes no leídos para el badge de notificaciones.
     */
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

    // ================= MÉTODOS PRIVADOS DE AYUDA =================

    /**
     * Extrae el usuario actual desde el contexto de seguridad de Spring.
     * Esto evita tener que enviar el ID del usuario desde el frontend (que es inseguro).
     */
    private Usuario obtenerUsuarioAutenticado() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated()) {
            throw new RuntimeException("Usuario no autenticado");
        }

        String rutLogueado = auth.getName(); // Esto devuelve el RUT, no el email

        // CORRECCIÓN: Usamos buscarPorRut en vez de buscarPorEmail
        return usuarioServicio.buscarPorRut(rutLogueado)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado en la base de datos con RUT: " + rutLogueado));
    }
}