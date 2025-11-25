package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;
import java.util.List;

@Data
public class CategoriaFullDto {
    private Long id_cat;
    private String nombre;
    private int orden;

    // Lista de preguntas hijas
    private List<PreguntaDto> preguntas;
}