package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Permiso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PermisoRepositorio extends JpaRepository<Permiso, Long> {
    Optional<Permiso> findByNombre(String nombre);
}
