package com.ingsoftware.proyectosemestral.Dto;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ingsoftware.proyectosemestral.Modelo.SentidoCorte;
import com.ingsoftware.proyectosemestral.Modelo.TipoDato;
import lombok.Data;

import java.util.List;

@Data
public class PreguntaDto {

    private String etiqueta;
    private String descripcion;

    @JsonProperty("tipo_dato")
    private TipoDato tipo_dato;

    private boolean dato_sensible = false;
    private boolean activo = true;

    private int orden;

    private Long categoriaId;

    private Double dicotomizacion;
    private SentidoCorte sentido_corte;

    private List<String> opciones;

    private Long usuarioId;
}