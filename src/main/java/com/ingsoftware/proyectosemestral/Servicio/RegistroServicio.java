package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.RegistroRepositorio;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

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
}
