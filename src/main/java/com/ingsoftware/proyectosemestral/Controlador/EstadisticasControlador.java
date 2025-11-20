package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDemograficaDto;
import com.ingsoftware.proyectosemestral.Servicio.EstadisticaServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api/estadisticas")
public class EstadisticasControlador {
    @Autowired
    private EstadisticaServicio estadisticaServicio;

    @GetMapping("/demograficas")
    @PreAuthorize("hasAuthority('VER_LISTADO_PACIENTES') or hasRole('ROLE_ADMIN') or hasRole('ROLE_INVESTIGADOR')")
    public ResponseEntity<EstadisticaDemograficaDto> obtenerEstadisticasDemograficas() {
        EstadisticaDemograficaDto dto = estadisticaServicio.obtenerEstadisticasDemograficas();
        return ResponseEntity.ok(dto);
    }
}
