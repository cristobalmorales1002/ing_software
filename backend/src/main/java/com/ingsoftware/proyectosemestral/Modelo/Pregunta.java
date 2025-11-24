package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Pregunta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long pregunta_id;

    @Column(nullable = false)
    private int orden;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private TipoDato tipo_dato;

    @Column(nullable = false)
    private String etiqueta; // Ej: "¿Cuál es su peso?"

    // Campo para Stata
    @Column(length = 50)
    private String codigoStata;

    @Column(nullable = false)
    private boolean dato_sensible;

    @Column(nullable = false)
    private boolean activo;

    @Column(nullable = false)
    private String descripcion;

    @Column
    private Double dicotomizacion;

    @Column
    @Enumerated(EnumType.STRING)
    private SentidoCorte sentido_corte;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @OneToMany(mappedBy = "pregunta", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<OpcionPregunta> opciones = new HashSet<>();

    @OneToMany(mappedBy = "pregunta", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Respuesta> respuestas = new HashSet<>();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "varchar(20) default 'NINGUNO'")
    private TipoCorte tipoCorte = TipoCorte.NINGUNO;

    @Column(nullable = false, columnDefinition = "boolean default true")
    private boolean exportable = true;

    // NUEVO CAMPO PARA ESTADÍSTICAS
    // Por defecto false, para que no se generen gráficos a menos que se pida explícitamente
    @Column(nullable = false, columnDefinition = "boolean default false")
    private boolean generarEstadistica = false;
}