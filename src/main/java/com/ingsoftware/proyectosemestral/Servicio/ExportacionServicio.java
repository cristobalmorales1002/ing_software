package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import org.apache.poi.ss.usermodel.Row;
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

    private void recolectarDato(Map<Integer, List<String>> colector, int colIdx, String valor) {
        if (valor == null) {
            valor = "";
        }
        colector.computeIfAbsent(colIdx, k -> new ArrayList<>()).add(valor);
    }

    @Transactional(readOnly = true)
    public ByteArrayInputStream generarExcel(boolean anonimo, boolean dicotomizar) throws IOException {

        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        List<Pregunta> preguntas;
        if (anonimo) {
            preguntas = preguntaRepositorio.findByActivoTrueAndDato_sensibleFalseOrderByOrdenAsc();
        } else {
            preguntas = preguntaRepositorio.findByActivoTrueOrderByOrdenAsc();
        }

        Map<Long, Double> medias = new HashMap<>();
        Map<Long, Double> medianas = new HashMap<>();

        if (dicotomizar) {
            for (Pregunta p : preguntas) {
                if (p.getTipo_dato() == TipoDato.NUMERO && p.getTipoCorte() != null && (p.getTipoCorte() == TipoCorte.MEDIA || p.getTipoCorte() == TipoCorte.MEDIANA)) {

                    List<Double> valores = pacientes.stream()
                            .map(paciente -> obtenerValorNumerico(paciente, p.getPregunta_id()))
                            .filter(Objects::nonNull)
                            .sorted()
                            .collect(Collectors.toList());

                    if (valores.isEmpty()) continue;

                    if (p.getTipoCorte() == TipoCorte.MEDIA) {
                        double media = valores.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
                        medias.put(p.getPregunta_id(), media);
                    }

                    if (p.getTipoCorte() == TipoCorte.MEDIANA) {
                        double mediana;
                        int size = valores.size();
                        if (size % 2 == 0) {
                            mediana = (valores.get(size / 2 - 1) + valores.get(size / 2)) / 2.0;
                        } else {
                            mediana = valores.get(size / 2);
                        }
                        medianas.put(p.getPregunta_id(), mediana);
                    }
                }
            }
        }

        try(XSSFWorkbook workbook = new XSSFWorkbook()) {
            XSSFSheet sheet = workbook.createSheet("Datos_Participantes");
            Row headerRow = sheet.createRow(0);
            int cellIdx = 0;

            if (!anonimo) {
                headerRow.createCell(cellIdx++).setCellValue("ID_Participante");
                headerRow.createCell(cellIdx++).setCellValue("Codigo_Participante");
            }
            headerRow.createCell(cellIdx++).setCellValue("Es_Caso");
            if (!anonimo) {
                headerRow.createCell(cellIdx++).setCellValue("Fecha_Inclusion");
                headerRow.createCell(cellIdx++).setCellValue("RUT_Reclutador");
            }

            for (Pregunta p : preguntas) {
                headerRow.createCell(cellIdx++).setCellValue(p.getEtiqueta());
            }

            if (dicotomizar) {
                for (Pregunta p : preguntas) {
                    if (p.getTipo_dato() == TipoDato.NUMERO && p.getTipoCorte() != null && p.getTipoCorte() != TipoCorte.NINGUNO) {
                        headerRow.createCell(cellIdx++).setCellValue(p.getEtiqueta() + "_d_" + p.getSentido_corte().toString());
                    }
                }
            }

            Map<Integer, List<String>> datosPorColumna = new HashMap<>();

            int rowNum = 1;
            for (Paciente p : pacientes) {
                Row dataRow = sheet.createRow(rowNum++);
                cellIdx = 0;

                Map<Long, String> mapaRespuestas = p.getRespuestas().stream()
                        .collect(Collectors.toMap(r -> r.getPregunta().getPregunta_id(), Respuesta::getValor, (val1, val2) -> val1));

                if (!anonimo) {
                    String idVal = String.valueOf(p.getParticipante_id());
                    dataRow.createCell(cellIdx).setCellValue(idVal);
                    recolectarDato(datosPorColumna, cellIdx, idVal);
                    cellIdx++;

                    String codVal = p.getParticipanteCod();
                    dataRow.createCell(cellIdx).setCellValue(codVal);
                    recolectarDato(datosPorColumna, cellIdx, codVal);
                    cellIdx++;
                }

                String casoVal = p.getEsCaso() ? (dicotomizar ? "1" : "CASO") : (dicotomizar ? "0" : "CONTROL");
                dataRow.createCell(cellIdx).setCellValue(casoVal);
                recolectarDato(datosPorColumna, cellIdx, casoVal);
                cellIdx++;

                if (!anonimo) {
                    String fechaVal = p.getFechaIncl().toString();
                    dataRow.createCell(cellIdx).setCellValue(fechaVal);
                    recolectarDato(datosPorColumna, cellIdx, fechaVal);
                    cellIdx++;

                    String rutVal = p.getReclutador().getRut();
                    dataRow.createCell(cellIdx).setCellValue(rutVal);
                    recolectarDato(datosPorColumna, cellIdx, rutVal);
                    cellIdx++;
                }

                for (Pregunta pHeader : preguntas) {
                    String valorCrudo = mapaRespuestas.get(pHeader.getPregunta_id());
                    String valorFinal = valorCrudo;

                    if (dicotomizar && valorCrudo != null && pHeader.getTipo_dato() == TipoDato.ENUM) {
                        valorFinal = buscarValorDicotomizado(pHeader.getOpciones(), valorCrudo);
                    }

                    String valorCelda = (valorFinal != null ? valorFinal : "");
                    dataRow.createCell(cellIdx).setCellValue(valorCelda);
                    recolectarDato(datosPorColumna, cellIdx, valorCelda);
                    cellIdx++;
                }

                if (dicotomizar) {
                    for (Pregunta pHeader : preguntas) {
                        if (pHeader.getTipo_dato() == TipoDato.NUMERO && pHeader.getTipoCorte() != null && pHeader.getTipoCorte() != TipoCorte.NINGUNO) {

                            Double puntoDeCorte = 0.0;
                            if (pHeader.getTipoCorte() == TipoCorte.VALOR_FIJO) {
                                puntoDeCorte = pHeader.getDicotomizacion();
                            } else if (pHeader.getTipoCorte() == TipoCorte.MEDIA) {
                                puntoDeCorte = medias.get(pHeader.getPregunta_id());
                            } else if (pHeader.getTipoCorte() == TipoCorte.MEDIANA) {
                                puntoDeCorte = medianas.get(pHeader.getPregunta_id());
                            }

                            Double valorPaciente = obtenerValorNumerico(p, pHeader.getPregunta_id());
                            String resultado = "0";

                            if (valorPaciente != null && puntoDeCorte != null && pHeader.getSentido_corte() != null) {
                                switch (pHeader.getSentido_corte()) {
                                    case MAYOR_QUE:
                                        if (valorPaciente > puntoDeCorte) resultado = "1";
                                        break;
                                    case MENOR_QUE:
                                        if (valorPaciente < puntoDeCorte) resultado = "1";
                                        break;
                                    case IGUAL_A:
                                        if (valorPaciente.equals(puntoDeCorte)) resultado = "1";
                                        break;
                                    case MAYOR_O_IGUAL:
                                        if (valorPaciente >= puntoDeCorte) resultado = "1";
                                        break;
                                    case MENOR_O_IGUAL:
                                        if (valorPaciente <= puntoDeCorte) resultado = "1";
                                        break;
                                }
                            }
                            dataRow.createCell(cellIdx).setCellValue(resultado);
                            recolectarDato(datosPorColumna, cellIdx, resultado);
                            cellIdx++;
                        }
                    }
                }
            }

            // --- 5. ESCRIBIR FILAS DE RECUENTO (Versión 2.0 - Más Clara) ---
            rowNum++; // Dejar una fila en blanco

            Map<String, Row> filasDeRecuentoCreadas = new HashMap<>();
            int numColumnas = headerRow.getLastCellNum();

            // Iterar por CADA COLUMNA para generar su recuento
            for (int colIdx = 0; colIdx < numColumnas; colIdx++) {

                List<String> datosDeEstaColumna = datosPorColumna.get(colIdx);

                if (datosDeEstaColumna == null || datosDeEstaColumna.isEmpty()) {
                    continue;
                }

                // Calcular frecuencias para ESTA columna
                Map<String, Long> frecuencias = datosDeEstaColumna.stream()
                        .collect(Collectors.groupingBy(s -> s, Collectors.counting()));

                // No hacer recuento de columnas con demasiados valores únicos (ej. RUT, ID)
                // Si tiene más de 8 valores únicos O si todos son únicos, no es categórico.
                if (frecuencias.size() > 8 || frecuencias.size() == datosDeEstaColumna.size()) {
                    continue;
                }

                // Ahora, iterar por cada frecuencia (ej. "Sí" -> 1, "No" -> 2)
                for (Map.Entry<String, Long> entry : frecuencias.entrySet()) {
                    String valor = entry.getKey();
                    Long conteo = entry.getValue();

                    // Saltar valores vacíos (no queremos un "Recuento ''")
                    if (valor.isBlank() || conteo == 0) {
                        continue;
                    }

                    String etiquetaFila = "Recuento '" + valor + "'";

                    Row fila = filasDeRecuentoCreadas.get(etiquetaFila);

                    if (fila == null) {
                        fila = sheet.createRow(rowNum++);
                        fila.createCell(0).setCellValue(etiquetaFila);
                        filasDeRecuentoCreadas.put(etiquetaFila, fila);
                    }

                    fila.createCell(colIdx).setCellValue(conteo);
                }
            }
            // --- FIN DEL RECUENTO (V2) ---

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return new ByteArrayInputStream(outputStream.toByteArray());
        }
    }

    private String buscarValorDicotomizado(Set<OpcionPregunta> opciones, String etiquetaGuardada) {
        if (etiquetaGuardada == null || opciones == null || opciones.isEmpty()) {
            return etiquetaGuardada;
        }

        for (OpcionPregunta op : opciones) {
            if (etiquetaGuardada.equalsIgnoreCase(op.getEtiqueta())) {
                if (op.getValorDicotomizado() != null) {
                    double valor = op.getValorDicotomizado();
                    if (valor == Math.floor(valor)) {
                        return String.valueOf((int) valor);
                    }
                    return String.valueOf(valor);
                }
                return etiquetaGuardada;
            }
        }
        return etiquetaGuardada;
    }

    private Double obtenerValorNumerico(Paciente p, Long preguntaId) {
        try {
            Optional<Respuesta> respuesta = p.getRespuestas().stream()
                    .filter(r -> r.getPregunta().getPregunta_id().equals(preguntaId))
                    .findFirst();

            if (respuesta.isPresent() && respuesta.get().getValor() != null && !respuesta.get().getValor().isBlank()) {
                return Double.parseDouble(respuesta.get().getValor());
            }
            return null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}