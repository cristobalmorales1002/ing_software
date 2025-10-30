package com.ingsoftware.proyectosemestral.DTO;

import lombok.*;
import jakarta.validation.constraints.Email;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioActualizarDto {

    // Nota: Todos los campos son opcionales.
    // El servicio solo actualizará lo que no venga nulo o vacío.

    @Email(message = "El formato del email no es válido")
    private String email;

    private String telefono;

    private String password; // La nueva contraseña (opcional)
}