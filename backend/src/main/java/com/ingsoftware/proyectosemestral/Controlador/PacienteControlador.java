package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.PacienteCreateDto;
import com.ingsoftware.proyectosemestral.DTO.PacienteResponseDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaDto;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.PacienteServicio;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/pacientes")
public class PacienteControlador {

    @Autowired
    private PacienteServicio pacienteServicio;

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @PostMapping
    @PreAuthorize("hasAuthority('CREAR_CASO') or hasAuthority('CREAR_CONTROL')")
    public ResponseEntity<PacienteResponseDto> crearPaciente(
            @RequestBody PacienteCreateDto pacienteDto,
            Authentication authentication
    ) {
        String rut = authentication.getName();
        Usuario usuarioReal = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado en BDD: " + rut));

        if (pacienteDto.getEsCaso()) {
            boolean tienePermisoCaso = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("CREAR_CASO"));

            if (!tienePermisoCaso) {
                throw new AccessDeniedException("Acceso denegado: Solo los Médicos pueden crear 'Casos'.");
            }
        }

        PacienteResponseDto nuevoPacienteDto =
                pacienteServicio.crearPacienteConRespuestas(pacienteDto, usuarioReal);

        return ResponseEntity.created(URI.create("/api/pacientes/" + nuevoPacienteDto.getParticipante_id()))
                .body(nuevoPacienteDto);
    }

    @GetMapping("/{pacienteId}")
    @PreAuthorize("hasAuthority('VER_PACIENTE')")
    public ResponseEntity<PacienteResponseDto> getPaciente(@PathVariable Long pacienteId) {
        return ResponseEntity.ok(pacienteServicio.getPacienteById(pacienteId));
    }

    @GetMapping
    @PreAuthorize("hasAuthority('VER_LISTADO_PACIENTES')")
    public ResponseEntity<List<PacienteResponseDto>> getAllPacientes() {
        return ResponseEntity.ok(pacienteServicio.getAllPacientes());
    }

    @PutMapping("/{pacienteId}/respuestas")
    @PreAuthorize("hasAuthority('EDITAR_CASO') or hasAuthority('EDITAR_CONTROL')")
    public ResponseEntity<PacienteResponseDto> actualizarRespuestas(
            @PathVariable Long pacienteId,
            @RequestBody List<RespuestaDto> respuestasDto,
            Authentication authentication
    ) {
        String rut = authentication.getName();
        Usuario usuarioReal = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado en BDD: " + rut));

        pacienteServicio.actualizarRespuestasDePaciente(pacienteId, respuestasDto, usuarioReal);
        return ResponseEntity.ok(pacienteServicio.getPacienteById(pacienteId));
    }

    @DeleteMapping("/{pacienteId}")
    @PreAuthorize("hasAuthority('ELIMINAR_PACIENTE')")
    public ResponseEntity<Void> archivarPaciente(
            @PathVariable Long pacienteId,
            Authentication authentication
    ) {
        String rut = authentication.getName();
        Usuario usuarioReal = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado en BDD: " + rut));

        pacienteServicio.archivarPaciente(pacienteId, usuarioReal);
        return ResponseEntity.noContent().build();
    }
}