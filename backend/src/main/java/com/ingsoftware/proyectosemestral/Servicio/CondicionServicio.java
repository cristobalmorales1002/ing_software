package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class CondicionServicio {

    public String evaluarEstadoPregunta(Pregunta pregunta, Map<Long, String> respuestasActuales) {
        if (pregunta.getPreguntaControladora() == null) {
            return "VISIBLE";
        }

        Long idControladora = pregunta.getPreguntaControladora().getPregunta_id();
        String valorEsperado = pregunta.getValorEsperadoControladora();
        String accion = pregunta.getAccionSiNoCumple();

        String valorActual = respuestasActuales.get(idControladora);
        return "VISIBLE";
    }
}