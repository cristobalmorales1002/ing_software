package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;

@Data
public class RespuestaResponseDto {
    private Long respuesta_id;
    private Long pregunta_id;
    private String valor;
}
