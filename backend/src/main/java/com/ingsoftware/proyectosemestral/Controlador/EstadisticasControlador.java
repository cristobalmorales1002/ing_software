package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.DTO.PreferenciasEstadisticaDto;
import com.ingsoftware.proyectosemestral.Servicio.EstadisticaServicio;
import com.ingsoftware.proyectosemestral.Servicio.UsuarioServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/estadisticas")
public class EstadisticasControlador {

    @Autowired
    private EstadisticaServicio estadisticaServicio;

    @Autowired
    private UsuarioServicio usuarioServicio;

    @GetMapping("/dashboard")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<EstadisticaDto>> obtenerEstadisticasDashboard(Authentication authentication) {
        String rut = authentication.getName();

        List<EstadisticaDto> estadisticas = estadisticaServicio.calcularEstadisticasDashboard(rut);

        return ResponseEntity.ok(estadisticas);
    }

    @PostMapping("/preferencias")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> guardarPreferencias(Authentication authentication,
                                                    @RequestBody PreferenciasEstadisticaDto dto) {
        String rut = authentication.getName();
        usuarioServicio.guardarPreferenciasEstadistica(rut, dto.getPreguntasIds());

        return ResponseEntity.ok().build();
    }

    @GetMapping("/opciones")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Map<String, Object>>> obtenerOpciones() {
        return ResponseEntity.ok(estadisticaServicio.obtenerOpcionesDisponibles());
    }
}