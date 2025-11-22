package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.Servicio.EstadisticaServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/estadisticas")
public class EstadisticasControlador {

    @Autowired
    private EstadisticaServicio estadisticaServicio;

    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ROLE_ADMIN') or hasRole('ROLE_INVESTIGADOR')")
    public ResponseEntity<List<EstadisticaDto>> obtenerEstadisticasDashboard() {
        List<EstadisticaDto> estadisticas = estadisticaServicio.calcularEstadisticasDashboard();
        return ResponseEntity.ok(estadisticas);
    }
}