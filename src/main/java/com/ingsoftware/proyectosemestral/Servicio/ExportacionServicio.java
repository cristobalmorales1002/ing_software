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

@Service
public class ExportacionServicio {

    @Autowired
    private PacienteRepositorio pacienteRepositorio;

    @Autowired
    private PreguntaRepositorio preguntaRepositorio;

    @Transactional(readOnly = true)
    public ByteArrayInputStream generarExcel(boolean anonimo, boolean dicotomizar) throws IOException {

        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        List<Pregunta> preguntas;

        if (anonimo) {
            preguntas = preguntaRepositorio.findByActivoTrueAndDato_sensibleFalseAndExportableTrueOrderByOrdenAsc();

        } else {
            preguntas = preguntaRepositorio.findByActivoTrueAndExportableTrueOrderByOrdenAsc();
        }

        Map<Long, Double> medias = new HashMap<>();
        Map<Long, Double> medianas = new HashMap<>();

        if (dicotomizar) {
            calcularEstadisticasGlobales(preguntas, pacientes, medias, medianas);
        }

        boolean generarDiccionario = anonimo || dicotomizar;

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            // CREACIÓN DE HOJAS
            XSSFSheet sheetDatos = workbook.createSheet("Datos_Stata");
            XSSFSheet sheetResumen = workbook.createSheet("Resumen_Conteos");
            XSSFSheet sheetDiccionario = null;
            if (generarDiccionario) {
                sheetDiccionario = workbook.createSheet("Diccionario_Variables");
            }

            // ENCABEZADOS
            Row headerRowDatos = sheetDatos.createRow(0);
            Row headerRowResumen = sheetResumen.createRow(0);

            List<String> headersList = new ArrayList<>();
            if (!anonimo) {
                headersList.add("ID_Participante");
                headersList.add("Codigo_Participante");
            } else {
                headersList.add("ID");
            }
            headersList.add("Es_Caso_Cod");

            for (Pregunta p : preguntas) {
                String label = (p.getCodigoStata() != null && !p.getCodigoStata().isBlank()) ? p.getCodigoStata() : p.getEtiqueta();
                headersList.add(label);

                if (dicotomizar && p.getTipo_dato() == TipoDato.NUMERO) {
                    headersList.add(label + "_media_cod");
                    headersList.add(label + "_mediana_cod");
                    if (p.getDicotomizacion() != null) {
                        headersList.add(label + "_corte_" + p.getDicotomizacion() + "_cod");
                    }
                }
            }

            for (int i = 0; i < headersList.size(); i++) {
                headerRowDatos.createCell(i).setCellValue(headersList.get(i));
                headerRowResumen.createCell(i).setCellValue(headersList.get(i));
            }

            // DATOS
            int rowNum = 1;
            Map<Integer, Map<String, Integer>> mapaDeConteos = new HashMap<>();

            for (Paciente p : pacientes) {
                Row dataRow = sheetDatos.createRow(rowNum++);
                int currentCell = 0;
                Map<Long, Respuesta> mapaRespuestas = p.getRespuestas().stream()
                        .filter(r -> r.getPregunta() != null)
                        .collect(Collectors.toMap(r -> r.getPregunta().getPregunta_id(), r -> r, (a, b) -> a));

                // IDs
                if (!anonimo) {
                    dataRow.createCell(currentCell++).setCellValue(p.getParticipante_id());
                    dataRow.createCell(currentCell++).setCellValue(p.getParticipanteCod());
                } else {
                    dataRow.createCell(currentCell++).setCellValue(p.getParticipanteCod());
                }

                // Caso  0/1
                String valCaso = p.getEsCaso() ? "1" : "0";
                dataRow.createCell(currentCell).setCellValue(valCaso);
                registrarConteo(mapaDeConteos, currentCell, valCaso);
                currentCell++;

                // Preguntas Dinámicas
                for (Pregunta pHeader : preguntas) {
                    Respuesta r = mapaRespuestas.get(pHeader.getPregunta_id());
                    String valorRaw = r != null ? r.getValor() : "";
                    String valorFinal = valorRaw;

                    if (dicotomizar || anonimo) {
                        if (pHeader.getTipo_dato() == TipoDato.ENUM) {
                            valorFinal = buscarValorDicotomizado(pHeader.getOpciones(), valorRaw);
                        } else if (pHeader.getTipo_dato() == TipoDato.NUMERO) {
                            valorFinal = valorRaw;
                        } else if (isBooleano(valorRaw)) {
                            valorFinal = convertirBooleano(valorRaw);
                        }
                    }
                    dataRow.createCell(currentCell).setCellValue(valorFinal);

                    boolean esContable = (pHeader.getTipo_dato() == TipoDato.ENUM) || isBooleano(valorRaw);
                    if (esContable) registrarConteo(mapaDeConteos, currentCell, valorFinal);
                    currentCell++;

                    // Dicotomización Automática (Numéricas)
                    if (dicotomizar && pHeader.getTipo_dato() == TipoDato.NUMERO) {
                        Double valorNum = parseDoubleSeguro(valorRaw);

                        Double umbralMedia = medias.get(pHeader.getPregunta_id());
                        String resMedia = aplicarCorte(valorNum, umbralMedia, pHeader.getSentido_corte());
                        dataRow.createCell(currentCell).setCellValue(resMedia);
                        registrarConteo(mapaDeConteos, currentCell, resMedia);
                        currentCell++;

                        Double umbralMediana = medianas.get(pHeader.getPregunta_id());
                        String resMediana = aplicarCorte(valorNum, umbralMediana, pHeader.getSentido_corte());
                        dataRow.createCell(currentCell).setCellValue(resMediana);
                        registrarConteo(mapaDeConteos, currentCell, resMediana);
                        currentCell++;

                        if (pHeader.getDicotomizacion() != null) {
                            String resFijo = aplicarCorte(valorNum, pHeader.getDicotomizacion(), pHeader.getSentido_corte());
                            dataRow.createCell(currentCell).setCellValue(resFijo);
                            registrarConteo(mapaDeConteos, currentCell, resFijo);
                            currentCell++;
                        }
                    }
                }
            }

            // RESUMEN
            generarFilasResumen(sheetResumen, 0, headersList.size(), mapaDeConteos, anonimo);

            // DICCIONARIO (CON 0/1)
            if (generarDiccionario && sheetDiccionario != null) {
                generarHojaDiccionario(sheetDiccionario, preguntas, medias, medianas, dicotomizar);
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return new ByteArrayInputStream(outputStream.toByteArray());
        }
    }

