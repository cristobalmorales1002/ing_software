package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class RegistroResponseDto {
    private Long id;
    private String nombreUsuario;
    private String rutUsuario;
    private String accion;
    private String detalles;
    private LocalDateTime fecha;
    private Long idRespuestaAfectada;
}