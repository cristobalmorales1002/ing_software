package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.Data;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "preguntas")
@Data
public class Pregunta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long pregunta_id;

    private String etiqueta;
    private String codigoStata;
    private String descripcion;

    @Enumerated(EnumType.STRING)
    private TipoDato tipo_dato;

    private boolean dato_sensible;
    private boolean activo = true;
    private int orden;

    @ManyToOne
    @JoinColumn(name = "id_cat")
    private Categoria categoria;

    // --- CAMBIO PRINCIPAL: LISTA DE DICOTOMIZACIONES ---
    @OneToMany(mappedBy = "pregunta", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Dicotomizacion> dicotomizaciones = new ArrayList<>();
    // ---------------------------------------------------

    private boolean exportable;

    @Enumerated(EnumType.STRING)
    private TipoCorte tipoCorte;

    private boolean generarEstadistica;

    @OneToMany(mappedBy = "pregunta", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OpcionPregunta> opciones;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pregunta_controladora_id")
    private Pregunta preguntaControladora;

    @Column(length = 500)
    private String valorEsperadoControladora;
}