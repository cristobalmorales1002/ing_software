package com.ingsoftware.proyectosemestral.DTO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CategoriaDto {
    private Long id_cat;

    @NotBlank(message = "El nombre de la categoría es obligatorio")
    private String nombre;

    private int orden;
}