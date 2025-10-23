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

public class Permiso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id_perm;
    @Column(nullable = false)
    private String nombre;
    @Column(nullable = false)
    private String descripcion;
}
