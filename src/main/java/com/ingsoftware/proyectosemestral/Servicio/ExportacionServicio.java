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

    // --- Lógica de Recuento (Comentada para futuro) ---
    // private void recolectarDato(Map<Integer, List<String>> colector, int colIdx, String valor) {
    //     if (valor == null) {
    //         valor = "";
    //     }
    //     colector.computeIfAbsent(colIdx, k -> new ArrayList<>()).add(valor);
    // }

    @Transactional(readOnly = true)
    public ByteArrayInputStream generarExcel(boolean anonimo, boolean dicotomizar) throws IOException {

        List<Paciente> pacientes = pacienteRepositorio.findByActivoTrue();
        List<Pregunta> preguntas;

        // Usamos los métodos del repositorio que filtran por 'exportable = true'
        if (anonimo) {
            preguntas = preguntaRepositorio.findByActivoTrueAndDato_sensibleFalseAndExportableTrueOrderByOrdenAsc();
        } else {
            preguntas = preguntaRepositorio.findByActivoTrueAndExportableTrueOrderByOrdenAsc();
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

            // --- Lógica de Recuento (Comentada para futuro) ---
            // Set<Integer> indicesDeColumnasCategoricas = new HashSet<>();


            // --- Encabezados Estáticos ---
            if (!anonimo) {
                headerRow.createCell(cellIdx++).setCellValue("ID_Participante");
                headerRow.createCell(cellIdx++).setCellValue("Codigo_Participante");
            }

            // indicesDeColumnasCategoricas.add(cellIdx); // Recuento: 'Es_Caso'
            headerRow.createCell(cellIdx++).setCellValue("Es_Caso");

            // --- Encabezados de Preguntas (Dinámicos) ---
            for (Pregunta p : preguntas) {
                // if (p.getTipo_dato() == TipoDato.ENUM) {
                //     indicesDeColumnasCategoricas.add(cellIdx); // Recuento: ENUMs
                // }
                headerRow.createCell(cellIdx++).setCellValue(p.getEtiqueta());
            }

            // --- Encabezados Dicotomizados ---
            if (dicotomizar) {
                for (Pregunta p : preguntas) {
                    if (p.getTipo_dato() == TipoDato.NUMERO && p.getTipoCorte() != null && p.getTipoCorte() != TipoCorte.NINGUNO) {
                        // indicesDeColumnasCategoricas.add(cellIdx); // Recuento: Columnas _d
                        headerRow.createCell(cellIdx++).setCellValue(p.getEtiqueta() + "_d_" + p.getSentido_corte().toString());
                    }
                }
            }

            // --- Lógica de Recuento (Comentada para futuro) ---
            // Map<Integer, List<String>> datosPorColumna = new HashMap<>();

            int rowNum = 1;
            for (Paciente p : pacientes) {
                Row dataRow = sheet.createRow(rowNum++);
                cellIdx = 0;

                Map<Long, String> mapaRespuestas = p.getRespuestas().stream()
                        .collect(Collectors.toMap(r -> r.getPregunta().getPregunta_id(), Respuesta::getValor, (val1, val2) -> val1));

                if (!anonimo) {
                    String idVal = String.valueOf(p.getParticipante_id());
                    dataRow.createCell(cellIdx).setCellValue(idVal);
                    // recolectarDato(datosPorColumna, cellIdx, idVal);
                    cellIdx++;

                    String codVal = p.getParticipanteCod();
                    dataRow.createCell(cellIdx).setCellValue(codVal);
                    // recolectarDato(datosPorColumna, cellIdx, codVal);
                    cellIdx++;
                }

                String casoVal = p.getEsCaso() ? (dicotomizar ? "1" : "CASO") : (dicotomizar ? "0" : "CONTROL");
                dataRow.createCell(cellIdx).setCellValue(casoVal);
                // recolectarDato(datosPorColumna, cellIdx, casoVal);
                cellIdx++;

                for (Pregunta pHeader : preguntas) {
                    String valorCrudo = mapaRespuestas.get(pHeader.getPregunta_id());
                    String valorFinal = valorCrudo;

                    if (dicotomizar && valorCrudo != null && pHeader.getTipo_dato() == TipoDato.ENUM) {
                        valorFinal = buscarValorDicotomizado(pHeader.getOpciones(), valorCrudo);
                    }

                    String valorCelda = (valorFinal != null ? valorFinal : "");
                    dataRow.createCell(cellIdx).setCellValue(valorCelda);
                    // recolectarDato(datosPorColumna, cellIdx, valorCelda);
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
                            // recolectarDato(datosPorColumna, cellIdx, resultado);
                            cellIdx++;
                        }
                    }
                }
            }

            // --- 5. SECCIÓN DE RECUENTO (Toda comentada) ---

            // rowNum++;

            // Map<String, Row> filasDeRecuentoCreadas = new HashMap<>();
            // int numColumnas = headerRow.getLastCellNum();

            // for (int colIdx = 0; colIdx < numColumnas; colIdx++) {

            //     if (!indicesDeColumnasCategoricas.contains(colIdx)) {
            //         continue;
            //     }

            //     List<String> datosDeEstaColumna = datosPorColumna.get(colIdx);
            //     if (datosDeEstaColumna == null || datosDeEstaColumna.isEmpty()) {
            //         continue;
            //     }

            //     Map<String, Long> frecuencias = datosDeEstaColumna.stream()
            //         .collect(Collectors.groupingBy(s -> s, Collectors.counting()));

            //     for (Map.Entry<String, Long> entry : frecuencias.entrySet()) {
            //         String valor = entry.getKey();
            //         Long conteo = entry.getValue();

            //         if (valor.isBlank() || conteo == 0) {
            //             continue;
            //         }

            //         String etiquetaFila = "Contar '" + valor + "'";

            //         Row fila = filasDeRecuentoCreadas.get(etiquetaFila);

            //         if (fila == null) {
            //             fila = sheet.createRow(rowNum++);
            //             fila.createCell(0).setCellValue(etiquetaFila);
            //             filasDeRecuentoCreadas.put(etiquetaFila, fila);
            //         }

            //         fila.createCell(colIdx).setCellValue(conteo);
            //     }
            // }

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