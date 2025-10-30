package com.ingsoftware.proyectosemestral.DTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioResponseDto {
    private Long usuarioId;      // coincide con usuarios.js -> usuario.usuarioId
    private String rut;
    private String nombres;
    private String apellidos;
    private String email;
    private String telefono;
    private String rol;         // nombre del rol principal (ej. "ADMIN")
    private String estadoU;     // "ACTIVO" o "INACTIVO" (lo que espera el frontend)
}
