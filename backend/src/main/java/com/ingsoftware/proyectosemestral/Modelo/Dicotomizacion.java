package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "dicotomizaciones")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Dicotomizacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_dicotomizacion;

    @Column(name = "valor_corte")
    private Double valor;

    @Column(name = "sentido_corte")
    @Enumerated(EnumType.STRING)
    private SentidoCorte sentido;

    // Relación: Muchas dicotomizaciones -> 1 Pregunta
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pregunta_id")
    private Pregunta pregunta;
}