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
        resultados.add(getConteoPorRangoDeEdad());
        return EstadisticaDemograficaDto.builder().datos(resultados).build();
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

    private EstadisticaDto getConteoPorRangoDeEdad() {
        Pregunta preguntaFechaNac = preguntaRepositorio.findByEtiqueta(ETIQUETA_FECHA_NACIMIENTO)
                .orElseThrow(() -> new RuntimeException("Pregunta de Fecha de Nacimiento no encontrada: " + ETIQUETA_FECHA_NACIMIENTO));

        List<Respuesta> respuestas = respuestaRepositorio.findByPregunta(preguntaFechaNac);
        LocalDate hoy = LocalDate.now();

        Map<String, Long> conteo = respuestas.stream()
                .filter(r -> r.getValor() != null && !r.getValor().isBlank())
                .map(r -> {
                    try {
                        LocalDate fechaNac = LocalDate.parse(r.getValor());
                        return Period.between(fechaNac, hoy).getYears();
                    } catch (Exception e) {
                        return -1;
                    }
                })
                .filter(edad -> edad >= 0)
                .collect(Collectors.groupingBy(
                        EstadisticaServicio::clasificarEdad,
                        Collectors.counting()
                ));

        return EstadisticaDto.builder()
                .nombreEstadistica("Conteo por Rangos de Edad")
                .conteoPorCategoria(conteo)
                .build();
    }

    private static String clasificarEdad(int edad) {
        if (edad >= 18 && edad <= 30) {
            return "18-30 años";
        } else if (edad >= 31 && edad <= 50) {
            return "31-50 años";
        } else if (edad > 50) {
            return "Más de 50 años";
        } else {
            return "Menores de 18 no existen";
        }
    }
}
