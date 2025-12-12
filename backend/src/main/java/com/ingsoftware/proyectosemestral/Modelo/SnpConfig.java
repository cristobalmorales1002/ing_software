package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SnpConfig {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_snp;

    @Column(nullable = false)
    private String nombreGen; // Ej: "TLR9 rs5743836"

    // Opciones válidas para validación (Ej: "TT", "TC", "CC")
    private String opcion1;
    private String opcion2;
    private String opcion3;

    // Configuración para el algoritmo (Puede ser NULL al inicio)
    private String aleloRef;    // Ej: "T"
    private String aleloRiesgo; // Ej: "C" (Este es el que define el modelo Dominante/Recesivo)
}