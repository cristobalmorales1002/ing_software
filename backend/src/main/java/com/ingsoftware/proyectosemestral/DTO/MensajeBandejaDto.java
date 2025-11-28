package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class MensajeBandejaDto {
    private Long id;
    private String asunto;
    private String contenido;
    private LocalDateTime fechaEnvio;

    private String nombreEmisor;
    private String emailEmisor;

    private boolean leido;
}