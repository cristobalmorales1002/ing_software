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

public class Categoria {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id_cat;

    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private int orden;

}