    //      LÓGICA DE DICCIONARIO

    private void generarHojaDiccionario(XSSFSheet sheet, List<Pregunta> preguntas, Map<Long, Double> medias, Map<Long, Double> medianas, boolean dicotomizar) {
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("Código Variable (Stata)");
        header.createCell(1).setCellValue("Etiqueta Original / Pregunta");
        header.createCell(2).setCellValue("Codificación / Significado");

        int rowIdx = 1;

        Row rowCaso = sheet.createRow(rowIdx++);
        rowCaso.createCell(0).setCellValue("Es_Caso_Cod");
        rowCaso.createCell(1).setCellValue("Grupo del participante");
        rowCaso.createCell(2).setCellValue("1 = Caso (Cáncer), 0 = Control (Sano)");

        for (Pregunta p : preguntas) {
            String codigo = (p.getCodigoStata() != null && !p.getCodigoStata().isBlank()) ? p.getCodigoStata() : p.getEtiqueta();

            Row rowP = sheet.createRow(rowIdx++);
            rowP.createCell(0).setCellValue(codigo);
            rowP.createCell(1).setCellValue(p.getEtiqueta());

            String definicion = "Texto libre / Numérico continuo";

            if (p.getTipo_dato() == TipoDato.ENUM) {
                List<OpcionPregunta> opcionesOrdenadas = new ArrayList<>(p.getOpciones());
                opcionesOrdenadas.sort(Comparator.comparingInt(OpcionPregunta::getOrden));

                StringBuilder sb = new StringBuilder();
                int totalOpciones = opcionesOrdenadas.size();

                for (OpcionPregunta op : opcionesOrdenadas) {
                    String val = calcularValorOpcion(op, totalOpciones);
                    sb.append(val).append("=").append(op.getEtiqueta()).append("; ");
                }
                definicion = sb.toString();
            }

            rowP.createCell(2).setCellValue(definicion);

            if (dicotomizar && p.getTipo_dato() == TipoDato.NUMERO) {
                String sentido = p.getSentido_corte() != null ? p.getSentido_corte().toString() : "MAYOR_O_IGUAL";

                Row rowMedia = sheet.createRow(rowIdx++);
                rowMedia.createCell(0).setCellValue(codigo + "_media_cod");
                rowMedia.createCell(1).setCellValue("Corte por Media (" + p.getEtiqueta() + ")");
                Double valMedia = medias.getOrDefault(p.getPregunta_id(), 0.0);
                rowMedia.createCell(2).setCellValue("1 si " + sentido + " a " + String.format("%.2f", valMedia) + "; 0 si no");

                Row rowMediana = sheet.createRow(rowIdx++);
                rowMediana.createCell(0).setCellValue(codigo + "_mediana_cod");
                rowMediana.createCell(1).setCellValue("Corte por Mediana (" + p.getEtiqueta() + ")");
                Double valMediana = medianas.getOrDefault(p.getPregunta_id(), 0.0);
                rowMediana.createCell(2).setCellValue("1 si " + sentido + " a " + String.format("%.2f", valMediana) + "; 0 si no");

                if (p.getDicotomizacion() != null) {
                    Row rowFijo = sheet.createRow(rowIdx++);
                    rowFijo.createCell(0).setCellValue(codigo + "_corte_" + p.getDicotomizacion() + "_cod");
                    rowFijo.createCell(1).setCellValue("Corte Fijo Definido (" + p.getEtiqueta() + ")");
                    rowFijo.createCell(2).setCellValue("1 si " + sentido + " a " + p.getDicotomizacion() + "; 0 si no");
                }
            }
        }

        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
        sheet.setColumnWidth(2, 10000);
    }

