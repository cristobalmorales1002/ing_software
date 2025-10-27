package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.UsuarioServicio;
import com.ingsoftware.proyectosemestral.Servicio.VariableServicio;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

        // 1. Obtenemos todas las entidades de la BDD
        List<Pregunta> listaDePreguntas = variableServicio.obtenerTodasLasPreguntas();

        // 2. Mapeamos esa lista de Entidades a una lista de DTOs
        List<PreguntaDto> listaDeDtos = listaDePreguntas.stream()
                .map(this::mapearEntidadADto)
                .toList();

        // 3. Devolvemos la lista de DTOs con un 200 OK
        return ResponseEntity.ok(listaDeDtos);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Pregunta> obtenerPorId(@PathVariable("id") Long id) {
        Pregunta pregunta = variableServicio.obtenerPorId(id);
        PreguntaDto dtoRespuesta = mapearEntidadADto(pregunta);
        return ResponseEntity.ok(pregunta);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> archivar(@PathVariable("id") Long id, // <-- Este es el idPregunta
                                         Authentication authentication) {

        // 1. Obtenemos el RUT del usuario logueado
        String rutUsuarioLogueado = authentication.getName();

        // 2. Buscamos al usuario en la BDD para saber su ID
        Usuario usuario = usuarioRepositorio.findByRut(rutUsuarioLogueado)
                .orElseThrow(() -> new IllegalArgumentException("Usuario de sesión no encontrado"));

        // 3. Llamamos al servicio con AMBOS IDs
        variableServicio.archivarPregunta(id, usuario.getIdUsuario()); // (O .getId(), tu getter de ID)

        return ResponseEntity.noContent().build();
    }

    private PreguntaDto mapearEntidadADto(Pregunta entidad) {
        if (entidad == null) return null;
        PreguntaDto dto = new PreguntaDto();
        dto.setPregunta_id(entidad.getPregunta_id());
        dto.setEtiqueta(entidad.getEtiqueta());
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

        return dto;
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<PreguntaDto> actualizar(
            @PathVariable("id") Long id,
            @RequestBody PreguntaDto preguntaDto) {

        // Llamamos al nuevo metodo de servicio para actualizar la pregunta
        Pregunta preguntaActualizada = variableServicio.actualizarPregunta(id, preguntaDto);

        // Mapeamos la entidad actualizada de vuelta a un DTO para la respuesta
        PreguntaDto dtoRespuesta = mapearEntidadADto(preguntaActualizada);

        return ResponseEntity.ok(dtoRespuesta);
    }
}
