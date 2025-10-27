package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class PacienteResponseDto {
    private Long participante_id;
    private String participanteCod;
    private Boolean esCaso;
    private LocalDate fechaIncl;

    private List<RespuestaResponseDto> respuestas;
}