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

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        logger.info(">>> INICIANDO CARGA (DICOTOMIZACIONES CORREGIDAS FINAL) <<<");

        crearSistemaDeSeguridad();
        Usuario admin = crearUsuariosDePrueba();

        if (pacienteServicio.getAllPacientes().isEmpty()) {
            crearEncuestaCRF();
            generarPacientesRealistas(admin);
        } else {
            logger.info(">>> BASE DE DATOS YA INICIALIZADA <<<");
        }

        logger.info(">>> CARGA FINALIZADA EXITOSAMENTE <<<");
    }

    private void crearEncuestaCRF() {
        // Listas auxiliares para orden correcto (0=No, 1=Sí)
        List<String> noSi = List.of("No", "Sí");
        List<String> siNo = List.of("Sí", "No"); // Solo si se requiere visualmente al revés, pero cuidado con el índice
        List<String> siNoRecuerda = List.of("Sí", "No", "No recuerda");

        // --- 1. IDENTIFICACIÓN ---
        Categoria c1 = crearCategoria("1. Identificación del participante", 1);
        crearPregunta(c1, "Nombre completo", "Nombre", TipoDato.TEXTO, 1, false, false);
        crearPregunta(c1, "Teléfono", "Telefono", TipoDato.CELULAR, 2, false, false);
        crearPregunta(c1, "Correo electrónico", "Email", TipoDato.EMAIL, 3, false, false);

        // --- 2. DATOS SOCIODEMOGRÁFICOS (CORREGIDO SEGÚN TABLA) ---
        Categoria c2 = crearCategoria("2. Datos sociodemográficos", 2);

        // Edad: Cortes en 50 y 60
        crearPregunta(c2, "Edad", "Edad", TipoDato.NUMERO, 1, true, true, 50.0, 60.0);

        // Sexo: Mujer(0), Hombre(1)
        crearPregunta(c2, "Sexo", "Sexo", TipoDato.ENUM, 2, true, true, List.of("Mujer", "Hombre"));

        crearPregunta(c2, "Nacionalidad", "Nacionalidad", TipoDato.TEXTO, 3, false, false);
        crearPregunta(c2, "Dirección", "Direccion", TipoDato.TEXTO, 4, false, false);
        crearPregunta(c2, "Comuna", "Comuna", TipoDato.TEXTO, 5, false, false);
        crearPregunta(c2, "Ciudad", "Ciudad", TipoDato.TEXTO, 6, false, false);
        crearPregunta(c2, "Zona", "Zona", TipoDato.ENUM, 7, true, true, List.of("Urbana", "Rural")); // Urbana=0, Rural=1

        // Residencia >5 años: No(0), Sí(1)
        crearPregunta(c2, "¿Vive usted en esta zona desde hace más de 5 años?", "Residencia_Urbana5", TipoDato.ENUM, 8, true, true,
                List.of("No", "Sí"));

        // Nivel educacional: Cortes en 1.0 (Básico vs Resto) y 2.0 (Sup vs Resto)
        crearPregunta(c2, "Nivel educacional", "NivelEduc", TipoDato.ENUM, 9, true, true,
                List.of("Básico", "Medio", "Superior"), 1.0, 2.0);

        crearPregunta(c2, "Ocupación actual", "Ocupacion", TipoDato.TEXTO, 10, false, false);

        // Previsión: Corte en 2.0 (Fonasa+Sin vs Isapre+Otros)
        crearPregunta(c2, "Previsión de salud actual", "Prevision_FonasaVsOtros", TipoDato.ENUM, 11, true, true,
                List.of("Fonasa", "Sin previsión", "Isapre", "Capredena / Dipreca", "Otra"), 2.0);


        // --- 3. ANTECEDENTES CLÍNICOS (CORREGIDO ORDEN NO/SI) ---
        Categoria c3 = crearCategoria("3. Antecedentes clínicos", 3);
        crearPregunta(c3, "Diagnóstico histológico de adenocarcinoma gástrico (solo casos)", "Diag_Adenocarcinoma", TipoDato.ENUM, 1, false, false, List.of("No", "Sí"));
        crearPregunta(c3, "Fecha de diagnóstico (solo casos)", "Fecha_Diag", TipoDato.TEXTO, 2, false, false);

        // No(0), Sí(1)
        crearPregunta(c3, "Antecedentes familiares de cáncer gástrico", "CA_FamiliaGastrico", TipoDato.ENUM, 3, true, true, List.of("No", "Sí"));
        crearPregunta(c3, "Antecedentes familiares de otros tipos de cáncer", "CA_FamiliaOtros", TipoDato.ENUM, 4, true, true, List.of("No", "Sí"));
        crearPregunta(c3, "¿Cuál(es)? (Otros cánceres)", "CA_FamiliaOtros_Detalle", TipoDato.TEXTO, 5, false, false);

        // Enfermedades Relevantes: Ahora es ENUM No/Sí para dicotomizar + Texto extra
        crearPregunta(c3, "Otras enfermedades relevantes", "EnfermedadesRelevantes", TipoDato.ENUM, 6, true, true, List.of("No", "Sí"));
        crearPregunta(c3, "Detalle enfermedades relevantes", "EnfermedadesRelevantes_Detalle", TipoDato.TEXTO, 7, false, false);

        crearPregunta(c3, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "UsoCronico_Medicamentos", TipoDato.ENUM, 8, true, true, List.of("No", "Sí"));
        crearPregunta(c3, "Especificar cuál (Medicamentos)", "UsoCronico_Detalle", TipoDato.TEXTO, 9, false, false);
        crearPregunta(c3, "Cirugía gástrica previa", "CirugiaGastricaPrevia", TipoDato.ENUM, 10, true, true, List.of("No", "Sí"));


        // --- 4. ANTROPOMETRÍA (CORREGIDO IMC) ---
        Categoria c4 = crearCategoria("4. Antropometría", 4);
        crearPregunta(c4, "Peso (kg)", "Peso", TipoDato.NUMERO, 1, true, true);

        // IMC: Corte en 25.0
        crearPregunta(c4, "IMC", "IMC", TipoDato.NUMERO, 2, true, true, 25.0);
        crearPregunta(c4, "Estatura (m)", "Estatura", TipoDato.NUMERO, 3, true, true);


        // --- 5. TABAQUISMO ---
        Categoria c5 = crearCategoria("5. Tabaquismo", 5);
        crearPregunta(c5, "Estado de tabaquismo", "tabaco_estado", TipoDato.ENUM, 1, true, true,
                List.of("Nunca fumó (menos de 100 cigarrillos en la vida)", "Exfumador", "Fumador actual"));
        crearPregunta(c5, "Cantidad promedio fumada", "tabaco_cantidad", TipoDato.ENUM, 2, true, true,
                List.of("1–9 cigarrillos/día (poco)", "10–19 cigarrillos/día (moderado)", "≥20 cigarrillos/día (mucho)"));
        crearPregunta(c5, "Tiempo total fumando", "tabaco_tiempo_total", TipoDato.ENUM, 3, true, true,
                List.of("<10 años", "10–20 años", ">20 años"));
        crearPregunta(c5, "Si exfumador: tiempo desde que dejó de fumar", "tabaco_exfumador_tiempo", TipoDato.ENUM, 4, true, true,
                List.of("<5 años", "5–10 años", ">10 años"));


        // --- 6. CONSUMO DE ALCOHOL ---
        Categoria c6 = crearCategoria("6. Consumo de alcohol", 6);
        crearPregunta(c6, "Estado de consumo", "alcohol_estado", TipoDato.ENUM, 1, true, true,
                List.of("Nunca", "Exconsumidor", "Consumidor actual"));
        crearPregunta(c6, "Frecuencia", "alcohol_frecuencia", TipoDato.ENUM, 2, true, true,
                List.of("Ocasional (menos de 1 vez/semana)", "Regular (1–3 veces/semana)", "Frecuente (≥4 veces/semana)"));
        crearPregunta(c6, "Cantidad típica por ocasión", "alcohol_cantidad", TipoDato.ENUM, 3, true, true,
                List.of("1–2 tragos (poco)", "3–4 tragos (moderado)", "≥5 tragos (mucho)"));
        crearPregunta(c6, "Años de consumo habitual", "alcohol_tiempo_total", TipoDato.ENUM, 4, true, true,
                List.of("<10 años", "10–20 años", ">20 años"));
        crearPregunta(c6, "Si exconsumidor: tiempo desde que dejó de beber regularmente", "alcohol_exconsumidor_tiempo", TipoDato.ENUM, 5, true, true,
                List.of("<5 años", "5–10 años", ">10 años"));


        // --- 7. FACTORES DIETARIOS Y AMBIENTALES ---
        Categoria c7 = crearCategoria("7. Factores dietarios y ambientales", 7);
        crearPregunta(c7, "Consumo de carnes procesadas/cecinas", "diet_carnes", TipoDato.ENUM, 1, true, true,
                List.of("≤1/sem", "2/sem", "≥3/sem"));
        crearPregunta(c7, "Consumo de alimentos muy salados (agrega sal a la comida sin probar)", "diet_sal", TipoDato.ENUM, 2, true, true, siNo);
        crearPregunta(c7, "Consumo de porciones de frutas y verduras frescas", "diet_frutas_verduras", TipoDato.ENUM, 3, true, true,
                List.of("≥5 porciones/día", "3–4 porciones/día", "≤2 porciones/día"));
        crearPregunta(c7, "Consumo frecuente de frituras (≥3 veces por semana)", "diet_frituras", TipoDato.ENUM, 4, true, true, siNo);
        crearPregunta(c7, "Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)", "diet_condimentos", TipoDato.ENUM, 5, true, true,
                List.of("Casi nunca / Rara vez", "1 a 2 veces por semana", "3 o más veces por semana"));
        crearPregunta(c7, "Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)", "diet_bebidas_calientes", TipoDato.ENUM, 6, true, true,
                List.of("Nunca/Rara vez", "1–2/sem", "≥3/sem"));
        crearPregunta(c7, "Exposición ocupacional a pesticidas", "amb_pesticidas", TipoDato.ENUM, 7, true, true, siNo);
        crearPregunta(c7, "Exposición a otros compuestos químicos", "amb_quimicos", TipoDato.ENUM, 8, true, true, siNo);
        crearPregunta(c7, "¿Cuál(es)? (Químicos)", "amb_quimicos_detalle", TipoDato.TEXTO, 9, false, false);
        crearPregunta(c7, "Humo de leña en el hogar (cocina/calefacción)", "amb_lena", TipoDato.ENUM, 10, true, true,
                List.of("Nunca/Rara vez", "Estacional", "Diario"));
        crearPregunta(c7, "Fuente principal de agua en el hogar", "amb_agua_fuente", TipoDato.ENUM, 11, true, true,
                List.of("Red pública", "Pozo", "Camión aljibe", "Otra"));
        crearPregunta(c7, "Tratamiento del agua en casa", "amb_agua_tratamiento", TipoDato.ENUM, 12, true, true,
                List.of("Ninguno", "Hervir", "Filtro", "Cloro"));


        // --- 8. H. PYLORI ---
        Categoria c8 = crearCategoria("8. H. Pylori", 8);
        crearPregunta(c8, "Resultado del examen para Helicobacter pylori", "hp_resultado", TipoDato.ENUM, 1, true, true,
                List.of("Positivo", "Negativo", "Desconocido"));
        crearPregunta(c8, "¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?", "hp_pasado_positivo", TipoDato.ENUM, 2, true, true,
                siNoRecuerda);
        crearPregunta(c8, "Si responde “Sí”, indicar año aproximado y tipo de examen", "hp_pasado_detalle", TipoDato.TEXTO, 3, false, false);
        crearPregunta(c8, "¿Recibió tratamiento para erradicación de H. pylori?", "hp_tratamiento", TipoDato.ENUM, 4, true, true,
                siNoRecuerda);
        crearPregunta(c8, "Si “Sí”, anotar año y esquema, si se conoce", "hp_tratamiento_detalle", TipoDato.TEXTO, 5, false, false);
        crearPregunta(c8, "Tipo de examen realizado", "hp_tipo_examen", TipoDato.ENUM, 6, true, true,
                List.of("Test de aliento (urea-C13/C14)", "Antígeno en deposiciones", "Serología (IgG)", "Test rápido de ureasa", "Histología / Biopsia", "Otro"));
        crearPregunta(c8, "¿Hace cuánto tiempo se realizó el test?", "hp_tiempo_test", TipoDato.ENUM, 7, true, true,
                List.of("<1 año", "1–5 años", ">5 años"));
        crearPregunta(c8, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "hp_uso_ibp", TipoDato.ENUM, 8, true, true,
                siNoRecuerda);
        crearPregunta(c8, "¿Ha repetido el examen posteriormente?", "hp_repetido", TipoDato.ENUM, 9, true, true,
                List.of("Sí", "No"));


        // --- 9. HISTOPATOLOGÍA ---
        Categoria c9 = crearCategoria("9. Histopatología (Solo Casos)", 9);
        crearPregunta(c9, "Tipo Histológico", "Histologia_Tipo", TipoDato.ENUM, 1, true, true, List.of("Intestinal", "Difuso", "Mixto", "Otro"));
        crearPregunta(c9, "Tipo histológico (especificar)", "histo_tipo_otro", TipoDato.TEXTO, 2, false, false);
        crearPregunta(c9, "Localización Tumoral", "Histologia_Localizacion", TipoDato.ENUM, 3, true, true, List.of("Cardias", "Cuerpo", "Antro", "Difuso"));
        crearPregunta(c9, "Estadio clínico (TNM)", "histo_tnm", TipoDato.TEXTO, 4, true, true);
    }

    // --------------------------------------------------------------------------------------------
    // 2. GENERACIÓN DE PACIENTES
    // --------------------------------------------------------------------------------------------
    private void generarPacientesRealistas(Usuario reclutador) {
        List<String> comunas = List.of("Chillán", "San Carlos", "Coihueco");

        // --- 5 CASOS (PACIENTES CON CÁNCER - ALTO RIESGO) ---
        for (int i = 1; i <= 5; i++) {
            PacienteCreateDto dto = new PacienteCreateDto();
            dto.setEsCaso(true);
            dto.setFechaIncl(LocalDate.now().minusDays(i * 2));
            List<RespuestaDto> respuestas = new ArrayList<>();

            // 1. Identificación
            addRes(respuestas, "Nombre completo", "Paciente Caso " + i);
            addRes(respuestas, "Teléfono", "912345678");
            addRes(respuestas, "Correo electrónico", "caso" + i + "@email.com");

            // 2. Sociodemográficos
            addRes(respuestas, "Edad", String.valueOf(55 + i));
            addRes(respuestas, "Sexo", "Hombre");
            addRes(respuestas, "Nacionalidad", "Chilena");
            addRes(respuestas, "Dirección", "Calle Rural 123");
            addRes(respuestas, "Comuna", comunas.get(i % comunas.size()));
            addRes(respuestas, "Ciudad", "Chillán");
            addRes(respuestas, "Zona", "Rural");
            addRes(respuestas, "¿Vive usted en esta zona desde hace más de 5 años?", "Sí");
            addRes(respuestas, "Nivel educacional", "Básico");
            addRes(respuestas, "Ocupación actual", "Agricultor");
            addRes(respuestas, "Previsión de salud actual", "Fonasa");

            // 3. Clínicos (Perfil de Riesgo)
            addRes(respuestas, "Diagnóstico histológico de adenocarcinoma gástrico (solo casos)", "Sí");
            addRes(respuestas, "Fecha de diagnóstico (solo casos)", "01/03/2024");
            addRes(respuestas, "Antecedentes familiares de cáncer gástrico", "Sí");
            addRes(respuestas, "Antecedentes familiares de otros tipos de cáncer", "No");

            // Enfermedades (Ahora con ENUM + DETALLE)
            addRes(respuestas, "Otras enfermedades relevantes", "Sí");
            addRes(respuestas, "Detalle enfermedades relevantes", "Gastritis crónica atrófica");

            addRes(respuestas, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "Sí");
            addRes(respuestas, "Especificar cuál (Medicamentos)", "Omeprazol");
            addRes(respuestas, "Cirugía gástrica previa", "No");

            // 4. Antropometría
            addRes(respuestas, "Peso (kg)", "62");
            addRes(respuestas, "Estatura (m)", "1.65");
            addRes(respuestas, "IMC", "22.8"); // < 25 (0)

            // 5. Tabaquismo
            addRes(respuestas, "Estado de tabaquismo", "Fumador actual");
            addRes(respuestas, "Cantidad promedio fumada", "≥20 cigarrillos/día (mucho)");
            addRes(respuestas, "Tiempo total fumando", ">20 años");

            // 6. Alcohol
            addRes(respuestas, "Estado de consumo", "Consumidor actual");
            addRes(respuestas, "Frecuencia", "Frecuente (≥4 veces/semana)");
            addRes(respuestas, "Cantidad típica por ocasión", "≥5 tragos (mucho)");
            addRes(respuestas, "Años de consumo habitual", ">20 años");

            // 7. Dieta/Ambiente
            addRes(respuestas, "Consumo de carnes procesadas/cecinas", "≥3/sem");
            addRes(respuestas, "Consumo de alimentos muy salados (agrega sal a la comida sin probar)", "Sí");
            addRes(respuestas, "Consumo de porciones de frutas y verduras frescas", "≤2 porciones/día");
            addRes(respuestas, "Consumo frecuente de frituras (≥3 veces por semana)", "Sí");
            addRes(respuestas, "Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)", "3 o más veces por semana");
            addRes(respuestas, "Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)", "≥3/sem");
            addRes(respuestas, "Exposición ocupacional a pesticidas", "Sí");
            addRes(respuestas, "Exposición a otros compuestos químicos", "No");
            addRes(respuestas, "Humo de leña en el hogar (cocina/calefacción)", "Diario");
            addRes(respuestas, "Fuente principal de agua en el hogar", "Pozo");
            addRes(respuestas, "Tratamiento del agua en casa", "Ninguno");

            // 8. H. PYLORI
            addRes(respuestas, "Resultado del examen para Helicobacter pylori", "Positivo");
            addRes(respuestas, "¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?", "Sí");
            addRes(respuestas, "Si responde “Sí”, indicar año aproximado y tipo de examen", "2015, Test de Aliento");
            addRes(respuestas, "¿Recibió tratamiento para erradicación de H. pylori?", "Sí");
            addRes(respuestas, "Si “Sí”, anotar año y esquema, si se conoce", "2015, Claritromicina + Amoxicilina");
            addRes(respuestas, "Tipo de examen realizado", "Histología / Biopsia");
            addRes(respuestas, "¿Hace cuánto tiempo se realizó el test?", "<1 año");
            addRes(respuestas, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "No");
            addRes(respuestas, "¿Ha repetido el examen posteriormente?", "No");

            // 9. Histopatología
            addRes(respuestas, "Tipo Histológico", "Difuso");
            addRes(respuestas, "Localización Tumoral", "Cuerpo");
            addRes(respuestas, "Estadio clínico (TNM)", "T3N1M0");

            dto.setRespuestas(respuestas);
            pacienteServicio.crearPacienteConRespuestas(dto, reclutador);
        }

        // --- 5 CONTROLES (SANO - BAJO RIESGO) ---
        for (int i = 1; i <= 5; i++) {
            PacienteCreateDto dto = new PacienteCreateDto();
            dto.setEsCaso(false);
            dto.setFechaIncl(LocalDate.now().minusDays(i * 3));
            List<RespuestaDto> respuestas = new ArrayList<>();

            // 1. Identificación
            addRes(respuestas, "Nombre completo", "Paciente Control " + i);
            addRes(respuestas, "Teléfono", "987654321");
            addRes(respuestas, "Correo electrónico", "control" + i + "@email.com");

            // 2. Sociodemográficos
            addRes(respuestas, "Edad", String.valueOf(45 + i));
            addRes(respuestas, "Sexo", "Mujer");
            addRes(respuestas, "Nacionalidad", "Chilena");
            addRes(respuestas, "Dirección", "Av. Libertad 456");
            addRes(respuestas, "Comuna", "Chillán");
            addRes(respuestas, "Ciudad", "Chillán");
            addRes(respuestas, "Zona", "Urbana");
            addRes(respuestas, "¿Vive usted en esta zona desde hace más de 5 años?", "Sí");
            addRes(respuestas, "Nivel educacional", "Superior");
            addRes(respuestas, "Ocupación actual", "Profesor");
            addRes(respuestas, "Previsión de salud actual", "Isapre");

            // 3. Clínicos (Sano)
            addRes(respuestas, "Antecedentes familiares de cáncer gástrico", "No");
            addRes(respuestas, "Antecedentes familiares de otros tipos de cáncer", "Sí");
            addRes(respuestas, "Otras enfermedades relevantes", "No");
            addRes(respuestas, "Uso crónico de medicamentos gastrolesivos (AINES u otros)", "No");
            addRes(respuestas, "Cirugía gástrica previa", "No");

            // 4. Antropometría
            addRes(respuestas, "Peso (kg)", "75");
            addRes(respuestas, "Estatura (m)", "1.70");
            addRes(respuestas, "IMC", "25.9"); // >= 25 (1)

            // 5. Tabaquismo
            addRes(respuestas, "Estado de tabaquismo", "Nunca fumó (menos de 100 cigarrillos en la vida)");

            // 6. Alcohol
            addRes(respuestas, "Estado de consumo", "Consumidor actual");
            addRes(respuestas, "Frecuencia", "Ocasional (menos de 1 vez/semana)");
            addRes(respuestas, "Cantidad típica por ocasión", "1–2 tragos (poco)");
            addRes(respuestas, "Años de consumo habitual", "10–20 años");

            // 7. Dieta/Ambiente
            addRes(respuestas, "Consumo de carnes procesadas/cecinas", "≤1/sem");
            addRes(respuestas, "Consumo de alimentos muy salados (agrega sal a la comida sin probar)", "No");
            addRes(respuestas, "Consumo de porciones de frutas y verduras frescas", "≥5 porciones/día");
            addRes(respuestas, "Consumo frecuente de frituras (≥3 veces por semana)", "No");
            addRes(respuestas, "Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)", "Casi nunca / Rara vez");
            addRes(respuestas, "Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)", "Nunca/Rara vez");
            addRes(respuestas, "Exposición ocupacional a pesticidas", "No");
            addRes(respuestas, "Exposición a otros compuestos químicos", "No");
            addRes(respuestas, "Humo de leña en el hogar (cocina/calefacción)", "Nunca/Rara vez");
            addRes(respuestas, "Fuente principal de agua en el hogar", "Red pública");
            addRes(respuestas, "Tratamiento del agua en casa", "Ninguno");

            // 8. H. PYLORI
            addRes(respuestas, "Resultado del examen para Helicobacter pylori", "Negativo");
            addRes(respuestas, "¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?", "No");
            addRes(respuestas, "¿Recibió tratamiento para erradicación de H. pylori?", "No");
            addRes(respuestas, "Tipo de examen realizado", "Test de aliento (urea-C13/C14)");
            addRes(respuestas, "¿Hace cuánto tiempo se realizó el test?", "1–5 años");
            addRes(respuestas, "Uso de antibióticos o IBP en las 4 semanas previas al examen", "No");
            addRes(respuestas, "¿Ha repetido el examen posteriormente?", "No");

            dto.setRespuestas(respuestas);
            pacienteServicio.crearPacienteConRespuestas(dto, reclutador);
        }
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
        crearUsuario("22.222.222-2", "medico", "Dr. Juan", "Pérez", "medico@hospital.cl", "ROLE_MEDICO");
        crearUsuario("33.333.333-3", "investigador", "Ana", "Silva", "investigacion@ubiobio.cl", "ROLE_INVESTIGADOR");
        crearUsuario("44.444.444-4", "estudiante", "Pedro", "Estudiante", "pedro@alumnos.cl", "ROLE_ESTUDIANTE");
        crearUsuario("55.555.555-5", "visualizador", "Juanito", "XD", "pedro@alumnos.cl", "ROLE_VISUALIZADOR");
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

    private void crearPregunta(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden,
                               boolean exportable, boolean estadistica,
                               List<String> opciones, Double... cortesManuales) {
        if (preguntaRepositorio.findByEtiqueta(etiqueta).isPresent()) return;

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
    }

    // Sobrecarga 1: Sin opciones ni cortes (TEXTO)
    private void crearPregunta(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden, boolean exportable, boolean estadistica) {
        crearPregunta(cat, etiqueta, codigoStata, tipo, orden, exportable, estadistica, (List<String>) null);
    }

    // Sobrecarga 2: Numérica con cortes manuales
    private void crearPregunta(Categoria cat, String etiqueta, String codigoStata, TipoDato tipo, int orden,
                               boolean exportable, boolean estadistica, Double... cortesManuales) {
        crearPregunta(cat, etiqueta, codigoStata, tipo, orden, exportable, estadistica, null, cortesManuales);
    }
}