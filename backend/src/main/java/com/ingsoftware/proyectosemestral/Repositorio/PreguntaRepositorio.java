package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PreguntaRepositorio extends JpaRepository<Pregunta, Long> {

    List<Pregunta> findByActivo(boolean activo);
    List<Pregunta> findByCategoria(Categoria categoria);
    List<Pregunta> findByCategoriaAndActivo(Categoria categoria, boolean activo);
    Optional<Pregunta> findByEtiqueta(String etiqueta);

    // --- MÉTODOS FALTANTES QUE AGREGAMOS AHORA ---

    // 1. Verifica si ya existe el código (Para crear nueva pregunta)
    boolean existsByCodigoStata(String codigoStata);

    // 2. Verifica si existe el código EN OTRA pregunta distinta (Para actualizar)
    // Usamos @Query para asegurar que compare con 'pregunta_id' correctamente
    @Query("SELECT COUNT(p) > 0 FROM Pregunta p WHERE p.codigoStata = :codigo AND p.pregunta_id <> :id")
    boolean existsByCodigoStataAndIdNot(@Param("codigo") String codigo, @Param("id") Long id);

    // ---------------------------------------------

    // Para la exportación COMPLETA
    @Query("SELECT p FROM Pregunta p WHERE p.activo = true AND p.exportable = true ORDER BY p.orden ASC")
    List<Pregunta> findByActivoTrueAndExportableTrueOrderByOrdenAsc();

    // Para la exportación ANÓNIMA
    @Query("SELECT p FROM Pregunta p WHERE p.activo = true AND p.dato_sensible = false AND p.exportable = true ORDER BY p.orden ASC")
    List<Pregunta> findByActivoTrueAndDato_sensibleFalseAndExportableTrueOrderByOrdenAsc();
}