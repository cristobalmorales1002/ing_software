package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class MensajeEnviadoDto {
    private Long id;
    private String asunto;
    private String contenido;
    private LocalDateTime fechaEnvio;

    private String destinatariosResumen;
    private List<DestinatarioSimpleDto> destinatariosDetalle;

    // Opcional: Podrías agregar un contador de a cuántas personas se envió
    // private int cantidadDestinatarios;
}