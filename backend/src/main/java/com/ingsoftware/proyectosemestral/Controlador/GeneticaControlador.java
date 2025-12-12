package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.AnalisisGeneticoDto;
import com.ingsoftware.proyectosemestral.DTO.RegistroMuestraDto;
import com.ingsoftware.proyectosemestral.Modelo.SnpConfig;
import com.ingsoftware.proyectosemestral.Servicio.GeneticaServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/genetica")
public class GeneticaControlador {

    @Autowired
    private GeneticaServicio geneticaServicio;

    // Obtener lista de genes para pintar el formulario
    @GetMapping("/configuraciones")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<SnpConfig>> obtenerConfigs() {
        return ResponseEntity.ok(geneticaServicio.obtenerConfiguraciones());
    }

    // Guardar una muestra (desde el formulario CRF)
    @PostMapping("/muestra")
    @PreAuthorize("hasRole('ROLE_ADMIN')") // O el rol que corresponda
    public ResponseEntity<Void> guardarMuestra(@RequestBody RegistroMuestraDto dto) {
        geneticaServicio.guardarMuestra(dto);
        return ResponseEntity.ok().build();
    }

    // Obtener análisis de un paciente específico
    @GetMapping("/analisis/{participanteId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<AnalisisGeneticoDto>> obtenerAnalisis(@PathVariable Long participanteId) {
        return ResponseEntity.ok(geneticaServicio.obtenerAnalisisPorPaciente(participanteId));
    }

    @PutMapping("/configuracion/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<SnpConfig> actualizarConfig(@PathVariable Long id, @RequestBody String aleloRiesgo) {
        // A veces el body llega con comillas extra, las limpiamos por seguridad
        String limpio = aleloRiesgo.replace("\"", "").trim();
        return ResponseEntity.ok(geneticaServicio.actualizarConfiguracionRiesgo(id, limpio));
    }
}