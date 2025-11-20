package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDemograficaDto;
import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.RespuestaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class EstadisticaServicio {
    @Autowired
    private RespuestaRepositorio respuestaRepositorio;

    @Autowired
    private PreguntaRepositorio preguntaRepositorio;

    private static final String ETIQUETA_SEXO = "SEXO";
    private static final String ETIQUETA_FECHA_NACIMIENTO = "FECHA_NACIMIENTO";

    @Transactional(readOnly = true)
    public EstadisticaDemograficaDto obtenerEstadisticasDemograficas() {
        List<EstadisticaDto> resultados = new ArrayList<>();
        resultados.add(getConteoPorSexo());
        return null;
    }

    private EstadisticaDto getConteoPorSexo() {
        Pregunta preguntaSexo = preguntaRepositorio.findByEtiqueta(ETIQUETA_SEXO)
                .orElseThrow(() -> new RuntimeException("Pregunta de Sexo no encontrada: " + ETIQUETA_SEXO));

        List<Respuesta> respuestas = respuestaRepositorio.findByPregunta(preguntaSexo);

        Map<String, Long> conteo = respuestas.stream()
                .filter(r -> r.getValor() != null && !r.getValor().isBlank())
                .collect(Collectors.groupingBy(
                        Respuesta::getValor,
                        Collectors.counting()
                ));

        return EstadisticaDto.builder()
                .nombreEstadistica("Conteo por Sexo")
                .conteoPorCategoria(conteo)
                .build();
    }

}
