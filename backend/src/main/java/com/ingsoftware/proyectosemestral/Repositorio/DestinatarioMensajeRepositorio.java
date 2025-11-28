package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.DestinatarioMensaje;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DestinatarioMensajeRepositorio extends JpaRepository<DestinatarioMensaje, Long> {

    List<DestinatarioMensaje> findByDestinatario_IdUsuarioAndEliminadoFalseOrderByMensaje_FechaEnvioDesc(Long idUsuario);

    long countByDestinatario_IdUsuarioAndLeidoFalseAndEliminadoFalse(Long idUsuario);
}