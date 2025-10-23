package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class Paciente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long participante_id;
    @Column(nullable = false)
    private String participante_cod;
    @Column(nullable = false)
    private Boolean esCaso;
    @Column(nullable = false)
    private LocalDate fecha_incl;

}
