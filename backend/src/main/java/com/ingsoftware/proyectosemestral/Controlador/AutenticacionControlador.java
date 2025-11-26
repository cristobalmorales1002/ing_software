package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.SolicitudRecuperarClave;
import com.ingsoftware.proyectosemestral.DTO.SolicitudResetClave;
import com.ingsoftware.proyectosemestral.Servicio.AutenticacionServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/autenticacion")
public class AutenticacionControlador {

    @Autowired
    private AutenticacionServicio autenticacionServicio;

    @PostMapping("/recuperar-clave")
    public ResponseEntity<?> solicitarRecuperacion(@RequestBody SolicitudRecuperarClave solicitud) {
        try {
            autenticacionServicio.solicitarRecuperacionClave(solicitud.getEmail());
            return ResponseEntity.ok("Correo de recuperación enviado exitosamente.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("Error al procesar la solicitud.");
        }
    }

    @PostMapping("/validar-token")
    public ResponseEntity<?> validarToken(@RequestBody Map<String, String> payload) {
        try {
            autenticacionServicio.verificarTokenValido(payload.get("token"));
            return ResponseEntity.ok(Map.of("valido", true));
        } catch (RuntimeException e) {
            // Retornamos 400 Bad Request con el mensaje de error (ej: "Código expirado")
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/reset-clave")
    public ResponseEntity<?> resetearClave(@RequestBody SolicitudResetClave solicitud) {
        try {
            autenticacionServicio.resetearClave(solicitud.getToken(), solicitud.getNuevaContrasena());
            return ResponseEntity.ok("Contraseña actualizada exitosamente.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}
