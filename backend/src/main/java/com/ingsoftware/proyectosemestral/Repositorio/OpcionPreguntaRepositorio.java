package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.OpcionPregunta;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OpcionPreguntaRepositorio extends JpaRepository<OpcionPregunta, Long> {
    List<OpcionPregunta> findByPregunta(Pregunta pregunta);
    Optional<OpcionPregunta> findByPreguntaAndEtiqueta(Pregunta pregunta, String etiqueta);
    @Transactional
    void deleteByPregunta(Pregunta pregunta);
}
