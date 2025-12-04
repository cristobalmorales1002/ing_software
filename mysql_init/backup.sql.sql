-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-12-2025 a las 22:05:32
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto_semestral`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
                             `orden` int(11) NOT NULL,
                             `id_cat` bigint(20) NOT NULL,
                             `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`orden`, `id_cat`, `nombre`) VALUES
                                                          (1, 1, '1. Identificación del participante'),
                                                          (2, 2, '2. Datos sociodemográficos'),
                                                          (3, 3, '3. Antecedentes clínicos'),
                                                          (4, 4, '4. Antropometría'),
                                                          (5, 5, '5. Tabaquismo'),
                                                          (6, 6, '6. Consumo de alcohol'),
                                                          (7, 7, '7. Factores dietarios y ambientales'),
                                                          (8, 8, '8. H. Pylori'),
                                                          (9, 9, '9. Histopatología (Solo Casos)');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `destinatario_mensaje`
--

CREATE TABLE `destinatario_mensaje` (
                                        `eliminado` bit(1) NOT NULL,
                                        `leido` bit(1) NOT NULL,
                                        `destinatario_id` bigint(20) NOT NULL,
                                        `fecha_lectura` datetime(6) DEFAULT NULL,
                                        `id` bigint(20) NOT NULL,
                                        `mensaje_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dicotomizaciones`
--

CREATE TABLE `dicotomizaciones` (
                                    `valor_corte` double DEFAULT NULL,
                                    `id_dicotomizacion` bigint(20) NOT NULL,
                                    `pregunta_id` bigint(20) DEFAULT NULL,
                                    `sentido_corte` enum('IGUAL_A','MAYOR_O_IGUAL','MAYOR_QUE','MENOR_O_IGUAL','MENOR_QUE') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dicotomizaciones`
--

INSERT INTO `dicotomizaciones` (`valor_corte`, `id_dicotomizacion`, `pregunta_id`, `sentido_corte`) VALUES
                                                                                                        (50, 1, 4, 'MAYOR_O_IGUAL'),
                                                                                                        (60, 2, 4, 'MAYOR_O_IGUAL'),
                                                                                                        (1, 3, 12, 'MAYOR_O_IGUAL'),
                                                                                                        (2, 4, 12, 'MAYOR_O_IGUAL'),
                                                                                                        (2, 5, 14, 'MAYOR_O_IGUAL'),
                                                                                                        (25, 6, 26, 'MAYOR_O_IGUAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensaje`
--

CREATE TABLE `mensaje` (
                           `emisor_id` bigint(20) NOT NULL,
                           `fecha_envio` datetime(6) NOT NULL,
                           `id` bigint(20) NOT NULL,
                           `asunto` varchar(255) NOT NULL,
                           `contenido` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion_pregunta`
--

CREATE TABLE `opcion_pregunta` (
                                   `orden` int(11) NOT NULL,
                                   `valor_dicotomizado` double DEFAULT NULL,
                                   `id_opcion` bigint(20) NOT NULL,
                                   `pregunta_id` bigint(20) NOT NULL,
                                   `etiqueta` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `opcion_pregunta`
--

INSERT INTO `opcion_pregunta` (`orden`, `valor_dicotomizado`, `id_opcion`, `pregunta_id`, `etiqueta`) VALUES
                                                                                                          (0, NULL, 1, 5, 'Mujer'),
                                                                                                          (1, NULL, 2, 5, 'Hombre'),
                                                                                                          (0, NULL, 3, 10, 'Urbana'),
                                                                                                          (1, NULL, 4, 10, 'Rural'),
                                                                                                          (0, NULL, 5, 11, 'No'),
                                                                                                          (1, NULL, 6, 11, 'Sí'),
                                                                                                          (0, NULL, 7, 12, 'Básico'),
                                                                                                          (1, NULL, 8, 12, 'Medio'),
                                                                                                          (2, NULL, 9, 12, 'Superior'),
                                                                                                          (0, NULL, 10, 14, 'Fonasa'),
                                                                                                          (1, NULL, 11, 14, 'Sin previsión'),
                                                                                                          (2, NULL, 12, 14, 'Isapre'),
                                                                                                          (3, NULL, 13, 14, 'Capredena / Dipreca'),
                                                                                                          (4, NULL, 14, 14, 'Otra'),
                                                                                                          (0, NULL, 15, 15, 'No'),
                                                                                                          (1, NULL, 16, 15, 'Sí'),
                                                                                                          (0, NULL, 17, 17, 'No'),
                                                                                                          (1, NULL, 18, 17, 'Sí'),
                                                                                                          (0, NULL, 19, 18, 'No'),
                                                                                                          (1, NULL, 20, 18, 'Sí'),
                                                                                                          (0, NULL, 21, 20, 'No'),
                                                                                                          (1, NULL, 22, 20, 'Sí'),
                                                                                                          (0, NULL, 23, 22, 'No'),
                                                                                                          (1, NULL, 24, 22, 'Sí'),
                                                                                                          (0, NULL, 25, 24, 'No'),
                                                                                                          (1, NULL, 26, 24, 'Sí'),
                                                                                                          (0, NULL, 27, 28, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                                          (1, NULL, 28, 28, 'Exfumador'),
                                                                                                          (2, NULL, 29, 28, 'Fumador actual'),
                                                                                                          (0, NULL, 30, 29, '1–9 cigarrillos/día (poco)'),
                                                                                                          (1, NULL, 31, 29, '10–19 cigarrillos/día (moderado)'),
                                                                                                          (2, NULL, 32, 29, '≥20 cigarrillos/día (mucho)'),
                                                                                                          (0, NULL, 33, 30, '<10 años'),
                                                                                                          (1, NULL, 34, 30, '10–20 años'),
                                                                                                          (2, NULL, 35, 30, '>20 años'),
                                                                                                          (0, NULL, 36, 31, '<5 años'),
                                                                                                          (1, NULL, 37, 31, '5–10 años'),
                                                                                                          (2, NULL, 38, 31, '>10 años'),
                                                                                                          (0, NULL, 39, 32, 'Nunca'),
                                                                                                          (1, NULL, 40, 32, 'Exconsumidor'),
                                                                                                          (2, NULL, 41, 32, 'Consumidor actual'),
                                                                                                          (0, NULL, 42, 33, 'Ocasional (menos de 1 vez/semana)'),
                                                                                                          (1, NULL, 43, 33, 'Regular (1–3 veces/semana)'),
                                                                                                          (2, NULL, 44, 33, 'Frecuente (≥4 veces/semana)'),
                                                                                                          (0, NULL, 45, 34, '1–2 tragos (poco)'),
                                                                                                          (1, NULL, 46, 34, '3–4 tragos (moderado)'),
                                                                                                          (2, NULL, 47, 34, '≥5 tragos (mucho)'),
                                                                                                          (0, NULL, 48, 35, '<10 años'),
                                                                                                          (1, NULL, 49, 35, '10–20 años'),
                                                                                                          (2, NULL, 50, 35, '>20 años'),
                                                                                                          (0, NULL, 51, 36, '<5 años'),
                                                                                                          (1, NULL, 52, 36, '5–10 años'),
                                                                                                          (2, NULL, 53, 36, '>10 años'),
                                                                                                          (0, NULL, 54, 37, '≤1/sem'),
                                                                                                          (1, NULL, 55, 37, '2/sem'),
                                                                                                          (2, NULL, 56, 37, '≥3/sem'),
                                                                                                          (0, NULL, 57, 38, 'Sí'),
                                                                                                          (1, NULL, 58, 38, 'No'),
                                                                                                          (0, NULL, 59, 39, '≥5 porciones/día'),
                                                                                                          (1, NULL, 60, 39, '3–4 porciones/día'),
                                                                                                          (2, NULL, 61, 39, '≤2 porciones/día'),
                                                                                                          (0, NULL, 62, 40, 'Sí'),
                                                                                                          (1, NULL, 63, 40, 'No'),
                                                                                                          (0, NULL, 64, 41, 'Casi nunca / Rara vez'),
                                                                                                          (1, NULL, 65, 41, '1 a 2 veces por semana'),
                                                                                                          (2, NULL, 66, 41, '3 o más veces por semana'),
                                                                                                          (0, NULL, 67, 42, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 68, 42, '1–2/sem'),
                                                                                                          (2, NULL, 69, 42, '≥3/sem'),
                                                                                                          (0, NULL, 70, 43, 'Sí'),
                                                                                                          (1, NULL, 71, 43, 'No'),
                                                                                                          (0, NULL, 72, 44, 'Sí'),
                                                                                                          (1, NULL, 73, 44, 'No'),
                                                                                                          (0, NULL, 74, 46, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 75, 46, 'Estacional'),
                                                                                                          (2, NULL, 76, 46, 'Diario'),
                                                                                                          (0, NULL, 77, 47, 'Red pública'),
                                                                                                          (1, NULL, 78, 47, 'Pozo'),
                                                                                                          (2, NULL, 79, 47, 'Camión aljibe'),
                                                                                                          (3, NULL, 80, 47, 'Otra'),
                                                                                                          (0, NULL, 81, 48, 'Ninguno'),
                                                                                                          (1, NULL, 82, 48, 'Hervir'),
                                                                                                          (2, NULL, 83, 48, 'Filtro'),
                                                                                                          (3, NULL, 84, 48, 'Cloro'),
                                                                                                          (0, NULL, 85, 49, 'Positivo'),
                                                                                                          (1, NULL, 86, 49, 'Negativo'),
                                                                                                          (2, NULL, 87, 49, 'Desconocido'),
                                                                                                          (0, NULL, 88, 50, 'Sí'),
                                                                                                          (1, NULL, 89, 50, 'No'),
                                                                                                          (2, NULL, 90, 50, 'No recuerda'),
                                                                                                          (0, NULL, 91, 52, 'Sí'),
                                                                                                          (1, NULL, 92, 52, 'No'),
                                                                                                          (2, NULL, 93, 52, 'No recuerda'),
                                                                                                          (0, NULL, 94, 54, 'Test de aliento (urea-C13/C14)'),
                                                                                                          (1, NULL, 95, 54, 'Antígeno en deposiciones'),
                                                                                                          (2, NULL, 96, 54, 'Serología (IgG)'),
                                                                                                          (3, NULL, 97, 54, 'Test rápido de ureasa'),
                                                                                                          (4, NULL, 98, 54, 'Histología / Biopsia'),
                                                                                                          (5, NULL, 99, 54, 'Otro'),
                                                                                                          (0, NULL, 100, 55, '<1 año'),
                                                                                                          (1, NULL, 101, 55, '1–5 años'),
                                                                                                          (2, NULL, 102, 55, '>5 años'),
                                                                                                          (0, NULL, 103, 56, 'Sí'),
                                                                                                          (1, NULL, 104, 56, 'No'),
                                                                                                          (2, NULL, 105, 56, 'No recuerda'),
                                                                                                          (0, NULL, 106, 57, 'Sí'),
                                                                                                          (1, NULL, 107, 57, 'No'),
                                                                                                          (0, NULL, 108, 58, 'Intestinal'),
                                                                                                          (1, NULL, 109, 58, 'Difuso'),
                                                                                                          (2, NULL, 110, 58, 'Mixto'),
                                                                                                          (3, NULL, 111, 58, 'Otro'),
                                                                                                          (0, NULL, 112, 60, 'Cardias'),
                                                                                                          (1, NULL, 113, 60, 'Cuerpo'),
                                                                                                          (2, NULL, 114, 60, 'Antro'),
                                                                                                          (3, NULL, 115, 60, 'Difuso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
                            `activo` bit(1) NOT NULL,
                            `es_caso` bit(1) NOT NULL,
                            `fecha_incl` date NOT NULL,
                            `participante_id` bigint(20) NOT NULL,
                            `reclutador_id` bigint(20) NOT NULL,
                            `participante_cod` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`activo`, `es_caso`, `fecha_incl`, `participante_id`, `reclutador_id`, `participante_cod`) VALUES
                                                                                                                       (b'1', b'1', '2025-12-04', 1, 2, 'CAS_001'),
                                                                                                                       (b'1', b'1', '2025-12-04', 2, 2, 'CAS_002'),
                                                                                                                       (b'1', b'1', '2025-12-04', 3, 2, 'CAS_003'),
                                                                                                                       (b'1', b'1', '2025-12-04', 4, 2, 'CAS_004'),
                                                                                                                       (b'1', b'1', '2025-12-04', 5, 2, 'CAS_005'),
                                                                                                                       (b'1', b'0', '2025-12-04', 6, 1, 'CONT_001'),
                                                                                                                       (b'1', b'0', '2025-12-04', 7, 1, 'CONT_002'),
                                                                                                                       (b'1', b'0', '2025-12-04', 8, 1, 'CONT_003'),
                                                                                                                       (b'1', b'0', '2025-12-04', 9, 1, 'CONT_004'),
                                                                                                                       (b'1', b'0', '2025-12-04', 10, 1, 'CONT_005');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
                           `id_perm` bigint(20) NOT NULL,
                           `descripcion` varchar(255) NOT NULL,
                           `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`id_perm`, `descripcion`, `nombre`) VALUES
                                                               (1, 'Permite ingresar pacientes Caso', 'CREAR_CASO'),
                                                               (2, 'Permite ingresar pacientes Control', 'CREAR_CONTROL'),
                                                               (3, 'Permite editar respuestas de Casos', 'EDITAR_CASO'),
                                                               (4, 'Permite editar respuestas de Controles', 'EDITAR_CONTROL'),
                                                               (5, 'Permite ver ficha individual', 'VER_PACIENTE'),
                                                               (6, 'Permite ver tabla resumen y exportar', 'VER_LISTADO_PACIENTES'),
                                                               (7, 'Permite archivar/eliminar', 'ELIMINAR_PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas`
--

CREATE TABLE `preguntas` (
                             `activo` bit(1) NOT NULL,
                             `dato_sensible` bit(1) NOT NULL,
                             `exportable` bit(1) NOT NULL,
                             `generar_estadistica` bit(1) NOT NULL,
                             `orden` int(11) NOT NULL,
                             `id_cat` bigint(20) DEFAULT NULL,
                             `pregunta_id` bigint(20) NOT NULL,
                             `codigo_stata` varchar(255) DEFAULT NULL,
                             `descripcion` varchar(255) DEFAULT NULL,
                             `etiqueta` varchar(255) DEFAULT NULL,
                             `tipo_corte` enum('MEDIA','MEDIANA','NINGUNO','VALOR_FIJO') DEFAULT NULL,
                             `tipo_dato` enum('CELULAR','EMAIL','ENUM','NUMERO','RUT','TEXTO') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `preguntas`
--

INSERT INTO `preguntas` (`activo`, `dato_sensible`, `exportable`, `generar_estadistica`, `orden`, `id_cat`, `pregunta_id`, `codigo_stata`, `descripcion`, `etiqueta`, `tipo_corte`, `tipo_dato`) VALUES
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 1, 1, 1, 'Nombre', 'Nombre completo', 'Nombre completo', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 2, 1, 2, 'Telefono', 'Teléfono', 'Teléfono', 'NINGUNO', 'CELULAR'),
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 3, 1, 3, 'Email', 'Correo electrónico', 'Correo electrónico', 'NINGUNO', 'EMAIL'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 2, 4, 'Edad', 'Edad', 'Edad', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 2, 5, 'Sexo', 'Sexo', 'Sexo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 2, 6, 'Nacionalidad', 'Nacionalidad', 'Nacionalidad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 4, 2, 7, 'Direccion', 'Dirección', 'Dirección', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 2, 8, 'Comuna', 'Comuna', 'Comuna', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 6, 2, 9, 'Ciudad', 'Ciudad', 'Ciudad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 2, 10, 'Zona', 'Zona', 'Zona', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 2, 11, 'Residencia_Urbana5', '¿Vive usted en esta zona desde hace más de 5 años?', '¿Vive usted en esta zona desde hace más de 5 años?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 2, 12, 'NivelEduc', 'Nivel educacional', 'Nivel educacional', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 10, 2, 13, 'Ocupacion', 'Ocupación actual', 'Ocupación actual', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 2, 14, 'Prevision_FonasaVsOtros', 'Previsión de salud actual', 'Previsión de salud actual', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 1, 3, 15, 'Diag_Adenocarcinoma', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 3, 16, 'Fecha_Diag', 'Fecha de diagnóstico (solo casos)', 'Fecha de diagnóstico (solo casos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 3, 17, 'CA_FamiliaGastrico', 'Antecedentes familiares de cáncer gástrico', 'Antecedentes familiares de cáncer gástrico', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 3, 18, 'CA_FamiliaOtros', 'Antecedentes familiares de otros tipos de cáncer', 'Antecedentes familiares de otros tipos de cáncer', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 3, 19, 'CA_FamiliaOtros_Detalle', '¿Cuál(es)? (Otros cánceres)', '¿Cuál(es)? (Otros cánceres)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 3, 20, 'EnfermedadesRelevantes', 'Otras enfermedades relevantes', 'Otras enfermedades relevantes', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 7, 3, 21, 'EnfermedadesRelevantes_Detalle', 'Detalle enfermedades relevantes', 'Detalle enfermedades relevantes', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 3, 22, 'UsoCronico_Medicamentos', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 9, 3, 23, 'UsoCronico_Detalle', 'Especificar cuál (Medicamentos)', 'Especificar cuál (Medicamentos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 10, 3, 24, 'CirugiaGastricaPrevia', 'Cirugía gástrica previa', 'Cirugía gástrica previa', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 4, 25, 'Peso', 'Peso (kg)', 'Peso (kg)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 4, 26, 'IMC', 'IMC', 'IMC', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 4, 27, 'Estatura', 'Estatura (m)', 'Estatura (m)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 5, 28, 'tabaco_estado', 'Estado de tabaquismo', 'Estado de tabaquismo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 5, 29, 'tabaco_cantidad', 'Cantidad promedio fumada', 'Cantidad promedio fumada', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 5, 30, 'tabaco_tiempo_total', 'Tiempo total fumando', 'Tiempo total fumando', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 5, 31, 'tabaco_exfumador_tiempo', 'Si exfumador: tiempo desde que dejó de fumar', 'Si exfumador: tiempo desde que dejó de fumar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 6, 32, 'alcohol_estado', 'Estado de consumo', 'Estado de consumo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 6, 33, 'alcohol_frecuencia', 'Frecuencia', 'Frecuencia', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 6, 34, 'alcohol_cantidad', 'Cantidad típica por ocasión', 'Cantidad típica por ocasión', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 6, 35, 'alcohol_tiempo_total', 'Años de consumo habitual', 'Años de consumo habitual', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 6, 36, 'alcohol_exconsumidor_tiempo', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 7, 37, 'diet_carnes', 'Consumo de carnes procesadas/cecinas', 'Consumo de carnes procesadas/cecinas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 7, 38, 'diet_sal', 'Consumo de alimentos muy salados (agrega sal a la comida sin probar)', 'Consumo de alimentos muy salados (agrega sal a la comida sin probar)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 7, 39, 'diet_frutas_verduras', 'Consumo de porciones de frutas y verduras frescas', 'Consumo de porciones de frutas y verduras frescas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 7, 40, 'diet_frituras', 'Consumo frecuente de frituras (≥3 veces por semana)', 'Consumo frecuente de frituras (≥3 veces por semana)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 7, 41, 'diet_condimentos', 'Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)', 'Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 7, 42, 'diet_bebidas_calientes', 'Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)', 'Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 7, 43, 'amb_pesticidas', 'Exposición ocupacional a pesticidas', 'Exposición ocupacional a pesticidas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 7, 44, 'amb_quimicos', 'Exposición a otros compuestos químicos', 'Exposición a otros compuestos químicos', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 9, 7, 45, 'amb_quimicos_detalle', '¿Cuál(es)? (Químicos)', '¿Cuál(es)? (Químicos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 10, 7, 46, 'amb_lena', 'Humo de leña en el hogar (cocina/calefacción)', 'Humo de leña en el hogar (cocina/calefacción)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 7, 47, 'amb_agua_fuente', 'Fuente principal de agua en el hogar', 'Fuente principal de agua en el hogar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 12, 7, 48, 'amb_agua_tratamiento', 'Tratamiento del agua en casa', 'Tratamiento del agua en casa', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 8, 49, 'hp_resultado', 'Resultado del examen para Helicobacter pylori', 'Resultado del examen para Helicobacter pylori', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 8, 50, 'hp_pasado_positivo', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 8, 51, 'hp_pasado_detalle', 'Si responde “Sí”, indicar año aproximado y tipo de examen', 'Si responde “Sí”, indicar año aproximado y tipo de examen', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 8, 52, 'hp_tratamiento', '¿Recibió tratamiento para erradicación de H. pylori?', '¿Recibió tratamiento para erradicación de H. pylori?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 8, 53, 'hp_tratamiento_detalle', 'Si “Sí”, anotar año y esquema, si se conoce', 'Si “Sí”, anotar año y esquema, si se conoce', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 8, 54, 'hp_tipo_examen', 'Tipo de examen realizado', 'Tipo de examen realizado', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 8, 55, 'hp_tiempo_test', '¿Hace cuánto tiempo se realizó el test?', '¿Hace cuánto tiempo se realizó el test?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 8, 56, 'hp_uso_ibp', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 8, 57, 'hp_repetido', '¿Ha repetido el examen posteriormente?', '¿Ha repetido el examen posteriormente?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 9, 58, 'Histologia_Tipo', 'Tipo Histológico', 'Tipo Histológico', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 9, 59, 'histo_tipo_otro', 'Tipo histológico (especificar)', 'Tipo histológico (especificar)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 9, 60, 'Histologia_Localizacion', 'Localización Tumoral', 'Localización Tumoral', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 9, 61, 'histo_tnm', 'Estadio clínico (TNM)', 'Estadio clínico (TNM)', 'NINGUNO', 'TEXTO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro`
--

CREATE TABLE `registro` (
                            `registro_fecha` datetime(6) NOT NULL,
                            `registro_id` bigint(20) NOT NULL,
                            `respuesta_id` bigint(20) DEFAULT NULL,
                            `usuario_id` bigint(20) NOT NULL,
                            `detalles` varchar(1024) NOT NULL,
                            `accion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro`
--

INSERT INTO `registro` (`registro_fecha`, `registro_id`, `respuesta_id`, `usuario_id`, `detalles`, `accion`) VALUES
                                                                                                                 ('2025-12-04 18:04:52.000000', 1, 1, 1, 'Valor: \'Paciente Caso 1\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 2, 2, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 3, 3, 1, 'Valor: \'caso1@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 4, 4, 1, 'Valor: \'56\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 5, 5, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 6, 6, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 7, 7, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 8, 8, 1, 'Valor: \'San Carlos\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 9, 9, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 10, 10, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 11, 11, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 12, 12, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 13, 13, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 14, 14, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 15, 15, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 16, 16, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 17, 17, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 18, 18, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 19, 19, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 20, 20, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 21, 21, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 22, 22, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 23, 23, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 24, 24, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 25, 25, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 26, 26, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 27, 27, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 28, 28, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 29, 29, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 30, 30, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 31, 31, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 32, 32, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 33, 33, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 34, 34, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 35, 35, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 36, 36, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 37, 37, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 38, 38, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 39, 39, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 40, 40, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 41, 41, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 42, 42, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 43, 43, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 44, 44, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 45, 45, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 46, 46, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 47, 47, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 48, 48, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 49, 49, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 50, 50, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 51, 51, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 52, 52, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 53, 53, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 54, 54, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 55, 55, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 56, 56, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 57, NULL, 1, 'Paciente creado con codigo: CAS_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 58, 57, 1, 'Valor: \'Paciente Caso 2\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 59, 58, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 60, 59, 1, 'Valor: \'caso2@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 61, 60, 1, 'Valor: \'57\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 62, 61, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 63, 62, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 64, 63, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 65, 64, 1, 'Valor: \'Coihueco\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 66, 65, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 67, 66, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 68, 67, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 69, 68, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 70, 69, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 71, 70, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 72, 71, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 73, 72, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 74, 73, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 75, 74, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 76, 75, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 77, 76, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 78, 77, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 79, 78, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 80, 79, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 81, 80, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 82, 81, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 83, 82, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 84, 83, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 85, 84, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 86, 85, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 87, 86, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 88, 87, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 89, 88, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 90, 89, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 91, 90, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 92, 91, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 93, 92, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 94, 93, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 95, 94, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 96, 95, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 97, 96, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 98, 97, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 99, 98, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 100, 99, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 101, 100, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 102, 101, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 103, 102, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 104, 103, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 105, 104, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 106, 105, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 107, 106, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 108, 107, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 109, 108, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 110, 109, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 111, 110, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 112, 111, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 113, 112, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 114, NULL, 1, 'Paciente creado con codigo: CAS_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 115, 113, 1, 'Valor: \'Paciente Caso 3\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 116, 114, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 117, 115, 1, 'Valor: \'caso3@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 118, 116, 1, 'Valor: \'58\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 119, 117, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 120, 118, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 121, 119, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 122, 120, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 123, 121, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 124, 122, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 125, 123, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 126, 124, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 127, 125, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 128, 126, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 129, 127, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 130, 128, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 131, 129, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 132, 130, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 133, 131, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 134, 132, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 135, 133, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 136, 134, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 137, 135, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 138, 136, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 139, 137, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 140, 138, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 141, 139, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 142, 140, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 143, 141, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 144, 142, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 145, 143, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 146, 144, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 147, 145, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 148, 146, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 149, 147, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 150, 148, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 151, 149, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 152, 150, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 153, 151, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 154, 152, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 155, 153, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 156, 154, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 157, 155, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 158, 156, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 159, 157, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 160, 158, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 161, 159, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 162, 160, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 163, 161, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 164, 162, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 165, 163, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 166, 164, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 167, 165, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 168, 166, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 169, 167, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 170, 168, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 171, NULL, 1, 'Paciente creado con codigo: CAS_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 172, 169, 1, 'Valor: \'Paciente Caso 4\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 173, 170, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 174, 171, 1, 'Valor: \'caso4@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 175, 172, 1, 'Valor: \'59\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 176, 173, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 177, 174, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 178, 175, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 179, 176, 1, 'Valor: \'San Carlos\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 180, 177, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 181, 178, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 182, 179, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 183, 180, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 184, 181, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 185, 182, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 186, 183, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 187, 184, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 188, 185, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 189, 186, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 190, 187, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 191, 188, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 192, 189, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 193, 190, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 194, 191, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 195, 192, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 196, 193, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 197, 194, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 198, 195, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 199, 196, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 200, 197, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 201, 198, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 202, 199, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 203, 200, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 204, 201, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 205, 202, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 206, 203, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 207, 204, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 208, 205, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 209, 206, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 210, 207, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 211, 208, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 212, 209, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 213, 210, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 214, 211, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 215, 212, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 216, 213, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 217, 214, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 218, 215, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 219, 216, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 220, 217, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 221, 218, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 222, 219, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 223, 220, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 224, 221, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 225, 222, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 226, 223, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 227, 224, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 228, NULL, 1, 'Paciente creado con codigo: CAS_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 229, 225, 1, 'Valor: \'Paciente Caso 5\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 230, 226, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 231, 227, 1, 'Valor: \'caso5@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 232, 228, 1, 'Valor: \'60\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 233, 229, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 234, 230, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 235, 231, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 236, 232, 1, 'Valor: \'Coihueco\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 237, 233, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 238, 234, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 239, 235, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 240, 236, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 241, 237, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 242, 238, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 243, 239, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 244, 240, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 245, 241, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 246, 242, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 247, 243, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 248, 244, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 249, 245, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 250, 246, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 251, 247, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 252, 248, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 253, 249, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 254, 250, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 255, 251, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 256, 252, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 257, 253, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 258, 254, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 259, 255, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 260, 256, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 261, 257, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 262, 258, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 263, 259, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 264, 260, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 265, 261, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 266, 262, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 267, 263, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 268, 264, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 269, 265, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 270, 266, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 271, 267, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 272, 268, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 273, 269, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 274, 270, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 275, 271, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 276, 272, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 277, 273, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 278, 274, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 279, 275, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 280, 276, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 281, 277, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 282, 278, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 283, 279, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 284, 280, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 285, NULL, 1, 'Paciente creado con codigo: CAS_005', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 286, 281, 1, 'Valor: \'Paciente Control 1\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 287, 282, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 288, 283, 1, 'Valor: \'control1@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 289, 284, 1, 'Valor: \'46\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 290, 285, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 291, 286, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 292, 287, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 293, 288, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 294, 289, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 295, 290, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 296, 291, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 297, 292, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 298, 293, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 299, 294, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 300, 295, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 301, 296, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 302, 297, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 303, 298, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 304, 299, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 305, 300, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 306, 301, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 307, 302, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 308, 303, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 309, 304, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 310, 305, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 311, 306, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 312, 307, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 313, 308, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 314, 309, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 315, 310, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 316, 311, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 317, 312, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 318, 313, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 319, 314, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 320, 315, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 321, 316, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 322, 317, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 323, 318, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 324, 319, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 325, 320, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 326, 321, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 327, 322, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 328, 323, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 329, 324, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 330, 325, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 331, NULL, 1, 'Paciente creado con codigo: CONT_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 332, 326, 1, 'Valor: \'Paciente Control 2\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 333, 327, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 334, 328, 1, 'Valor: \'control2@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 335, 329, 1, 'Valor: \'47\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 336, 330, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 337, 331, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 338, 332, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 339, 333, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 340, 334, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 341, 335, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 342, 336, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 343, 337, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 344, 338, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 345, 339, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 346, 340, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 347, 341, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 348, 342, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 349, 343, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 350, 344, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 351, 345, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 352, 346, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 353, 347, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 354, 348, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 355, 349, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 356, 350, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 357, 351, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 358, 352, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 359, 353, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 360, 354, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 361, 355, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 362, 356, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 363, 357, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 364, 358, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 365, 359, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 366, 360, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 367, 361, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 368, 362, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 369, 363, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 370, 364, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 371, 365, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 372, 366, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 373, 367, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 374, 368, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 375, 369, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 376, 370, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 377, NULL, 1, 'Paciente creado con codigo: CONT_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 378, 371, 1, 'Valor: \'Paciente Control 3\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 379, 372, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 380, 373, 1, 'Valor: \'control3@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 381, 374, 1, 'Valor: \'48\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 382, 375, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 383, 376, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 384, 377, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 385, 378, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 386, 379, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 387, 380, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 388, 381, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 389, 382, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 390, 383, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 391, 384, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 392, 385, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 393, 386, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 394, 387, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 395, 388, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 396, 389, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 397, 390, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 398, 391, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 399, 392, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 400, 393, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 401, 394, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 402, 395, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 403, 396, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 404, 397, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 405, 398, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 406, 399, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 407, 400, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 408, 401, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 409, 402, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 410, 403, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 411, 404, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 412, 405, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 413, 406, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 414, 407, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 415, 408, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 416, 409, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 417, 410, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 418, 411, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 419, 412, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 420, 413, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 421, 414, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 422, 415, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 423, NULL, 1, 'Paciente creado con codigo: CONT_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 424, 416, 1, 'Valor: \'Paciente Control 4\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 425, 417, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 426, 418, 1, 'Valor: \'control4@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 427, 419, 1, 'Valor: \'49\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 428, 420, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 429, 421, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 430, 422, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 431, 423, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 432, 424, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 433, 425, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 434, 426, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 435, 427, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 436, 428, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 437, 429, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 438, 430, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 439, 431, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 440, 432, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 441, 433, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 442, 434, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 443, 435, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 444, 436, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 445, 437, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 446, 438, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 447, 439, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 448, 440, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 449, 441, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 450, 442, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 451, 443, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 452, 444, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 453, 445, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 454, 446, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 455, 447, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 456, 448, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 457, 449, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 458, 450, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 459, 451, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 460, 452, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 461, 453, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 462, 454, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 463, 455, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 464, 456, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 465, 457, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 466, 458, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 467, 459, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 468, 460, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 469, NULL, 1, 'Paciente creado con codigo: CONT_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 470, 461, 1, 'Valor: \'Paciente Control 5\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 471, 462, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 472, 463, 1, 'Valor: \'control5@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 473, 464, 1, 'Valor: \'50\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 474, 465, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 475, 466, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 476, 467, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 477, 468, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 478, 469, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 479, 470, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 480, 471, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 481, 472, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 482, 473, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 483, 474, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 484, 475, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 485, 476, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 486, 477, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 487, 478, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 488, 479, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 489, 480, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 490, 481, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 491, 482, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 492, 483, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 493, 484, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 494, 485, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 495, 486, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 496, 487, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 497, 488, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 498, 489, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 499, 490, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 500, 491, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 501, 492, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 502, 493, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 503, 494, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 504, 495, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 505, 496, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 506, 497, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 507, 498, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 508, 499, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 509, 500, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 510, 501, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 511, 502, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 512, 503, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 513, 504, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 514, 505, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 515, NULL, 1, 'Paciente creado con codigo: CONT_005', 'CREAR_PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta`
--

CREATE TABLE `respuesta` (
                             `paciente_id` bigint(20) NOT NULL,
                             `pregunta_id` bigint(20) NOT NULL,
                             `respuesta_id` bigint(20) NOT NULL,
                             `valor` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `respuesta`
--

INSERT INTO `respuesta` (`paciente_id`, `pregunta_id`, `respuesta_id`, `valor`) VALUES
                                                                                    (1, 1, 1, 'Paciente Caso 1'),
                                                                                    (1, 2, 2, '912345678'),
                                                                                    (1, 3, 3, 'caso1@email.com'),
                                                                                    (1, 4, 4, '56'),
                                                                                    (1, 5, 5, 'Hombre'),
                                                                                    (1, 6, 6, 'Chilena'),
                                                                                    (1, 7, 7, 'Calle Rural 123'),
                                                                                    (1, 8, 8, 'San Carlos'),
                                                                                    (1, 9, 9, 'Chillán'),
                                                                                    (1, 10, 10, 'Rural'),
                                                                                    (1, 11, 11, 'Sí'),
                                                                                    (1, 12, 12, 'Básico'),
                                                                                    (1, 13, 13, 'Agricultor'),
                                                                                    (1, 14, 14, 'Fonasa'),
                                                                                    (1, 15, 15, 'Sí'),
                                                                                    (1, 16, 16, '01/03/2024'),
                                                                                    (1, 17, 17, 'Sí'),
                                                                                    (1, 18, 18, 'No'),
                                                                                    (1, 20, 19, 'Sí'),
                                                                                    (1, 21, 20, 'Gastritis crónica atrófica'),
                                                                                    (1, 22, 21, 'Sí'),
                                                                                    (1, 23, 22, 'Omeprazol'),
                                                                                    (1, 24, 23, 'No'),
                                                                                    (1, 25, 24, '62'),
                                                                                    (1, 27, 25, '1.65'),
                                                                                    (1, 26, 26, '22.8'),
                                                                                    (1, 28, 27, 'Fumador actual'),
                                                                                    (1, 29, 28, '≥20 cigarrillos/día (mucho)'),
                                                                                    (1, 30, 29, '>20 años'),
                                                                                    (1, 32, 30, 'Consumidor actual'),
                                                                                    (1, 33, 31, 'Frecuente (≥4 veces/semana)'),
                                                                                    (1, 34, 32, '≥5 tragos (mucho)'),
                                                                                    (1, 35, 33, '>20 años'),
                                                                                    (1, 37, 34, '≥3/sem'),
                                                                                    (1, 38, 35, 'Sí'),
                                                                                    (1, 39, 36, '≤2 porciones/día'),
                                                                                    (1, 40, 37, 'Sí'),
                                                                                    (1, 41, 38, '3 o más veces por semana'),
                                                                                    (1, 42, 39, '≥3/sem'),
                                                                                    (1, 43, 40, 'Sí'),
                                                                                    (1, 44, 41, 'No'),
                                                                                    (1, 46, 42, 'Diario'),
                                                                                    (1, 47, 43, 'Pozo'),
                                                                                    (1, 48, 44, 'Ninguno'),
                                                                                    (1, 49, 45, 'Positivo'),
                                                                                    (1, 50, 46, 'Sí'),
                                                                                    (1, 51, 47, '2015, Test de Aliento'),
                                                                                    (1, 52, 48, 'Sí'),
                                                                                    (1, 53, 49, '2015, Claritromicina + Amoxicilina'),
                                                                                    (1, 54, 50, 'Histología / Biopsia'),
                                                                                    (1, 55, 51, '<1 año'),
                                                                                    (1, 56, 52, 'No'),
                                                                                    (1, 57, 53, 'No'),
                                                                                    (1, 58, 54, 'Difuso'),
                                                                                    (1, 60, 55, 'Cuerpo'),
                                                                                    (1, 61, 56, 'T3N1M0'),
                                                                                    (2, 1, 57, 'Paciente Caso 2'),
                                                                                    (2, 2, 58, '912345678'),
                                                                                    (2, 3, 59, 'caso2@email.com'),
                                                                                    (2, 4, 60, '57'),
                                                                                    (2, 5, 61, 'Hombre'),
                                                                                    (2, 6, 62, 'Chilena'),
                                                                                    (2, 7, 63, 'Calle Rural 123'),
                                                                                    (2, 8, 64, 'Coihueco'),
                                                                                    (2, 9, 65, 'Chillán'),
                                                                                    (2, 10, 66, 'Rural'),
                                                                                    (2, 11, 67, 'Sí'),
                                                                                    (2, 12, 68, 'Básico'),
                                                                                    (2, 13, 69, 'Agricultor'),
                                                                                    (2, 14, 70, 'Fonasa'),
                                                                                    (2, 15, 71, 'Sí'),
                                                                                    (2, 16, 72, '01/03/2024'),
                                                                                    (2, 17, 73, 'Sí'),
                                                                                    (2, 18, 74, 'No'),
                                                                                    (2, 20, 75, 'Sí'),
                                                                                    (2, 21, 76, 'Gastritis crónica atrófica'),
                                                                                    (2, 22, 77, 'Sí'),
                                                                                    (2, 23, 78, 'Omeprazol'),
                                                                                    (2, 24, 79, 'No'),
                                                                                    (2, 25, 80, '62'),
                                                                                    (2, 27, 81, '1.65'),
                                                                                    (2, 26, 82, '22.8'),
                                                                                    (2, 28, 83, 'Fumador actual'),
                                                                                    (2, 29, 84, '≥20 cigarrillos/día (mucho)'),
                                                                                    (2, 30, 85, '>20 años'),
                                                                                    (2, 32, 86, 'Consumidor actual'),
                                                                                    (2, 33, 87, 'Frecuente (≥4 veces/semana)'),
                                                                                    (2, 34, 88, '≥5 tragos (mucho)'),
                                                                                    (2, 35, 89, '>20 años'),
                                                                                    (2, 37, 90, '≥3/sem'),
                                                                                    (2, 38, 91, 'Sí'),
                                                                                    (2, 39, 92, '≤2 porciones/día'),
                                                                                    (2, 40, 93, 'Sí'),
                                                                                    (2, 41, 94, '3 o más veces por semana'),
                                                                                    (2, 42, 95, '≥3/sem'),
                                                                                    (2, 43, 96, 'Sí'),
                                                                                    (2, 44, 97, 'No'),
                                                                                    (2, 46, 98, 'Diario'),
                                                                                    (2, 47, 99, 'Pozo'),
                                                                                    (2, 48, 100, 'Ninguno'),
                                                                                    (2, 49, 101, 'Positivo'),
                                                                                    (2, 50, 102, 'Sí'),
                                                                                    (2, 51, 103, '2015, Test de Aliento'),
                                                                                    (2, 52, 104, 'Sí'),
                                                                                    (2, 53, 105, '2015, Claritromicina + Amoxicilina'),
                                                                                    (2, 54, 106, 'Histología / Biopsia'),
                                                                                    (2, 55, 107, '<1 año'),
                                                                                    (2, 56, 108, 'No'),
                                                                                    (2, 57, 109, 'No'),
                                                                                    (2, 58, 110, 'Difuso'),
                                                                                    (2, 60, 111, 'Cuerpo'),
                                                                                    (2, 61, 112, 'T3N1M0'),
                                                                                    (3, 1, 113, 'Paciente Caso 3'),
                                                                                    (3, 2, 114, '912345678'),
                                                                                    (3, 3, 115, 'caso3@email.com'),
                                                                                    (3, 4, 116, '58'),
                                                                                    (3, 5, 117, 'Hombre'),
                                                                                    (3, 6, 118, 'Chilena'),
                                                                                    (3, 7, 119, 'Calle Rural 123'),
                                                                                    (3, 8, 120, 'Chillán'),
                                                                                    (3, 9, 121, 'Chillán'),
                                                                                    (3, 10, 122, 'Rural'),
                                                                                    (3, 11, 123, 'Sí'),
                                                                                    (3, 12, 124, 'Básico'),
                                                                                    (3, 13, 125, 'Agricultor'),
                                                                                    (3, 14, 126, 'Fonasa'),
                                                                                    (3, 15, 127, 'Sí'),
                                                                                    (3, 16, 128, '01/03/2024'),
                                                                                    (3, 17, 129, 'Sí'),
                                                                                    (3, 18, 130, 'No'),
                                                                                    (3, 20, 131, 'Sí'),
                                                                                    (3, 21, 132, 'Gastritis crónica atrófica'),
                                                                                    (3, 22, 133, 'Sí'),
                                                                                    (3, 23, 134, 'Omeprazol'),
                                                                                    (3, 24, 135, 'No'),
                                                                                    (3, 25, 136, '62'),
                                                                                    (3, 27, 137, '1.65'),
                                                                                    (3, 26, 138, '22.8'),
                                                                                    (3, 28, 139, 'Fumador actual'),
                                                                                    (3, 29, 140, '≥20 cigarrillos/día (mucho)'),
                                                                                    (3, 30, 141, '>20 años'),
                                                                                    (3, 32, 142, 'Consumidor actual'),
                                                                                    (3, 33, 143, 'Frecuente (≥4 veces/semana)'),
                                                                                    (3, 34, 144, '≥5 tragos (mucho)'),
                                                                                    (3, 35, 145, '>20 años'),
                                                                                    (3, 37, 146, '≥3/sem'),
                                                                                    (3, 38, 147, 'Sí'),
                                                                                    (3, 39, 148, '≤2 porciones/día'),
                                                                                    (3, 40, 149, 'Sí'),
                                                                                    (3, 41, 150, '3 o más veces por semana'),
                                                                                    (3, 42, 151, '≥3/sem'),
                                                                                    (3, 43, 152, 'Sí'),
                                                                                    (3, 44, 153, 'No'),
                                                                                    (3, 46, 154, 'Diario'),
                                                                                    (3, 47, 155, 'Pozo'),
                                                                                    (3, 48, 156, 'Ninguno'),
                                                                                    (3, 49, 157, 'Positivo'),
                                                                                    (3, 50, 158, 'Sí'),
                                                                                    (3, 51, 159, '2015, Test de Aliento'),
                                                                                    (3, 52, 160, 'Sí'),
                                                                                    (3, 53, 161, '2015, Claritromicina + Amoxicilina'),
                                                                                    (3, 54, 162, 'Histología / Biopsia'),
                                                                                    (3, 55, 163, '<1 año'),
                                                                                    (3, 56, 164, 'No'),
                                                                                    (3, 57, 165, 'No'),
                                                                                    (3, 58, 166, 'Difuso'),
                                                                                    (3, 60, 167, 'Cuerpo'),
                                                                                    (3, 61, 168, 'T3N1M0'),
                                                                                    (4, 1, 169, 'Paciente Caso 4'),
                                                                                    (4, 2, 170, '912345678'),
                                                                                    (4, 3, 171, 'caso4@email.com'),
                                                                                    (4, 4, 172, '59'),
                                                                                    (4, 5, 173, 'Hombre'),
                                                                                    (4, 6, 174, 'Chilena'),
                                                                                    (4, 7, 175, 'Calle Rural 123'),
                                                                                    (4, 8, 176, 'San Carlos'),
                                                                                    (4, 9, 177, 'Chillán'),
                                                                                    (4, 10, 178, 'Rural'),
                                                                                    (4, 11, 179, 'Sí'),
                                                                                    (4, 12, 180, 'Básico'),
                                                                                    (4, 13, 181, 'Agricultor'),
                                                                                    (4, 14, 182, 'Fonasa'),
                                                                                    (4, 15, 183, 'Sí'),
                                                                                    (4, 16, 184, '01/03/2024'),
                                                                                    (4, 17, 185, 'Sí'),
                                                                                    (4, 18, 186, 'No'),
                                                                                    (4, 20, 187, 'Sí'),
                                                                                    (4, 21, 188, 'Gastritis crónica atrófica'),
                                                                                    (4, 22, 189, 'Sí'),
                                                                                    (4, 23, 190, 'Omeprazol'),
                                                                                    (4, 24, 191, 'No'),
                                                                                    (4, 25, 192, '62'),
                                                                                    (4, 27, 193, '1.65'),
                                                                                    (4, 26, 194, '22.8'),
                                                                                    (4, 28, 195, 'Fumador actual'),
                                                                                    (4, 29, 196, '≥20 cigarrillos/día (mucho)'),
                                                                                    (4, 30, 197, '>20 años'),
                                                                                    (4, 32, 198, 'Consumidor actual'),
                                                                                    (4, 33, 199, 'Frecuente (≥4 veces/semana)'),
                                                                                    (4, 34, 200, '≥5 tragos (mucho)'),
                                                                                    (4, 35, 201, '>20 años'),
                                                                                    (4, 37, 202, '≥3/sem'),
                                                                                    (4, 38, 203, 'Sí'),
                                                                                    (4, 39, 204, '≤2 porciones/día'),
                                                                                    (4, 40, 205, 'Sí'),
                                                                                    (4, 41, 206, '3 o más veces por semana'),
                                                                                    (4, 42, 207, '≥3/sem'),
                                                                                    (4, 43, 208, 'Sí'),
                                                                                    (4, 44, 209, 'No'),
                                                                                    (4, 46, 210, 'Diario'),
                                                                                    (4, 47, 211, 'Pozo'),
                                                                                    (4, 48, 212, 'Ninguno'),
                                                                                    (4, 49, 213, 'Positivo'),
                                                                                    (4, 50, 214, 'Sí'),
                                                                                    (4, 51, 215, '2015, Test de Aliento'),
                                                                                    (4, 52, 216, 'Sí'),
                                                                                    (4, 53, 217, '2015, Claritromicina + Amoxicilina'),
                                                                                    (4, 54, 218, 'Histología / Biopsia'),
                                                                                    (4, 55, 219, '<1 año'),
                                                                                    (4, 56, 220, 'No'),
                                                                                    (4, 57, 221, 'No'),
                                                                                    (4, 58, 222, 'Difuso'),
                                                                                    (4, 60, 223, 'Cuerpo'),
                                                                                    (4, 61, 224, 'T3N1M0'),
                                                                                    (5, 1, 225, 'Paciente Caso 5'),
                                                                                    (5, 2, 226, '912345678'),
                                                                                    (5, 3, 227, 'caso5@email.com'),
                                                                                    (5, 4, 228, '60'),
                                                                                    (5, 5, 229, 'Hombre'),
                                                                                    (5, 6, 230, 'Chilena'),
                                                                                    (5, 7, 231, 'Calle Rural 123'),
                                                                                    (5, 8, 232, 'Coihueco'),
                                                                                    (5, 9, 233, 'Chillán'),
                                                                                    (5, 10, 234, 'Rural'),
                                                                                    (5, 11, 235, 'Sí'),
                                                                                    (5, 12, 236, 'Básico'),
                                                                                    (5, 13, 237, 'Agricultor'),
                                                                                    (5, 14, 238, 'Fonasa'),
                                                                                    (5, 15, 239, 'Sí'),
                                                                                    (5, 16, 240, '01/03/2024'),
                                                                                    (5, 17, 241, 'Sí'),
                                                                                    (5, 18, 242, 'No'),
                                                                                    (5, 20, 243, 'Sí'),
                                                                                    (5, 21, 244, 'Gastritis crónica atrófica'),
                                                                                    (5, 22, 245, 'Sí'),
                                                                                    (5, 23, 246, 'Omeprazol'),
                                                                                    (5, 24, 247, 'No'),
                                                                                    (5, 25, 248, '62'),
                                                                                    (5, 27, 249, '1.65'),
                                                                                    (5, 26, 250, '22.8'),
                                                                                    (5, 28, 251, 'Fumador actual'),
                                                                                    (5, 29, 252, '≥20 cigarrillos/día (mucho)'),
                                                                                    (5, 30, 253, '>20 años'),
                                                                                    (5, 32, 254, 'Consumidor actual'),
                                                                                    (5, 33, 255, 'Frecuente (≥4 veces/semana)'),
                                                                                    (5, 34, 256, '≥5 tragos (mucho)'),
                                                                                    (5, 35, 257, '>20 años'),
                                                                                    (5, 37, 258, '≥3/sem'),
                                                                                    (5, 38, 259, 'Sí'),
                                                                                    (5, 39, 260, '≤2 porciones/día'),
                                                                                    (5, 40, 261, 'Sí'),
                                                                                    (5, 41, 262, '3 o más veces por semana'),
                                                                                    (5, 42, 263, '≥3/sem'),
                                                                                    (5, 43, 264, 'Sí'),
                                                                                    (5, 44, 265, 'No'),
                                                                                    (5, 46, 266, 'Diario'),
                                                                                    (5, 47, 267, 'Pozo'),
                                                                                    (5, 48, 268, 'Ninguno'),
                                                                                    (5, 49, 269, 'Positivo'),
                                                                                    (5, 50, 270, 'Sí'),
                                                                                    (5, 51, 271, '2015, Test de Aliento'),
                                                                                    (5, 52, 272, 'Sí'),
                                                                                    (5, 53, 273, '2015, Claritromicina + Amoxicilina'),
                                                                                    (5, 54, 274, 'Histología / Biopsia'),
                                                                                    (5, 55, 275, '<1 año'),
                                                                                    (5, 56, 276, 'No'),
                                                                                    (5, 57, 277, 'No'),
                                                                                    (5, 58, 278, 'Difuso'),
                                                                                    (5, 60, 279, 'Cuerpo'),
                                                                                    (5, 61, 280, 'T3N1M0'),
                                                                                    (6, 1, 281, 'Paciente Control 1'),
                                                                                    (6, 2, 282, '987654321'),
                                                                                    (6, 3, 283, 'control1@email.com'),
                                                                                    (6, 4, 284, '46'),
                                                                                    (6, 5, 285, 'Mujer'),
                                                                                    (6, 6, 286, 'Chilena'),
                                                                                    (6, 7, 287, 'Av. Libertad 456'),
                                                                                    (6, 8, 288, 'Chillán'),
                                                                                    (6, 9, 289, 'Chillán'),
                                                                                    (6, 10, 290, 'Urbana'),
                                                                                    (6, 11, 291, 'Sí'),
                                                                                    (6, 12, 292, 'Superior'),
                                                                                    (6, 13, 293, 'Profesor'),
                                                                                    (6, 14, 294, 'Isapre'),
                                                                                    (6, 17, 295, 'No'),
                                                                                    (6, 18, 296, 'Sí'),
                                                                                    (6, 20, 297, 'No'),
                                                                                    (6, 22, 298, 'No'),
                                                                                    (6, 24, 299, 'No'),
                                                                                    (6, 25, 300, '75'),
                                                                                    (6, 27, 301, '1.70'),
                                                                                    (6, 26, 302, '25.9'),
                                                                                    (6, 28, 303, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (6, 32, 304, 'Consumidor actual'),
                                                                                    (6, 33, 305, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (6, 34, 306, '1–2 tragos (poco)'),
                                                                                    (6, 35, 307, '10–20 años'),
                                                                                    (6, 37, 308, '≤1/sem'),
                                                                                    (6, 38, 309, 'No'),
                                                                                    (6, 39, 310, '≥5 porciones/día'),
                                                                                    (6, 40, 311, 'No'),
                                                                                    (6, 41, 312, 'Casi nunca / Rara vez'),
                                                                                    (6, 42, 313, 'Nunca/Rara vez'),
                                                                                    (6, 43, 314, 'No'),
                                                                                    (6, 44, 315, 'No'),
                                                                                    (6, 46, 316, 'Nunca/Rara vez'),
                                                                                    (6, 47, 317, 'Red pública'),
                                                                                    (6, 48, 318, 'Ninguno'),
                                                                                    (6, 49, 319, 'Negativo'),
                                                                                    (6, 50, 320, 'No'),
                                                                                    (6, 52, 321, 'No'),
                                                                                    (6, 54, 322, 'Test de aliento (urea-C13/C14)'),
                                                                                    (6, 55, 323, '1–5 años'),
                                                                                    (6, 56, 324, 'No'),
                                                                                    (6, 57, 325, 'No'),
                                                                                    (7, 1, 326, 'Paciente Control 2'),
                                                                                    (7, 2, 327, '987654321'),
                                                                                    (7, 3, 328, 'control2@email.com'),
                                                                                    (7, 4, 329, '47'),
                                                                                    (7, 5, 330, 'Mujer'),
                                                                                    (7, 6, 331, 'Chilena'),
                                                                                    (7, 7, 332, 'Av. Libertad 456'),
                                                                                    (7, 8, 333, 'Chillán'),
                                                                                    (7, 9, 334, 'Chillán'),
                                                                                    (7, 10, 335, 'Urbana'),
                                                                                    (7, 11, 336, 'Sí'),
                                                                                    (7, 12, 337, 'Superior'),
                                                                                    (7, 13, 338, 'Profesor'),
                                                                                    (7, 14, 339, 'Isapre'),
                                                                                    (7, 17, 340, 'No'),
                                                                                    (7, 18, 341, 'Sí'),
                                                                                    (7, 20, 342, 'No'),
                                                                                    (7, 22, 343, 'No'),
                                                                                    (7, 24, 344, 'No'),
                                                                                    (7, 25, 345, '75'),
                                                                                    (7, 27, 346, '1.70'),
                                                                                    (7, 26, 347, '25.9'),
                                                                                    (7, 28, 348, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (7, 32, 349, 'Consumidor actual'),
                                                                                    (7, 33, 350, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (7, 34, 351, '1–2 tragos (poco)'),
                                                                                    (7, 35, 352, '10–20 años'),
                                                                                    (7, 37, 353, '≤1/sem'),
                                                                                    (7, 38, 354, 'No'),
                                                                                    (7, 39, 355, '≥5 porciones/día'),
                                                                                    (7, 40, 356, 'No'),
                                                                                    (7, 41, 357, 'Casi nunca / Rara vez'),
                                                                                    (7, 42, 358, 'Nunca/Rara vez'),
                                                                                    (7, 43, 359, 'No'),
                                                                                    (7, 44, 360, 'No'),
                                                                                    (7, 46, 361, 'Nunca/Rara vez'),
                                                                                    (7, 47, 362, 'Red pública'),
                                                                                    (7, 48, 363, 'Ninguno'),
                                                                                    (7, 49, 364, 'Negativo'),
                                                                                    (7, 50, 365, 'No'),
                                                                                    (7, 52, 366, 'No'),
                                                                                    (7, 54, 367, 'Test de aliento (urea-C13/C14)'),
                                                                                    (7, 55, 368, '1–5 años'),
                                                                                    (7, 56, 369, 'No'),
                                                                                    (7, 57, 370, 'No'),
                                                                                    (8, 1, 371, 'Paciente Control 3'),
                                                                                    (8, 2, 372, '987654321'),
                                                                                    (8, 3, 373, 'control3@email.com'),
                                                                                    (8, 4, 374, '48'),
                                                                                    (8, 5, 375, 'Mujer'),
                                                                                    (8, 6, 376, 'Chilena'),
                                                                                    (8, 7, 377, 'Av. Libertad 456'),
                                                                                    (8, 8, 378, 'Chillán'),
                                                                                    (8, 9, 379, 'Chillán'),
                                                                                    (8, 10, 380, 'Urbana'),
                                                                                    (8, 11, 381, 'Sí'),
                                                                                    (8, 12, 382, 'Superior'),
                                                                                    (8, 13, 383, 'Profesor'),
                                                                                    (8, 14, 384, 'Isapre'),
                                                                                    (8, 17, 385, 'No'),
                                                                                    (8, 18, 386, 'Sí'),
                                                                                    (8, 20, 387, 'No'),
                                                                                    (8, 22, 388, 'No'),
                                                                                    (8, 24, 389, 'No'),
                                                                                    (8, 25, 390, '75'),
                                                                                    (8, 27, 391, '1.70'),
                                                                                    (8, 26, 392, '25.9'),
                                                                                    (8, 28, 393, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (8, 32, 394, 'Consumidor actual'),
                                                                                    (8, 33, 395, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (8, 34, 396, '1–2 tragos (poco)'),
                                                                                    (8, 35, 397, '10–20 años'),
                                                                                    (8, 37, 398, '≤1/sem'),
                                                                                    (8, 38, 399, 'No'),
                                                                                    (8, 39, 400, '≥5 porciones/día'),
                                                                                    (8, 40, 401, 'No'),
                                                                                    (8, 41, 402, 'Casi nunca / Rara vez'),
                                                                                    (8, 42, 403, 'Nunca/Rara vez'),
                                                                                    (8, 43, 404, 'No'),
                                                                                    (8, 44, 405, 'No'),
                                                                                    (8, 46, 406, 'Nunca/Rara vez'),
                                                                                    (8, 47, 407, 'Red pública'),
                                                                                    (8, 48, 408, 'Ninguno'),
                                                                                    (8, 49, 409, 'Negativo'),
                                                                                    (8, 50, 410, 'No'),
                                                                                    (8, 52, 411, 'No'),
                                                                                    (8, 54, 412, 'Test de aliento (urea-C13/C14)'),
                                                                                    (8, 55, 413, '1–5 años'),
                                                                                    (8, 56, 414, 'No'),
                                                                                    (8, 57, 415, 'No'),
                                                                                    (9, 1, 416, 'Paciente Control 4'),
                                                                                    (9, 2, 417, '987654321'),
                                                                                    (9, 3, 418, 'control4@email.com'),
                                                                                    (9, 4, 419, '49'),
                                                                                    (9, 5, 420, 'Mujer'),
                                                                                    (9, 6, 421, 'Chilena'),
                                                                                    (9, 7, 422, 'Av. Libertad 456'),
                                                                                    (9, 8, 423, 'Chillán'),
                                                                                    (9, 9, 424, 'Chillán'),
                                                                                    (9, 10, 425, 'Urbana'),
                                                                                    (9, 11, 426, 'Sí'),
                                                                                    (9, 12, 427, 'Superior'),
                                                                                    (9, 13, 428, 'Profesor'),
                                                                                    (9, 14, 429, 'Isapre'),
                                                                                    (9, 17, 430, 'No'),
                                                                                    (9, 18, 431, 'Sí'),
                                                                                    (9, 20, 432, 'No'),
                                                                                    (9, 22, 433, 'No'),
                                                                                    (9, 24, 434, 'No'),
                                                                                    (9, 25, 435, '75'),
                                                                                    (9, 27, 436, '1.70'),
                                                                                    (9, 26, 437, '25.9'),
                                                                                    (9, 28, 438, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (9, 32, 439, 'Consumidor actual'),
                                                                                    (9, 33, 440, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (9, 34, 441, '1–2 tragos (poco)'),
                                                                                    (9, 35, 442, '10–20 años'),
                                                                                    (9, 37, 443, '≤1/sem'),
                                                                                    (9, 38, 444, 'No'),
                                                                                    (9, 39, 445, '≥5 porciones/día'),
                                                                                    (9, 40, 446, 'No'),
                                                                                    (9, 41, 447, 'Casi nunca / Rara vez'),
                                                                                    (9, 42, 448, 'Nunca/Rara vez'),
                                                                                    (9, 43, 449, 'No'),
                                                                                    (9, 44, 450, 'No'),
                                                                                    (9, 46, 451, 'Nunca/Rara vez'),
                                                                                    (9, 47, 452, 'Red pública'),
                                                                                    (9, 48, 453, 'Ninguno'),
                                                                                    (9, 49, 454, 'Negativo'),
                                                                                    (9, 50, 455, 'No'),
                                                                                    (9, 52, 456, 'No'),
                                                                                    (9, 54, 457, 'Test de aliento (urea-C13/C14)'),
                                                                                    (9, 55, 458, '1–5 años'),
                                                                                    (9, 56, 459, 'No'),
                                                                                    (9, 57, 460, 'No'),
                                                                                    (10, 1, 461, 'Paciente Control 5'),
                                                                                    (10, 2, 462, '987654321'),
                                                                                    (10, 3, 463, 'control5@email.com'),
                                                                                    (10, 4, 464, '50'),
                                                                                    (10, 5, 465, 'Mujer'),
                                                                                    (10, 6, 466, 'Chilena'),
                                                                                    (10, 7, 467, 'Av. Libertad 456'),
                                                                                    (10, 8, 468, 'Chillán'),
                                                                                    (10, 9, 469, 'Chillán'),
                                                                                    (10, 10, 470, 'Urbana'),
                                                                                    (10, 11, 471, 'Sí'),
                                                                                    (10, 12, 472, 'Superior'),
                                                                                    (10, 13, 473, 'Profesor'),
                                                                                    (10, 14, 474, 'Isapre'),
                                                                                    (10, 17, 475, 'No'),
                                                                                    (10, 18, 476, 'Sí'),
                                                                                    (10, 20, 477, 'No'),
                                                                                    (10, 22, 478, 'No'),
                                                                                    (10, 24, 479, 'No'),
                                                                                    (10, 25, 480, '75'),
                                                                                    (10, 27, 481, '1.70'),
                                                                                    (10, 26, 482, '25.9'),
                                                                                    (10, 28, 483, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (10, 32, 484, 'Consumidor actual'),
                                                                                    (10, 33, 485, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (10, 34, 486, '1–2 tragos (poco)'),
                                                                                    (10, 35, 487, '10–20 años'),
                                                                                    (10, 37, 488, '≤1/sem'),
                                                                                    (10, 38, 489, 'No'),
                                                                                    (10, 39, 490, '≥5 porciones/día'),
                                                                                    (10, 40, 491, 'No'),
                                                                                    (10, 41, 492, 'Casi nunca / Rara vez'),
                                                                                    (10, 42, 493, 'Nunca/Rara vez'),
                                                                                    (10, 43, 494, 'No'),
                                                                                    (10, 44, 495, 'No'),
                                                                                    (10, 46, 496, 'Nunca/Rara vez'),
                                                                                    (10, 47, 497, 'Red pública'),
                                                                                    (10, 48, 498, 'Ninguno'),
                                                                                    (10, 49, 499, 'Negativo'),
                                                                                    (10, 50, 500, 'No'),
                                                                                    (10, 52, 501, 'No'),
                                                                                    (10, 54, 502, 'Test de aliento (urea-C13/C14)'),
                                                                                    (10, 55, 503, '1–5 años'),
                                                                                    (10, 56, 504, 'No'),
                                                                                    (10, 57, 505, 'No');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
                       `rol_id` bigint(20) NOT NULL,
                       `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `nombre`) VALUES
                                           (1, 'ROLE_ADMIN'),
                                           (4, 'ROLE_ESTUDIANTE'),
                                           (3, 'ROLE_INVESTIGADOR'),
                                           (2, 'ROLE_MEDICO'),
                                           (5, 'ROLE_VISUALIZADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
                               `permiso_id` bigint(20) NOT NULL,
                               `rol_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol_permiso`
--

INSERT INTO `rol_permiso` (`permiso_id`, `rol_id`) VALUES
                                                       (1, 1),
                                                       (1, 2),
                                                       (2, 1),
                                                       (2, 2),
                                                       (2, 4),
                                                       (3, 1),
                                                       (3, 2),
                                                       (4, 1),
                                                       (4, 2),
                                                       (4, 4),
                                                       (5, 1),
                                                       (5, 2),
                                                       (5, 3),
                                                       (5, 4),
                                                       (6, 1),
                                                       (6, 2),
                                                       (6, 3),
                                                       (6, 4),
                                                       (6, 5),
                                                       (7, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
                           `activo` bit(1) DEFAULT NULL,
                           `id_usuario` bigint(20) NOT NULL,
                           `token_cambio_email_expiracion` datetime(6) DEFAULT NULL,
                           `token_rec_expiracion` datetime(6) DEFAULT NULL,
                           `apellidos` varchar(255) NOT NULL,
                           `contrasena` varchar(255) NOT NULL,
                           `email` varchar(255) NOT NULL,
                           `nombres` varchar(255) NOT NULL,
                           `rut` varchar(255) NOT NULL,
                           `telefono` varchar(255) DEFAULT NULL,
                           `token_cambio_email` varchar(255) DEFAULT NULL,
                           `token_recuperacion` varchar(255) DEFAULT NULL,
                           `foto_perfil` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`activo`, `id_usuario`, `token_cambio_email_expiracion`, `token_rec_expiracion`, `apellidos`, `contrasena`, `email`, `nombres`, `rut`, `telefono`, `token_cambio_email`, `token_recuperacion`, `foto_perfil`) VALUES
                                                                                                                                                                                                                                         (b'1', 1, NULL, NULL, 'General', '$2a$10$4HXkHDBf7oi9SpZJ/Srl7O8.IzcgjhVDkYhO7P6djmAG2vxoA1K2S', 'admin@hospital.cl', 'Admin', '11.111.111-1', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 2, NULL, NULL, 'Pérez', '$2a$10$Ya6e8PEISNtV7KjIcyD3v.en6mmHDWXw1h6MsA.TadfxeATQ3t766', 'medico@hospital.cl', 'Dr. Juan', '22.222.222-2', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 3, NULL, NULL, 'Silva', '$2a$10$ppUQLOL1ljb0ctuO60AYHOrvCgXHo2yyo2TMwF7Kysy9D6ZFvmrH.', 'investigacion@ubiobio.cl', 'Ana', '33.333.333-3', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 4, NULL, NULL, 'Estudiante', '$2a$10$NDCjMWaZWXSoBz/OyP6sQOmNlbkWWXp71Invmx0x2mHCo9ebOIDOS', 'pedro@alumnos.cl', 'Pedro', '44.444.444-4', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_rol`
--

CREATE TABLE `usuario_rol` (
                               `rol_id` bigint(20) NOT NULL,
                               `usuario_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_rol`
--

INSERT INTO `usuario_rol` (`rol_id`, `usuario_id`) VALUES
                                                       (1, 1),
                                                       (2, 2),
                                                       (3, 3),
                                                       (4, 4);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
    ADD PRIMARY KEY (`id_cat`);

--
-- Indices de la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FKnvjsi51uco733s2n6ep9pay8k` (`destinatario_id`),
  ADD KEY `FKqyl87cej61sep55uuin3t5yrj` (`mensaje_id`);

--
-- Indices de la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    ADD PRIMARY KEY (`id_dicotomizacion`),
  ADD KEY `FKgjwmkfv176urksoaxmb08qwjb` (`pregunta_id`);

--
-- Indices de la tabla `mensaje`
--
ALTER TABLE `mensaje`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FK9iju1ryvmblhnq7cilb3mqvg0` (`emisor_id`);

--
-- Indices de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    ADD PRIMARY KEY (`id_opcion`),
  ADD KEY `FKljlpfii82o9ichkq7pqxs7jpo` (`pregunta_id`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
    ADD PRIMARY KEY (`participante_id`),
  ADD UNIQUE KEY `UKqyuxt0wy3e9w3grxt1id54r55` (`participante_cod`),
  ADD KEY `FKk850gvh3kplkn9f9mdainwuqq` (`reclutador_id`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
    ADD PRIMARY KEY (`id_perm`),
  ADD UNIQUE KEY `UKnwe6lkk7x7sbw94xcmbwgvycu` (`nombre`);

--
-- Indices de la tabla `preguntas`
--
ALTER TABLE `preguntas`
    ADD PRIMARY KEY (`pregunta_id`),
  ADD KEY `FKax8hwm2wxx26i9ntdvq4iox5x` (`id_cat`);

--
-- Indices de la tabla `registro`
--
ALTER TABLE `registro`
    ADD PRIMARY KEY (`registro_id`),
  ADD KEY `FKhhjtfebyk33a740ix5smgwqyc` (`respuesta_id`),
  ADD KEY `FKqfbdwuu2isbwwnx1uky39930w` (`usuario_id`);

--
-- Indices de la tabla `respuesta`
--
ALTER TABLE `respuesta`
    ADD PRIMARY KEY (`respuesta_id`),
  ADD KEY `FK7axh6xp0twctrjpq7d8ngdcu7` (`paciente_id`),
  ADD KEY `FKmlq7l9u0bpvxor26presg5x84` (`pregunta_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
    ADD PRIMARY KEY (`rol_id`),
  ADD UNIQUE KEY `UK43kr6s7bts1wqfv43f7jd87kp` (`nombre`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
    ADD PRIMARY KEY (`permiso_id`,`rol_id`),
  ADD KEY `FK6o522368i97la9m9cqn0gul2e` (`rol_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
    ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `UKjx61a01wwidax9iafoa3xj22i` (`rut`);

--
-- Indices de la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
    ADD PRIMARY KEY (`rol_id`,`usuario_id`),
  ADD KEY `FKbyfgloj439r9wr9smrms9u33r` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
    MODIFY `id_cat` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    MODIFY `id_dicotomizacion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `mensaje`
--
ALTER TABLE `mensaje`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    MODIFY `id_opcion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
    MODIFY `participante_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
    MODIFY `id_perm` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `preguntas`
--
ALTER TABLE `preguntas`
    MODIFY `pregunta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
    MODIFY `registro_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=516;

--
-- AUTO_INCREMENT de la tabla `respuesta`
--
ALTER TABLE `respuesta`
    MODIFY `respuesta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=506;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
    MODIFY `rol_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
    MODIFY `id_usuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    ADD CONSTRAINT `FKnvjsi51uco733s2n6ep9pay8k` FOREIGN KEY (`destinatario_id`) REFERENCES `usuario` (`id_usuario`),
  ADD CONSTRAINT `FKqyl87cej61sep55uuin3t5yrj` FOREIGN KEY (`mensaje_id`) REFERENCES `mensaje` (`id`);

--
-- Filtros para la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    ADD CONSTRAINT `FKgjwmkfv176urksoaxmb08qwjb` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `mensaje`
--
ALTER TABLE `mensaje`
    ADD CONSTRAINT `FK9iju1ryvmblhnq7cilb3mqvg0` FOREIGN KEY (`emisor_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    ADD CONSTRAINT `FKljlpfii82o9ichkq7pqxs7jpo` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
    ADD CONSTRAINT `FKk850gvh3kplkn9f9mdainwuqq` FOREIGN KEY (`reclutador_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `preguntas`
--
ALTER TABLE `preguntas`
    ADD CONSTRAINT `FKax8hwm2wxx26i9ntdvq4iox5x` FOREIGN KEY (`id_cat`) REFERENCES `categoria` (`id_cat`);

--
-- Filtros para la tabla `registro`
--
ALTER TABLE `registro`
    ADD CONSTRAINT `FKhhjtfebyk33a740ix5smgwqyc` FOREIGN KEY (`respuesta_id`) REFERENCES `respuesta` (`respuesta_id`),
  ADD CONSTRAINT `FKqfbdwuu2isbwwnx1uky39930w` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `respuesta`
--
ALTER TABLE `respuesta`
    ADD CONSTRAINT `FK7axh6xp0twctrjpq7d8ngdcu7` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`participante_id`),
  ADD CONSTRAINT `FKmlq7l9u0bpvxor26presg5x84` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-12-2025 a las 22:05:32
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

    SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto_semestral`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
                             `orden` int(11) NOT NULL,
                             `id_cat` bigint(20) NOT NULL,
                             `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`orden`, `id_cat`, `nombre`) VALUES
                                                          (1, 1, '1. Identificación del participante'),
                                                          (2, 2, '2. Datos sociodemográficos'),
                                                          (3, 3, '3. Antecedentes clínicos'),
                                                          (4, 4, '4. Antropometría'),
                                                          (5, 5, '5. Tabaquismo'),
                                                          (6, 6, '6. Consumo de alcohol'),
                                                          (7, 7, '7. Factores dietarios y ambientales'),
                                                          (8, 8, '8. H. Pylori'),
                                                          (9, 9, '9. Histopatología (Solo Casos)');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `destinatario_mensaje`
--

CREATE TABLE `destinatario_mensaje` (
                                        `eliminado` bit(1) NOT NULL,
                                        `leido` bit(1) NOT NULL,
                                        `destinatario_id` bigint(20) NOT NULL,
                                        `fecha_lectura` datetime(6) DEFAULT NULL,
                                        `id` bigint(20) NOT NULL,
                                        `mensaje_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dicotomizaciones`
--

CREATE TABLE `dicotomizaciones` (
                                    `valor_corte` double DEFAULT NULL,
                                    `id_dicotomizacion` bigint(20) NOT NULL,
                                    `pregunta_id` bigint(20) DEFAULT NULL,
                                    `sentido_corte` enum('IGUAL_A','MAYOR_O_IGUAL','MAYOR_QUE','MENOR_O_IGUAL','MENOR_QUE') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dicotomizaciones`
--

INSERT INTO `dicotomizaciones` (`valor_corte`, `id_dicotomizacion`, `pregunta_id`, `sentido_corte`) VALUES
                                                                                                        (50, 1, 4, 'MAYOR_O_IGUAL'),
                                                                                                        (60, 2, 4, 'MAYOR_O_IGUAL'),
                                                                                                        (1, 3, 12, 'MAYOR_O_IGUAL'),
                                                                                                        (2, 4, 12, 'MAYOR_O_IGUAL'),
                                                                                                        (2, 5, 14, 'MAYOR_O_IGUAL'),
                                                                                                        (25, 6, 26, 'MAYOR_O_IGUAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensaje`
--

CREATE TABLE `mensaje` (
                           `emisor_id` bigint(20) NOT NULL,
                           `fecha_envio` datetime(6) NOT NULL,
                           `id` bigint(20) NOT NULL,
                           `asunto` varchar(255) NOT NULL,
                           `contenido` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion_pregunta`
--

CREATE TABLE `opcion_pregunta` (
                                   `orden` int(11) NOT NULL,
                                   `valor_dicotomizado` double DEFAULT NULL,
                                   `id_opcion` bigint(20) NOT NULL,
                                   `pregunta_id` bigint(20) NOT NULL,
                                   `etiqueta` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `opcion_pregunta`
--

INSERT INTO `opcion_pregunta` (`orden`, `valor_dicotomizado`, `id_opcion`, `pregunta_id`, `etiqueta`) VALUES
                                                                                                          (0, NULL, 1, 5, 'Mujer'),
                                                                                                          (1, NULL, 2, 5, 'Hombre'),
                                                                                                          (0, NULL, 3, 10, 'Urbana'),
                                                                                                          (1, NULL, 4, 10, 'Rural'),
                                                                                                          (0, NULL, 5, 11, 'No'),
                                                                                                          (1, NULL, 6, 11, 'Sí'),
                                                                                                          (0, NULL, 7, 12, 'Básico'),
                                                                                                          (1, NULL, 8, 12, 'Medio'),
                                                                                                          (2, NULL, 9, 12, 'Superior'),
                                                                                                          (0, NULL, 10, 14, 'Fonasa'),
                                                                                                          (1, NULL, 11, 14, 'Sin previsión'),
                                                                                                          (2, NULL, 12, 14, 'Isapre'),
                                                                                                          (3, NULL, 13, 14, 'Capredena / Dipreca'),
                                                                                                          (4, NULL, 14, 14, 'Otra'),
                                                                                                          (0, NULL, 15, 15, 'No'),
                                                                                                          (1, NULL, 16, 15, 'Sí'),
                                                                                                          (0, NULL, 17, 17, 'No'),
                                                                                                          (1, NULL, 18, 17, 'Sí'),
                                                                                                          (0, NULL, 19, 18, 'No'),
                                                                                                          (1, NULL, 20, 18, 'Sí'),
                                                                                                          (0, NULL, 21, 20, 'No'),
                                                                                                          (1, NULL, 22, 20, 'Sí'),
                                                                                                          (0, NULL, 23, 22, 'No'),
                                                                                                          (1, NULL, 24, 22, 'Sí'),
                                                                                                          (0, NULL, 25, 24, 'No'),
                                                                                                          (1, NULL, 26, 24, 'Sí'),
                                                                                                          (0, NULL, 27, 28, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                                          (1, NULL, 28, 28, 'Exfumador'),
                                                                                                          (2, NULL, 29, 28, 'Fumador actual'),
                                                                                                          (0, NULL, 30, 29, '1–9 cigarrillos/día (poco)'),
                                                                                                          (1, NULL, 31, 29, '10–19 cigarrillos/día (moderado)'),
                                                                                                          (2, NULL, 32, 29, '≥20 cigarrillos/día (mucho)'),
                                                                                                          (0, NULL, 33, 30, '<10 años'),
                                                                                                          (1, NULL, 34, 30, '10–20 años'),
                                                                                                          (2, NULL, 35, 30, '>20 años'),
                                                                                                          (0, NULL, 36, 31, '<5 años'),
                                                                                                          (1, NULL, 37, 31, '5–10 años'),
                                                                                                          (2, NULL, 38, 31, '>10 años'),
                                                                                                          (0, NULL, 39, 32, 'Nunca'),
                                                                                                          (1, NULL, 40, 32, 'Exconsumidor'),
                                                                                                          (2, NULL, 41, 32, 'Consumidor actual'),
                                                                                                          (0, NULL, 42, 33, 'Ocasional (menos de 1 vez/semana)'),
                                                                                                          (1, NULL, 43, 33, 'Regular (1–3 veces/semana)'),
                                                                                                          (2, NULL, 44, 33, 'Frecuente (≥4 veces/semana)'),
                                                                                                          (0, NULL, 45, 34, '1–2 tragos (poco)'),
                                                                                                          (1, NULL, 46, 34, '3–4 tragos (moderado)'),
                                                                                                          (2, NULL, 47, 34, '≥5 tragos (mucho)'),
                                                                                                          (0, NULL, 48, 35, '<10 años'),
                                                                                                          (1, NULL, 49, 35, '10–20 años'),
                                                                                                          (2, NULL, 50, 35, '>20 años'),
                                                                                                          (0, NULL, 51, 36, '<5 años'),
                                                                                                          (1, NULL, 52, 36, '5–10 años'),
                                                                                                          (2, NULL, 53, 36, '>10 años'),
                                                                                                          (0, NULL, 54, 37, '≤1/sem'),
                                                                                                          (1, NULL, 55, 37, '2/sem'),
                                                                                                          (2, NULL, 56, 37, '≥3/sem'),
                                                                                                          (0, NULL, 57, 38, 'Sí'),
                                                                                                          (1, NULL, 58, 38, 'No'),
                                                                                                          (0, NULL, 59, 39, '≥5 porciones/día'),
                                                                                                          (1, NULL, 60, 39, '3–4 porciones/día'),
                                                                                                          (2, NULL, 61, 39, '≤2 porciones/día'),
                                                                                                          (0, NULL, 62, 40, 'Sí'),
                                                                                                          (1, NULL, 63, 40, 'No'),
                                                                                                          (0, NULL, 64, 41, 'Casi nunca / Rara vez'),
                                                                                                          (1, NULL, 65, 41, '1 a 2 veces por semana'),
                                                                                                          (2, NULL, 66, 41, '3 o más veces por semana'),
                                                                                                          (0, NULL, 67, 42, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 68, 42, '1–2/sem'),
                                                                                                          (2, NULL, 69, 42, '≥3/sem'),
                                                                                                          (0, NULL, 70, 43, 'Sí'),
                                                                                                          (1, NULL, 71, 43, 'No'),
                                                                                                          (0, NULL, 72, 44, 'Sí'),
                                                                                                          (1, NULL, 73, 44, 'No'),
                                                                                                          (0, NULL, 74, 46, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 75, 46, 'Estacional'),
                                                                                                          (2, NULL, 76, 46, 'Diario'),
                                                                                                          (0, NULL, 77, 47, 'Red pública'),
                                                                                                          (1, NULL, 78, 47, 'Pozo'),
                                                                                                          (2, NULL, 79, 47, 'Camión aljibe'),
                                                                                                          (3, NULL, 80, 47, 'Otra'),
                                                                                                          (0, NULL, 81, 48, 'Ninguno'),
                                                                                                          (1, NULL, 82, 48, 'Hervir'),
                                                                                                          (2, NULL, 83, 48, 'Filtro'),
                                                                                                          (3, NULL, 84, 48, 'Cloro'),
                                                                                                          (0, NULL, 85, 49, 'Positivo'),
                                                                                                          (1, NULL, 86, 49, 'Negativo'),
                                                                                                          (2, NULL, 87, 49, 'Desconocido'),
                                                                                                          (0, NULL, 88, 50, 'Sí'),
                                                                                                          (1, NULL, 89, 50, 'No'),
                                                                                                          (2, NULL, 90, 50, 'No recuerda'),
                                                                                                          (0, NULL, 91, 52, 'Sí'),
                                                                                                          (1, NULL, 92, 52, 'No'),
                                                                                                          (2, NULL, 93, 52, 'No recuerda'),
                                                                                                          (0, NULL, 94, 54, 'Test de aliento (urea-C13/C14)'),
                                                                                                          (1, NULL, 95, 54, 'Antígeno en deposiciones'),
                                                                                                          (2, NULL, 96, 54, 'Serología (IgG)'),
                                                                                                          (3, NULL, 97, 54, 'Test rápido de ureasa'),
                                                                                                          (4, NULL, 98, 54, 'Histología / Biopsia'),
                                                                                                          (5, NULL, 99, 54, 'Otro'),
                                                                                                          (0, NULL, 100, 55, '<1 año'),
                                                                                                          (1, NULL, 101, 55, '1–5 años'),
                                                                                                          (2, NULL, 102, 55, '>5 años'),
                                                                                                          (0, NULL, 103, 56, 'Sí'),
                                                                                                          (1, NULL, 104, 56, 'No'),
                                                                                                          (2, NULL, 105, 56, 'No recuerda'),
                                                                                                          (0, NULL, 106, 57, 'Sí'),
                                                                                                          (1, NULL, 107, 57, 'No'),
                                                                                                          (0, NULL, 108, 58, 'Intestinal'),
                                                                                                          (1, NULL, 109, 58, 'Difuso'),
                                                                                                          (2, NULL, 110, 58, 'Mixto'),
                                                                                                          (3, NULL, 111, 58, 'Otro'),
                                                                                                          (0, NULL, 112, 60, 'Cardias'),
                                                                                                          (1, NULL, 113, 60, 'Cuerpo'),
                                                                                                          (2, NULL, 114, 60, 'Antro'),
                                                                                                          (3, NULL, 115, 60, 'Difuso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
                            `activo` bit(1) NOT NULL,
                            `es_caso` bit(1) NOT NULL,
                            `fecha_incl` date NOT NULL,
                            `participante_id` bigint(20) NOT NULL,
                            `reclutador_id` bigint(20) NOT NULL,
                            `participante_cod` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`activo`, `es_caso`, `fecha_incl`, `participante_id`, `reclutador_id`, `participante_cod`) VALUES
                                                                                                                       (b'1', b'1', '2025-12-04', 1, 1, 'CAS_001'),
                                                                                                                       (b'1', b'1', '2025-12-04', 2, 1, 'CAS_002'),
                                                                                                                       (b'1', b'1', '2025-12-04', 3, 1, 'CAS_003'),
                                                                                                                       (b'1', b'1', '2025-12-04', 4, 1, 'CAS_004'),
                                                                                                                       (b'1', b'1', '2025-12-04', 5, 1, 'CAS_005'),
                                                                                                                       (b'1', b'0', '2025-12-04', 6, 1, 'CONT_001'),
                                                                                                                       (b'1', b'0', '2025-12-04', 7, 1, 'CONT_002'),
                                                                                                                       (b'1', b'0', '2025-12-04', 8, 1, 'CONT_003'),
                                                                                                                       (b'1', b'0', '2025-12-04', 9, 1, 'CONT_004'),
                                                                                                                       (b'1', b'0', '2025-12-04', 10, 1, 'CONT_005');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
                           `id_perm` bigint(20) NOT NULL,
                           `descripcion` varchar(255) NOT NULL,
                           `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`id_perm`, `descripcion`, `nombre`) VALUES
                                                               (1, 'Permite ingresar pacientes Caso', 'CREAR_CASO'),
                                                               (2, 'Permite ingresar pacientes Control', 'CREAR_CONTROL'),
                                                               (3, 'Permite editar respuestas de Casos', 'EDITAR_CASO'),
                                                               (4, 'Permite editar respuestas de Controles', 'EDITAR_CONTROL'),
                                                               (5, 'Permite ver ficha individual', 'VER_PACIENTE'),
                                                               (6, 'Permite ver tabla resumen y exportar', 'VER_LISTADO_PACIENTES'),
                                                               (7, 'Permite archivar/eliminar', 'ELIMINAR_PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas`
--

CREATE TABLE `preguntas` (
                             `activo` bit(1) NOT NULL,
                             `dato_sensible` bit(1) NOT NULL,
                             `exportable` bit(1) NOT NULL,
                             `generar_estadistica` bit(1) NOT NULL,
                             `orden` int(11) NOT NULL,
                             `id_cat` bigint(20) DEFAULT NULL,
                             `pregunta_id` bigint(20) NOT NULL,
                             `codigo_stata` varchar(255) DEFAULT NULL,
                             `descripcion` varchar(255) DEFAULT NULL,
                             `etiqueta` varchar(255) DEFAULT NULL,
                             `tipo_corte` enum('MEDIA','MEDIANA','NINGUNO','VALOR_FIJO') DEFAULT NULL,
                             `tipo_dato` enum('CELULAR','EMAIL','ENUM','NUMERO','RUT','TEXTO') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `preguntas`
--

INSERT INTO `preguntas` (`activo`, `dato_sensible`, `exportable`, `generar_estadistica`, `orden`, `id_cat`, `pregunta_id`, `codigo_stata`, `descripcion`, `etiqueta`, `tipo_corte`, `tipo_dato`) VALUES
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 1, 1, 1, 'Nombre', 'Nombre completo', 'Nombre completo', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 1, 2, 'Telefono', 'Teléfono', 'Teléfono', 'NINGUNO', 'CELULAR'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 1, 3, 'Email', 'Correo electrónico', 'Correo electrónico', 'NINGUNO', 'EMAIL'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 2, 4, 'Edad', 'Edad', 'Edad', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 2, 5, 'Sexo', 'Sexo', 'Sexo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 2, 6, 'Nacionalidad', 'Nacionalidad', 'Nacionalidad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 4, 2, 7, 'Direccion', 'Dirección', 'Dirección', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 2, 8, 'Comuna', 'Comuna', 'Comuna', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 6, 2, 9, 'Ciudad', 'Ciudad', 'Ciudad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 2, 10, 'Zona', 'Zona', 'Zona', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 2, 11, 'Residencia_Urbana5', '¿Vive usted en esta zona desde hace más de 5 años?', '¿Vive usted en esta zona desde hace más de 5 años?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 2, 12, 'NivelEduc', 'Nivel educacional', 'Nivel educacional', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 10, 2, 13, 'Ocupacion', 'Ocupación actual', 'Ocupación actual', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 2, 14, 'Prevision_FonasaVsOtros', 'Previsión de salud actual', 'Previsión de salud actual', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 1, 3, 15, 'Diag_Adenocarcinoma', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 3, 16, 'Fecha_Diag', 'Fecha de diagnóstico (solo casos)', 'Fecha de diagnóstico (solo casos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 3, 17, 'CA_FamiliaGastrico', 'Antecedentes familiares de cáncer gástrico', 'Antecedentes familiares de cáncer gástrico', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 3, 18, 'CA_FamiliaOtros', 'Antecedentes familiares de otros tipos de cáncer', 'Antecedentes familiares de otros tipos de cáncer', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 3, 19, 'CA_FamiliaOtros_Detalle', '¿Cuál(es)? (Otros cánceres)', '¿Cuál(es)? (Otros cánceres)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 3, 20, 'EnfermedadesRelevantes', 'Otras enfermedades relevantes', 'Otras enfermedades relevantes', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 7, 3, 21, 'EnfermedadesRelevantes_Detalle', 'Detalle enfermedades relevantes', 'Detalle enfermedades relevantes', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 3, 22, 'UsoCronico_Medicamentos', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 9, 3, 23, 'UsoCronico_Detalle', 'Especificar cuál (Medicamentos)', 'Especificar cuál (Medicamentos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 10, 3, 24, 'CirugiaGastricaPrevia', 'Cirugía gástrica previa', 'Cirugía gástrica previa', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 4, 25, 'Peso', 'Peso (kg)', 'Peso (kg)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 4, 26, 'IMC', 'IMC', 'IMC', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 4, 27, 'Estatura', 'Estatura (m)', 'Estatura (m)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 5, 28, 'tabaco_estado', 'Estado de tabaquismo', 'Estado de tabaquismo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 5, 29, 'tabaco_cantidad', 'Cantidad promedio fumada', 'Cantidad promedio fumada', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 5, 30, 'tabaco_tiempo_total', 'Tiempo total fumando', 'Tiempo total fumando', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 5, 31, 'tabaco_exfumador_tiempo', 'Si exfumador: tiempo desde que dejó de fumar', 'Si exfumador: tiempo desde que dejó de fumar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 6, 32, 'alcohol_estado', 'Estado de consumo', 'Estado de consumo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 6, 33, 'alcohol_frecuencia', 'Frecuencia', 'Frecuencia', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 6, 34, 'alcohol_cantidad', 'Cantidad típica por ocasión', 'Cantidad típica por ocasión', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 6, 35, 'alcohol_tiempo_total', 'Años de consumo habitual', 'Años de consumo habitual', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 6, 36, 'alcohol_exconsumidor_tiempo', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 7, 37, 'diet_carnes', 'Consumo de carnes procesadas/cecinas', 'Consumo de carnes procesadas/cecinas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 7, 38, 'diet_sal', 'Consumo de alimentos muy salados (agrega sal a la comida sin probar)', 'Consumo de alimentos muy salados (agrega sal a la comida sin probar)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 7, 39, 'diet_frutas_verduras', 'Consumo de porciones de frutas y verduras frescas', 'Consumo de porciones de frutas y verduras frescas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 7, 40, 'diet_frituras', 'Consumo frecuente de frituras (≥3 veces por semana)', 'Consumo frecuente de frituras (≥3 veces por semana)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 7, 41, 'diet_condimentos', 'Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)', 'Consumo de alimentos muy condimentados (ají, salsas picantes, etc.)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 7, 42, 'diet_bebidas_calientes', 'Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)', 'Consumo de infusiones o bebidas muy calientes (tomadas sin dejar entibiar)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 7, 43, 'amb_pesticidas', 'Exposición ocupacional a pesticidas', 'Exposición ocupacional a pesticidas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 7, 44, 'amb_quimicos', 'Exposición a otros compuestos químicos', 'Exposición a otros compuestos químicos', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 9, 7, 45, 'amb_quimicos_detalle', '¿Cuál(es)? (Químicos)', '¿Cuál(es)? (Químicos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 10, 7, 46, 'amb_lena', 'Humo de leña en el hogar (cocina/calefacción)', 'Humo de leña en el hogar (cocina/calefacción)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 7, 47, 'amb_agua_fuente', 'Fuente principal de agua en el hogar', 'Fuente principal de agua en el hogar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 12, 7, 48, 'amb_agua_tratamiento', 'Tratamiento del agua en casa', 'Tratamiento del agua en casa', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 8, 49, 'hp_resultado', 'Resultado del examen para Helicobacter pylori', 'Resultado del examen para Helicobacter pylori', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 8, 50, 'hp_pasado_positivo', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 8, 51, 'hp_pasado_detalle', 'Si responde “Sí”, indicar año aproximado y tipo de examen', 'Si responde “Sí”, indicar año aproximado y tipo de examen', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 8, 52, 'hp_tratamiento', '¿Recibió tratamiento para erradicación de H. pylori?', '¿Recibió tratamiento para erradicación de H. pylori?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 8, 53, 'hp_tratamiento_detalle', 'Si “Sí”, anotar año y esquema, si se conoce', 'Si “Sí”, anotar año y esquema, si se conoce', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 8, 54, 'hp_tipo_examen', 'Tipo de examen realizado', 'Tipo de examen realizado', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 8, 55, 'hp_tiempo_test', '¿Hace cuánto tiempo se realizó el test?', '¿Hace cuánto tiempo se realizó el test?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 8, 56, 'hp_uso_ibp', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 8, 57, 'hp_repetido', '¿Ha repetido el examen posteriormente?', '¿Ha repetido el examen posteriormente?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 9, 58, 'Histologia_Tipo', 'Tipo Histológico', 'Tipo Histológico', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 9, 59, 'histo_tipo_otro', 'Tipo histológico (especificar)', 'Tipo histológico (especificar)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 9, 60, 'Histologia_Localizacion', 'Localización Tumoral', 'Localización Tumoral', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 9, 61, 'histo_tnm', 'Estadio clínico (TNM)', 'Estadio clínico (TNM)', 'NINGUNO', 'TEXTO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro`
--

CREATE TABLE `registro` (
                            `registro_fecha` datetime(6) NOT NULL,
                            `registro_id` bigint(20) NOT NULL,
                            `respuesta_id` bigint(20) DEFAULT NULL,
                            `usuario_id` bigint(20) NOT NULL,
                            `detalles` varchar(1024) NOT NULL,
                            `accion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro`
--

INSERT INTO `registro` (`registro_fecha`, `registro_id`, `respuesta_id`, `usuario_id`, `detalles`, `accion`) VALUES
                                                                                                                 ('2025-12-04 18:04:52.000000', 1, 1, 1, 'Valor: \'Paciente Caso 1\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 2, 2, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 3, 3, 1, 'Valor: \'caso1@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 4, 4, 1, 'Valor: \'56\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 5, 5, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 6, 6, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 7, 7, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 8, 8, 1, 'Valor: \'San Carlos\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 9, 9, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 10, 10, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 11, 11, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 12, 12, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 13, 13, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 14, 14, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 15, 15, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 16, 16, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 17, 17, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 18, 18, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 19, 19, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 20, 20, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 21, 21, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 22, 22, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 23, 23, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 24, 24, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 25, 25, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:52.000000', 26, 26, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 27, 27, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 28, 28, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 29, 29, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 30, 30, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 31, 31, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 32, 32, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 33, 33, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 34, 34, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 35, 35, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 36, 36, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 37, 37, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 38, 38, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 39, 39, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 40, 40, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 41, 41, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 42, 42, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 43, 43, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 44, 44, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 45, 45, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 46, 46, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 47, 47, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 48, 48, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 49, 49, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 50, 50, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 51, 51, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 52, 52, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 53, 53, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 54, 54, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 55, 55, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 56, 56, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:53.000000', 57, NULL, 1, 'Paciente creado con codigo: CAS_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 58, 57, 1, 'Valor: \'Paciente Caso 2\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 59, 58, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 60, 59, 1, 'Valor: \'caso2@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 61, 60, 1, 'Valor: \'57\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 62, 61, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 63, 62, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 64, 63, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 65, 64, 1, 'Valor: \'Coihueco\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 66, 65, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 67, 66, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 68, 67, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 69, 68, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 70, 69, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 71, 70, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 72, 71, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 73, 72, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 74, 73, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 75, 74, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 76, 75, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 77, 76, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 78, 77, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 79, 78, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 80, 79, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 81, 80, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 82, 81, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 83, 82, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 84, 83, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 85, 84, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 86, 85, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 87, 86, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 88, 87, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 89, 88, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 90, 89, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 91, 90, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 92, 91, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 93, 92, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 94, 93, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 95, 94, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 96, 95, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 97, 96, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 98, 97, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 99, 98, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 100, 99, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 101, 100, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 102, 101, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 103, 102, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 104, 103, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 105, 104, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 106, 105, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 107, 106, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 108, 107, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 109, 108, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 110, 109, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 111, 110, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:54.000000', 112, 111, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 113, 112, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 114, NULL, 1, 'Paciente creado con codigo: CAS_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 115, 113, 1, 'Valor: \'Paciente Caso 3\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 116, 114, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 117, 115, 1, 'Valor: \'caso3@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 118, 116, 1, 'Valor: \'58\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 119, 117, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 120, 118, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 121, 119, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 122, 120, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 123, 121, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 124, 122, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 125, 123, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 126, 124, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 127, 125, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 128, 126, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 129, 127, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 130, 128, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 131, 129, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 132, 130, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 133, 131, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 134, 132, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:55.000000', 135, 133, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 136, 134, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 137, 135, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 138, 136, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 139, 137, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 140, 138, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 141, 139, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 142, 140, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 143, 141, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 144, 142, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 145, 143, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 146, 144, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 147, 145, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 148, 146, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 149, 147, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 150, 148, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 151, 149, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 152, 150, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 153, 151, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 154, 152, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 155, 153, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 156, 154, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 157, 155, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 158, 156, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 159, 157, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 160, 158, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 161, 159, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 162, 160, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 163, 161, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 164, 162, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 165, 163, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 166, 164, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 167, 165, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 168, 166, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 169, 167, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 170, 168, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 171, NULL, 1, 'Paciente creado con codigo: CAS_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 172, 169, 1, 'Valor: \'Paciente Caso 4\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 173, 170, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 174, 171, 1, 'Valor: \'caso4@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 175, 172, 1, 'Valor: \'59\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 176, 173, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 177, 174, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:56.000000', 178, 175, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 179, 176, 1, 'Valor: \'San Carlos\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 180, 177, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 181, 178, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 182, 179, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 183, 180, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 184, 181, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 185, 182, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 186, 183, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 187, 184, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 188, 185, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 189, 186, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 190, 187, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 191, 188, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 192, 189, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 193, 190, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 194, 191, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 195, 192, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 196, 193, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 197, 194, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 198, 195, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 199, 196, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 200, 197, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 201, 198, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 202, 199, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 203, 200, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 204, 201, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 205, 202, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 206, 203, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 207, 204, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 208, 205, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 209, 206, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 210, 207, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 211, 208, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 212, 209, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 213, 210, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 214, 211, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 215, 212, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 216, 213, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 217, 214, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 218, 215, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 219, 216, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 220, 217, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 221, 218, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 222, 219, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 223, 220, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 224, 221, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 225, 222, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 226, 223, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 227, 224, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:57.000000', 228, NULL, 1, 'Paciente creado con codigo: CAS_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 229, 225, 1, 'Valor: \'Paciente Caso 5\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 230, 226, 1, 'Valor: \'912345678\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 231, 227, 1, 'Valor: \'caso5@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 232, 228, 1, 'Valor: \'60\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 233, 229, 1, 'Valor: \'Hombre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 234, 230, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 235, 231, 1, 'Valor: \'Calle Rural 123\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 236, 232, 1, 'Valor: \'Coihueco\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 237, 233, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 238, 234, 1, 'Valor: \'Rural\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 239, 235, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 240, 236, 1, 'Valor: \'Básico\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 241, 237, 1, 'Valor: \'Agricultor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 242, 238, 1, 'Valor: \'Fonasa\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 243, 239, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 244, 240, 1, 'Valor: \'01/03/2024\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 245, 241, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 246, 242, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 247, 243, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 248, 244, 1, 'Valor: \'Gastritis crónica atrófica\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 249, 245, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 250, 246, 1, 'Valor: \'Omeprazol\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 251, 247, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 252, 248, 1, 'Valor: \'62\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 253, 249, 1, 'Valor: \'1.65\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 254, 250, 1, 'Valor: \'22.8\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 255, 251, 1, 'Valor: \'Fumador actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 256, 252, 1, 'Valor: \'≥20 cigarrillos/día (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 257, 253, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 258, 254, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 259, 255, 1, 'Valor: \'Frecuente (≥4 veces/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 260, 256, 1, 'Valor: \'≥5 tragos (mucho)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 261, 257, 1, 'Valor: \'>20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 262, 258, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 263, 259, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 264, 260, 1, 'Valor: \'≤2 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 265, 261, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 266, 262, 1, 'Valor: \'3 o más veces por semana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 267, 263, 1, 'Valor: \'≥3/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 268, 264, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 269, 265, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 270, 266, 1, 'Valor: \'Diario\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 271, 267, 1, 'Valor: \'Pozo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 272, 268, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 273, 269, 1, 'Valor: \'Positivo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 274, 270, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 275, 271, 1, 'Valor: \'2015, Test de Aliento\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 276, 272, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 277, 273, 1, 'Valor: \'2015, Claritromicina + Amoxicilina\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 278, 274, 1, 'Valor: \'Histología / Biopsia\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 279, 275, 1, 'Valor: \'<1 año\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 280, 276, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 281, 277, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 282, 278, 1, 'Valor: \'Difuso\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 283, 279, 1, 'Valor: \'Cuerpo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 284, 280, 1, 'Valor: \'T3N1M0\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:58.000000', 285, NULL, 1, 'Paciente creado con codigo: CAS_005', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 286, 281, 1, 'Valor: \'Paciente Control 1\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 287, 282, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 288, 283, 1, 'Valor: \'control1@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 289, 284, 1, 'Valor: \'46\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 290, 285, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 291, 286, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 292, 287, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 293, 288, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 294, 289, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 295, 290, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 296, 291, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 297, 292, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 298, 293, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 299, 294, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 300, 295, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 301, 296, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 302, 297, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 303, 298, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 304, 299, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 305, 300, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 306, 301, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 307, 302, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 308, 303, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 309, 304, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 310, 305, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 311, 306, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 312, 307, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 313, 308, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 314, 309, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 315, 310, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 316, 311, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 317, 312, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 318, 313, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 319, 314, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 320, 315, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 321, 316, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 322, 317, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 323, 318, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 324, 319, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 325, 320, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 326, 321, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 327, 322, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 328, 323, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 329, 324, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 330, 325, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:04:59.000000', 331, NULL, 1, 'Paciente creado con codigo: CONT_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 332, 326, 1, 'Valor: \'Paciente Control 2\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 333, 327, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 334, 328, 1, 'Valor: \'control2@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 335, 329, 1, 'Valor: \'47\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 336, 330, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 337, 331, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 338, 332, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 339, 333, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 340, 334, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 341, 335, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 342, 336, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 343, 337, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 344, 338, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 345, 339, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 346, 340, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 347, 341, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 348, 342, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 349, 343, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 350, 344, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 351, 345, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 352, 346, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 353, 347, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 354, 348, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 355, 349, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 356, 350, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 357, 351, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 358, 352, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:00.000000', 359, 353, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 360, 354, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 361, 355, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 362, 356, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 363, 357, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 364, 358, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 365, 359, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 366, 360, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 367, 361, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 368, 362, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 369, 363, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 370, 364, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 371, 365, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 372, 366, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 373, 367, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 374, 368, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 375, 369, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 376, 370, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 377, NULL, 1, 'Paciente creado con codigo: CONT_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 378, 371, 1, 'Valor: \'Paciente Control 3\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 379, 372, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 380, 373, 1, 'Valor: \'control3@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 381, 374, 1, 'Valor: \'48\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 382, 375, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 383, 376, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 384, 377, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 385, 378, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 386, 379, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 387, 380, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 388, 381, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 389, 382, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 390, 383, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 391, 384, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 392, 385, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 393, 386, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 394, 387, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 395, 388, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 396, 389, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 397, 390, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 398, 391, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 399, 392, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 400, 393, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 401, 394, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 402, 395, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:01.000000', 403, 396, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 404, 397, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 405, 398, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 406, 399, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 407, 400, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 408, 401, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 409, 402, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 410, 403, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 411, 404, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 412, 405, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 413, 406, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 414, 407, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 415, 408, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 416, 409, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 417, 410, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 418, 411, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 419, 412, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 420, 413, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 421, 414, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 422, 415, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 423, NULL, 1, 'Paciente creado con codigo: CONT_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 424, 416, 1, 'Valor: \'Paciente Control 4\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 425, 417, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 426, 418, 1, 'Valor: \'control4@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 427, 419, 1, 'Valor: \'49\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 428, 420, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 429, 421, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 430, 422, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 431, 423, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 432, 424, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 433, 425, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 434, 426, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 435, 427, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 436, 428, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 437, 429, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 438, 430, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 439, 431, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 440, 432, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 441, 433, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 442, 434, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 443, 435, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 444, 436, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:02.000000', 445, 437, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 446, 438, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 447, 439, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 448, 440, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 449, 441, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 450, 442, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 451, 443, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 452, 444, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 453, 445, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 454, 446, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 455, 447, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 456, 448, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 457, 449, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 458, 450, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 459, 451, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 460, 452, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 461, 453, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 462, 454, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 463, 455, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 464, 456, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 465, 457, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 466, 458, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 467, 459, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 468, 460, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 469, NULL, 1, 'Paciente creado con codigo: CONT_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 470, 461, 1, 'Valor: \'Paciente Control 5\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 471, 462, 1, 'Valor: \'987654321\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 472, 463, 1, 'Valor: \'control5@email.com\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 473, 464, 1, 'Valor: \'50\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 474, 465, 1, 'Valor: \'Mujer\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 475, 466, 1, 'Valor: \'Chilena\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:03.000000', 476, 467, 1, 'Valor: \'Av. Libertad 456\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 477, 468, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 478, 469, 1, 'Valor: \'Chillán\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 479, 470, 1, 'Valor: \'Urbana\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 480, 471, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 481, 472, 1, 'Valor: \'Superior\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 482, 473, 1, 'Valor: \'Profesor\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 483, 474, 1, 'Valor: \'Isapre\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 484, 475, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 485, 476, 1, 'Valor: \'Sí\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 486, 477, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 487, 478, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 488, 479, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 489, 480, 1, 'Valor: \'75\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 490, 481, 1, 'Valor: \'1.70\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 491, 482, 1, 'Valor: \'25.9\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 492, 483, 1, 'Valor: \'Nunca fumó (menos de 100 cigarrillos en la vida)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 493, 484, 1, 'Valor: \'Consumidor actual\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 494, 485, 1, 'Valor: \'Ocasional (menos de 1 vez/semana)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 495, 486, 1, 'Valor: \'1–2 tragos (poco)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 496, 487, 1, 'Valor: \'10–20 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 497, 488, 1, 'Valor: \'≤1/sem\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 498, 489, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 499, 490, 1, 'Valor: \'≥5 porciones/día\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 500, 491, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 501, 492, 1, 'Valor: \'Casi nunca / Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 502, 493, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 503, 494, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 504, 495, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 505, 496, 1, 'Valor: \'Nunca/Rara vez\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 506, 497, 1, 'Valor: \'Red pública\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 507, 498, 1, 'Valor: \'Ninguno\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 508, 499, 1, 'Valor: \'Negativo\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 509, 500, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 510, 501, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 511, 502, 1, 'Valor: \'Test de aliento (urea-C13/C14)\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 512, 503, 1, 'Valor: \'1–5 años\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 513, 504, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 514, 505, 1, 'Valor: \'No\'', 'CREAR_RESPUESTA'),
                                                                                                                 ('2025-12-04 18:05:04.000000', 515, NULL, 1, 'Paciente creado con codigo: CONT_005', 'CREAR_PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta`
--

CREATE TABLE `respuesta` (
                             `paciente_id` bigint(20) NOT NULL,
                             `pregunta_id` bigint(20) NOT NULL,
                             `respuesta_id` bigint(20) NOT NULL,
                             `valor` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `respuesta`
--

INSERT INTO `respuesta` (`paciente_id`, `pregunta_id`, `respuesta_id`, `valor`) VALUES
                                                                                    (1, 1, 1, 'Paciente Caso 1'),
                                                                                    (1, 2, 2, '912345678'),
                                                                                    (1, 3, 3, 'caso1@email.com'),
                                                                                    (1, 4, 4, '56'),
                                                                                    (1, 5, 5, 'Hombre'),
                                                                                    (1, 6, 6, 'Chilena'),
                                                                                    (1, 7, 7, 'Calle Rural 123'),
                                                                                    (1, 8, 8, 'San Carlos'),
                                                                                    (1, 9, 9, 'Chillán'),
                                                                                    (1, 10, 10, 'Rural'),
                                                                                    (1, 11, 11, 'Sí'),
                                                                                    (1, 12, 12, 'Básico'),
                                                                                    (1, 13, 13, 'Agricultor'),
                                                                                    (1, 14, 14, 'Fonasa'),
                                                                                    (1, 15, 15, 'Sí'),
                                                                                    (1, 16, 16, '01/03/2024'),
                                                                                    (1, 17, 17, 'Sí'),
                                                                                    (1, 18, 18, 'No'),
                                                                                    (1, 20, 19, 'Sí'),
                                                                                    (1, 21, 20, 'Gastritis crónica atrófica'),
                                                                                    (1, 22, 21, 'Sí'),
                                                                                    (1, 23, 22, 'Omeprazol'),
                                                                                    (1, 24, 23, 'No'),
                                                                                    (1, 25, 24, '62'),
                                                                                    (1, 27, 25, '1.65'),
                                                                                    (1, 26, 26, '22.8'),
                                                                                    (1, 28, 27, 'Fumador actual'),
                                                                                    (1, 29, 28, '≥20 cigarrillos/día (mucho)'),
                                                                                    (1, 30, 29, '>20 años'),
                                                                                    (1, 32, 30, 'Consumidor actual'),
                                                                                    (1, 33, 31, 'Frecuente (≥4 veces/semana)'),
                                                                                    (1, 34, 32, '≥5 tragos (mucho)'),
                                                                                    (1, 35, 33, '>20 años'),
                                                                                    (1, 37, 34, '≥3/sem'),
                                                                                    (1, 38, 35, 'Sí'),
                                                                                    (1, 39, 36, '≤2 porciones/día'),
                                                                                    (1, 40, 37, 'Sí'),
                                                                                    (1, 41, 38, '3 o más veces por semana'),
                                                                                    (1, 42, 39, '≥3/sem'),
                                                                                    (1, 43, 40, 'Sí'),
                                                                                    (1, 44, 41, 'No'),
                                                                                    (1, 46, 42, 'Diario'),
                                                                                    (1, 47, 43, 'Pozo'),
                                                                                    (1, 48, 44, 'Ninguno'),
                                                                                    (1, 49, 45, 'Positivo'),
                                                                                    (1, 50, 46, 'Sí'),
                                                                                    (1, 51, 47, '2015, Test de Aliento'),
                                                                                    (1, 52, 48, 'Sí'),
                                                                                    (1, 53, 49, '2015, Claritromicina + Amoxicilina'),
                                                                                    (1, 54, 50, 'Histología / Biopsia'),
                                                                                    (1, 55, 51, '<1 año'),
                                                                                    (1, 56, 52, 'No'),
                                                                                    (1, 57, 53, 'No'),
                                                                                    (1, 58, 54, 'Difuso'),
                                                                                    (1, 60, 55, 'Cuerpo'),
                                                                                    (1, 61, 56, 'T3N1M0'),
                                                                                    (2, 1, 57, 'Paciente Caso 2'),
                                                                                    (2, 2, 58, '912345678'),
                                                                                    (2, 3, 59, 'caso2@email.com'),
                                                                                    (2, 4, 60, '57'),
                                                                                    (2, 5, 61, 'Hombre'),
                                                                                    (2, 6, 62, 'Chilena'),
                                                                                    (2, 7, 63, 'Calle Rural 123'),
                                                                                    (2, 8, 64, 'Coihueco'),
                                                                                    (2, 9, 65, 'Chillán'),
                                                                                    (2, 10, 66, 'Rural'),
                                                                                    (2, 11, 67, 'Sí'),
                                                                                    (2, 12, 68, 'Básico'),
                                                                                    (2, 13, 69, 'Agricultor'),
                                                                                    (2, 14, 70, 'Fonasa'),
                                                                                    (2, 15, 71, 'Sí'),
                                                                                    (2, 16, 72, '01/03/2024'),
                                                                                    (2, 17, 73, 'Sí'),
                                                                                    (2, 18, 74, 'No'),
                                                                                    (2, 20, 75, 'Sí'),
                                                                                    (2, 21, 76, 'Gastritis crónica atrófica'),
                                                                                    (2, 22, 77, 'Sí'),
                                                                                    (2, 23, 78, 'Omeprazol'),
                                                                                    (2, 24, 79, 'No'),
                                                                                    (2, 25, 80, '62'),
                                                                                    (2, 27, 81, '1.65'),
                                                                                    (2, 26, 82, '22.8'),
                                                                                    (2, 28, 83, 'Fumador actual'),
                                                                                    (2, 29, 84, '≥20 cigarrillos/día (mucho)'),
                                                                                    (2, 30, 85, '>20 años'),
                                                                                    (2, 32, 86, 'Consumidor actual'),
                                                                                    (2, 33, 87, 'Frecuente (≥4 veces/semana)'),
                                                                                    (2, 34, 88, '≥5 tragos (mucho)'),
                                                                                    (2, 35, 89, '>20 años'),
                                                                                    (2, 37, 90, '≥3/sem'),
                                                                                    (2, 38, 91, 'Sí'),
                                                                                    (2, 39, 92, '≤2 porciones/día'),
                                                                                    (2, 40, 93, 'Sí'),
                                                                                    (2, 41, 94, '3 o más veces por semana'),
                                                                                    (2, 42, 95, '≥3/sem'),
                                                                                    (2, 43, 96, 'Sí'),
                                                                                    (2, 44, 97, 'No'),
                                                                                    (2, 46, 98, 'Diario'),
                                                                                    (2, 47, 99, 'Pozo'),
                                                                                    (2, 48, 100, 'Ninguno'),
                                                                                    (2, 49, 101, 'Positivo'),
                                                                                    (2, 50, 102, 'Sí'),
                                                                                    (2, 51, 103, '2015, Test de Aliento'),
                                                                                    (2, 52, 104, 'Sí'),
                                                                                    (2, 53, 105, '2015, Claritromicina + Amoxicilina'),
                                                                                    (2, 54, 106, 'Histología / Biopsia'),
                                                                                    (2, 55, 107, '<1 año'),
                                                                                    (2, 56, 108, 'No'),
                                                                                    (2, 57, 109, 'No'),
                                                                                    (2, 58, 110, 'Difuso'),
                                                                                    (2, 60, 111, 'Cuerpo'),
                                                                                    (2, 61, 112, 'T3N1M0'),
                                                                                    (3, 1, 113, 'Paciente Caso 3'),
                                                                                    (3, 2, 114, '912345678'),
                                                                                    (3, 3, 115, 'caso3@email.com'),
                                                                                    (3, 4, 116, '58'),
                                                                                    (3, 5, 117, 'Hombre'),
                                                                                    (3, 6, 118, 'Chilena'),
                                                                                    (3, 7, 119, 'Calle Rural 123'),
                                                                                    (3, 8, 120, 'Chillán'),
                                                                                    (3, 9, 121, 'Chillán'),
                                                                                    (3, 10, 122, 'Rural'),
                                                                                    (3, 11, 123, 'Sí'),
                                                                                    (3, 12, 124, 'Básico'),
                                                                                    (3, 13, 125, 'Agricultor'),
                                                                                    (3, 14, 126, 'Fonasa'),
                                                                                    (3, 15, 127, 'Sí'),
                                                                                    (3, 16, 128, '01/03/2024'),
                                                                                    (3, 17, 129, 'Sí'),
                                                                                    (3, 18, 130, 'No'),
                                                                                    (3, 20, 131, 'Sí'),
                                                                                    (3, 21, 132, 'Gastritis crónica atrófica'),
                                                                                    (3, 22, 133, 'Sí'),
                                                                                    (3, 23, 134, 'Omeprazol'),
                                                                                    (3, 24, 135, 'No'),
                                                                                    (3, 25, 136, '62'),
                                                                                    (3, 27, 137, '1.65'),
                                                                                    (3, 26, 138, '22.8'),
                                                                                    (3, 28, 139, 'Fumador actual'),
                                                                                    (3, 29, 140, '≥20 cigarrillos/día (mucho)'),
                                                                                    (3, 30, 141, '>20 años'),
                                                                                    (3, 32, 142, 'Consumidor actual'),
                                                                                    (3, 33, 143, 'Frecuente (≥4 veces/semana)'),
                                                                                    (3, 34, 144, '≥5 tragos (mucho)'),
                                                                                    (3, 35, 145, '>20 años'),
                                                                                    (3, 37, 146, '≥3/sem'),
                                                                                    (3, 38, 147, 'Sí'),
                                                                                    (3, 39, 148, '≤2 porciones/día'),
                                                                                    (3, 40, 149, 'Sí'),
                                                                                    (3, 41, 150, '3 o más veces por semana'),
                                                                                    (3, 42, 151, '≥3/sem'),
                                                                                    (3, 43, 152, 'Sí'),
                                                                                    (3, 44, 153, 'No'),
                                                                                    (3, 46, 154, 'Diario'),
                                                                                    (3, 47, 155, 'Pozo'),
                                                                                    (3, 48, 156, 'Ninguno'),
                                                                                    (3, 49, 157, 'Positivo'),
                                                                                    (3, 50, 158, 'Sí'),
                                                                                    (3, 51, 159, '2015, Test de Aliento'),
                                                                                    (3, 52, 160, 'Sí'),
                                                                                    (3, 53, 161, '2015, Claritromicina + Amoxicilina'),
                                                                                    (3, 54, 162, 'Histología / Biopsia'),
                                                                                    (3, 55, 163, '<1 año'),
                                                                                    (3, 56, 164, 'No'),
                                                                                    (3, 57, 165, 'No'),
                                                                                    (3, 58, 166, 'Difuso'),
                                                                                    (3, 60, 167, 'Cuerpo'),
                                                                                    (3, 61, 168, 'T3N1M0'),
                                                                                    (4, 1, 169, 'Paciente Caso 4'),
                                                                                    (4, 2, 170, '912345678'),
                                                                                    (4, 3, 171, 'caso4@email.com'),
                                                                                    (4, 4, 172, '59'),
                                                                                    (4, 5, 173, 'Hombre'),
                                                                                    (4, 6, 174, 'Chilena'),
                                                                                    (4, 7, 175, 'Calle Rural 123'),
                                                                                    (4, 8, 176, 'San Carlos'),
                                                                                    (4, 9, 177, 'Chillán'),
                                                                                    (4, 10, 178, 'Rural'),
                                                                                    (4, 11, 179, 'Sí'),
                                                                                    (4, 12, 180, 'Básico'),
                                                                                    (4, 13, 181, 'Agricultor'),
                                                                                    (4, 14, 182, 'Fonasa'),
                                                                                    (4, 15, 183, 'Sí'),
                                                                                    (4, 16, 184, '01/03/2024'),
                                                                                    (4, 17, 185, 'Sí'),
                                                                                    (4, 18, 186, 'No'),
                                                                                    (4, 20, 187, 'Sí'),
                                                                                    (4, 21, 188, 'Gastritis crónica atrófica'),
                                                                                    (4, 22, 189, 'Sí'),
                                                                                    (4, 23, 190, 'Omeprazol'),
                                                                                    (4, 24, 191, 'No'),
                                                                                    (4, 25, 192, '62'),
                                                                                    (4, 27, 193, '1.65'),
                                                                                    (4, 26, 194, '22.8'),
                                                                                    (4, 28, 195, 'Fumador actual'),
                                                                                    (4, 29, 196, '≥20 cigarrillos/día (mucho)'),
                                                                                    (4, 30, 197, '>20 años'),
                                                                                    (4, 32, 198, 'Consumidor actual'),
                                                                                    (4, 33, 199, 'Frecuente (≥4 veces/semana)'),
                                                                                    (4, 34, 200, '≥5 tragos (mucho)'),
                                                                                    (4, 35, 201, '>20 años'),
                                                                                    (4, 37, 202, '≥3/sem'),
                                                                                    (4, 38, 203, 'Sí'),
                                                                                    (4, 39, 204, '≤2 porciones/día'),
                                                                                    (4, 40, 205, 'Sí'),
                                                                                    (4, 41, 206, '3 o más veces por semana'),
                                                                                    (4, 42, 207, '≥3/sem'),
                                                                                    (4, 43, 208, 'Sí'),
                                                                                    (4, 44, 209, 'No'),
                                                                                    (4, 46, 210, 'Diario'),
                                                                                    (4, 47, 211, 'Pozo'),
                                                                                    (4, 48, 212, 'Ninguno'),
                                                                                    (4, 49, 213, 'Positivo'),
                                                                                    (4, 50, 214, 'Sí'),
                                                                                    (4, 51, 215, '2015, Test de Aliento'),
                                                                                    (4, 52, 216, 'Sí'),
                                                                                    (4, 53, 217, '2015, Claritromicina + Amoxicilina'),
                                                                                    (4, 54, 218, 'Histología / Biopsia'),
                                                                                    (4, 55, 219, '<1 año'),
                                                                                    (4, 56, 220, 'No'),
                                                                                    (4, 57, 221, 'No'),
                                                                                    (4, 58, 222, 'Difuso'),
                                                                                    (4, 60, 223, 'Cuerpo'),
                                                                                    (4, 61, 224, 'T3N1M0'),
                                                                                    (5, 1, 225, 'Paciente Caso 5'),
                                                                                    (5, 2, 226, '912345678'),
                                                                                    (5, 3, 227, 'caso5@email.com'),
                                                                                    (5, 4, 228, '60'),
                                                                                    (5, 5, 229, 'Hombre'),
                                                                                    (5, 6, 230, 'Chilena'),
                                                                                    (5, 7, 231, 'Calle Rural 123'),
                                                                                    (5, 8, 232, 'Coihueco'),
                                                                                    (5, 9, 233, 'Chillán'),
                                                                                    (5, 10, 234, 'Rural'),
                                                                                    (5, 11, 235, 'Sí'),
                                                                                    (5, 12, 236, 'Básico'),
                                                                                    (5, 13, 237, 'Agricultor'),
                                                                                    (5, 14, 238, 'Fonasa'),
                                                                                    (5, 15, 239, 'Sí'),
                                                                                    (5, 16, 240, '01/03/2024'),
                                                                                    (5, 17, 241, 'Sí'),
                                                                                    (5, 18, 242, 'No'),
                                                                                    (5, 20, 243, 'Sí'),
                                                                                    (5, 21, 244, 'Gastritis crónica atrófica'),
                                                                                    (5, 22, 245, 'Sí'),
                                                                                    (5, 23, 246, 'Omeprazol'),
                                                                                    (5, 24, 247, 'No'),
                                                                                    (5, 25, 248, '62'),
                                                                                    (5, 27, 249, '1.65'),
                                                                                    (5, 26, 250, '22.8'),
                                                                                    (5, 28, 251, 'Fumador actual'),
                                                                                    (5, 29, 252, '≥20 cigarrillos/día (mucho)'),
                                                                                    (5, 30, 253, '>20 años'),
                                                                                    (5, 32, 254, 'Consumidor actual'),
                                                                                    (5, 33, 255, 'Frecuente (≥4 veces/semana)'),
                                                                                    (5, 34, 256, '≥5 tragos (mucho)'),
                                                                                    (5, 35, 257, '>20 años'),
                                                                                    (5, 37, 258, '≥3/sem'),
                                                                                    (5, 38, 259, 'Sí'),
                                                                                    (5, 39, 260, '≤2 porciones/día'),
                                                                                    (5, 40, 261, 'Sí'),
                                                                                    (5, 41, 262, '3 o más veces por semana'),
                                                                                    (5, 42, 263, '≥3/sem'),
                                                                                    (5, 43, 264, 'Sí'),
                                                                                    (5, 44, 265, 'No'),
                                                                                    (5, 46, 266, 'Diario'),
                                                                                    (5, 47, 267, 'Pozo'),
                                                                                    (5, 48, 268, 'Ninguno'),
                                                                                    (5, 49, 269, 'Positivo'),
                                                                                    (5, 50, 270, 'Sí'),
                                                                                    (5, 51, 271, '2015, Test de Aliento'),
                                                                                    (5, 52, 272, 'Sí'),
                                                                                    (5, 53, 273, '2015, Claritromicina + Amoxicilina'),
                                                                                    (5, 54, 274, 'Histología / Biopsia'),
                                                                                    (5, 55, 275, '<1 año'),
                                                                                    (5, 56, 276, 'No'),
                                                                                    (5, 57, 277, 'No'),
                                                                                    (5, 58, 278, 'Difuso'),
                                                                                    (5, 60, 279, 'Cuerpo'),
                                                                                    (5, 61, 280, 'T3N1M0'),
                                                                                    (6, 1, 281, 'Paciente Control 1'),
                                                                                    (6, 2, 282, '987654321'),
                                                                                    (6, 3, 283, 'control1@email.com'),
                                                                                    (6, 4, 284, '46'),
                                                                                    (6, 5, 285, 'Mujer'),
                                                                                    (6, 6, 286, 'Chilena'),
                                                                                    (6, 7, 287, 'Av. Libertad 456'),
                                                                                    (6, 8, 288, 'Chillán'),
                                                                                    (6, 9, 289, 'Chillán'),
                                                                                    (6, 10, 290, 'Urbana'),
                                                                                    (6, 11, 291, 'Sí'),
                                                                                    (6, 12, 292, 'Superior'),
                                                                                    (6, 13, 293, 'Profesor'),
                                                                                    (6, 14, 294, 'Isapre'),
                                                                                    (6, 17, 295, 'No'),
                                                                                    (6, 18, 296, 'Sí'),
                                                                                    (6, 20, 297, 'No'),
                                                                                    (6, 22, 298, 'No'),
                                                                                    (6, 24, 299, 'No'),
                                                                                    (6, 25, 300, '75'),
                                                                                    (6, 27, 301, '1.70'),
                                                                                    (6, 26, 302, '25.9'),
                                                                                    (6, 28, 303, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (6, 32, 304, 'Consumidor actual'),
                                                                                    (6, 33, 305, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (6, 34, 306, '1–2 tragos (poco)'),
                                                                                    (6, 35, 307, '10–20 años'),
                                                                                    (6, 37, 308, '≤1/sem'),
                                                                                    (6, 38, 309, 'No'),
                                                                                    (6, 39, 310, '≥5 porciones/día'),
                                                                                    (6, 40, 311, 'No'),
                                                                                    (6, 41, 312, 'Casi nunca / Rara vez'),
                                                                                    (6, 42, 313, 'Nunca/Rara vez'),
                                                                                    (6, 43, 314, 'No'),
                                                                                    (6, 44, 315, 'No'),
                                                                                    (6, 46, 316, 'Nunca/Rara vez'),
                                                                                    (6, 47, 317, 'Red pública'),
                                                                                    (6, 48, 318, 'Ninguno'),
                                                                                    (6, 49, 319, 'Negativo'),
                                                                                    (6, 50, 320, 'No'),
                                                                                    (6, 52, 321, 'No'),
                                                                                    (6, 54, 322, 'Test de aliento (urea-C13/C14)'),
                                                                                    (6, 55, 323, '1–5 años'),
                                                                                    (6, 56, 324, 'No'),
                                                                                    (6, 57, 325, 'No'),
                                                                                    (7, 1, 326, 'Paciente Control 2'),
                                                                                    (7, 2, 327, '987654321'),
                                                                                    (7, 3, 328, 'control2@email.com'),
                                                                                    (7, 4, 329, '47'),
                                                                                    (7, 5, 330, 'Mujer'),
                                                                                    (7, 6, 331, 'Chilena'),
                                                                                    (7, 7, 332, 'Av. Libertad 456'),
                                                                                    (7, 8, 333, 'Chillán'),
                                                                                    (7, 9, 334, 'Chillán'),
                                                                                    (7, 10, 335, 'Urbana'),
                                                                                    (7, 11, 336, 'Sí'),
                                                                                    (7, 12, 337, 'Superior'),
                                                                                    (7, 13, 338, 'Profesor'),
                                                                                    (7, 14, 339, 'Isapre'),
                                                                                    (7, 17, 340, 'No'),
                                                                                    (7, 18, 341, 'Sí'),
                                                                                    (7, 20, 342, 'No'),
                                                                                    (7, 22, 343, 'No'),
                                                                                    (7, 24, 344, 'No'),
                                                                                    (7, 25, 345, '75'),
                                                                                    (7, 27, 346, '1.70'),
                                                                                    (7, 26, 347, '25.9'),
                                                                                    (7, 28, 348, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (7, 32, 349, 'Consumidor actual'),
                                                                                    (7, 33, 350, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (7, 34, 351, '1–2 tragos (poco)'),
                                                                                    (7, 35, 352, '10–20 años'),
                                                                                    (7, 37, 353, '≤1/sem'),
                                                                                    (7, 38, 354, 'No'),
                                                                                    (7, 39, 355, '≥5 porciones/día'),
                                                                                    (7, 40, 356, 'No'),
                                                                                    (7, 41, 357, 'Casi nunca / Rara vez'),
                                                                                    (7, 42, 358, 'Nunca/Rara vez'),
                                                                                    (7, 43, 359, 'No'),
                                                                                    (7, 44, 360, 'No'),
                                                                                    (7, 46, 361, 'Nunca/Rara vez'),
                                                                                    (7, 47, 362, 'Red pública'),
                                                                                    (7, 48, 363, 'Ninguno'),
                                                                                    (7, 49, 364, 'Negativo'),
                                                                                    (7, 50, 365, 'No'),
                                                                                    (7, 52, 366, 'No'),
                                                                                    (7, 54, 367, 'Test de aliento (urea-C13/C14)'),
                                                                                    (7, 55, 368, '1–5 años'),
                                                                                    (7, 56, 369, 'No'),
                                                                                    (7, 57, 370, 'No'),
                                                                                    (8, 1, 371, 'Paciente Control 3'),
                                                                                    (8, 2, 372, '987654321'),
                                                                                    (8, 3, 373, 'control3@email.com'),
                                                                                    (8, 4, 374, '48'),
                                                                                    (8, 5, 375, 'Mujer'),
                                                                                    (8, 6, 376, 'Chilena'),
                                                                                    (8, 7, 377, 'Av. Libertad 456'),
                                                                                    (8, 8, 378, 'Chillán'),
                                                                                    (8, 9, 379, 'Chillán'),
                                                                                    (8, 10, 380, 'Urbana'),
                                                                                    (8, 11, 381, 'Sí'),
                                                                                    (8, 12, 382, 'Superior'),
                                                                                    (8, 13, 383, 'Profesor'),
                                                                                    (8, 14, 384, 'Isapre'),
                                                                                    (8, 17, 385, 'No'),
                                                                                    (8, 18, 386, 'Sí'),
                                                                                    (8, 20, 387, 'No'),
                                                                                    (8, 22, 388, 'No'),
                                                                                    (8, 24, 389, 'No'),
                                                                                    (8, 25, 390, '75'),
                                                                                    (8, 27, 391, '1.70'),
                                                                                    (8, 26, 392, '25.9'),
                                                                                    (8, 28, 393, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (8, 32, 394, 'Consumidor actual'),
                                                                                    (8, 33, 395, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (8, 34, 396, '1–2 tragos (poco)'),
                                                                                    (8, 35, 397, '10–20 años'),
                                                                                    (8, 37, 398, '≤1/sem'),
                                                                                    (8, 38, 399, 'No'),
                                                                                    (8, 39, 400, '≥5 porciones/día'),
                                                                                    (8, 40, 401, 'No'),
                                                                                    (8, 41, 402, 'Casi nunca / Rara vez'),
                                                                                    (8, 42, 403, 'Nunca/Rara vez'),
                                                                                    (8, 43, 404, 'No'),
                                                                                    (8, 44, 405, 'No'),
                                                                                    (8, 46, 406, 'Nunca/Rara vez'),
                                                                                    (8, 47, 407, 'Red pública'),
                                                                                    (8, 48, 408, 'Ninguno'),
                                                                                    (8, 49, 409, 'Negativo'),
                                                                                    (8, 50, 410, 'No'),
                                                                                    (8, 52, 411, 'No'),
                                                                                    (8, 54, 412, 'Test de aliento (urea-C13/C14)'),
                                                                                    (8, 55, 413, '1–5 años'),
                                                                                    (8, 56, 414, 'No'),
                                                                                    (8, 57, 415, 'No'),
                                                                                    (9, 1, 416, 'Paciente Control 4'),
                                                                                    (9, 2, 417, '987654321'),
                                                                                    (9, 3, 418, 'control4@email.com'),
                                                                                    (9, 4, 419, '49'),
                                                                                    (9, 5, 420, 'Mujer'),
                                                                                    (9, 6, 421, 'Chilena'),
                                                                                    (9, 7, 422, 'Av. Libertad 456'),
                                                                                    (9, 8, 423, 'Chillán'),
                                                                                    (9, 9, 424, 'Chillán'),
                                                                                    (9, 10, 425, 'Urbana'),
                                                                                    (9, 11, 426, 'Sí'),
                                                                                    (9, 12, 427, 'Superior'),
                                                                                    (9, 13, 428, 'Profesor'),
                                                                                    (9, 14, 429, 'Isapre'),
                                                                                    (9, 17, 430, 'No'),
                                                                                    (9, 18, 431, 'Sí'),
                                                                                    (9, 20, 432, 'No'),
                                                                                    (9, 22, 433, 'No'),
                                                                                    (9, 24, 434, 'No'),
                                                                                    (9, 25, 435, '75'),
                                                                                    (9, 27, 436, '1.70'),
                                                                                    (9, 26, 437, '25.9'),
                                                                                    (9, 28, 438, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (9, 32, 439, 'Consumidor actual'),
                                                                                    (9, 33, 440, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (9, 34, 441, '1–2 tragos (poco)'),
                                                                                    (9, 35, 442, '10–20 años'),
                                                                                    (9, 37, 443, '≤1/sem'),
                                                                                    (9, 38, 444, 'No'),
                                                                                    (9, 39, 445, '≥5 porciones/día'),
                                                                                    (9, 40, 446, 'No'),
                                                                                    (9, 41, 447, 'Casi nunca / Rara vez'),
                                                                                    (9, 42, 448, 'Nunca/Rara vez'),
                                                                                    (9, 43, 449, 'No'),
                                                                                    (9, 44, 450, 'No'),
                                                                                    (9, 46, 451, 'Nunca/Rara vez'),
                                                                                    (9, 47, 452, 'Red pública'),
                                                                                    (9, 48, 453, 'Ninguno'),
                                                                                    (9, 49, 454, 'Negativo'),
                                                                                    (9, 50, 455, 'No'),
                                                                                    (9, 52, 456, 'No'),
                                                                                    (9, 54, 457, 'Test de aliento (urea-C13/C14)'),
                                                                                    (9, 55, 458, '1–5 años'),
                                                                                    (9, 56, 459, 'No'),
                                                                                    (9, 57, 460, 'No'),
                                                                                    (10, 1, 461, 'Paciente Control 5'),
                                                                                    (10, 2, 462, '987654321'),
                                                                                    (10, 3, 463, 'control5@email.com'),
                                                                                    (10, 4, 464, '50'),
                                                                                    (10, 5, 465, 'Mujer'),
                                                                                    (10, 6, 466, 'Chilena'),
                                                                                    (10, 7, 467, 'Av. Libertad 456'),
                                                                                    (10, 8, 468, 'Chillán'),
                                                                                    (10, 9, 469, 'Chillán'),
                                                                                    (10, 10, 470, 'Urbana'),
                                                                                    (10, 11, 471, 'Sí'),
                                                                                    (10, 12, 472, 'Superior'),
                                                                                    (10, 13, 473, 'Profesor'),
                                                                                    (10, 14, 474, 'Isapre'),
                                                                                    (10, 17, 475, 'No'),
                                                                                    (10, 18, 476, 'Sí'),
                                                                                    (10, 20, 477, 'No'),
                                                                                    (10, 22, 478, 'No'),
                                                                                    (10, 24, 479, 'No'),
                                                                                    (10, 25, 480, '75'),
                                                                                    (10, 27, 481, '1.70'),
                                                                                    (10, 26, 482, '25.9'),
                                                                                    (10, 28, 483, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (10, 32, 484, 'Consumidor actual'),
                                                                                    (10, 33, 485, 'Ocasional (menos de 1 vez/semana)'),
                                                                                    (10, 34, 486, '1–2 tragos (poco)'),
                                                                                    (10, 35, 487, '10–20 años'),
                                                                                    (10, 37, 488, '≤1/sem'),
                                                                                    (10, 38, 489, 'No'),
                                                                                    (10, 39, 490, '≥5 porciones/día'),
                                                                                    (10, 40, 491, 'No'),
                                                                                    (10, 41, 492, 'Casi nunca / Rara vez'),
                                                                                    (10, 42, 493, 'Nunca/Rara vez'),
                                                                                    (10, 43, 494, 'No'),
                                                                                    (10, 44, 495, 'No'),
                                                                                    (10, 46, 496, 'Nunca/Rara vez'),
                                                                                    (10, 47, 497, 'Red pública'),
                                                                                    (10, 48, 498, 'Ninguno'),
                                                                                    (10, 49, 499, 'Negativo'),
                                                                                    (10, 50, 500, 'No'),
                                                                                    (10, 52, 501, 'No'),
                                                                                    (10, 54, 502, 'Test de aliento (urea-C13/C14)'),
                                                                                    (10, 55, 503, '1–5 años'),
                                                                                    (10, 56, 504, 'No'),
                                                                                    (10, 57, 505, 'No');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
                       `rol_id` bigint(20) NOT NULL,
                       `nombre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`rol_id`, `nombre`) VALUES
                                           (1, 'ROLE_ADMIN'),
                                           (4, 'ROLE_ESTUDIANTE'),
                                           (3, 'ROLE_INVESTIGADOR'),
                                           (2, 'ROLE_MEDICO'),
                                           (5, 'ROLE_VISUALIZADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
                               `permiso_id` bigint(20) NOT NULL,
                               `rol_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol_permiso`
--

INSERT INTO `rol_permiso` (`permiso_id`, `rol_id`) VALUES
                                                       (1, 1),
                                                       (1, 2),
                                                       (2, 1),
                                                       (2, 2),
                                                       (2, 4),
                                                       (3, 1),
                                                       (3, 2),
                                                       (4, 1),
                                                       (4, 2),
                                                       (4, 4),
                                                       (5, 1),
                                                       (5, 2),
                                                       (5, 3),
                                                       (5, 4),
                                                       (6, 1),
                                                       (6, 2),
                                                       (6, 3),
                                                       (6, 4),
                                                       (6, 5),
                                                       (7, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
                           `activo` bit(1) DEFAULT NULL,
                           `id_usuario` bigint(20) NOT NULL,
                           `token_cambio_email_expiracion` datetime(6) DEFAULT NULL,
                           `token_rec_expiracion` datetime(6) DEFAULT NULL,
                           `apellidos` varchar(255) NOT NULL,
                           `contrasena` varchar(255) NOT NULL,
                           `email` varchar(255) NOT NULL,
                           `nombres` varchar(255) NOT NULL,
                           `rut` varchar(255) NOT NULL,
                           `telefono` varchar(255) DEFAULT NULL,
                           `token_cambio_email` varchar(255) DEFAULT NULL,
                           `token_recuperacion` varchar(255) DEFAULT NULL,
                           `foto_perfil` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`activo`, `id_usuario`, `token_cambio_email_expiracion`, `token_rec_expiracion`, `apellidos`, `contrasena`, `email`, `nombres`, `rut`, `telefono`, `token_cambio_email`, `token_recuperacion`, `foto_perfil`) VALUES
                                                                                                                                                                                                                                         (b'1', 1, NULL, NULL, 'General', '$2a$10$4HXkHDBf7oi9SpZJ/Srl7O8.IzcgjhVDkYhO7P6djmAG2vxoA1K2S', 'admin@hospital.cl', 'Admin', '11.111.111-1', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 2, NULL, NULL, 'Pérez', '$2a$10$Ya6e8PEISNtV7KjIcyD3v.en6mmHDWXw1h6MsA.TadfxeATQ3t766', 'medico@hospital.cl', 'Dr. Juan', '22.222.222-2', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 3, NULL, NULL, 'Silva', '$2a$10$ppUQLOL1ljb0ctuO60AYHOrvCgXHo2yyo2TMwF7Kysy9D6ZFvmrH.', 'investigacion@ubiobio.cl', 'Ana', '33.333.333-3', NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                         (b'1', 4, NULL, NULL, 'Estudiante', '$2a$10$NDCjMWaZWXSoBz/OyP6sQOmNlbkWWXp71Invmx0x2mHCo9ebOIDOS', 'pedro@alumnos.cl', 'Pedro', '44.444.444-4', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_rol`
--

CREATE TABLE `usuario_rol` (
                               `rol_id` bigint(20) NOT NULL,
                               `usuario_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_rol`
--

INSERT INTO `usuario_rol` (`rol_id`, `usuario_id`) VALUES
                                                       (1, 1),
                                                       (2, 2),
                                                       (3, 3),
                                                       (4, 4);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
    ADD PRIMARY KEY (`id_cat`);

--
-- Indices de la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FKnvjsi51uco733s2n6ep9pay8k` (`destinatario_id`),
  ADD KEY `FKqyl87cej61sep55uuin3t5yrj` (`mensaje_id`);

--
-- Indices de la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    ADD PRIMARY KEY (`id_dicotomizacion`),
  ADD KEY `FKgjwmkfv176urksoaxmb08qwjb` (`pregunta_id`);

--
-- Indices de la tabla `mensaje`
--
ALTER TABLE `mensaje`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FK9iju1ryvmblhnq7cilb3mqvg0` (`emisor_id`);

--
-- Indices de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    ADD PRIMARY KEY (`id_opcion`),
  ADD KEY `FKljlpfii82o9ichkq7pqxs7jpo` (`pregunta_id`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
    ADD PRIMARY KEY (`participante_id`),
  ADD UNIQUE KEY `UKqyuxt0wy3e9w3grxt1id54r55` (`participante_cod`),
  ADD KEY `FKk850gvh3kplkn9f9mdainwuqq` (`reclutador_id`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
    ADD PRIMARY KEY (`id_perm`),
  ADD UNIQUE KEY `UKnwe6lkk7x7sbw94xcmbwgvycu` (`nombre`);

--
-- Indices de la tabla `preguntas`
--
ALTER TABLE `preguntas`
    ADD PRIMARY KEY (`pregunta_id`),
  ADD KEY `FKax8hwm2wxx26i9ntdvq4iox5x` (`id_cat`);

--
-- Indices de la tabla `registro`
--
ALTER TABLE `registro`
    ADD PRIMARY KEY (`registro_id`),
  ADD KEY `FKhhjtfebyk33a740ix5smgwqyc` (`respuesta_id`),
  ADD KEY `FKqfbdwuu2isbwwnx1uky39930w` (`usuario_id`);

--
-- Indices de la tabla `respuesta`
--
ALTER TABLE `respuesta`
    ADD PRIMARY KEY (`respuesta_id`),
  ADD KEY `FK7axh6xp0twctrjpq7d8ngdcu7` (`paciente_id`),
  ADD KEY `FKmlq7l9u0bpvxor26presg5x84` (`pregunta_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
    ADD PRIMARY KEY (`rol_id`),
  ADD UNIQUE KEY `UK43kr6s7bts1wqfv43f7jd87kp` (`nombre`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
    ADD PRIMARY KEY (`permiso_id`,`rol_id`),
  ADD KEY `FK6o522368i97la9m9cqn0gul2e` (`rol_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
    ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `UKjx61a01wwidax9iafoa3xj22i` (`rut`);

--
-- Indices de la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
    ADD PRIMARY KEY (`rol_id`,`usuario_id`),
  ADD KEY `FKbyfgloj439r9wr9smrms9u33r` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
    MODIFY `id_cat` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    MODIFY `id_dicotomizacion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `mensaje`
--
ALTER TABLE `mensaje`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    MODIFY `id_opcion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
    MODIFY `participante_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
    MODIFY `id_perm` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `preguntas`
--
ALTER TABLE `preguntas`
    MODIFY `pregunta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
    MODIFY `registro_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=516;

--
-- AUTO_INCREMENT de la tabla `respuesta`
--
ALTER TABLE `respuesta`
    MODIFY `respuesta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=506;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
    MODIFY `rol_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
    MODIFY `id_usuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `destinatario_mensaje`
--
ALTER TABLE `destinatario_mensaje`
    ADD CONSTRAINT `FKnvjsi51uco733s2n6ep9pay8k` FOREIGN KEY (`destinatario_id`) REFERENCES `usuario` (`id_usuario`),
  ADD CONSTRAINT `FKqyl87cej61sep55uuin3t5yrj` FOREIGN KEY (`mensaje_id`) REFERENCES `mensaje` (`id`);

--
-- Filtros para la tabla `dicotomizaciones`
--
ALTER TABLE `dicotomizaciones`
    ADD CONSTRAINT `FKgjwmkfv176urksoaxmb08qwjb` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `mensaje`
--
ALTER TABLE `mensaje`
    ADD CONSTRAINT `FK9iju1ryvmblhnq7cilb3mqvg0` FOREIGN KEY (`emisor_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    ADD CONSTRAINT `FKljlpfii82o9ichkq7pqxs7jpo` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
    ADD CONSTRAINT `FKk850gvh3kplkn9f9mdainwuqq` FOREIGN KEY (`reclutador_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `preguntas`
--
ALTER TABLE `preguntas`
    ADD CONSTRAINT `FKax8hwm2wxx26i9ntdvq4iox5x` FOREIGN KEY (`id_cat`) REFERENCES `categoria` (`id_cat`);

--
-- Filtros para la tabla `registro`
--
ALTER TABLE `registro`
    ADD CONSTRAINT `FKhhjtfebyk33a740ix5smgwqyc` FOREIGN KEY (`respuesta_id`) REFERENCES `respuesta` (`respuesta_id`),
  ADD CONSTRAINT `FKqfbdwuu2isbwwnx1uky39930w` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `respuesta`
--
ALTER TABLE `respuesta`
    ADD CONSTRAINT `FK7axh6xp0twctrjpq7d8ngdcu7` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`participante_id`),
  ADD CONSTRAINT `FKmlq7l9u0bpvxor26presg5x84` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`);

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
    ADD CONSTRAINT `FK6o522368i97la9m9cqn0gul2e` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`),
  ADD CONSTRAINT `FKfyao8wd0o5tsyem1w55s3141k` FOREIGN KEY (`permiso_id`) REFERENCES `permiso` (`id_perm`);

--
-- Filtros para la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
    ADD CONSTRAINT `FK610kvhkwcqk2pxeewur4l7bd1` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`),
  ADD CONSTRAINT `FKbyfgloj439r9wr9smrms9u33r` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

ADD CONSTRAINT `FK6o522368i97la9m9cqn0gul2e` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`),
  ADD CONSTRAINT `FKfyao8wd0o5tsyem1w55s3141k` FOREIGN KEY (`permiso_id`) REFERENCES `permiso` (`id_perm`);

--
-- Filtros para la tabla `usuario_rol`
--
ALTER TABLE `usuario_rol`
    ADD CONSTRAINT `FK610kvhkwcqk2pxeewur4l7bd1` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`rol_id`),
  ADD CONSTRAINT `FKbyfgloj439r9wr9smrms9u33r` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
