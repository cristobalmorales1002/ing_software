package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Servicio.CondicionServicio;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class CondicionServicioTest {

    @Autowired
    private CondicionServicio condicionServicio;

    @Test
    void testPreguntaSinDependenciaEsSiempreVisible() {
        Pregunta p = new Pregunta();
        p.setPreguntaControladora(null);

        String estado = condicionServicio.evaluarEstadoPregunta(p, new HashMap<>());
        assertEquals("VISIBLE", estado);
    }

    @Test
    void testPreguntaSeOcultaSiNoCumpleCondicion() {
        Pregunta controladora = new Pregunta();
        controladora.setPregunta_id(10L);

        Pregunta dependiente = new Pregunta();
        dependiente.setPreguntaControladora(controladora);
        dependiente.setValorEsperadoControladora("Sí");
        dependiente.setAccionSiNoCumple("OCULTAR");

        Map<Long, String> respuestas = new HashMap<>();
        respuestas.put(10L, "No");

        String estado = condicionServicio.evaluarEstadoPregunta(dependiente, respuestas);
        assertEquals("OCULTA", estado);
    }

    @Test
    void testPreguntaSeMuestraSiCumpleCondicion() {
        Pregunta controladora = new Pregunta();
        controladora.setPregunta_id(20L);

        Pregunta dependiente = new Pregunta();
        dependiente.setPreguntaControladora(controladora);
        dependiente.setValorEsperadoControladora("Positivo");
        dependiente.setAccionSiNoCumple("BLOQUEAR");

        Map<Long, String> respuestas = new HashMap<>();
        respuestas.put(20L, "Positivo");

        String estado = condicionServicio.evaluarEstadoPregunta(dependiente, respuestas);
        assertEquals("VISIBLE", estado);
    }
}