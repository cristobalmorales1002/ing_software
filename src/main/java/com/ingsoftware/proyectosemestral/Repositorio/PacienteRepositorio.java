package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PacienteRepositorio extends JpaRepository<Paciente, Long> {
    Optional<Paciente> findByParticipanteCod(String participanteCod);
    List<Paciente> findByEsCaso(Boolean esCaso);
    List<Paciente> findByFechaInclBetween(LocalDate fechaInicio, LocalDate fechaFin);
    List<Paciente> findByReclutador(Usuario reclutador);

    //Metodo para generar el codigo del paciente 'generarCodigoPaciente' en PacienteServicio
    long countByEsCaso(boolean esCaso);

    List<Paciente> findByActivoTrue();
}
