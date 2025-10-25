package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface RegistroRepositorio extends JpaRepository<Registro, Long> {
    List<Registro> findByUsuario(Usuario usuario);
    List<Registro> findByAccion(String accion);
    List<Registro> findByRegistro_fechaBetween(LocalDate fechaInicio, LocalDate fechaFin);
    List<Registro> findByRespuesta(Respuesta respuesta);
    List<Usuario> findByUsuarioAndRegistro_fechaBetween(Usuario usuario, LocalDate fechaInicio, LocalDate fechaFin);
}
