package com.ingsoftware.proyectosemestral.DTO;

import lombok.*; // Importa las anotaciones de Lombok

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudRecuperarClave {
    private String email;
}