package com.ingsoftware.proyectosemestral.DTO;

import com.ingsoftware.proyectosemestral.Modelo.SentidoCorte;
import lombok.Data;

@Data
public class DicotomizacionDto {
    private Long id_dicotomizacion;
    private Double valor;         // El número (ej: 5.5)
    private SentidoCorte sentido; // MAYOR, MENOR, etc.
}