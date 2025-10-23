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
public class Rol {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long rolId;

    @Column(nullable = false, unique = true)
    private String nombre;

    @ManyToMany(mappedBy = "roles")
    private Set<Usuario> usuarios = new HashSet<>();


    @ManyToMany(fetch = FetchType.EAGER) //Contraparte de la relacion muchos a muchos con Permiso
    @JoinTable(
            name = "rol_permiso", // Nombre de tabla pivote (Tabla intermedia, sin tener que crear nuevas clases)
            joinColumns = @JoinColumn(name = "rol_id"), // Columna que apunta a esta entidad (Rol)
            inverseJoinColumns = @JoinColumn(name = "permiso_id") // Columna que apunta a la otra (Permiso)
    )
    private Set<Permiso> permisos = new HashSet<>();

}