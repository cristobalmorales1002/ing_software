package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class EstadisticaServicio {

    @Autowired
    private PreguntaRepositorio preguntaRepositorio;

    @Autowired
    private PacienteRepositorio pacienteRepositorio;

    @Transactional(readOnly = true)
    public List<EstadisticaDto> calcularEstadisticasDashboard() {
        // Obtener preguntas configuradas para estadísticas (Solo las activas y de tipo ENUM)
        List<Pregunta> preguntasParaEstadistica = preguntaRepositorio.findAll().stream()
                .filter(p -> p.isActivo() && p.isGenerarEstadistica())
                .collect(Collectors.toList());

        // Obtener todos los pacientes activos para contar sus respuestas
        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        long totalPacientes = pacientes.size();

        List<EstadisticaDto> resultados = new ArrayList<>();

        for (Pregunta p : preguntasParaEstadistica) {
            EstadisticaDto dto = new EstadisticaDto();
            dto.setPreguntaId(p.getPregunta_id());
            dto.setTituloPregunta(p.getEtiqueta());

            // Mapa para contar: "Opción A" -> 5, "Opción B" -> 3
            Map<String, Long> conteoRespuestas = new HashMap<>();

            // Inicializar mapa con 0 para todas las opciones posibles (para que salgan aunque nadie responda)
            p.getOpciones().forEach(op -> conteoRespuestas.put(op.getEtiqueta(), 0L));

            // Contar respuestas reales
            for (Paciente paciente : pacientes) {
                // Buscar respuesta del paciente a esta pregunta
                paciente.getRespuestas().stream()
                        .filter(r -> r.getPregunta().getPregunta_id().equals(p.getPregunta_id()))
                        .findFirst()
                        .ifPresent(respuesta -> {
                            String valor = respuesta.getValor();
                            if (valor != null && !valor.isBlank()) {
                                // Normalizar clave para evitar duplicados por espacios
                                // Buscamos la etiqueta exacta en las opciones para sumar al bucket correcto
                                conteoRespuestas.computeIfPresent(valor, (k, v) -> v + 1);
                                // Si la respuesta no coincide exacto con una opción (ej: se editó la opción después),
                                // se podría agregar como "Otros" o ignorar. Aquí asumimos consistencia.
                            }
                        });
            }

            // Convertir Mapa a Lista de DTOs
            List<EstadisticaDto.DatoGrafico> datosGrafico = new ArrayList<>();
            long totalRespuestasValidas = conteoRespuestas.values().stream().mapToLong(Long::longValue).sum();

            for (Map.Entry<String, Long> entry : conteoRespuestas.entrySet()) {
                double porcentaje = 0.0;
                if (totalRespuestasValidas > 0) {
                    porcentaje = (entry.getValue() * 100.0) / totalRespuestasValidas;
                }
                // Redondear a 1 decimal
                porcentaje = Math.round(porcentaje * 10.0) / 10.0;

                datosGrafico.add(new EstadisticaDto.DatoGrafico(entry.getKey(), entry.getValue(), porcentaje));
            }

            dto.setDatos(datosGrafico);
            resultados.add(dto);
        }

        // Extra: Agregar estadística fija de Casos vs Controles
        resultados.add(0, calcularEstadisticaCasosControles(pacientes));

        return resultados;
    }

    private EstadisticaDto calcularEstadisticaCasosControles(List<Paciente> pacientes) {
        long total = pacientes.size();
        long casos = pacientes.stream().filter(Paciente::getEsCaso).count();
        long controles = total - casos;

        EstadisticaDto dto = new EstadisticaDto();
        dto.setTituloPregunta("Distribución Casos vs Controles");
        dto.setPreguntaId(0L); // ID ficticio

        List<EstadisticaDto.DatoGrafico> datos = new ArrayList<>();

        double porcCasos = total > 0 ? (casos * 100.0) / total : 0;
        double porcControles = total > 0 ? (controles * 100.0) / total : 0;

        datos.add(new EstadisticaDto.DatoGrafico("Casos", casos, Math.round(porcCasos * 10.0) / 10.0));
        datos.add(new EstadisticaDto.DatoGrafico("Controles", controles, Math.round(porcControles * 10.0) / 10.0));

        dto.setDatos(datos);
        return dto;
    }
}