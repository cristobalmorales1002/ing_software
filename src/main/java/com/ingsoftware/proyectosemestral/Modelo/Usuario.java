package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
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
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUsuario;

    @Column(unique = true, nullable = false)
    private String rut;

    @Column(nullable = false)
    private String nombres;

    @Column(nullable = false)
    private String apellidos;

    @Column(nullable = false)
    @Email
    private String email;

    @Column(nullable = false)
    private String contrasena;

    @Column(nullable = false)
    private String telefono;

    @Column
    private boolean activo;

    @Column(nullable = false)
    private String tokenRecuperacion;

    @Column
    private LocalDate token_rec_expiracion;
}
