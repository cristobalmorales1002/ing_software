package com.ingsoftware.proyectosemestral.DTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor

public class EstadisticaDto {
    // private Map<String, Long> conteoPorCategoria;

    private String tituloPregunta; // Ej: "Sexo"
    private Long preguntaId;
    private List<DatoGrafico> datos; // La serie de datos

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class DatoGrafico {
        private String etiqueta; // Ej: "Mujer"
        private Long valor;      // Ej: 15
        private Double porcentaje; // Ej: 55.5
    }
}
