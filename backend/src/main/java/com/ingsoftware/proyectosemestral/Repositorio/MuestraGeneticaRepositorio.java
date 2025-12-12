package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.MuestraGenetica;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MuestraGeneticaRepositorio extends JpaRepository<MuestraGenetica, Long> {
    List<MuestraGenetica> findByParticipanteId(Long participanteId);
}