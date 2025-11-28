package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;
import java.util.List;

@Data
public class MensajeEnvioDto {
    private String asunto;
    private String contenido;

    private List<Long> destinatariosIds;

    private boolean enviarATodos;
    private String enviarARol;
}