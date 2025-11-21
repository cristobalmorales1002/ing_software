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
public class Permiso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_perm;

    @Column(nullable = false, unique = true)
    private String nombre;

    @Column(nullable = false)
    private String descripcion;

    @ManyToMany(mappedBy = "permisos") //Esto es muy importante para la relacion bidireccional (m:n), evita tablas intermedias innecesarias, y mantiene la integridad de los datos.
    private Set<Rol> roles = new HashSet<>();

}