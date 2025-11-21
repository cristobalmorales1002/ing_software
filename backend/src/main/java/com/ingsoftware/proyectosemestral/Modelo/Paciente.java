package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Paciente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long participante_id;

    @Column(nullable = false, unique = true, name = "participante_cod")
    private String participanteCod;

    @Column(nullable = false)
    private Boolean esCaso;

    @Column(nullable = false, name = "fecha_incl")
    private LocalDate fechaIncl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reclutador_id", nullable = false)
    private Usuario reclutador;

    @OneToMany(mappedBy = "paciente", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Respuesta> respuestas = new HashSet<>();

    @Column(nullable = false)
    private Boolean activo = true;
}