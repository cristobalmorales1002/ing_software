package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.MuestraGenetica;
import com.ingsoftware.proyectosemestral.Modelo.SnpConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface MuestraGeneticaRepositorio extends JpaRepository<MuestraGenetica, Long> {
    List<MuestraGenetica> findByParticipanteId(Long participanteId);
    Optional<MuestraGenetica> findByParticipanteIdAndSnpConfig(Long participanteId, SnpConfig config);
}