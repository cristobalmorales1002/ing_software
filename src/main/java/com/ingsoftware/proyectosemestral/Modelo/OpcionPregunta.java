package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OpcionPregunta {

    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id_opcion;

    @Column(nullable = false)
    private String etiqueta;

    @Column(nullable = false)
    private int orden;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pregunta_id", nullable = false)
    private Pregunta pregunta;

    @Column(nullable = true)
    private Double valorDicotomizado;

}