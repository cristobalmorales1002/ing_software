package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class ExportacionServicio {

    @Autowired private PacienteRepositorio pacienteRepositorio;
    @Autowired private PreguntaRepositorio preguntaRepositorio;

    @Transactional(readOnly = true)
    public ByteArrayInputStream generarExcel(boolean anonimo, boolean dicotomizar) throws IOException {

        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        List<Pregunta> preguntas;

        // 1. SELECCIÓN DE PREGUNTAS
        if (dicotomizar) {
            // MODO STATA: Solo variables de estudio (filtro estricto: Numéricas y ENUMs exportables)
            List<Pregunta> base;
            if (anonimo) {
                base = preguntaRepositorio.findByActivoTrueAndDato_sensibleFalseAndExportableTrueOrderByOrdenAsc();
            } else {
                base = preguntaRepositorio.findByActivoTrueAndExportableTrueOrderByOrdenAsc();
            }
            // Filtramos explícitamente cualquier texto libre que se haya colado, ya que no se puede dicotomizar
            preguntas = base.stream()
                    .filter(p -> p.getTipo_dato() != TipoDato.TEXTO)
                    .collect(Collectors.toList());
        } else {
            // MODO COMPLETO: Todas las variables activas (incluso texto libre)
            List<Pregunta> todas = preguntaRepositorio.findByActivo(true);
            Stream<Pregunta> stream = todas.stream().sorted(Comparator.comparingInt(Pregunta::getOrden));

            // Si es anónimo, filtramos manualmente las sensibles (RUT, Nombre, Dirección, etc.)
            if (anonimo) {
                stream = stream.filter(p -> !p.isDato_sensible());
            }
            preguntas = stream.collect(Collectors.toList());
        }

        // 2. CÁLCULOS ESTADÍSTICOS (Solo necesarios para cortes automáticos en modo dicotomizado)
        Map<Long, Double> medias = new HashMap<>();
        Map<Long, Double> medianas = new HashMap<>();
        if (dicotomizar) {
            calcularEstadisticasGlobales(preguntas, pacientes, medias, medianas);
        }

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            XSSFSheet sheetDatos = workbook.createSheet("Datos");
            XSSFSheet sheetResumen = workbook.createSheet("Resumen_Conteos");

            // Diccionario SOLO si es dicotomizado (Stata)
            XSSFSheet sheetDiccionario = dicotomizar ? workbook.createSheet("Diccionario_Variables") : null;

            // 3. HEADERS
            Row hRow = sheetDatos.createRow(0);
            List<String> hList = new ArrayList<>();

            if (anonimo) {
                hList.add("ID");
            } else {
                hList.add("ID_Participante");
                hList.add("Codigo_Participante");
            }
            hList.add("Es_Caso_Cod");

            for (Pregunta p : preguntas) {
                // Etiqueta legible para Completo, Código técnico para Dicotomizado
                String label = (dicotomizar && p.getCodigoStata() != null && !p.getCodigoStata().isBlank())
                        ? p.getCodigoStata()
                        : p.getEtiqueta();
                hList.add(label);

                // Columnas extra SOLO si estamos dicotomizando
                if (dicotomizar) {
                    if (p.getTipo_dato() == TipoDato.NUMERO) {
                        hList.add(label + "_media_cod");
                        hList.add(label + "_mediana_cod");
                    }
                    // Cortes manuales (para Numéricas y ENUMs)
                    if (p.getDicotomizaciones() != null) {
                        for (Dicotomizacion d : p.getDicotomizaciones()) {
                            hList.add(label + "_corte_" + d.getValor() + "_cod");
                        }
                    }
                }
            }
            // Escribir headers
            for (int i = 0; i < hList.size(); i++) {
                hRow.createCell(i).setCellValue(hList.get(i));
            }

            // 4. LLENADO DE DATOS
            int rNum = 1;
            Map<Integer, Map<String, Integer>> mapaConteos = new HashMap<>();

            for (Paciente p : pacientes) {
                Row row = sheetDatos.createRow(rNum++);
                int c = 0;

                // Mapa rápido de respuestas
                Map<Long, Respuesta> mapR = p.getRespuestas().stream()
                        .filter(r -> r.getPregunta() != null)
                        .collect(Collectors.toMap(r -> r.getPregunta().getPregunta_id(), r -> r, (a, b) -> a));

                // IDs
                if (anonimo) {
                    row.createCell(c++).setCellValue(p.getParticipanteCod());
                } else {
                    row.createCell(c++).setCellValue(p.getParticipante_id());
                    row.createCell(c++).setCellValue(p.getParticipanteCod());
                }

                // Caso Base
                String vCaso = p.getEsCaso() ? "1" : "0";
                row.createCell(c).setCellValue(vCaso);
                registrarConteo(mapaConteos, c++, vCaso);

                // Preguntas
                for (Pregunta ph : preguntas) {
                    Respuesta r = mapR.get(ph.getPregunta_id());
                    String vRaw = r != null ? r.getValor() : "";
                    String vFin = vRaw;

                    // Si es dicotomizado, transformamos texto a número (0/1) si aplica
                    if (dicotomizar) {
                        if (ph.getTipo_dato() == TipoDato.ENUM) {
                            vFin = buscarValorDicotomizado(ph.getOpciones(), vRaw);
                        } else if (isBooleano(vRaw)) {
                            vFin = convertirBooleano(vRaw);
                        }
                    }
                    row.createCell(c).setCellValue(vFin);

                    // Lógica de conteo para Resumen
                    registrarConteo(mapaConteos, c, vFin);
                    c++;

                    // Columnas calculadas (Solo en modo Dicotomizado)
                    if (dicotomizar) {
                        Double valNum = null;
                        if (ph.getTipo_dato() == TipoDato.NUMERO) {
                            valNum = parseDoubleSeguro(vRaw);
                        } else if (ph.getTipo_dato() == TipoDato.ENUM) {
                            valNum = obtenerOrdenOpcion(ph.getOpciones(), vRaw);
                        }

                        // Automáticas (solo números)
                        if (ph.getTipo_dato() == TipoDato.NUMERO) {
                            String rm = aplicarCorte(valNum, medias.get(ph.getPregunta_id()), SentidoCorte.MAYOR_O_IGUAL);
                            row.createCell(c).setCellValue(rm);
                            registrarConteo(mapaConteos, c++, rm);

                            String rmd = aplicarCorte(valNum, medianas.get(ph.getPregunta_id()), SentidoCorte.MAYOR_O_IGUAL);
                            row.createCell(c).setCellValue(rmd);
                            registrarConteo(mapaConteos, c++, rmd);
                        }

                        // Manuales (lista de cortes)
                        if (ph.getDicotomizaciones() != null) {
                            for (Dicotomizacion dic : ph.getDicotomizaciones()) {
                                String rf = aplicarCorte(valNum, dic.getValor(), dic.getSentido());
                                row.createCell(c).setCellValue(rf);
                                registrarConteo(mapaConteos, c++, rf);
                            }
                        }
                    }
                }
            }

            // 5. GENERAR RESUMEN (Lógica diferenciada)
            if (dicotomizar) {
                generarResumenDicotomizado(sheetResumen, hList, mapaConteos);
            } else {
                generarResumenCompleto(sheetResumen, hList, mapaConteos);
            }

            // 6. DICCIONARIO (Solo si corresponde)
            if (sheetDiccionario != null) {
                generarHojaDiccionario(sheetDiccionario, preguntas, medias, medianas, dicotomizar);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }

    // --- MÉTODOS DE RESUMEN Y CONTEO ---

    private void registrarConteo(Map<Integer, Map<String, Integer>> mapa, int col, String val) {
        String key = (val == null || val.isBlank()) ? "(Vacío)" : val;
        mapa.computeIfAbsent(col, k -> new HashMap<>()).merge(key, 1, Integer::sum);
    }

    // Resumen para Stata: Detalle de 0, 1 y Vacíos
    private void generarResumenDicotomizado(XSSFSheet sheet, List<String> headers, Map<Integer, Map<String, Integer>> mapaConteos) {
        Row rowH = sheet.createRow(0);
        for(int i=0; i<headers.size(); i++) rowH.createCell(i).setCellValue(headers.get(i));

        List<String> keys = Arrays.asList("(Vacío)", "0", "1");
        int r = 1;
        for (String k : keys) {
            Row row = sheet.createRow(r++);
            row.createCell(0).setCellValue("Contar '" + k + "'");
            for (int c = 1; c < headers.size(); c++) {
                if (mapaConteos.containsKey(c)) {
                    Integer count = mapaConteos.get(c).getOrDefault(k, 0);
                    if (count > 0) row.createCell(c).setCellValue(count);
                }
            }
        }
        generarFilaTotal(sheet, headers, mapaConteos, r);
        sheet.autoSizeColumn(0);
    }

    // Resumen para Completo: Válidos vs Vacíos (Limpio)
    private void generarResumenCompleto(XSSFSheet sheet, List<String> headers, Map<Integer, Map<String, Integer>> mapaConteos) {
        Row rowH = sheet.createRow(0);
        for(int i=0; i<headers.size(); i++) rowH.createCell(i).setCellValue(headers.get(i));

        int r = 1;
        Row rowValidos = sheet.createRow(r++);
        rowValidos.createCell(0).setCellValue("Datos Válidos (Respondidos)");

        Row rowVacios = sheet.createRow(r++);
        rowVacios.createCell(0).setCellValue("Vacíos / Sin Información");

        for (int c = 1; c < headers.size(); c++) {
            if (mapaConteos.containsKey(c)) {
                Map<String, Integer> colData = mapaConteos.get(c);
                int vacios = colData.getOrDefault("(Vacío)", 0);
                int total = colData.values().stream().mapToInt(Integer::intValue).sum();
                int validos = total - vacios;

                if (validos > 0) rowValidos.createCell(c).setCellValue(validos);
                if (vacios > 0) rowVacios.createCell(c).setCellValue(vacios);
            }
        }
        generarFilaTotal(sheet, headers, mapaConteos, r);
        sheet.autoSizeColumn(0);
    }

    private void generarFilaTotal(XSSFSheet sheet, List<String> headers, Map<Integer, Map<String, Integer>> mapaConteos, int rowIdx) {
        Row rowT = sheet.createRow(rowIdx);
        rowT.createCell(0).setCellValue("Total Registros");
        for (int c = 1; c < headers.size(); c++) {
            if (mapaConteos.containsKey(c)) {
                int total = mapaConteos.get(c).values().stream().mapToInt(i -> i).sum();
                rowT.createCell(c).setCellValue(total);
            }
        }
    }

    // --- DICCIONARIO DE VARIABLES ---

    private void generarHojaDiccionario(XSSFSheet sheet, List<Pregunta> preguntas, Map<Long, Double> medias, Map<Long, Double> medianas, boolean dicotomizar) {
        Row h = sheet.createRow(0);
        h.createCell(0).setCellValue("Código");
        h.createCell(1).setCellValue("Pregunta");
        h.createCell(2).setCellValue("Significado");

        int r = 1;
        // Fila fija para Grupo
        Row rowCaso = sheet.createRow(r++);
        rowCaso.createCell(0).setCellValue("Es_Caso_Cod");
        rowCaso.createCell(1).setCellValue("Grupo del participante");
        rowCaso.createCell(2).setCellValue("1 = Caso (Cáncer), 0 = Control (Sano)");

        for (Pregunta p : preguntas) {
            String cod = (p.getCodigoStata() != null && !p.getCodigoStata().isBlank()) ? p.getCodigoStata() : p.getEtiqueta();
            Row row = sheet.createRow(r++);
            row.createCell(0).setCellValue(cod);
            row.createCell(1).setCellValue(p.getEtiqueta());
            row.createCell(2).setCellValue(p.getTipo_dato() == TipoDato.ENUM ? verOpciones(p) : "Valor directo");

            if (dicotomizar) {
                if (p.getTipo_dato() == TipoDato.NUMERO) {
                    Row rm = sheet.createRow(r++);
                    rm.createCell(0).setCellValue(cod + "_media");
                    rm.createCell(2).setCellValue("1 si >= Media (" + String.format("%.2f", medias.getOrDefault(p.getPregunta_id(), 0.0)) + ")");

                    Row rmd = sheet.createRow(r++);
                    rmd.createCell(0).setCellValue(cod + "_mediana");
                    rmd.createCell(2).setCellValue("1 si >= Mediana (" + String.format("%.2f", medianas.getOrDefault(p.getPregunta_id(), 0.0)) + ")");
                }

                if (p.getDicotomizaciones() != null) {
                    for (Dicotomizacion d : p.getDicotomizaciones()) {
                        Row rf = sheet.createRow(r++);
                        rf.createCell(0).setCellValue(cod + "_corte_" + d.getValor() + "_cod");

                        String criterio;
                        if (p.getTipo_dato() == TipoDato.ENUM) {
                            criterio = "Opción Orden >= " + d.getValor().intValue();
                        } else {
                            criterio = "Valor " + (d.getSentido() != null ? d.getSentido() : "MAYOR_O_IGUAL") + " " + d.getValor();
                        }
                        rf.createCell(2).setCellValue("1 si " + criterio);
                    }
                }
            }
        }
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
        sheet.setColumnWidth(2, 12000);
    }

    // --- UTILS Y HELPERS ---

    private String verOpciones(Pregunta p) {
        if (p.getOpciones() == null) return "";
        return p.getOpciones().stream()
                .sorted(Comparator.comparingInt(OpcionPregunta::getOrden))
                .map(o -> o.getOrden() + "=" + o.getEtiqueta())
                .collect(Collectors.joining("; "));
    }

    private void calcularEstadisticasGlobales(List<Pregunta> l, List<Paciente> lp, Map<Long, Double> media, Map<Long, Double> median) {
        for (Pregunta p : l) {
            if (p.getTipo_dato() == TipoDato.NUMERO) {
                List<Double> v = lp.stream()
                        .map(pac -> parseDoubleSeguro(obtenerValorRespuesta(pac, p.getPregunta_id())))
                        .filter(Objects::nonNull)
                        .sorted()
                        .collect(Collectors.toList());

                if (!v.isEmpty()) {
                    media.put(p.getPregunta_id(), v.stream().mapToDouble(d -> d).average().orElse(0.0));
                    int size = v.size();
                    double medVal = (size % 2 == 0) ? (v.get(size / 2 - 1) + v.get(size / 2)) / 2.0 : v.get(size / 2);
                    median.put(p.getPregunta_id(), medVal);
                }
            }
        }
    }

    private String aplicarCorte(Double v, Double u, SentidoCorte s) {
        if (v == null || u == null) return "";
        if (s == null) s = SentidoCorte.MAYOR_O_IGUAL;
        boolean c = false;
        switch (s) {
            case MAYOR_QUE: c = v > u; break;
            case MENOR_QUE: c = v < u; break;
            case MAYOR_O_IGUAL: c = v >= u; break;
            case MENOR_O_IGUAL: c = v <= u; break;
            case IGUAL_A: c = v.equals(u); break;
        }
        return c ? "1" : "0";
    }

    private Double parseDoubleSeguro(String v) {
        try { return Double.parseDouble(v); } catch (Exception e) { return null; }
    }

    private String obtenerValorRespuesta(Paciente p, Long id) {
        return p.getRespuestas().stream()
                .filter(r -> r.getPregunta().getPregunta_id().equals(id))
                .findFirst()
                .map(Respuesta::getValor)
                .orElse(null);
    }

    private String buscarValorDicotomizado(List<OpcionPregunta> l, String v) {
        if (v == null || l == null) return isBooleano(v) ? convertirBooleano(v) : "";
        for (OpcionPregunta o : l) {
            if (o.getEtiqueta().trim().equalsIgnoreCase(v.trim())) return calcularValorOpcion(o, l.size());
        }
        return "";
    }

    private String calcularValorOpcion(OpcionPregunta o, int t) {
        // CORRECCIÓN: Devolver simplemente el orden (0, 1, 2...)
        return String.valueOf(o.getOrden());
    }

    private Double obtenerOrdenOpcion(List<OpcionPregunta> opciones, String valorTexto) {
        if (valorTexto == null || valorTexto.isBlank() || opciones == null) return null;
        for (OpcionPregunta op : opciones) {
            if (op.getEtiqueta().trim().equalsIgnoreCase(valorTexto.trim())) return (double) op.getOrden();
        }
        return null;
    }

    private boolean isBooleano(String v) {
        return v != null && (v.equalsIgnoreCase("si") || v.equalsIgnoreCase("no") || v.equalsIgnoreCase("sí"));
    }

    private String convertirBooleano(String v) {
        return (v.equalsIgnoreCase("si") || v.equalsIgnoreCase("sí")) ? "1" : "0";
    }
}