package com.ingsoftware.proyectosemestral.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CambioEmailDto {
    @NotBlank
    private String token;

    @NotBlank
    @Email
    private String nuevoEmail;
}