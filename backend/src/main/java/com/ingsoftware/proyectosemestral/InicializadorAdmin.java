package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.PacienteCreateDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import com.ingsoftware.proyectosemestral.Servicio.PacienteServicio;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Component
@Profile("!test")
public class InicializadorAdmin implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(InicializadorAdmin.class);

    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private RolRepositorio rolRepositorio;
    @Autowired private CategoriaRepositorio categoriaRepositorio;
    @Autowired private PasswordEncoder codificadorDeContrasena;
    @Autowired private PermisoRepositorio permisoRepositorio;
    @Autowired private PreguntaRepositorio preguntaRepositorio;
    @Autowired private OpcionPreguntaRepositorio opcionPreguntaRepositorio;
    @Autowired private PacienteServicio pacienteServicio;
    @Autowired private SnpConfigRepositorio snpConfigRepositorio;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        logger.info(">>> INICIANDO CARGA CON SISTEMA DE DEPENDENCIAS MEJORADO <<<");

        crearSistemaDeSeguridad();
        Usuario admin = crearUsuariosDePrueba();
        Usuario medico = usuarioRepositorio.findByRut("20.629.545-7")
                .orElseThrow(() -> new RuntimeException("Médico no encontrado"));

        inicializarConfiguracionGenetica();

        if (pacienteServicio.getAllPacientes().isEmpty()) {
            crearEncuestaCRFConDependencias();
            generarPacientesRealistas(admin, medico);
        } else {
            logger.info(">>> BASE DE DATOS YA INICIALIZADA <<<");
        }

        logger.info(">>> CARGA FINALIZADA EXITOSAMENTE <<<");
    }

    private void crearEncuestaCRFConDependencias() {
        List<String> noSi = List.of("No", "Sí");
        List<String> siNo = List.of("Sí", "No");
        List<String> siNoRecuerda = List.of("Sí", "No", "No recuerda");

        // --- 1. IDENTIFICACIÓN ---
        Categoria c1 = crearCategoria("1. Identificación del participante", 1);
        crearPregunta(c1, "Nombre completo", "Nombre", TipoDato.TEXTO, 1, false, false, false);
        crearPregunta(c1, "Teléfono", "Telefono", TipoDato.CELULAR, 2, false, false, false);
        crearPregunta(c1, "Correo electrónico", "Email", TipoDato.EMAIL, 3, false, false, false);

        // --- 2. DATOS SOCIODEMOGRÁFICOS ---
        Categoria c2 = crearCategoria("2. Datos sociodemográficos", 2);
        crearPregunta(c2, "Edad", "Edad", TipoDato.NUMERO, 1, true, true, false, 50.0, 60.0);
        crearPregunta(c2, "Sexo", "Sexo", TipoDato.ENUM, 2, true, true, false, List.of("Hombre", "Mujer"));
        crearPregunta(c2, "Nacionalidad", "Nacionalidad", TipoDato.TEXTO, 3, false, false, false);
        crearPregunta(c2, "Dirección", "Direccion", TipoDato.TEXTO, 4, false, false, false);
        crearPregunta(c2, "Comuna", "Comuna", TipoDato.TEXTO, 5, false, false, false);
        crearPregunta(c2, "Ciudad", "Ciudad", TipoDato.TEXTO, 6, false, false, false);
        crearPregunta(c2, "Zona", "Zona", TipoDato.ENUM, 7, true, true, false, List.of("Urbana", "Rural"));
        crearPregunta(c2, "¿Vive usted en esta zona desde hace más de 5 años?", "Residencia_Urbana5", TipoDato.ENUM, 8, true, true, false, siNo);
        crearPregunta(c2, "Nivel educacional", "NivelEduc", TipoDato.ENUM, 9, true, true, false,
                List.of("Básico", "Medio", "Superior"), 1.0, 2.0);
        crearPregunta(c2, "Ocupación actual", "Ocupacion", TipoDato.TEXTO, 10, false, false, false);
        crearPregunta(c2, "Previsión de salud actual", "Prevision_FonasaVsOtros", TipoDato.ENUM, 11, true, true, false,
                List.of("Fonasa", "Isapre", "Capredena / Dipreca", "Sin previsión", "Otra"), 2.0);

        // --- 3. ANTECEDENTES CLÍNICOS ---
        Categoria c3 = crearCategoria("3. Antecedentes clínicos", 3);
        crearPregunta(c3, "Diagnóstico histológico de adenocarcinoma gástrico (solo casos)", "Diag_Adenocarcinoma",
                TipoDato.ENUM, 1, false, false, true, siNo);
        crearPregunta(c3, "Fecha de diagnóstico (solo casos)", "Fecha_Diag", TipoDato.TEXTO, 2, false, false, true);

        Pregunta caGastrico = crearPregunta(c3, "Antecedentes familiares de cáncer gástrico", "CA_FamiliaGastrico", TipoDato.ENUM, 3, true, true, false, siNo);

        Pregunta caOtros = crearPreguntaConDependencia(c3, "Antecedentes familiares de otros tipos de cáncer", "CA_FamiliaOtros",
                TipoDato.ENUM, 4, true, true, false, siNo,
                caGastrico, "Sí", "OCULTAR");

        crearPreguntaConDependencia(c3, "¿Cuál(es)? (Otros cánceres)", "CA_FamiliaOtros_Detalle", TipoDato.TEXTO, 5, false, false, false, null,
                caOtros, "Sí", "OCULTAR");

        crearPregunta(c3, "Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)", "EnfermedadesRelevantes", TipoDato.TEXTO, 6, false, false, false);

        Pregunta usoMeds = crearPregunta(c3, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "UsoCronico_Medicamentos",
                TipoDato.ENUM, 7, true, true, false, siNo);

        crearPreguntaConDependencia(c3, "Especificar cuál (Medicamentos)", "UsoCronico_Detalle", TipoDato.TEXTO, 8, false, false, false, null,
                usoMeds, "Sí", "OCULTAR");

        crearPregunta(c3, "Cirugía gástrica previa (gastrectomía parcial)", "CirugiaGastricaPrevia", TipoDato.ENUM, 9, true, true, false, siNo);

        // --- 4. VARIABLES ANTROPOMÉTRICAS ---
        Categoria c4 = crearCategoria("4. Variables antropométricas", 4);
        crearPregunta(c4, "Peso (kg)", "Peso", TipoDato.NUMERO, 1, true, true, false);
        crearPregunta(c4, "Estatura (m)", "Estatura", TipoDato.NUMERO, 2, true, true, false);
        crearPregunta(c4, "Índice de masa corporal (IMC)", "IMC", TipoDato.NUMERO, 3, true, true, false, 25.0);

        // --- 5. TABAQUISMO (MODIFICADO) ---
        Categoria c5 = crearCategoria("5. Tabaquismo", 5);

        Pregunta estadoTabaco = crearPregunta(c5, "Estado de tabaquismo", "tabaco_estado", TipoDato.ENUM, 1, true, true, false,
                List.of("Nunca fumó (menos de 100 cigarrillos en la vida)", "Exfumador", "Fumador actual"));

        // AHORA APARECE SI ES FUMADOR ACTUAL O EXFUMADOR
        crearPreguntaConDependencia(c5, "Cantidad promedio fumada", "tabaco_cantidad",
                TipoDato.ENUM, 2, true, true, false,
                List.of("1–9 cigarrillos/día (poco)", "10–19 cigarrillos/día (moderado)", "≥20 cigarrillos/día (mucho)"),
                estadoTabaco, "Fumador actual|Exfumador", "OCULTAR");

        crearPreguntaConDependencia(c5, "Tiempo total fumando", "tabaco_tiempo_total",
                TipoDato.ENUM, 3, true, true, false,
                List.of("<10 años", "10–20 años", ">20 años"),
                estadoTabaco, "Fumador actual|Exfumador", "OCULTAR");

        // ESTA SIGUE SOLO PARA EXFUMADOR
        crearPreguntaConDependencia(c5, "Si exfumador: tiempo desde que dejó de fumar",
                "tabaco_exfumador_tiempo", TipoDato.ENUM, 4, true, true, false,
                List.of("<5 años", "5–10 años", ">10 años"),
                estadoTabaco, "Exfumador", "OCULTAR");

        // --- 6. CONSUMO DE ALCOHOL (MODIFICADO) ---
        Categoria c6 = crearCategoria("6. Consumo de alcohol", 6);

        Pregunta estadoAlcohol = crearPregunta(c6, "Estado de consumo", "alcohol_estado", TipoDato.ENUM, 1, true, true, false,
                List.of("Nunca", "Exconsumidor", "Consumidor actual"));

        // AHORA APARECE SI ES CONSUMIDOR ACTUAL O EXCONSUMIDOR
        crearPreguntaConDependencia(c6, "Frecuencia", "alcohol_frecuencia", TipoDato.ENUM, 2, true, true, false,
                List.of("Ocasional (menos de 1 vez/semana)", "Regular (1–3 veces/semana)", "Frecuente (≥4 veces/semana)"),
                estadoAlcohol, "Consumidor actual|Exconsumidor", "OCULTAR");

        crearPreguntaConDependencia(c6, "Cantidad típica por ocasión", "alcohol_cantidad", TipoDato.ENUM, 3, true, true, false,
                List.of("1–2 tragos (poco)", "3–4 tragos (moderado)", "≥5 tragos (mucho)"),
                estadoAlcohol, "Consumidor actual|Exconsumidor", "OCULTAR");

        crearPreguntaConDependencia(c6, "Años de consumo habitual", "alcohol_tiempo_total", TipoDato.ENUM, 4, true, true, false,
                List.of("<10 años", "10–20 años", ">20 años"),
                estadoAlcohol, "Consumidor actual|Exconsumidor", "OCULTAR");

        // ESTA SIGUE SOLO PARA EXCONSUMIDOR
        crearPreguntaConDependencia(c6, "Si exconsumidor: tiempo desde que dejó de beber regularmente",
                "alcohol_exconsumidor_tiempo", TipoDato.ENUM, 5, true, true, false,
                List.of("<5 años", "5–10 años", ">10 años"),
                estadoAlcohol, "Exconsumidor", "OCULTAR");

        // --- 7. FACTORES DIETARIOS Y AMBIENTALES ---
        Categoria c7 = crearCategoria("7. Factores dietarios y ambientales", 7);
        crearPregunta(c7, "Consumo de carnes procesadas/cecinas", "diet_carnes", TipoDato.ENUM, 1, true, true, false,
                List.of("≤1/sem", "2/sem", "≥3/sem"));
        crearPregunta(c7, "Consumo de alimentos muy salados", "diet_sal", TipoDato.ENUM, 2, true, true, false, siNo);
        crearPregunta(c7, "Consumo de porciones de frutas y verduras frescas", "diet_frutas_verduras",
                TipoDato.ENUM, 3, true, true, false, List.of("≥5 porciones/día", "3–4 porciones/día", "≤2 porciones/día"));
        crearPregunta(c7, "Consumo frecuente de frituras (≥3 veces por semana)", "diet_frituras",
                TipoDato.ENUM, 4, true, true, false, siNo);
        crearPregunta(c7, "Consumo de alimentos muy condimentados", "diet_condimentos",
                TipoDato.ENUM, 5, true, true, false, List.of("Casi nunca / Rara vez", "1 a 2 veces por semana", "3 o más veces por semana"));
        crearPregunta(c7, "Consumo de infusiones o bebidas muy calientes", "diet_bebidas_calientes",
                TipoDato.ENUM, 6, true, true, false, List.of("Nunca/Rara vez", "1–2/sem", "≥3/sem"));
        crearPregunta(c7, "Exposición ocupacional a pesticidas", "amb_pesticidas", TipoDato.ENUM, 7, true, true, false, siNo);

        Pregunta expoQuimicos = crearPregunta(c7, "Exposición a otros compuestos químicos", "amb_quimicos", TipoDato.ENUM, 8, true, true, false, siNo);
        crearPreguntaConDependencia(c7, "¿Cuál(es)? (Químicos)", "amb_quimicos_detalle", TipoDato.TEXTO, 9, false, false, false, null, expoQuimicos, "Sí", "OCULTAR");

        crearPregunta(c7, "Humo de leña en el hogar", "amb_lena", TipoDato.ENUM, 10, true, true, false,
                List.of("Nunca/Rara vez", "Estacional", "Diario"));
        crearPregunta(c7, "Fuente principal de agua en el hogar", "amb_agua_fuente", TipoDato.ENUM, 11, true, true, false,
                List.of("Red pública", "Pozo", "Camión aljibe", "Otra"));
        crearPregunta(c7, "Tratamiento del agua en casa", "amb_agua_tratamiento", TipoDato.ENUM, 12, true, true, false,
                List.of("Ninguno", "Hervir", "Filtro", "Cloro"));

        // --- 8. H. PYLORI (MODIFICADO) ---
        Categoria c8 = crearCategoria("8. Infección por Helicobacter pylori", 8);
        Pregunta hpResultado = crearPregunta(c8, "Resultado del examen para Helicobacter pylori", "hp_resultado", TipoDato.ENUM, 1, true, true, false,
                List.of("Positivo", "Negativo", "Desconocido"));

        // AHORA APARECE SI ES NEGATIVO O DESCONOCIDO
        crearPreguntaConDependencia(c8, "¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?", "hp_pasado_positivo",
                TipoDato.ENUM, 2, true, true, false, siNoRecuerda,
                hpResultado, "Negativo|Desconocido", "OCULTAR");

        crearPreguntaConDependencia(c8, "¿Recibió tratamiento para erradicación de H. pylori?", "hp_tratamiento",
                TipoDato.ENUM, 3, true, true, false, siNoRecuerda,
                hpResultado, "Negativo|Desconocido", "OCULTAR");

        crearPregunta(c8, "Tipo de examen realizado", "hp_tipo_examen", TipoDato.ENUM, 4, true, true, false,
                List.of("Test de aliento", "Antígeno en deposiciones", "Serología (IgG)", "Test rápido", "Histología", "Otro"));
        crearPregunta(c8, "¿Hace cuánto tiempo se realizó el test?", "hp_tiempo_test", TipoDato.ENUM, 5, true, true, false,
                List.of("<1 año", "1–5 años", ">5 años"));
        crearPregunta(c8, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "hp_uso_ibp",
                TipoDato.ENUM, 6, true, true, false, siNoRecuerda);
        crearPregunta(c8, "¿Ha repetido el examen posteriormente?", "hp_repetido", TipoDato.ENUM, 7, true, true, false, siNo);

        // --- 9. HISTOPATOLOGÍA (SOLO CASOS) - ETIQUETAS ACTUALIZADAS ---
        Categoria c9 = crearCategoria("9. Histopatología (solo casos)", 9);
        // Agregamos "(solo casos)" a la etiqueta para que el frontend lo detecte y oculte automáticamente en controles
        crearPregunta(c9, "Tipo histológico (solo casos)", "Histologia_Tipo", TipoDato.ENUM, 1, true, true, true,
                List.of("Intestinal", "Difuso", "Mixto", "Otro"));
        crearPregunta(c9, "Localización tumoral (solo casos)", "Histologia_Localizacion", TipoDato.ENUM, 2, true, true, true,
                List.of("Cardias", "Cuerpo", "Antro", "Difuso"));
        crearPregunta(c9, "Estadio clínico (TNM) (solo casos)", "histo_tnm", TipoDato.TEXTO, 3, true, true, true);

        logger.info(">>> Sistema de dependencias configurado correctamente <<<");
    }

    private void generarPacientesRealistas(Usuario admin, Usuario medico) {
        List<String> comunas = List.of("Chillán", "San Carlos", "Coihueco", "Bulnes", "Quillón");

        // --- 10 CASOS (CREADOS POR ADMIN) ---
        for (int i = 1; i <= 10; i++) {
            PacienteCreateDto dto = new PacienteCreateDto();
            dto.setEsCaso(true);
            dto.setFechaIncl(LocalDate.now().minusDays(i * 2L));
            List<RespuestaDto> respuestas = new ArrayList<>();

            addRes(respuestas, "Nombre completo", "Paciente Caso " + i);
            addRes(respuestas, "Teléfono", "912345" + String.format("%03d", i));
            addRes(respuestas, "Correo electrónico", "caso" + i + "@email.com");
            addRes(respuestas, "Edad", String.valueOf(55 + i));
            addRes(respuestas, "Sexo", i % 2 == 0 ? "Hombre" : "Mujer");
            addRes(respuestas, "Nacionalidad", "Chilena");
            addRes(respuestas, "Dirección", "Calle Rural " + (100 + i));
            addRes(respuestas, "Comuna", comunas.get(i % comunas.size()));
            addRes(respuestas, "Ciudad", "Chillán");
            addRes(respuestas, "Zona", "Rural");
            addRes(respuestas, "¿Vive usted en esta zona desde hace más de 5 años?", "Sí");
            addRes(respuestas, "Nivel educacional", "Básico");
            addRes(respuestas, "Ocupación actual", "Agricultor");
            addRes(respuestas, "Previsión de salud actual", "Fonasa");

            // Clínicos - CASOS: Se llenan las específicas
            addRes(respuestas, "Diagnóstico histológico de adenocarcinoma gástrico (solo casos)", "Sí");
            addRes(respuestas, "Fecha de diagnóstico (solo casos)", "01/0" + (i % 9 + 1) + "/2024");
            addRes(respuestas, "Antecedentes familiares de cáncer gástrico", "Sí");
            addRes(respuestas, "Antecedentes familiares de otros tipos de cáncer", "Sí");
            addRes(respuestas, "¿Cuál(es)? (Otros cánceres)", "Colon");
            addRes(respuestas, "Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)", "Gastritis crónica");
            addRes(respuestas, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "Sí");
            addRes(respuestas, "Especificar cuál (Medicamentos)", "Omeprazol");
            addRes(respuestas, "Cirugía gástrica previa (gastrectomía parcial)", "No");

            addRes(respuestas, "Peso (kg)", String.valueOf(62 + i));
            addRes(respuestas, "Estatura (m)", "1.6" + (5 + i % 5));
            addRes(respuestas, "Índice de masa corporal (IMC)", String.format("%.1f", 22.0 + i * 0.3).replace(",", "."));

            // Tabaquismo - CASOS
            addRes(respuestas, "Estado de tabaquismo", "Fumador actual");
            addRes(respuestas, "Cantidad promedio fumada", "≥20 cigarrillos/día (mucho)");
            addRes(respuestas, "Tiempo total fumando", ">20 años");

            // Alcohol - CASOS
            addRes(respuestas, "Estado de consumo", "Consumidor actual");
            addRes(respuestas, "Frecuencia", "Frecuente (≥4 veces/semana)");
            addRes(respuestas, "Cantidad típica por ocasión", "≥5 tragos (mucho)");
            addRes(respuestas, "Años de consumo habitual", ">20 años");

            addRes(respuestas, "Consumo de carnes procesadas/cecinas", "≥3/sem");
            addRes(respuestas, "Consumo de alimentos muy salados", "Sí");
            addRes(respuestas, "Consumo de porciones de frutas y verduras frescas", "≤2 porciones/día");
            addRes(respuestas, "Consumo frecuente de frituras (≥3 veces por semana)", "Sí");
            addRes(respuestas, "Consumo de alimentos muy condimentados", "3 o más veces por semana");
            addRes(respuestas, "Consumo de infusiones o bebidas muy calientes", "≥3/sem");
            addRes(respuestas, "Exposición ocupacional a pesticidas", "Sí");
            addRes(respuestas, "Exposición a otros compuestos químicos", "No");
            addRes(respuestas, "Humo de leña en el hogar", "Diario");
            addRes(respuestas, "Fuente principal de agua en el hogar", "Pozo");
            addRes(respuestas, "Tratamiento del agua en casa", "Ninguno");

            // H. Pylori - CASOS (Positivo) -> Se llenan preguntas directas, no las de "pasado"
            addRes(respuestas, "Resultado del examen para Helicobacter pylori", "Positivo");
            addRes(respuestas, "Tipo de examen realizado", "Histología / Biopsia");
            addRes(respuestas, "¿Hace cuánto tiempo se realizó el test?", "<1 año");
            addRes(respuestas, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "No");
            addRes(respuestas, "¿Ha repetido el examen posteriormente?", "No");

            // Histopatología - Nuevos nombres con (solo casos)
            addRes(respuestas, "Tipo histológico (solo casos)", i % 2 == 0 ? "Difuso" : "Intestinal");
            addRes(respuestas, "Localización tumoral (solo casos)", "Cuerpo");
            addRes(respuestas, "Estadio clínico (TNM) (solo casos)", "T" + (i % 3 + 1) + "N" + (i % 2) + "M0");

            dto.setRespuestas(respuestas);
            pacienteServicio.crearPacienteConRespuestas(dto, admin);
        }

        // --- 10 CONTROLES (CREADOS POR MÉDICO) ---
        for (int i = 1; i <= 10; i++) {
            PacienteCreateDto dto = new PacienteCreateDto();
            dto.setEsCaso(false);
            dto.setFechaIncl(LocalDate.now().minusDays(i * 3L));
            List<RespuestaDto> respuestas = new ArrayList<>();

            addRes(respuestas, "Nombre completo", "Paciente Control " + i);
            addRes(respuestas, "Teléfono", "987654" + String.format("%03d", i));
            addRes(respuestas, "Correo electrónico", "control" + i + "@email.com");
            addRes(respuestas, "Edad", String.valueOf(45 + i));
            addRes(respuestas, "Sexo", i % 2 == 0 ? "Mujer" : "Hombre");
            addRes(respuestas, "Nacionalidad", "Chilena");
            addRes(respuestas, "Dirección", "Av. Libertad " + (400 + i));
            addRes(respuestas, "Comuna", "Chillán");
            addRes(respuestas, "Ciudad", "Chillán");
            addRes(respuestas, "Zona", "Urbana");
            addRes(respuestas, "¿Vive usted en esta zona desde hace más de 5 años?", "Sí");
            addRes(respuestas, "Nivel educacional", "Superior");
            addRes(respuestas, "Ocupación actual", "Profesor");
            addRes(respuestas, "Previsión de salud actual", "Isapre");

            // Clínicos - CONTROLES
            addRes(respuestas, "Diagnóstico histológico de adenocarcinoma gástrico (solo casos)", "No");
            addRes(respuestas, "Antecedentes familiares de cáncer gástrico", "No");
            // Dependientes NO se llenan
            addRes(respuestas, "Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)", "No");
            addRes(respuestas, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "No");
            addRes(respuestas, "Cirugía gástrica previa (gastrectomía parcial)", "No");

            addRes(respuestas, "Peso (kg)", String.valueOf(70 + i));
            addRes(respuestas, "Estatura (m)", "1.7" + (i % 5));
            addRes(respuestas, "Índice de masa corporal (IMC)", String.format("%.1f", 24.0 + i * 0.2).replace(",", "."));

            // Tabaquismo - CONTROLES (Sanos)
            addRes(respuestas, "Estado de tabaquismo", "Nunca fumó (menos de 100 cigarrillos en la vida)");
            // Dependientes NO se llenan

            // Alcohol - CONTROLES
            addRes(respuestas, "Estado de consumo", "Nunca");
            // Dependientes NO se llenan

            addRes(respuestas, "Consumo de carnes procesadas/cecinas", "≤1/sem");
            addRes(respuestas, "Consumo de alimentos muy salados", "No");
            addRes(respuestas, "Consumo de porciones de frutas y verduras frescas", "≥5 porciones/día");
            addRes(respuestas, "Consumo frecuente de frituras (≥3 veces por semana)", "No");
            addRes(respuestas, "Consumo de alimentos muy condimentados", "Casi nunca / Rara vez");
            addRes(respuestas, "Consumo de infusiones o bebidas muy calientes", "Nunca/Rara vez");
            addRes(respuestas, "Exposición ocupacional a pesticidas", "No");
            addRes(respuestas, "Exposición a otros compuestos químicos", "No");
            addRes(respuestas, "Humo de leña en el hogar", "Nunca/Rara vez");
            addRes(respuestas, "Fuente principal de agua en el hogar", "Red pública");
            addRes(respuestas, "Tratamiento del agua en casa", "Ninguno");

            // H. Pylori - CONTROLES (Negativo) -> Se activan preguntas de pasado
            addRes(respuestas, "Resultado del examen para Helicobacter pylori", "Negativo");
            addRes(respuestas, "¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?", "No");
            addRes(respuestas, "¿Recibió tratamiento para erradicación de H. pylori?", "No");

            // Estas se responden igual
            addRes(respuestas, "Tipo de examen realizado", "Test de aliento");
            addRes(respuestas, "¿Hace cuánto tiempo se realizó el test?", "<1 año");
            addRes(respuestas, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "No");
            addRes(respuestas, "¿Ha repetido el examen posteriormente?", "No");

            dto.setRespuestas(respuestas);
            pacienteServicio.crearPacienteConRespuestas(dto, medico);
        }

        logger.info(">>> Generación de pacientes de prueba completada <<<");
    }

    private void crearSistemaDeSeguridad() {
        Permiso pCrearCaso = crearPermiso("CREAR_CASO", "Permite ingresar pacientes Caso");
        Permiso pCrearControl = crearPermiso("CREAR_CONTROL", "Permite ingresar pacientes Control");
        Permiso pEditarCaso = crearPermiso("EDITAR_CASO", "Permite editar respuestas de Casos");
        Permiso pEditarControl = crearPermiso("EDITAR_CONTROL", "Permite editar respuestas de Controles");
        Permiso pVerPaciente = crearPermiso("VER_PACIENTE", "Permite ver ficha individual");
        Permiso pVerListado = crearPermiso("VER_LISTADO_PACIENTES", "Permite ver tabla resumen y exportar");
        Permiso pEliminar = crearPermiso("ELIMINAR_PACIENTE", "Permite archivar/eliminar");

        crearRol("ROLE_ADMIN", Set.of(pCrearCaso, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        crearRol("ROLE_MEDICO", Set.of(pCrearCaso, pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado));
        crearRol("ROLE_INVESTIGADOR", Set.of(pCrearCaso, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        crearRol("ROLE_ESTUDIANTE", Set.of(pCrearControl, pEditarControl, pVerPaciente, pVerListado));
        crearRol("ROLE_VISUALIZADOR", Set.of(pVerListado));
    }

    private Usuario crearUsuariosDePrueba() {
        crearUsuario("11.111.111-1", "admin", "Admin", "General", "admin@hospital.cl", "ROLE_ADMIN");
        crearUsuario("20.629.545-7", "medico", "Matias", "Medico", "matias.aguilera2101@alumnos.ubiobio.cl", "ROLE_MEDICO");
        crearUsuario("21.503.053-9", "investigador", "Bairon", "Investigador", "bairon.munoz2201@alumnos.ubiobio.cl", "ROLE_INVESTIGADOR");
        crearUsuario("21.416.129-k", "estudiante", "Cristian", "Estudiante", "cristian.jimenez2201@alumnos.ubiobio.cl", "ROLE_ESTUDIANTE");
        crearUsuario("21.232.674-7", "visualizador", "Cristobal", "Visualizador", "cristobal.morales2201@alumnos.ubiobio.cl", "ROLE_VISUALIZADOR");
        return usuarioRepositorio.findByRut("11.111.111-1").orElseThrow();
    }

    private Permiso crearPermiso(String nombre, String descripcion) {
        return permisoRepositorio.findByNombre(nombre)
                .orElseGet(() -> permisoRepositorio.save(new Permiso(null, nombre, descripcion, new HashSet<>())));
    }

    private void crearRol(String nombre, Set<Permiso> permisos) {
        if (rolRepositorio.findByNombre(nombre).isEmpty()) {
            Rol r = new Rol();
            r.setNombre(nombre);
            r.setPermisos(permisos);
            rolRepositorio.save(r);
        }
    }

    private void crearUsuario(String rut, String pass, String nom, String ap, String email, String rolNombre) {
        if (usuarioRepositorio.findByRut(rut).isEmpty()) {
            Usuario u = new Usuario();
            u.setRut(rut); u.setNombres(nom); u.setApellidos(ap); u.setEmail(email);
            u.setContrasena(codificadorDeContrasena.encode(pass));
            u.setActivo(true);
            Rol rol = rolRepositorio.findByNombre(rolNombre).orElseThrow();
            u.setRoles(new HashSet<>(Collections.singletonList(rol)));
            usuarioRepositorio.save(u);
        }
    }

    private Categoria crearCategoria(String nombre, int orden) {
        return categoriaRepositorio.findByNombre(nombre)
                .orElseGet(() -> categoriaRepositorio.save(new Categoria(null, nombre, orden, new HashSet<>())));
    }

    private Pregunta crearPregunta(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden,
                                   boolean exportable, boolean estadistica, boolean soloCasos, Double... cortesManuales) {
        return crearPregunta(cat, etiqueta, codigoStata, tipo, orden, exportable, estadistica, soloCasos, null, cortesManuales);
    }

    // Sobrecarga 2: Base completa
    private Pregunta crearPregunta(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden,
                                   boolean exportable, boolean estadistica, boolean soloCasos, List<String> opciones, Double... cortesManuales) {
        Optional<Pregunta> existe = preguntaRepositorio.findByEtiqueta(etiqueta);
        if (existe.isPresent()) return existe.get();

        Pregunta p = new Pregunta();
        p.setCategoria(cat);
        p.setEtiqueta(etiqueta);
        p.setCodigoStata(codigoStata);
        p.setDescripcion(etiqueta);
        p.setTipo_dato(tipo);
        p.setOrden(orden);
        p.setActivo(true);
        p.setExportable(exportable);
        p.setGenerarEstadistica(estadistica);
        p.setSoloCasos(soloCasos);
        p.setDato_sensible(etiqueta.toLowerCase().contains("nombre") || etiqueta.toLowerCase().contains("dirección"));
        p.setDicotomizaciones(new ArrayList<>());

        if (cortesManuales != null && cortesManuales.length > 0) {
            p.setTipoCorte(TipoCorte.VALOR_FIJO);
            for (Double valor : cortesManuales) {
                Dicotomizacion dic = new Dicotomizacion();
                dic.setValor(valor);
                dic.setSentido(SentidoCorte.MAYOR_O_IGUAL);
                dic.setPregunta(p);
                p.getDicotomizaciones().add(dic);
            }
        } else if (tipo == TipoDato.NUMERO && exportable) {
            p.setTipoCorte(TipoCorte.MEDIA);
        } else {
            p.setTipoCorte(TipoCorte.NINGUNO);
        }

        p = preguntaRepositorio.save(p);

        if (tipo == TipoDato.ENUM && opciones != null) {
            int i = 0;
            for (String txt : opciones) {
                OpcionPregunta op = new OpcionPregunta();
                op.setEtiqueta(txt);
                op.setOrden(i++);
                op.setPregunta(p);
                opcionPreguntaRepositorio.save(op);
            }
        }
        return p;
    }

    private Pregunta crearPreguntaConDependencia(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden,
                                                 boolean exportable, boolean estadistica, boolean soloCasos, List<String> opciones,
                                                 Pregunta preguntaControladora, String valorEsperado, String accion) {
        Optional<Pregunta> existe = preguntaRepositorio.findByEtiqueta(etiqueta);
        if (existe.isPresent()) return existe.get();

        Pregunta p = new Pregunta();
        p.setCategoria(cat);
        p.setEtiqueta(etiqueta);
        p.setCodigoStata(codigoStata);
        p.setDescripcion(etiqueta);
        p.setTipo_dato(tipo);
        p.setOrden(orden);
        p.setActivo(true);
        p.setExportable(exportable);
        p.setGenerarEstadistica(estadistica);
        p.setSoloCasos(soloCasos);
        p.setDato_sensible(false);
        p.setDicotomizaciones(new ArrayList<>());
        p.setTipoCorte(TipoCorte.NINGUNO);

        p.setPreguntaControladora(preguntaControladora);
        p.setValorEsperadoControladora(valorEsperado);
        p.setAccionSiNoCumple(accion);

        p = preguntaRepositorio.save(p);

        if (tipo == TipoDato.ENUM && opciones != null) {
            int i = 0;
            for (String txt : opciones) {
                OpcionPregunta op = new OpcionPregunta();
                op.setEtiqueta(txt);
                op.setOrden(i++);
                op.setPregunta(p);
                opcionPreguntaRepositorio.save(op);
            }
        }
        return p;
    }
    private void addRes(List<RespuestaDto> lista, String etiqueta, String valor) {
        Optional<Pregunta> op = preguntaRepositorio.findByEtiqueta(etiqueta);
        if (op.isPresent()) {
            RespuestaDto r = new RespuestaDto();
            r.setPregunta_id(op.get().getPregunta_id());
            r.setValor(valor);
            lista.add(r);
        }
    }

    // --- MÉTODOS PARA CARGA DE GENÉTICA (SNP) ---

    private void inicializarConfiguracionGenetica() {
        // Gen 1: TLR9 rs5743836 [cite: 64]
        // Alelos base: T y C. Opciones: TT, TC, CC.
        crearSnpConfig("TLR9 rs5743836", "TT", "TC", "CC", "T");

        // Gen 2: TLR9 rs187084 [cite: 65]
        // Alelos base: T y C. Opciones: TT, TC, CC.
        crearSnpConfig("TLR9 rs187084", "TT", "TC", "CC", "T");

        // Gen 3: miR-146a rs2910164 [cite: 66]
        // Alelos base: G y C. Opciones: GG, GC, CC.
        crearSnpConfig("miR-146a rs2910164", "GG", "GC", "CC", "G");

        // Gen 4: miR-196a2 rs11614913 [cite: 67]
        // Alelos base: C y T. Opciones: CC, CT, TT.
        crearSnpConfig("miR-196a2 rs11614913", "CC", "CT", "TT", "C");

        // Gen 5: MTHFR rs1801133 [cite: 68]
        // Alelos base: C y T. Opciones: CC, CT, TT.
        crearSnpConfig("MTHFR rs1801133", "CC", "CT", "TT", "C");

        // Gen 6: DNMT3B rs1569686 [cite: 69]
        // Alelos base: G y T. Opciones: GG, GT, TT.
        crearSnpConfig("DNMT3B rs1569686", "GG", "GT", "TT", "G");

        logger.info(">>> Configuración genética base cargada <<<");
    }

    private void crearSnpConfig(String nombre, String op1, String op2, String op3, String aleloRefPorDefecto) {
        // Verificamos por nombre si ya existe para no duplicar
        // Nota: Asume que agregaste un método findByNombreGen en SnpConfigRepositorio
        // Si no lo tienes, puedes usar findAll y filtrar stream, o agregarlo al repo.
        // Aquí usaré una lógica segura con stream si no quieres tocar el Repo todavía:
        boolean existe = snpConfigRepositorio.findAll().stream()
                .anyMatch(s -> s.getNombreGen().equals(nombre));

        if (!existe) {
            SnpConfig snp = new SnpConfig();
            snp.setNombreGen(nombre);
            snp.setOpcion1(op1);
            snp.setOpcion2(op2);
            snp.setOpcion3(op3);

            snp.setAleloRef(aleloRefPorDefecto);
            snp.setAleloRiesgo(null); // SE DEJA NULL INTENCIONALMENTE (Pendiente de configurar por Clienta)

            snpConfigRepositorio.save(snp);
        }
    }

}