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
