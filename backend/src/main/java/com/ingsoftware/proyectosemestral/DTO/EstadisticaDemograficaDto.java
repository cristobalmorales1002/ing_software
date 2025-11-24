package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class EstadisticaDemograficaDto {
    private List<EstadisticaDto> datos;
}
