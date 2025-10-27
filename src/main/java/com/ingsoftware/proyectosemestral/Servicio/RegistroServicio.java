package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Registro;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.RegistroRepositorio;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service //Indica que es una clase de servicio
public class RegistroServicio {

    @Autowired //Inyectar el repositorio para poder gurdar en la BDD
    private RegistroRepositorio registroRepositorio;

    //Metodo especialista, ingresa un log y lo vincula a una respuesta especifica.
    @Transactional //Se asegura que la operación sea atomica
    public void registrarAccion(Usuario usuario, String accion, String detalles, Respuesta respuesta ) {
        Registro registro = new Registro();
        registro.setUsuario(usuario);
        registro.setAccion(accion);
        registro.setDetalles(detalles);
        registro.setRegistroFecha(LocalDateTime.now());

        // Vincula este registro con la respuesta específica que se modificó.
        registro.setRespuesta(respuesta);

        registroRepositorio.save(registro);
    }

    //Metodo generalista (sobrecarga de metodos), registra un log general del sistema
    //Ayuda a que los logs no esten atados a una respuesta, y llama al metodo especialista pasando null en la respuesta.
    @Transactional
    public void registrarAccion(Usuario usuario, String accion, String detalles) {
        // Llama al metodo especialista con respuesta como null
        this.registrarAccion(usuario, accion, detalles, null);
    }
}
