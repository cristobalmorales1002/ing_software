package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RespuestaRepositorio extends JpaRepository<Respuesta, Long> {
    Optional<Respuesta> findByPacienteAndPregunta(Paciente paciente, Pregunta pregunta);
    List<Respuesta> findByPaciente(Paciente paciente);
    List<Respuesta> findByPregunta(Pregunta pregunta);
    List<Respuesta> findByPreguntaAndValor(Pregunta pregunta, String valor);
    List<Respuesta> findByPreguntaAndValorIn(Pregunta pregunta, List<String> valores);
}
