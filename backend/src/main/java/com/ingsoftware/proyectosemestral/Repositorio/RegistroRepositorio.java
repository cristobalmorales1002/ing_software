package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RegistroRepositorio extends JpaRepository<Registro, Long> {
    List<Registro> findByUsuario(Usuario usuario);
    List<Registro> findByAccion(String accion);
    List<Registro> findByRespuesta(Respuesta respuesta);
    List<Registro> findByRegistroFechaBetween(LocalDateTime fechaInicio, LocalDateTime fechaFin);
    List<Registro> findByUsuarioAndRegistroFechaBetween(Usuario usuario, LocalDateTime fechaInicio, LocalDateTime fechaFin);
}
