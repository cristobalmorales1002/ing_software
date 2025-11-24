package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.VariableServicio;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/variables")
@RequiredArgsConstructor
public class VariableControlador {

    private final VariableServicio variableServicio;
    private final UsuarioRepositorio usuarioRepositorio;

    @PostMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<PreguntaDto> crear(@RequestBody PreguntaDto preguntaDto) {
        Pregunta nuevaPregunta = variableServicio.crearPregunta(preguntaDto);
        PreguntaDto dtoRespuesta = mapearEntidadADto(nuevaPregunta);
        return ResponseEntity.status(HttpStatus.CREATED).body(dtoRespuesta);
    }

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<List<PreguntaDto>> obtenerTodas() {
        List<Pregunta> listaDePreguntas = variableServicio.obtenerTodasLasPreguntas();
        List<PreguntaDto> listaDeDtos = listaDePreguntas.stream()
                .map(this::mapearEntidadADto)
                .toList();
        return ResponseEntity.ok(listaDeDtos);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Pregunta> obtenerPorId(@PathVariable("id") Long id) {
        Pregunta pregunta = variableServicio.obtenerPorId(id);
        return ResponseEntity.ok(pregunta);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> archivar(@PathVariable("id") Long id,
                                         Authentication authentication) {
        String rutUsuarioLogueado = authentication.getName();
        Usuario usuario = usuarioRepositorio.findByRut(rutUsuarioLogueado)
                .orElseThrow(() -> new IllegalArgumentException("Usuario de sesión no encontrado"));

        variableServicio.archivarPregunta(id, usuario.getIdUsuario());
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<PreguntaDto> actualizar(
            @PathVariable("id") Long id,
            @RequestBody PreguntaDto preguntaDto) {

        Pregunta preguntaActualizada = variableServicio.actualizarPregunta(id, preguntaDto);
        PreguntaDto dtoRespuesta = mapearEntidadADto(preguntaActualizada);
        return ResponseEntity.ok(dtoRespuesta);
    }

    private PreguntaDto mapearEntidadADto(Pregunta entidad) {
        if (entidad == null) return null;
        PreguntaDto dto = new PreguntaDto();
        dto.setPregunta_id(entidad.getPregunta_id());
        dto.setEtiqueta(entidad.getEtiqueta());
        dto.setCodigoStata(entidad.getCodigoStata());
        dto.setDescripcion(entidad.getDescripcion());
        dto.setTipo_dato(entidad.getTipo_dato());
        dto.setDato_sensible(entidad.isDato_sensible());
        dto.setActivo(entidad.isActivo());
        dto.setOrden(entidad.getOrden());
        if (entidad.getCategoria() != null) {
            dto.setCategoriaId(entidad.getCategoria().getId_cat());
        }
        dto.setDicotomizacion(entidad.getDicotomizacion());
        dto.setSentido_corte(entidad.getSentido_corte());
        dto.setExportable(entidad.isExportable());
        dto.setTipoCorte(entidad.getTipoCorte());

        // MAPEO CAMPO NUEVO
        dto.setGenerarEstadistica(entidad.isGenerarEstadistica());

        if (entidad.getTipo_dato() == TipoDato.ENUM && entidad.getOpciones() != null) {
            List<String> listaOpciones = entidad.getOpciones().stream()
                    .sorted(Comparator.comparingInt(OpcionPregunta::getOrden))
                    .map(OpcionPregunta::getEtiqueta)
                    .collect(Collectors.toList());
            dto.setOpciones(listaOpciones);
        }

        return dto;
    }
}