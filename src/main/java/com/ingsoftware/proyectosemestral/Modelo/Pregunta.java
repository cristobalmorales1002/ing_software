package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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
    private TipoDato tipo_dato;
    @Column(nullable = false)
    private String etiqueta;
    @Column(nullable = false)
    private boolean dato_sensible;
    @Column(nullable = false)
    private boolean activo;
    @Column(nullable = false)
    private String descripcion;
    @Column(nullable = false)
    private double dicotomizacion;
    @Column(nullable = false)
    private SentidoCorte sentido_corte;
}
