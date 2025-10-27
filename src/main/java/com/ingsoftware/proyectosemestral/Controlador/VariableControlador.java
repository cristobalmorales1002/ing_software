package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.Dto.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Servicio.VariableServicio;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

public class VariableControlador {

    private VariableServicio variableServicio;

    @PostMapping
    public ResponseEntity<Pregunta> crear(@RequestBody PreguntaDto preguntaDto) {
        Pregunta nuevaPregunta = variableServicio.crearPregunta(preguntaDto);
        return ResponseEntity.ok(nuevaPregunta);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pregunta> obtenerPorId(Long id) {
        Pregunta pregunta = variableServicio.obtenerPorId(id);
        return ResponseEntity.ok(pregunta);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable("id") Long id) {
        variableServicio.eliminarPregunta(id);
        return ResponseEntity.noContent().build();
    }
}
