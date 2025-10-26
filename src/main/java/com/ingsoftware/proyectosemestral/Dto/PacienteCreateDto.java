package com.ingsoftware.proyectosemestral.Dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class PacienteCreateDto {
    private boolean esCaso;
    private LocalDate fecha_incl;
    private List<RespuestaDto> respuestas;
}
