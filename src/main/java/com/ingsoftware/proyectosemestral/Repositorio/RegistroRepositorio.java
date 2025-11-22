package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RegistroRepositorio extends JpaRepository<Registro, Long> {
    List<Registro> findByUsuario(Usuario usuario);
    List<Registro> findByAccion(String accion);
    List<Registro> findByRespuesta(Respuesta respuesta);

    Page<Registro> findAll(Pageable pageable);

    Page<Registro> findByRegistroFechaBetween(LocalDateTime inicio, LocalDateTime fin, Pageable pageable);

    Page<Registro> findByUsuarioAndRegistroFechaBetween(Usuario usuario, LocalDateTime inicio, LocalDateTime fin, Pageable pageable);
}