    //      LÓGICA CENTRALIZADA (0/1)

    // Metodo maestro para saber qué número le corresponde a una opción
    private String calcularValorOpcion(OpcionPregunta op, int totalOpciones) {
        // Prioridad: Valor manual asignado por Admin
        if (op.getValorDicotomizado() != null) {
            double valor = op.getValorDicotomizado();
            if (valor == Math.floor(valor)) return String.valueOf((int) valor);
            return String.valueOf(valor);
        }

        // Detección inteligente de Sí/No (Estándar: Sí=1, No=0)
        String label = op.getEtiqueta().trim().toLowerCase();
        if (label.equals("no")) return "0";
        if (label.equals("si") || label.equals("sí")) return "1";

        if (totalOpciones == 2) {
            return String.valueOf(op.getOrden() - 1);
        }

        return String.valueOf(op.getOrden());
    }

    private String buscarValorDicotomizado(Set<OpcionPregunta> opciones, String etiquetaGuardada) {
        if (etiquetaGuardada == null || opciones == null || opciones.isEmpty()) {
            if (isBooleano(etiquetaGuardada)) return convertirBooleano(etiquetaGuardada);
            return "";
        }

        int totalOpciones = opciones.size();

        for (OpcionPregunta op : opciones) {
            if (etiquetaGuardada.trim().equalsIgnoreCase(op.getEtiqueta().trim())) {
                return calcularValorOpcion(op, totalOpciones);
            }
        }
        return "";
    }

    //          OTROS MÉTODOS AUXILIARES

