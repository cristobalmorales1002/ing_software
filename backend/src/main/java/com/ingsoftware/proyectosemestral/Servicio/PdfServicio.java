package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PdfServicio {

    @Autowired
    private PacienteRepositorio pacienteRepositorio;

    @Autowired
    private CategoriaRepositorio categoriaRepositorio;

    @Autowired
    private TemplateEngine templateEngine;

    @Transactional(readOnly = true)
    public byte[] generarCrfPdf(Long pacienteId) {
        // 1. Obtener la estructura completa del formulario (Categorías y Preguntas activas)
        // Ordenamos por el campo 'orden'
        List<Categoria> categorias = categoriaRepositorio.findAll().stream()
                .sorted(Comparator.comparingInt(Categoria::getOrden))
                .peek(cat -> {
                    // Ordenar preguntas internas también
                    List<Pregunta> preguntasOrdenadas = cat.getPreguntas().stream()
                            .filter(Pregunta::isActivo) // Solo mostrar preguntas activas
                            .sorted(Comparator.comparingInt(Pregunta::getOrden))
                            .collect(Collectors.toList());
                    // Convertimos a Set o List para la vista (Thymeleaf itera Lists mejor)
                    cat.setPreguntas(new HashSet<>(preguntasOrdenadas));
                })
                .collect(Collectors.toList());

        // 2. Preparar Contexto de Thymeleaf (Variables para el HTML)
        Context context = new Context();
        context.setVariable("categorias", categorias);

        // 3. Si hay paciente, cargar sus datos
        if (pacienteId != null) {
            Paciente paciente = pacienteRepositorio.findById(pacienteId)
                    .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            context.setVariable("codigoPaciente", paciente.getParticipanteCod());
            context.setVariable("esCaso", paciente.getEsCaso());
            context.setVariable("fechaInclusion", paciente.getFechaIncl().toString());

            // Mapear respuestas para acceso rápido: ID_PREGUNTA -> RESPUESTA
            Map<Long, Respuesta> respuestasMap = new HashMap<>();
            for (Respuesta r : paciente.getRespuestas()) {
                if (r.getPregunta() != null) {
                    respuestasMap.put(r.getPregunta().getPregunta_id(), r);
                }
            }
            context.setVariable("respuestasMap", respuestasMap);
        } else {
            // CRF Vacío
            context.setVariable("codigoPaciente", null);
            context.setVariable("esCaso", null);
            context.setVariable("respuestasMap", new HashMap<>());
        }

        // 4. Renderizar HTML
        String htmlContent = templateEngine.process("crf_template", context);

        // 5. Convertir HTML a PDF
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(htmlContent, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error al generar PDF del CRF", e);
        }
    }
}