package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;


@Data
public class PacienteCreateDto {
    private Boolean esCaso;
    private LocalDate fechaIncl;
    private List<RespuestaDto> respuestas;
}
