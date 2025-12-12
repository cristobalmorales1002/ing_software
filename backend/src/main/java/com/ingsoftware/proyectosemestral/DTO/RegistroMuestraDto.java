package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;

@Data
public class RegistroMuestraDto {
    private Long participanteId;
    private Long snpConfigId;
    private String resultado; // "TT", "TC", etc.
}