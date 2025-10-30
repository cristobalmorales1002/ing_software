package com.ingsoftware.proyectosemestral.DTO;

import lombok.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioCreateDto {
    @NotBlank
    private String rut;

    @NotBlank
    private String nombres;

    @NotBlank
    private String apellidos;

    @Email
    @NotBlank
    private String email;

    private String telefono;

    @NotBlank
    private String password; // campo de entrada para crear usuario

    @NotBlank
    private String rol; // nombre del rol a asignar (ej. "ADMIN")
}