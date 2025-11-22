package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.RegistroResponseDto;
import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.RegistroRepositorio;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Service
public class RegistroServicio {

    @Autowired
    private RegistroRepositorio registroRepositorio;

    @Transactional
    public void registrarAccion(Usuario usuario, String accion, String detalles, Respuesta respuesta ) {
        Registro registro = new Registro();
        registro.setUsuario(usuario);
        registro.setAccion(accion);
        registro.setDetalles(detalles);
        registro.setRegistroFecha(LocalDateTime.now());
        registro.setRespuesta(respuesta);
        registroRepositorio.save(registro);
    }

    @Transactional
    public void registrarAccion(Usuario usuario, String accion, String detalles) {
        this.registrarAccion(usuario, accion, detalles, null);
    }

    // AHORA SÍ FUNCIONA EL READONLY
    @Transactional(readOnly = true)
    public Page<RegistroResponseDto> obtenerLogsPaginados(LocalDate fechaInicio, LocalDate fechaFin, Pageable pageable) {

        Page<Registro> paginaRegistros;

        if (fechaInicio != null && fechaFin != null) {
            LocalDateTime inicio = fechaInicio.atStartOfDay();
            LocalDateTime fin = fechaFin.atTime(LocalTime.MAX);

            paginaRegistros = registroRepositorio.findByRegistroFechaBetween(inicio, fin, pageable);
        } else {
            paginaRegistros = registroRepositorio.findAll(pageable);
        }

        return paginaRegistros.map(this::mapearADto);
    }

    private RegistroResponseDto mapearADto(Registro r) {
        RegistroResponseDto dto = new RegistroResponseDto();
        dto.setId(r.getRegistro_id());
        dto.setAccion(r.getAccion());
        dto.setDetalles(r.getDetalles());
        dto.setFecha(r.getRegistroFecha());

        if (r.getUsuario() != null) {
            dto.setNombreUsuario(r.getUsuario().getNombres() + " " + r.getUsuario().getApellidos());
            dto.setRutUsuario(r.getUsuario().getRut());
        }

        if (r.getRespuesta() != null) {
            dto.setIdRespuestaAfectada(r.getRespuesta().getRespuesta_id());
        }

        return dto;
    }
}