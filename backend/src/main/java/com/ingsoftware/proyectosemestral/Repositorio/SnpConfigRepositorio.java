package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.SnpConfig;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SnpConfigRepositorio extends JpaRepository<SnpConfig, Long> {
    // Para buscar por nombre si hace falta
}