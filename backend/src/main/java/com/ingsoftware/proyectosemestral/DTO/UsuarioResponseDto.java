package com.ingsoftware.proyectosemestral.DTO;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioResponseDto {
    private Long usuarioId;
    private String rut;
    private String nombres;
    private String apellidos;
    private String email;
    private String telefono;
    private String rol;
    private String estadoU;
}