    private void calcularEstadisticasGlobales(List<Pregunta> preguntas, List<Paciente> pacientes, Map<Long, Double> medias, Map<Long, Double> medianas) {
        for (Pregunta p : preguntas) {
            if (p.getTipo_dato() == TipoDato.NUMERO) {
                List<Double> valores = pacientes.stream()
                        .map(pac -> parseDoubleSeguro(obtenerValorRespuesta(pac, p.getPregunta_id())))
                        .filter(Objects::nonNull).sorted().collect(Collectors.toList());
                if (valores.isEmpty()) continue;
                double media = valores.stream().mapToDouble(d -> d).average().orElse(0.0);
                medias.put(p.getPregunta_id(), media);
                double mediana;
                int size = valores.size();
                if (size % 2 == 0) mediana = (valores.get(size / 2 - 1) + valores.get(size / 2)) / 2.0;
                else mediana = valores.get(size / 2);
                medianas.put(p.getPregunta_id(), mediana);
            }
        }
    }

    private String aplicarCorte(Double valor, Double umbral, SentidoCorte sentido) {
        if (valor == null || umbral == null) return "";
        boolean cumple = false;
        if (sentido == null) sentido = SentidoCorte.MAYOR_O_IGUAL;
        switch (sentido) {
            case MAYOR_QUE: cumple = valor > umbral; break;
            case MENOR_QUE: cumple = valor < umbral; break;
            case MAYOR_O_IGUAL: cumple = valor >= umbral; break;
            case MENOR_O_IGUAL: cumple = valor <= umbral; break;
            case IGUAL_A: cumple = valor.equals(umbral); break;
        }
        return cumple ? "1" : "0";
    }

    private void registrarConteo(Map<Integer, Map<String, Integer>> mapa, int colIdx, String valor) {
        if (valor == null || valor.isBlank()) return;
        mapa.computeIfAbsent(colIdx, k -> new HashMap<>()).merge(valor, 1, Integer::sum);
    }

    private void generarFilasResumen(XSSFSheet sheet, int startRow, int totalCols, Map<Integer, Map<String, Integer>> mapaDeConteos, boolean anonimo) {
        Set<String> valoresEncontrados = new HashSet<>();
        mapaDeConteos.values().forEach(mapa -> valoresEncontrados.addAll(mapa.keySet()));
        List<String> valoresOrdenados = new ArrayList<>(valoresEncontrados);
        Collections.sort(valoresOrdenados);
        int currentRow = startRow + 1;
        for (String valorRef : valoresOrdenados) {
            if (valorRef.isBlank()) continue;
            Row rowResumen = sheet.createRow(currentRow++);
            rowResumen.createCell(0).setCellValue("Contar " + valorRef);
            int startCol = (!anonimo) ? 2 : 1;
            for (int c = startCol; c < totalCols; c++) {
                Integer cantidad = mapaDeConteos.getOrDefault(c, new HashMap<>()).getOrDefault(valorRef, 0);
                if (cantidad > 0) rowResumen.createCell(c).setCellValue(cantidad);
            }
        }
        Row rowTotal = sheet.createRow(currentRow++);
        rowTotal.createCell(0).setCellValue("Total Registros");
        int startCol = (!anonimo) ? 2 : 1;
        for (int c = startCol; c < totalCols; c++) {
            int total = mapaDeConteos.getOrDefault(c, new HashMap<>()).values().stream().mapToInt(Integer::intValue).sum();
            if (total > 0) rowTotal.createCell(c).setCellValue(total);
        }
    }

    private Double parseDoubleSeguro(String valor) {
        if (valor == null || valor.isBlank()) return null;
        try { return Double.parseDouble(valor); } catch (Exception e) { return null; }
    }

    private String obtenerValorRespuesta(Paciente p, Long preguntaId) {
        return p.getRespuestas().stream().filter(r -> r.getPregunta().getPregunta_id().equals(preguntaId))
                .findFirst().map(Respuesta::getValor).orElse(null);
    }

    private boolean isBooleano(String val) {
        if (val == null) return false;
        String v = val.trim().toLowerCase();
        return v.equals("si") || v.equals("sí") || v.equals("no");
    }

    private String convertirBooleano(String val) {
        String v = val.trim().toLowerCase();
        if (v.equals("si") || v.equals("sí")) return "1";
        if (v.equals("no")) return "0";
        return "";
    }
}