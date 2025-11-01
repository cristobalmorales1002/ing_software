package com.ingsoftware.proyectosemestral.DTO;

import lombok.*;
import jakarta.validation.constraints.Email;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioActualizarDto {
    @Email(message = "El formato del email no es válido")
    private String email;

    private String telefono;

    private String password;
}