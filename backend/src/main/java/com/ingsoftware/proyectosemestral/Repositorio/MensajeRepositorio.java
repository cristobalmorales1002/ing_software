package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Mensaje;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MensajeRepositorio extends JpaRepository<Mensaje, Long> {
    List<Mensaje> findByEmisor_IdUsuarioOrderByFechaEnvioDesc(Long idUsuario);
}