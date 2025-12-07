package com.ingsoftware.proyectosemestral.DTO;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class DestinatarioSimpleDto {
    private Long id;
    private String nombre;

    //AGREGUE ESTO POR MIENTRAS LO COMENTO PARA ELIMINARLO SI NO LES GUSTA
    private boolean leido;
    private LocalDateTime fechaLectura;
}