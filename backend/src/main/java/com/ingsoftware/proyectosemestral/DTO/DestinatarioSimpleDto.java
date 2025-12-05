package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DestinatarioSimpleDto {
    private Long id;
    private String nombre;
}