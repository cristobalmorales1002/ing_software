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

        if (valorActual == null || valorActual.isBlank()) {
            if ("OCULTAR".equalsIgnoreCase(accion)) {
                return "OCULTA";
            } else if ("BLOQUEAR".equalsIgnoreCase(accion)) {
                return "BLOQUEADA";
            }
            return "VISIBLE";
        }

        boolean cumpleCondicion = valorActual.trim().equalsIgnoreCase(valorEsperado.trim());

        if (!cumpleCondicion) {
            if ("OCULTAR".equalsIgnoreCase(accion)) {
                return "OCULTA";
            } else if ("BLOQUEAR".equalsIgnoreCase(accion)) {
                return "BLOQUEADA";
            }
        }
        return "VISIBLE";
    }
}