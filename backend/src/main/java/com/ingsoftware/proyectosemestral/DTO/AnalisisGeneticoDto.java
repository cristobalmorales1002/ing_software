package com.ingsoftware.proyectosemestral.DTO;

import lombok.Data;

@Data
public class AnalisisGeneticoDto {
    private String nombreGen;
    private String resultadoPaciente;

    // Resultados calculados
    private String interpretacionCodominante; // CC vs CA vs AA
    private String interpretacionDominante;   // Portador vs No portador
    private String interpretacionRecesivo;    // Riesgo alto vs bajo

    private boolean configuracionCompleta; // Avisa si falta definir el alelo de riesgo
}