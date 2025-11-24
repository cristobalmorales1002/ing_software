package com.ingsoftware.proyectosemestral.DTO;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ingsoftware.proyectosemestral.Modelo.SentidoCorte;
import com.ingsoftware.proyectosemestral.Modelo.TipoCorte;
import com.ingsoftware.proyectosemestral.Modelo.TipoDato;
import lombok.Data;

import java.util.List;

@Data
public class PreguntaDto {

    private Long pregunta_id;
    private String etiqueta;

    private String codigoStata;

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

    private TipoCorte tipoCorte;

    private boolean exportable = true;

    // NUEVO CAMPO
    private boolean generarEstadistica;
}