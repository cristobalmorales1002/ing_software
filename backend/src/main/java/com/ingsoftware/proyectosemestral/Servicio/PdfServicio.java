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

import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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
        // 1. Obtener datos crudos de la BD
        List<Categoria> categoriasEntidad = categoriaRepositorio.findAll().stream()
                .sorted(Comparator.comparingInt(Categoria::getOrden))
                .collect(Collectors.toList());

        // 2. CONSTRUIR VISTA MANUALMENTE (ESTRATEGIA SEGURA)
        // Convertimos las Entidades a una Lista de Mapas.
        // Al usar una List<Pregunta> explícita en el mapa, garantizamos que Thymeleaf
        // respete el orden visual al 100%, sin interferencia de JPA/Hibernate.
        List<Map<String, Object>> categoriasVista = new ArrayList<>();

        for (Categoria cat : categoriasEntidad) {
            Map<String, Object> map = new HashMap<>();
            map.put("id_cat", cat.getId_cat());
            map.put("nombre", cat.getNombre());
            map.put("orden", cat.getOrden());

            // Ordenamos las preguntas y las guardamos en una LISTA
            List<Pregunta> preguntasOrdenadas = cat.getPreguntas().stream()
                    .filter(Pregunta::isActivo)
                    .sorted(Comparator.comparingInt(Pregunta::getOrden))
                    .collect(Collectors.toList());

            // Opcional: Ordenar también las opciones dentro de cada pregunta para asegurar (Sí, No, etc.)
            preguntasOrdenadas.forEach(p -> {
                if (p.getOpciones() != null) {
                    p.getOpciones().sort(Comparator.comparingInt(OpcionPregunta::getOrden));
                }
            });

            map.put("preguntas", preguntasOrdenadas);
            categoriasVista.add(map);
        }

        // 3. Preparar Contexto usando nuestra lista segura "categoriasVista"
        Context context = new Context();
        context.setVariable("categorias", categoriasVista);

        // 4. Si hay paciente, cargar sus datos
        if (pacienteId != null) {
            Paciente paciente = pacienteRepositorio.findById(pacienteId)
                    .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            context.setVariable("codigoPaciente", paciente.getParticipanteCod());
            context.setVariable("esCaso", paciente.getEsCaso());
            context.setVariable("fechaInclusion", paciente.getFechaIncl().toString());

            // Mapear respuestas
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

        // 5. Renderizar HTML
        String htmlContent = templateEngine.process("crf_template", context);

        // 6. Convertir HTML a PDF
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

    @Transactional(readOnly = true)
    public byte[] generarZipCrfs(List<Long> pacienteIds) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             ZipOutputStream zos = new ZipOutputStream(baos)) {

            for (Long id : pacienteIds) {
                Paciente p = pacienteRepositorio.findById(id).orElse(null);
                if (p == null) continue;

                byte[] pdfBytes = generarCrfPdf(id);

                ZipEntry entry = new ZipEntry("CRF_" + p.getParticipanteCod() + ".pdf");
                entry.setSize(pdfBytes.length);
                zos.putNextEntry(entry);
                zos.write(pdfBytes);
                zos.closeEntry();
            }

            zos.finish();
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error al generar ZIP de CRFs", e);
        }
    }
}