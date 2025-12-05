package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
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

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Transactional(readOnly = true)
    public List<EstadisticaDto> calcularEstadisticasDashboard(String rutUsuario) {

        Usuario usuario = usuarioRepositorio.findByRut(rutUsuario)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        String prefs = usuario.getPreferenciasEstadisticas();
        System.out.println(">>> LEYENDO PREFERENCIAS de " + rutUsuario + ": [" + prefs + "]");

        List<Pregunta> preguntasParaEstadistica;

        // CASO 1: Usuario Nuevo (NULL) -> Usar Defaults (Solo Sexo)
        if (prefs == null) {
            System.out.println(">>> Preferencias NULL. Usando DEFAULTS (Sexo).");
            preguntasParaEstadistica = obtenerPreguntasPorDefecto();
        }
        // CASO 2: Usuario limpió todo explícitamente (Vacío) -> Ver nada
        else if (prefs.trim().isEmpty()) {
            System.out.println(">>> Preferencias VACÍAS. Mostrando 0 gráficos.");
            preguntasParaEstadistica = new ArrayList<>();
        }
        // CASO 3: Usuario tiene selección guardada
        else {
            try {
                List<Long> ids = Arrays.stream(prefs.split(","))
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .map(Long::valueOf)
                        .collect(Collectors.toList());

                preguntasParaEstadistica = preguntaRepositorio.findAllById(ids);
                System.out.println(">>> Preferencias ENCONTRADAS. IDs: " + ids);
            } catch (Exception e) {
                System.err.println(">>> ERROR parseando preferencias: " + e.getMessage());
                preguntasParaEstadistica = obtenerPreguntasPorDefecto();
            }
        }

        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        List<EstadisticaDto> resultados = new ArrayList<>();

        // Generar gráficos dinámicos (Sexo, etc.)
        for (Pregunta p : preguntasParaEstadistica) {
            EstadisticaDto dto = new EstadisticaDto();
            dto.setPreguntaId(p.getPregunta_id());
            dto.setTituloPregunta(p.getEtiqueta());

            Map<String, Long> conteoRespuestas = new HashMap<>();
            if (p.getOpciones() != null) {
                p.getOpciones().forEach(op -> conteoRespuestas.put(op.getEtiqueta(), 0L));
            }

            for (Paciente paciente : pacientes) {
                if (paciente.getRespuestas() != null) {
                    paciente.getRespuestas().stream()
                            .filter(r -> r.getPregunta().getPregunta_id().equals(p.getPregunta_id()))
                            .findFirst()
                            .ifPresent(respuesta -> {
                                String valor = respuesta.getValor();
                                if (valor != null && !valor.isBlank()) {
                                    conteoRespuestas.compute(valor, (k, v) -> (v == null) ? 1L : v + 1);
                                }
                            });
                }
            }

            List<EstadisticaDto.DatoGrafico> datosGrafico = new ArrayList<>();
            long totalRespuestasValidas = conteoRespuestas.values().stream().mapToLong(Long::longValue).sum();

            for (Map.Entry<String, Long> entry : conteoRespuestas.entrySet()) {
                double porcentaje = 0.0;
                if (totalRespuestasValidas > 0) {
                    porcentaje = (entry.getValue() * 100.0) / totalRespuestasValidas;
                }
                porcentaje = Math.round(porcentaje * 10.0) / 10.0;
                datosGrafico.add(new EstadisticaDto.DatoGrafico(entry.getKey(), entry.getValue(), porcentaje));
            }

            dto.setDatos(datosGrafico);
            resultados.add(dto);
        }

        // Agregar SIEMPRE estadística fija de Casos vs Controles al principio (Posición 0)
        resultados.add(0, calcularEstadisticaCasosControles(pacientes));

        return resultados;
    }

    /**
     * Lógica por defecto: devuelve SOLO las preguntas que contengan "Sexo" en el título.
     * (El gráfico de Casos vs Controles se agrega aparte, no es una Pregunta).
     */
    private List<Pregunta> obtenerPreguntasPorDefecto() {
        return preguntaRepositorio.findAll().stream()
                .filter(p -> p.isActivo() && p.isGenerarEstadistica())
                // --- CAMBIO CLAVE AQUÍ ---
                // Filtramos para que, si no hay preferencias, solo salga "Sexo"
                .filter(p -> p.getEtiqueta() != null && p.getEtiqueta().toLowerCase().contains("sexo"))
                .collect(Collectors.toList());
    }

    private EstadisticaDto calcularEstadisticaCasosControles(List<Paciente> pacientes) {
        long total = pacientes.size();
        long casos = pacientes.stream().filter(p -> Boolean.TRUE.equals(p.getEsCaso())).count();
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

    public List<Map<String, Object>> obtenerOpcionesDisponibles() {
        return preguntaRepositorio.findAll().stream()
                .filter(p -> p.isActivo() && p.isGenerarEstadistica())
                .map(p -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("preguntaId", p.getPregunta_id());
                    map.put("tituloPregunta", p.getEtiqueta());
                    return map;
                })
                .collect(Collectors.toList());
    }
}