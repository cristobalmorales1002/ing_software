package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PreguntaRepositorio extends JpaRepository<Pregunta, Long> {

    List<Pregunta> findByActivo(boolean activo);
    List<Pregunta> findByCategoria(Categoria categoria);
    List<Pregunta> findByCategoriaAndActivo(Categoria categoria, boolean activo);
    Optional<Pregunta> findByEtiqueta(String etiqueta);// Para la exportación COMPLETA

    // Para la exportación COMPLETA
    @Query("SELECT p FROM Pregunta p WHERE p.activo = true AND p.exportable = true ORDER BY p.orden ASC")
    List<Pregunta> findByActivoTrueAndExportableTrueOrderByOrdenAsc();

    // Para la exportación ANÓNIMA
    @Query("SELECT p FROM Pregunta p WHERE p.activo = true AND p.dato_sensible = false AND p.exportable = true ORDER BY p.orden ASC")
    List<Pregunta> findByActivoTrueAndDato_sensibleFalseAndExportableTrueOrderByOrdenAsc();
}