package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CategoriaRepositorio extends JpaRepository<Categoria, Long> {
    Optional<Categoria> findByNombre(String nombre);
    List<Categoria> findByOrden(int orden);
}
