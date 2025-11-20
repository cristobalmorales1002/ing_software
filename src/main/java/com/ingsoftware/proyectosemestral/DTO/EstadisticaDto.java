package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;
import java.util.Map;

@Data
@Builder
public class EstadisticaDto {
    private String nombreEstadistica;
    private Map<String, Long> conteoPorCategoria;
}
