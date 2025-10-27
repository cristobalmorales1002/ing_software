package com.ingsoftware.proyectosemestral.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudResetClave {
    private String token;
    private String nuevaContrasena;
}
