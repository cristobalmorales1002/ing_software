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
public class MuestraGenetica {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_muestra;

    // Aquí asumo que tienes un ID de paciente o participante.
    // Si tienes una entidad Paciente, cámbialo por @ManyToOne.
    @Column(nullable = false)
    private Long participanteId;

    @ManyToOne
    @JoinColumn(name = "id_snp", nullable = false)
    private SnpConfig snpConfig;

    @Column(nullable = false)
    private String resultado; // Ej: "TC"
}