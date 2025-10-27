package com.ingsoftware.proyectosemestral.Seguridad;

//Esta es una clase de tipo DTO, la cual se utiliza para transferir datos de autenticación
// entre el cliente y el servidor durante el proceso de login.
// especificamente para encapsular los datos que el usuario envía al intentar autenticarse,
// como su nombre de usuario y contraseña.

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class SolicitudAutenticacion {
    private String rut;
    private String contrasena;
}
