package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.PacienteCreateDto;
import com.ingsoftware.proyectosemestral.DTO.PacienteResponseDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaDto;
import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Servicio.PacienteServicio;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize; // Seguridad
import org.springframework.security.core.annotation.AuthenticationPrincipal; // Seguridad
import org.springframework.web.bind.annotation.*;

import java.net.URI; // Necesario para 'created'
import java.util.List;

@RestController
@RequestMapping("/api/pacientes")
public class PacienteControlador {

    @Autowired
    private PacienteServicio pacienteServicio;

    @PostMapping
    @PreAuthorize("hasAuthority('CREAR_CASO') or hasAuthority('CREAR_CONTROL')") // <-- SEGURIDAD RESTAURADA
    public ResponseEntity<PacienteResponseDto> crearPaciente(
            @RequestBody PacienteCreateDto pacienteDto,
            @AuthenticationPrincipal Usuario usuario // <-- USUARIO REAL RESTAURADO
    ) {
        Paciente nuevoPaciente = pacienteServicio.crearPacienteConRespuestas(pacienteDto, usuario); // <-- Usa el usuario real
        // Asegúrate que aquí se llame a getParticipanteId() (camelCase)
        return ResponseEntity.created(URI.create("/api/pacientes/" + nuevoPaciente.getParticipante_id()))
                .body(pacienteServicio.getPacienteById(nuevoPaciente.getParticipante_id()));
    }

    @GetMapping("/{pacienteId}")
    @PreAuthorize("hasAuthority('VER_PACIENTE')") // <-- SEGURIDAD RESTAURADA
    public ResponseEntity<PacienteResponseDto> getPaciente(@PathVariable Long pacienteId) {
        return ResponseEntity.ok(pacienteServicio.getPacienteById(pacienteId));
    }

    @GetMapping
    @PreAuthorize("hasAuthority('VER_LISTADO_PACIENTES')") // <-- SEGURIDAD RESTAURADA
    public ResponseEntity<List<PacienteResponseDto>> getAllPacientes() {
        return ResponseEntity.ok(pacienteServicio.getAllPacientes());
    }

    @PutMapping("/{pacienteId}/respuestas")
    @PreAuthorize("hasAuthority('EDITAR_CASO') or hasAuthority('EDITAR_CONTROL')") // <-- SEGURIDAD RESTAURADA
    public ResponseEntity<PacienteResponseDto> actualizarRespuestas(
            @PathVariable Long pacienteId,
            @RequestBody List<RespuestaDto> respuestasDto,
            @AuthenticationPrincipal Usuario usuario // <-- USUARIO REAL RESTAURADO
    ) {
        pacienteServicio.actualizarRespuestasDePaciente(pacienteId, respuestasDto, usuario); // <-- Usa el usuario real
        return ResponseEntity.ok(pacienteServicio.getPacienteById(pacienteId));
    }

    @DeleteMapping("/{pacienteId}")
    @PreAuthorize("hasAuthority('ELIMINAR_PACIENTE')") // <-- SEGURIDAD RESTAURADA
    public ResponseEntity<Void> deletePaciente(
            @PathVariable Long pacienteId,
            @AuthenticationPrincipal Usuario usuario // <-- USUARIO REAL RESTAURADO
    ) {
        pacienteServicio.deletePaciente(pacienteId, usuario); // <-- Usa el usuario real
        return ResponseEntity.noContent().build();
    }
}