-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-12-2025 a las 19:29:45
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
                                                          (4, 4, '4. Variables antropométricas'),
                                                          (5, 5, '5. Tabaquismo'),
                                                          (6, 6, '6. Consumo de alcohol'),
                                                          (7, 7, '7. Factores dietarios y ambientales'),
                                                          (8, 8, '8. Infección por Helicobacter pylori'),
                                                          (9, 9, '9. Histopatología (solo casos)');

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
-- Estructura de tabla para la tabla `muestra_genetica`
--

CREATE TABLE `muestra_genetica` (
                                    `id_muestra` bigint(20) NOT NULL,
                                    `id_snp` bigint(20) NOT NULL,
                                    `participante_id` bigint(20) NOT NULL,
                                    `resultado` varchar(255) NOT NULL
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
                                                                                                          (0, NULL, 1, 5, 'Hombre'),
                                                                                                          (1, NULL, 2, 5, 'Mujer'),
                                                                                                          (0, NULL, 3, 10, 'Urbana'),
                                                                                                          (1, NULL, 4, 10, 'Rural'),
                                                                                                          (0, NULL, 5, 11, 'Sí'),
                                                                                                          (1, NULL, 6, 11, 'No'),
                                                                                                          (0, NULL, 7, 12, 'Básico'),
                                                                                                          (1, NULL, 8, 12, 'Medio'),
                                                                                                          (2, NULL, 9, 12, 'Superior'),
                                                                                                          (0, NULL, 10, 14, 'Fonasa'),
                                                                                                          (1, NULL, 11, 14, 'Isapre'),
                                                                                                          (2, NULL, 12, 14, 'Capredena / Dipreca'),
                                                                                                          (3, NULL, 13, 14, 'Sin previsión'),
                                                                                                          (4, NULL, 14, 14, 'Otra'),
                                                                                                          (0, NULL, 15, 15, 'Sí'),
                                                                                                          (1, NULL, 16, 15, 'No'),
                                                                                                          (0, NULL, 17, 17, 'Sí'),
                                                                                                          (1, NULL, 18, 17, 'No'),
                                                                                                          (0, NULL, 19, 18, 'Sí'),
                                                                                                          (1, NULL, 20, 18, 'No'),
                                                                                                          (0, NULL, 21, 21, 'Sí'),
                                                                                                          (1, NULL, 22, 21, 'No'),
                                                                                                          (0, NULL, 23, 23, 'Sí'),
                                                                                                          (1, NULL, 24, 23, 'No'),
                                                                                                          (0, NULL, 25, 27, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                                          (1, NULL, 26, 27, 'Exfumador'),
                                                                                                          (2, NULL, 27, 27, 'Fumador actual'),
                                                                                                          (0, NULL, 28, 28, '1–9 cigarrillos/día (poco)'),
                                                                                                          (1, NULL, 29, 28, '10–19 cigarrillos/día (moderado)'),
                                                                                                          (2, NULL, 30, 28, '≥20 cigarrillos/día (mucho)'),
                                                                                                          (0, NULL, 31, 29, '<10 años'),
                                                                                                          (1, NULL, 32, 29, '10–20 años'),
                                                                                                          (2, NULL, 33, 29, '>20 años'),
                                                                                                          (0, NULL, 34, 30, '<5 años'),
                                                                                                          (1, NULL, 35, 30, '5–10 años'),
                                                                                                          (2, NULL, 36, 30, '>10 años'),
                                                                                                          (0, NULL, 37, 31, 'Nunca'),
                                                                                                          (1, NULL, 38, 31, 'Exconsumidor'),
                                                                                                          (2, NULL, 39, 31, 'Consumidor actual'),
                                                                                                          (0, NULL, 40, 32, 'Ocasional (menos de 1 vez/semana)'),
                                                                                                          (1, NULL, 41, 32, 'Regular (1–3 veces/semana)'),
                                                                                                          (2, NULL, 42, 32, 'Frecuente (≥4 veces/semana)'),
                                                                                                          (0, NULL, 43, 33, '1–2 tragos (poco)'),
                                                                                                          (1, NULL, 44, 33, '3–4 tragos (moderado)'),
                                                                                                          (2, NULL, 45, 33, '≥5 tragos (mucho)'),
                                                                                                          (0, NULL, 46, 34, '<10 años'),
                                                                                                          (1, NULL, 47, 34, '10–20 años'),
                                                                                                          (2, NULL, 48, 34, '>20 años'),
                                                                                                          (0, NULL, 49, 35, '<5 años'),
                                                                                                          (1, NULL, 50, 35, '5–10 años'),
                                                                                                          (2, NULL, 51, 35, '>10 años'),
                                                                                                          (0, NULL, 52, 36, '≤1/sem'),
                                                                                                          (1, NULL, 53, 36, '2/sem'),
                                                                                                          (2, NULL, 54, 36, '≥3/sem'),
                                                                                                          (0, NULL, 55, 37, 'Sí'),
                                                                                                          (1, NULL, 56, 37, 'No'),
                                                                                                          (0, NULL, 57, 38, '≥5 porciones/día'),
                                                                                                          (1, NULL, 58, 38, '3–4 porciones/día'),
                                                                                                          (2, NULL, 59, 38, '≤2 porciones/día'),
                                                                                                          (0, NULL, 60, 39, 'Sí'),
                                                                                                          (1, NULL, 61, 39, 'No'),
                                                                                                          (0, NULL, 62, 40, 'Casi nunca / Rara vez'),
                                                                                                          (1, NULL, 63, 40, '1 a 2 veces por semana'),
                                                                                                          (2, NULL, 64, 40, '3 o más veces por semana'),
                                                                                                          (0, NULL, 65, 41, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 66, 41, '1–2/sem'),
                                                                                                          (2, NULL, 67, 41, '≥3/sem'),
                                                                                                          (0, NULL, 68, 42, 'Sí'),
                                                                                                          (1, NULL, 69, 42, 'No'),
                                                                                                          (0, NULL, 70, 43, 'Sí'),
                                                                                                          (1, NULL, 71, 43, 'No'),
                                                                                                          (0, NULL, 72, 45, 'Nunca/Rara vez'),
                                                                                                          (1, NULL, 73, 45, 'Estacional'),
                                                                                                          (2, NULL, 74, 45, 'Diario'),
                                                                                                          (0, NULL, 75, 46, 'Red pública'),
                                                                                                          (1, NULL, 76, 46, 'Pozo'),
                                                                                                          (2, NULL, 77, 46, 'Camión aljibe'),
                                                                                                          (3, NULL, 78, 46, 'Otra'),
                                                                                                          (0, NULL, 79, 47, 'Ninguno'),
                                                                                                          (1, NULL, 80, 47, 'Hervir'),
                                                                                                          (2, NULL, 81, 47, 'Filtro'),
                                                                                                          (3, NULL, 82, 47, 'Cloro'),
                                                                                                          (0, NULL, 83, 48, 'Positivo'),
                                                                                                          (1, NULL, 84, 48, 'Negativo'),
                                                                                                          (2, NULL, 85, 48, 'Desconocido'),
                                                                                                          (0, NULL, 86, 49, 'Sí'),
                                                                                                          (1, NULL, 87, 49, 'No'),
                                                                                                          (2, NULL, 88, 49, 'No recuerda'),
                                                                                                          (0, NULL, 89, 50, 'Sí'),
                                                                                                          (1, NULL, 90, 50, 'No'),
                                                                                                          (2, NULL, 91, 50, 'No recuerda'),
                                                                                                          (0, NULL, 92, 51, 'Test de aliento'),
                                                                                                          (1, NULL, 93, 51, 'Antígeno en deposiciones'),
                                                                                                          (2, NULL, 94, 51, 'Serología (IgG)'),
                                                                                                          (3, NULL, 95, 51, 'Test rápido'),
                                                                                                          (4, NULL, 96, 51, 'Histología'),
                                                                                                          (5, NULL, 97, 51, 'Otro'),
                                                                                                          (0, NULL, 98, 52, '<1 año'),
                                                                                                          (1, NULL, 99, 52, '1–5 años'),
                                                                                                          (2, NULL, 100, 52, '>5 años'),
                                                                                                          (0, NULL, 101, 53, 'Sí'),
                                                                                                          (1, NULL, 102, 53, 'No'),
                                                                                                          (2, NULL, 103, 53, 'No recuerda'),
                                                                                                          (0, NULL, 104, 54, 'Sí'),
                                                                                                          (1, NULL, 105, 54, 'No'),
                                                                                                          (0, NULL, 106, 55, 'Intestinal'),
                                                                                                          (1, NULL, 107, 55, 'Difuso'),
                                                                                                          (2, NULL, 108, 55, 'Mixto'),
                                                                                                          (3, NULL, 109, 55, 'Otro'),
                                                                                                          (0, NULL, 110, 56, 'Cardias'),
                                                                                                          (1, NULL, 111, 56, 'Cuerpo'),
                                                                                                          (2, NULL, 112, 56, 'Antro'),
                                                                                                          (3, NULL, 113, 56, 'Difuso');

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
                                                                                                                       (b'1', b'1', '2025-12-13', 1, 2, 'CAS_001'),
                                                                                                                       (b'1', b'1', '2025-12-13', 2, 2, 'CAS_002'),
                                                                                                                       (b'1', b'1', '2025-12-13', 3, 2, 'CAS_003'),
                                                                                                                       (b'1', b'1', '2025-12-13', 4, 2, 'CAS_004'),
                                                                                                                       (b'1', b'1', '2025-12-13', 5, 2, 'CAS_005'),
                                                                                                                       (b'1', b'1', '2025-12-13', 6, 2, 'CAS_006'),
                                                                                                                       (b'1', b'1', '2025-12-13', 7, 2, 'CAS_007'),
                                                                                                                       (b'1', b'1', '2025-12-13', 8, 2, 'CAS_008'),
                                                                                                                       (b'1', b'1', '2025-12-13', 9, 2, 'CAS_009'),
                                                                                                                       (b'1', b'1', '2025-12-13', 10, 2, 'CAS_010'),
                                                                                                                       (b'1', b'0', '2025-12-13', 11, 1, 'CONT_001'),
                                                                                                                       (b'1', b'0', '2025-12-13', 12, 1, 'CONT_002'),
                                                                                                                       (b'1', b'0', '2025-12-13', 13, 1, 'CONT_003'),
                                                                                                                       (b'1', b'0', '2025-12-13', 14, 1, 'CONT_004'),
                                                                                                                       (b'1', b'0', '2025-12-13', 15, 1, 'CONT_005'),
                                                                                                                       (b'1', b'0', '2025-12-13', 16, 1, 'CONT_006'),
                                                                                                                       (b'1', b'0', '2025-12-13', 17, 1, 'CONT_007'),
                                                                                                                       (b'1', b'0', '2025-12-13', 18, 1, 'CONT_008'),
                                                                                                                       (b'1', b'0', '2025-12-13', 19, 1, 'CONT_009'),
                                                                                                                       (b'1', b'0', '2025-12-13', 20, 1, 'CONT_010');

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
                             `solo_casos` tinyint(1) DEFAULT 0,
                             `id_cat` bigint(20) DEFAULT NULL,
                             `pregunta_controladora_id` bigint(20) DEFAULT NULL,
                             `pregunta_id` bigint(20) NOT NULL,
                             `accion_si_no_cumple` varchar(20) DEFAULT NULL,
                             `valor_esperado_controladora` varchar(500) DEFAULT NULL,
                             `codigo_stata` varchar(255) DEFAULT NULL,
                             `descripcion` varchar(255) DEFAULT NULL,
                             `etiqueta` varchar(255) DEFAULT NULL,
                             `tipo_corte` enum('MEDIA','MEDIANA','NINGUNO','VALOR_FIJO') DEFAULT NULL,
                             `tipo_dato` enum('CELULAR','EMAIL','ENUM','NUMERO','RUT','TEXTO') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `preguntas`
--

INSERT INTO `preguntas` (`activo`, `dato_sensible`, `exportable`, `generar_estadistica`, `orden`, `solo_casos`, `id_cat`, `pregunta_controladora_id`, `pregunta_id`, `accion_si_no_cumple`, `valor_esperado_controladora`, `codigo_stata`, `descripcion`, `etiqueta`, `tipo_corte`, `tipo_dato`) VALUES
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 1, 0, 1, NULL, 1, NULL, NULL, 'Nombre', 'Nombre completo', 'Nombre completo', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 2, 0, 1, NULL, 2, NULL, NULL, 'Telefono', 'Teléfono', 'Teléfono', 'NINGUNO', 'CELULAR'),
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 3, 0, 1, NULL, 3, NULL, NULL, 'Email', 'Correo electrónico', 'Correo electrónico', 'NINGUNO', 'EMAIL'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 2, NULL, 4, NULL, NULL, 'Edad', 'Edad', 'Edad', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 2, NULL, 5, NULL, NULL, 'Sexo', 'Sexo', 'Sexo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 3, 0, 2, NULL, 6, NULL, NULL, 'Nacionalidad', 'Nacionalidad', 'Nacionalidad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 4, 0, 2, NULL, 7, NULL, NULL, 'Direccion', 'Dirección', 'Dirección', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 5, 0, 2, NULL, 8, NULL, NULL, 'Comuna', 'Comuna', 'Comuna', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'1', b'0', b'0', 6, 0, 2, NULL, 9, NULL, NULL, 'Ciudad', 'Ciudad', 'Ciudad', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 0, 2, NULL, 10, NULL, NULL, 'Zona', 'Zona', 'Zona', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 0, 2, NULL, 11, NULL, NULL, 'Residencia_Urbana5', '¿Vive usted en esta zona desde hace más de 5 años?', '¿Vive usted en esta zona desde hace más de 5 años?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 0, 2, NULL, 12, NULL, NULL, 'NivelEduc', 'Nivel educacional', 'Nivel educacional', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 10, 0, 2, NULL, 13, NULL, NULL, 'Ocupacion', 'Ocupación actual', 'Ocupación actual', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 0, 2, NULL, 14, NULL, NULL, 'Prevision_FonasaVsOtros', 'Previsión de salud actual', 'Previsión de salud actual', 'VALOR_FIJO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 1, 1, 3, NULL, 15, NULL, NULL, 'Diag_Adenocarcinoma', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 2, 1, 3, NULL, 16, NULL, NULL, 'Fecha_Diag', 'Fecha de diagnóstico (solo casos)', 'Fecha de diagnóstico (solo casos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 3, NULL, 17, NULL, NULL, 'CA_FamiliaGastrico', 'Antecedentes familiares de cáncer gástrico', 'Antecedentes familiares de cáncer gástrico', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 0, 3, 17, 18, 'OCULTAR', 'Sí', 'CA_FamiliaOtros', 'Antecedentes familiares de otros tipos de cáncer', 'Antecedentes familiares de otros tipos de cáncer', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 5, 0, 3, 18, 19, 'OCULTAR', 'Sí', 'CA_FamiliaOtros_Detalle', '¿Cuál(es)? (Otros cánceres)', '¿Cuál(es)? (Otros cánceres)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 6, 0, 3, NULL, 20, NULL, NULL, 'EnfermedadesRelevantes', 'Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)', 'Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 0, 3, NULL, 21, NULL, NULL, 'UsoCronico_Medicamentos', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'Uso crónico de medicamentos gastrolesivos (AINES u otros)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 8, 0, 3, 21, 22, 'OCULTAR', 'Sí', 'UsoCronico_Detalle', 'Especificar cuál (Medicamentos)', 'Especificar cuál (Medicamentos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 9, 0, 3, NULL, 23, NULL, NULL, 'CirugiaGastricaPrevia', 'Cirugía gástrica previa (gastrectomía parcial)', 'Cirugía gástrica previa (gastrectomía parcial)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 4, NULL, 24, NULL, NULL, 'Peso', 'Peso (kg)', 'Peso (kg)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 4, NULL, 25, NULL, NULL, 'Estatura', 'Estatura (m)', 'Estatura (m)', 'MEDIA', 'NUMERO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 4, NULL, 26, NULL, NULL, 'IMC', 'Índice de masa corporal (IMC)', 'Índice de masa corporal (IMC)', 'VALOR_FIJO', 'NUMERO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 5, NULL, 27, NULL, NULL, 'tabaco_estado', 'Estado de tabaquismo', 'Estado de tabaquismo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 5, 27, 28, 'OCULTAR', 'Fumador actual|Exfumador', 'tabaco_cantidad', 'Cantidad promedio fumada', 'Cantidad promedio fumada', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 5, 27, 29, 'OCULTAR', 'Fumador actual|Exfumador', 'tabaco_tiempo_total', 'Tiempo total fumando', 'Tiempo total fumando', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 0, 5, 27, 30, 'OCULTAR', 'Exfumador', 'tabaco_exfumador_tiempo', 'Si exfumador: tiempo desde que dejó de fumar', 'Si exfumador: tiempo desde que dejó de fumar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 6, NULL, 31, NULL, NULL, 'alcohol_estado', 'Estado de consumo', 'Estado de consumo', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 6, 31, 32, 'OCULTAR', 'Consumidor actual|Exconsumidor', 'alcohol_frecuencia', 'Frecuencia', 'Frecuencia', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 6, 31, 33, 'OCULTAR', 'Consumidor actual|Exconsumidor', 'alcohol_cantidad', 'Cantidad típica por ocasión', 'Cantidad típica por ocasión', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 0, 6, 31, 34, 'OCULTAR', 'Consumidor actual|Exconsumidor', 'alcohol_tiempo_total', 'Años de consumo habitual', 'Años de consumo habitual', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 0, 6, 31, 35, 'OCULTAR', 'Exconsumidor', 'alcohol_exconsumidor_tiempo', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'Si exconsumidor: tiempo desde que dejó de beber regularmente', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 7, NULL, 36, NULL, NULL, 'diet_carnes', 'Consumo de carnes procesadas/cecinas', 'Consumo de carnes procesadas/cecinas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 7, NULL, 37, NULL, NULL, 'diet_sal', 'Consumo de alimentos muy salados', 'Consumo de alimentos muy salados', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 7, NULL, 38, NULL, NULL, 'diet_frutas_verduras', 'Consumo de porciones de frutas y verduras frescas', 'Consumo de porciones de frutas y verduras frescas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 0, 7, NULL, 39, NULL, NULL, 'diet_frituras', 'Consumo frecuente de frituras (≥3 veces por semana)', 'Consumo frecuente de frituras (≥3 veces por semana)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 0, 7, NULL, 40, NULL, NULL, 'diet_condimentos', 'Consumo de alimentos muy condimentados', 'Consumo de alimentos muy condimentados', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 0, 7, NULL, 41, NULL, NULL, 'diet_bebidas_calientes', 'Consumo de infusiones o bebidas muy calientes', 'Consumo de infusiones o bebidas muy calientes', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 0, 7, NULL, 42, NULL, NULL, 'amb_pesticidas', 'Exposición ocupacional a pesticidas', 'Exposición ocupacional a pesticidas', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 8, 0, 7, NULL, 43, NULL, NULL, 'amb_quimicos', 'Exposición a otros compuestos químicos', 'Exposición a otros compuestos químicos', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'0', b'0', 9, 0, 7, 43, 44, 'OCULTAR', 'Sí', 'amb_quimicos_detalle', '¿Cuál(es)? (Químicos)', '¿Cuál(es)? (Químicos)', 'NINGUNO', 'TEXTO'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 10, 0, 7, NULL, 45, NULL, NULL, 'amb_lena', 'Humo de leña en el hogar', 'Humo de leña en el hogar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 11, 0, 7, NULL, 46, NULL, NULL, 'amb_agua_fuente', 'Fuente principal de agua en el hogar', 'Fuente principal de agua en el hogar', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 12, 0, 7, NULL, 47, NULL, NULL, 'amb_agua_tratamiento', 'Tratamiento del agua en casa', 'Tratamiento del agua en casa', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 0, 8, NULL, 48, NULL, NULL, 'hp_resultado', 'Resultado del examen para Helicobacter pylori', 'Resultado del examen para Helicobacter pylori', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 0, 8, 48, 49, 'OCULTAR', 'Negativo|Desconocido', 'hp_pasado_positivo', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', '¿Ha tenido alguna vez un resultado POSITIVO para H. pylori en el pasado?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 0, 8, 48, 50, 'OCULTAR', 'Negativo|Desconocido', 'hp_tratamiento', '¿Recibió tratamiento para erradicación de H. pylori?', '¿Recibió tratamiento para erradicación de H. pylori?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 4, 0, 8, NULL, 51, NULL, NULL, 'hp_tipo_examen', 'Tipo de examen realizado', 'Tipo de examen realizado', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 5, 0, 8, NULL, 52, NULL, NULL, 'hp_tiempo_test', '¿Hace cuánto tiempo se realizó el test?', '¿Hace cuánto tiempo se realizó el test?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 6, 0, 8, NULL, 53, NULL, NULL, 'hp_uso_ibp', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'Uso de antibióticos o IBP en las 4 semanas previas al examen', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 7, 0, 8, NULL, 54, NULL, NULL, 'hp_repetido', '¿Ha repetido el examen posteriormente?', '¿Ha repetido el examen posteriormente?', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 1, 1, 9, NULL, 55, NULL, NULL, 'Histologia_Tipo', 'Tipo histológico (solo casos)', 'Tipo histológico (solo casos)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 2, 1, 9, NULL, 56, NULL, NULL, 'Histologia_Localizacion', 'Localización tumoral (solo casos)', 'Localización tumoral (solo casos)', 'NINGUNO', 'ENUM'),
                                                                                                                                                                                                                                                                                                     (b'1', b'0', b'1', b'1', 3, 1, 9, NULL, 57, NULL, NULL, 'histo_tnm', 'Estadio clínico (TNM) (solo casos)', 'Estadio clínico (TNM) (solo casos)', 'NINGUNO', 'TEXTO');

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
                                                                                                                 ('2025-12-13 15:28:27.000000', 1, NULL, 1, 'Paciente creado con codigo: CAS_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:28.000000', 2, NULL, 1, 'Paciente creado con codigo: CAS_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:29.000000', 3, NULL, 1, 'Paciente creado con codigo: CAS_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:31.000000', 4, NULL, 1, 'Paciente creado con codigo: CAS_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:33.000000', 5, NULL, 1, 'Paciente creado con codigo: CAS_005', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:34.000000', 6, NULL, 1, 'Paciente creado con codigo: CAS_006', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:35.000000', 7, NULL, 1, 'Paciente creado con codigo: CAS_007', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:37.000000', 8, NULL, 1, 'Paciente creado con codigo: CAS_008', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:38.000000', 9, NULL, 1, 'Paciente creado con codigo: CAS_009', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:39.000000', 10, NULL, 1, 'Paciente creado con codigo: CAS_010', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:40.000000', 11, NULL, 2, 'Paciente creado con codigo: CONT_001', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:41.000000', 12, NULL, 2, 'Paciente creado con codigo: CONT_002', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:41.000000', 13, NULL, 2, 'Paciente creado con codigo: CONT_003', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:42.000000', 14, NULL, 2, 'Paciente creado con codigo: CONT_004', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:42.000000', 15, NULL, 2, 'Paciente creado con codigo: CONT_005', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:43.000000', 16, NULL, 2, 'Paciente creado con codigo: CONT_006', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:44.000000', 17, NULL, 2, 'Paciente creado con codigo: CONT_007', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:45.000000', 18, NULL, 2, 'Paciente creado con codigo: CONT_008', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:45.000000', 19, NULL, 2, 'Paciente creado con codigo: CONT_009', 'CREAR_PACIENTE'),
                                                                                                                 ('2025-12-13 15:28:46.000000', 20, NULL, 2, 'Paciente creado con codigo: CONT_010', 'CREAR_PACIENTE');

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
                                                                                    (1, 2, 2, '912345001'),
                                                                                    (1, 3, 3, 'caso1@email.com'),
                                                                                    (1, 4, 4, '56'),
                                                                                    (1, 5, 5, 'Mujer'),
                                                                                    (1, 6, 6, 'Chilena'),
                                                                                    (1, 7, 7, 'Calle Rural 101'),
                                                                                    (1, 8, 8, 'San Carlos'),
                                                                                    (1, 9, 9, 'Chillán'),
                                                                                    (1, 10, 10, 'Rural'),
                                                                                    (1, 11, 11, 'Sí'),
                                                                                    (1, 12, 12, 'Básico'),
                                                                                    (1, 13, 13, 'Agricultor'),
                                                                                    (1, 14, 14, 'Fonasa'),
                                                                                    (1, 15, 15, 'Sí'),
                                                                                    (1, 16, 16, '01/02/2024'),
                                                                                    (1, 17, 17, 'Sí'),
                                                                                    (1, 18, 18, 'Sí'),
                                                                                    (1, 19, 19, 'Colon'),
                                                                                    (1, 20, 20, 'Gastritis crónica'),
                                                                                    (1, 21, 21, 'Sí'),
                                                                                    (1, 22, 22, 'Omeprazol'),
                                                                                    (1, 23, 23, 'No'),
                                                                                    (1, 24, 24, '63'),
                                                                                    (1, 25, 25, '1.66'),
                                                                                    (1, 26, 26, '22.3'),
                                                                                    (1, 27, 27, 'Fumador actual'),
                                                                                    (1, 28, 28, '≥20 cigarrillos/día (mucho)'),
                                                                                    (1, 29, 29, '>20 años'),
                                                                                    (1, 31, 30, 'Consumidor actual'),
                                                                                    (1, 32, 31, 'Frecuente (≥4 veces/semana)'),
                                                                                    (1, 33, 32, '≥5 tragos (mucho)'),
                                                                                    (1, 34, 33, '>20 años'),
                                                                                    (1, 36, 34, '≥3/sem'),
                                                                                    (1, 37, 35, 'Sí'),
                                                                                    (1, 38, 36, '≤2 porciones/día'),
                                                                                    (1, 39, 37, 'Sí'),
                                                                                    (1, 40, 38, '3 o más veces por semana'),
                                                                                    (1, 41, 39, '≥3/sem'),
                                                                                    (1, 42, 40, 'Sí'),
                                                                                    (1, 43, 41, 'No'),
                                                                                    (1, 45, 42, 'Diario'),
                                                                                    (1, 46, 43, 'Pozo'),
                                                                                    (1, 47, 44, 'Ninguno'),
                                                                                    (1, 48, 45, 'Positivo'),
                                                                                    (1, 51, 46, 'Histología / Biopsia'),
                                                                                    (1, 52, 47, '<1 año'),
                                                                                    (1, 53, 48, 'No'),
                                                                                    (1, 54, 49, 'No'),
                                                                                    (1, 55, 50, 'Intestinal'),
                                                                                    (1, 56, 51, 'Cuerpo'),
                                                                                    (1, 57, 52, 'T2N1M0'),
                                                                                    (2, 1, 53, 'Paciente Caso 2'),
                                                                                    (2, 2, 54, '912345002'),
                                                                                    (2, 3, 55, 'caso2@email.com'),
                                                                                    (2, 4, 56, '57'),
                                                                                    (2, 5, 57, 'Hombre'),
                                                                                    (2, 6, 58, 'Chilena'),
                                                                                    (2, 7, 59, 'Calle Rural 102'),
                                                                                    (2, 8, 60, 'Coihueco'),
                                                                                    (2, 9, 61, 'Chillán'),
                                                                                    (2, 10, 62, 'Rural'),
                                                                                    (2, 11, 63, 'Sí'),
                                                                                    (2, 12, 64, 'Básico'),
                                                                                    (2, 13, 65, 'Agricultor'),
                                                                                    (2, 14, 66, 'Fonasa'),
                                                                                    (2, 15, 67, 'Sí'),
                                                                                    (2, 16, 68, '01/03/2024'),
                                                                                    (2, 17, 69, 'Sí'),
                                                                                    (2, 18, 70, 'Sí'),
                                                                                    (2, 19, 71, 'Colon'),
                                                                                    (2, 20, 72, 'Gastritis crónica'),
                                                                                    (2, 21, 73, 'Sí'),
                                                                                    (2, 22, 74, 'Omeprazol'),
                                                                                    (2, 23, 75, 'No'),
                                                                                    (2, 24, 76, '64'),
                                                                                    (2, 25, 77, '1.67'),
                                                                                    (2, 26, 78, '22.6'),
                                                                                    (2, 27, 79, 'Fumador actual'),
                                                                                    (2, 28, 80, '≥20 cigarrillos/día (mucho)'),
                                                                                    (2, 29, 81, '>20 años'),
                                                                                    (2, 31, 82, 'Consumidor actual'),
                                                                                    (2, 32, 83, 'Frecuente (≥4 veces/semana)'),
                                                                                    (2, 33, 84, '≥5 tragos (mucho)'),
                                                                                    (2, 34, 85, '>20 años'),
                                                                                    (2, 36, 86, '≥3/sem'),
                                                                                    (2, 37, 87, 'Sí'),
                                                                                    (2, 38, 88, '≤2 porciones/día'),
                                                                                    (2, 39, 89, 'Sí'),
                                                                                    (2, 40, 90, '3 o más veces por semana'),
                                                                                    (2, 41, 91, '≥3/sem'),
                                                                                    (2, 42, 92, 'Sí'),
                                                                                    (2, 43, 93, 'No'),
                                                                                    (2, 45, 94, 'Diario'),
                                                                                    (2, 46, 95, 'Pozo'),
                                                                                    (2, 47, 96, 'Ninguno'),
                                                                                    (2, 48, 97, 'Positivo'),
                                                                                    (2, 51, 98, 'Histología / Biopsia'),
                                                                                    (2, 52, 99, '<1 año'),
                                                                                    (2, 53, 100, 'No'),
                                                                                    (2, 54, 101, 'No'),
                                                                                    (2, 55, 102, 'Difuso'),
                                                                                    (2, 56, 103, 'Cuerpo'),
                                                                                    (2, 57, 104, 'T3N0M0'),
                                                                                    (3, 1, 105, 'Paciente Caso 3'),
                                                                                    (3, 2, 106, '912345003'),
                                                                                    (3, 3, 107, 'caso3@email.com'),
                                                                                    (3, 4, 108, '58'),
                                                                                    (3, 5, 109, 'Mujer'),
                                                                                    (3, 6, 110, 'Chilena'),
                                                                                    (3, 7, 111, 'Calle Rural 103'),
                                                                                    (3, 8, 112, 'Bulnes'),
                                                                                    (3, 9, 113, 'Chillán'),
                                                                                    (3, 10, 114, 'Rural'),
                                                                                    (3, 11, 115, 'Sí'),
                                                                                    (3, 12, 116, 'Básico'),
                                                                                    (3, 13, 117, 'Agricultor'),
                                                                                    (3, 14, 118, 'Fonasa'),
                                                                                    (3, 15, 119, 'Sí'),
                                                                                    (3, 16, 120, '01/04/2024'),
                                                                                    (3, 17, 121, 'Sí'),
                                                                                    (3, 18, 122, 'Sí'),
                                                                                    (3, 19, 123, 'Colon'),
                                                                                    (3, 20, 124, 'Gastritis crónica'),
                                                                                    (3, 21, 125, 'Sí'),
                                                                                    (3, 22, 126, 'Omeprazol'),
                                                                                    (3, 23, 127, 'No'),
                                                                                    (3, 24, 128, '65'),
                                                                                    (3, 25, 129, '1.68'),
                                                                                    (3, 26, 130, '22.9'),
                                                                                    (3, 27, 131, 'Fumador actual'),
                                                                                    (3, 28, 132, '≥20 cigarrillos/día (mucho)'),
                                                                                    (3, 29, 133, '>20 años'),
                                                                                    (3, 31, 134, 'Consumidor actual'),
                                                                                    (3, 32, 135, 'Frecuente (≥4 veces/semana)'),
                                                                                    (3, 33, 136, '≥5 tragos (mucho)'),
                                                                                    (3, 34, 137, '>20 años'),
                                                                                    (3, 36, 138, '≥3/sem'),
                                                                                    (3, 37, 139, 'Sí'),
                                                                                    (3, 38, 140, '≤2 porciones/día'),
                                                                                    (3, 39, 141, 'Sí'),
                                                                                    (3, 40, 142, '3 o más veces por semana'),
                                                                                    (3, 41, 143, '≥3/sem'),
                                                                                    (3, 42, 144, 'Sí'),
                                                                                    (3, 43, 145, 'No'),
                                                                                    (3, 45, 146, 'Diario'),
                                                                                    (3, 46, 147, 'Pozo'),
                                                                                    (3, 47, 148, 'Ninguno'),
                                                                                    (3, 48, 149, 'Positivo'),
                                                                                    (3, 51, 150, 'Histología / Biopsia'),
                                                                                    (3, 52, 151, '<1 año'),
                                                                                    (3, 53, 152, 'No'),
                                                                                    (3, 54, 153, 'No'),
                                                                                    (3, 55, 154, 'Intestinal'),
                                                                                    (3, 56, 155, 'Cuerpo'),
                                                                                    (3, 57, 156, 'T1N1M0'),
                                                                                    (4, 1, 157, 'Paciente Caso 4'),
                                                                                    (4, 2, 158, '912345004'),
                                                                                    (4, 3, 159, 'caso4@email.com'),
                                                                                    (4, 4, 160, '59'),
                                                                                    (4, 5, 161, 'Hombre'),
                                                                                    (4, 6, 162, 'Chilena'),
                                                                                    (4, 7, 163, 'Calle Rural 104'),
                                                                                    (4, 8, 164, 'Quillón'),
                                                                                    (4, 9, 165, 'Chillán'),
                                                                                    (4, 10, 166, 'Rural'),
                                                                                    (4, 11, 167, 'Sí'),
                                                                                    (4, 12, 168, 'Básico'),
                                                                                    (4, 13, 169, 'Agricultor'),
                                                                                    (4, 14, 170, 'Fonasa'),
                                                                                    (4, 15, 171, 'Sí'),
                                                                                    (4, 16, 172, '01/05/2024'),
                                                                                    (4, 17, 173, 'Sí'),
                                                                                    (4, 18, 174, 'Sí'),
                                                                                    (4, 19, 175, 'Colon'),
                                                                                    (4, 20, 176, 'Gastritis crónica'),
                                                                                    (4, 21, 177, 'Sí'),
                                                                                    (4, 22, 178, 'Omeprazol'),
                                                                                    (4, 23, 179, 'No'),
                                                                                    (4, 24, 180, '66'),
                                                                                    (4, 25, 181, '1.69'),
                                                                                    (4, 26, 182, '23.2'),
                                                                                    (4, 27, 183, 'Fumador actual'),
                                                                                    (4, 28, 184, '≥20 cigarrillos/día (mucho)'),
                                                                                    (4, 29, 185, '>20 años'),
                                                                                    (4, 31, 186, 'Consumidor actual'),
                                                                                    (4, 32, 187, 'Frecuente (≥4 veces/semana)'),
                                                                                    (4, 33, 188, '≥5 tragos (mucho)'),
                                                                                    (4, 34, 189, '>20 años'),
                                                                                    (4, 36, 190, '≥3/sem'),
                                                                                    (4, 37, 191, 'Sí'),
                                                                                    (4, 38, 192, '≤2 porciones/día'),
                                                                                    (4, 39, 193, 'Sí'),
                                                                                    (4, 40, 194, '3 o más veces por semana'),
                                                                                    (4, 41, 195, '≥3/sem'),
                                                                                    (4, 42, 196, 'Sí'),
                                                                                    (4, 43, 197, 'No'),
                                                                                    (4, 45, 198, 'Diario'),
                                                                                    (4, 46, 199, 'Pozo'),
                                                                                    (4, 47, 200, 'Ninguno'),
                                                                                    (4, 48, 201, 'Positivo'),
                                                                                    (4, 51, 202, 'Histología / Biopsia'),
                                                                                    (4, 52, 203, '<1 año'),
                                                                                    (4, 53, 204, 'No'),
                                                                                    (4, 54, 205, 'No'),
                                                                                    (4, 55, 206, 'Difuso'),
                                                                                    (4, 56, 207, 'Cuerpo'),
                                                                                    (4, 57, 208, 'T2N0M0'),
                                                                                    (5, 1, 209, 'Paciente Caso 5'),
                                                                                    (5, 2, 210, '912345005'),
                                                                                    (5, 3, 211, 'caso5@email.com'),
                                                                                    (5, 4, 212, '60'),
                                                                                    (5, 5, 213, 'Mujer'),
                                                                                    (5, 6, 214, 'Chilena'),
                                                                                    (5, 7, 215, 'Calle Rural 105'),
                                                                                    (5, 8, 216, 'Chillán'),
                                                                                    (5, 9, 217, 'Chillán'),
                                                                                    (5, 10, 218, 'Rural'),
                                                                                    (5, 11, 219, 'Sí'),
                                                                                    (5, 12, 220, 'Básico'),
                                                                                    (5, 13, 221, 'Agricultor'),
                                                                                    (5, 14, 222, 'Fonasa'),
                                                                                    (5, 15, 223, 'Sí'),
                                                                                    (5, 16, 224, '01/06/2024'),
                                                                                    (5, 17, 225, 'Sí'),
                                                                                    (5, 18, 226, 'Sí'),
                                                                                    (5, 19, 227, 'Colon'),
                                                                                    (5, 20, 228, 'Gastritis crónica'),
                                                                                    (5, 21, 229, 'Sí'),
                                                                                    (5, 22, 230, 'Omeprazol'),
                                                                                    (5, 23, 231, 'No'),
                                                                                    (5, 24, 232, '67'),
                                                                                    (5, 25, 233, '1.65'),
                                                                                    (5, 26, 234, '23.5'),
                                                                                    (5, 27, 235, 'Fumador actual'),
                                                                                    (5, 28, 236, '≥20 cigarrillos/día (mucho)'),
                                                                                    (5, 29, 237, '>20 años'),
                                                                                    (5, 31, 238, 'Consumidor actual'),
                                                                                    (5, 32, 239, 'Frecuente (≥4 veces/semana)'),
                                                                                    (5, 33, 240, '≥5 tragos (mucho)'),
                                                                                    (5, 34, 241, '>20 años'),
                                                                                    (5, 36, 242, '≥3/sem'),
                                                                                    (5, 37, 243, 'Sí'),
                                                                                    (5, 38, 244, '≤2 porciones/día'),
                                                                                    (5, 39, 245, 'Sí'),
                                                                                    (5, 40, 246, '3 o más veces por semana'),
                                                                                    (5, 41, 247, '≥3/sem'),
                                                                                    (5, 42, 248, 'Sí'),
                                                                                    (5, 43, 249, 'No'),
                                                                                    (5, 45, 250, 'Diario'),
                                                                                    (5, 46, 251, 'Pozo'),
                                                                                    (5, 47, 252, 'Ninguno'),
                                                                                    (5, 48, 253, 'Positivo'),
                                                                                    (5, 51, 254, 'Histología / Biopsia'),
                                                                                    (5, 52, 255, '<1 año'),
                                                                                    (5, 53, 256, 'No'),
                                                                                    (5, 54, 257, 'No'),
                                                                                    (5, 55, 258, 'Intestinal'),
                                                                                    (5, 56, 259, 'Cuerpo'),
                                                                                    (5, 57, 260, 'T3N1M0'),
                                                                                    (6, 1, 261, 'Paciente Caso 6'),
                                                                                    (6, 2, 262, '912345006'),
                                                                                    (6, 3, 263, 'caso6@email.com'),
                                                                                    (6, 4, 264, '61'),
                                                                                    (6, 5, 265, 'Hombre'),
                                                                                    (6, 6, 266, 'Chilena'),
                                                                                    (6, 7, 267, 'Calle Rural 106'),
                                                                                    (6, 8, 268, 'San Carlos'),
                                                                                    (6, 9, 269, 'Chillán'),
                                                                                    (6, 10, 270, 'Rural'),
                                                                                    (6, 11, 271, 'Sí'),
                                                                                    (6, 12, 272, 'Básico'),
                                                                                    (6, 13, 273, 'Agricultor'),
                                                                                    (6, 14, 274, 'Fonasa'),
                                                                                    (6, 15, 275, 'Sí'),
                                                                                    (6, 16, 276, '01/07/2024'),
                                                                                    (6, 17, 277, 'Sí'),
                                                                                    (6, 18, 278, 'Sí'),
                                                                                    (6, 19, 279, 'Colon'),
                                                                                    (6, 20, 280, 'Gastritis crónica'),
                                                                                    (6, 21, 281, 'Sí'),
                                                                                    (6, 22, 282, 'Omeprazol'),
                                                                                    (6, 23, 283, 'No'),
                                                                                    (6, 24, 284, '68'),
                                                                                    (6, 25, 285, '1.66'),
                                                                                    (6, 26, 286, '23.8'),
                                                                                    (6, 27, 287, 'Fumador actual'),
                                                                                    (6, 28, 288, '≥20 cigarrillos/día (mucho)'),
                                                                                    (6, 29, 289, '>20 años'),
                                                                                    (6, 31, 290, 'Consumidor actual'),
                                                                                    (6, 32, 291, 'Frecuente (≥4 veces/semana)'),
                                                                                    (6, 33, 292, '≥5 tragos (mucho)'),
                                                                                    (6, 34, 293, '>20 años'),
                                                                                    (6, 36, 294, '≥3/sem'),
                                                                                    (6, 37, 295, 'Sí'),
                                                                                    (6, 38, 296, '≤2 porciones/día'),
                                                                                    (6, 39, 297, 'Sí'),
                                                                                    (6, 40, 298, '3 o más veces por semana'),
                                                                                    (6, 41, 299, '≥3/sem'),
                                                                                    (6, 42, 300, 'Sí'),
                                                                                    (6, 43, 301, 'No'),
                                                                                    (6, 45, 302, 'Diario'),
                                                                                    (6, 46, 303, 'Pozo'),
                                                                                    (6, 47, 304, 'Ninguno'),
                                                                                    (6, 48, 305, 'Positivo'),
                                                                                    (6, 51, 306, 'Histología / Biopsia'),
                                                                                    (6, 52, 307, '<1 año'),
                                                                                    (6, 53, 308, 'No'),
                                                                                    (6, 54, 309, 'No'),
                                                                                    (6, 55, 310, 'Difuso'),
                                                                                    (6, 56, 311, 'Cuerpo'),
                                                                                    (6, 57, 312, 'T1N0M0'),
                                                                                    (7, 1, 313, 'Paciente Caso 7'),
                                                                                    (7, 2, 314, '912345007'),
                                                                                    (7, 3, 315, 'caso7@email.com'),
                                                                                    (7, 4, 316, '62'),
                                                                                    (7, 5, 317, 'Mujer'),
                                                                                    (7, 6, 318, 'Chilena'),
                                                                                    (7, 7, 319, 'Calle Rural 107'),
                                                                                    (7, 8, 320, 'Coihueco'),
                                                                                    (7, 9, 321, 'Chillán'),
                                                                                    (7, 10, 322, 'Rural'),
                                                                                    (7, 11, 323, 'Sí'),
                                                                                    (7, 12, 324, 'Básico'),
                                                                                    (7, 13, 325, 'Agricultor'),
                                                                                    (7, 14, 326, 'Fonasa'),
                                                                                    (7, 15, 327, 'Sí'),
                                                                                    (7, 16, 328, '01/08/2024'),
                                                                                    (7, 17, 329, 'Sí'),
                                                                                    (7, 18, 330, 'Sí'),
                                                                                    (7, 19, 331, 'Colon'),
                                                                                    (7, 20, 332, 'Gastritis crónica'),
                                                                                    (7, 21, 333, 'Sí'),
                                                                                    (7, 22, 334, 'Omeprazol'),
                                                                                    (7, 23, 335, 'No'),
                                                                                    (7, 24, 336, '69'),
                                                                                    (7, 25, 337, '1.67'),
                                                                                    (7, 26, 338, '24.1'),
                                                                                    (7, 27, 339, 'Fumador actual'),
                                                                                    (7, 28, 340, '≥20 cigarrillos/día (mucho)'),
                                                                                    (7, 29, 341, '>20 años'),
                                                                                    (7, 31, 342, 'Consumidor actual'),
                                                                                    (7, 32, 343, 'Frecuente (≥4 veces/semana)'),
                                                                                    (7, 33, 344, '≥5 tragos (mucho)'),
                                                                                    (7, 34, 345, '>20 años'),
                                                                                    (7, 36, 346, '≥3/sem'),
                                                                                    (7, 37, 347, 'Sí'),
                                                                                    (7, 38, 348, '≤2 porciones/día'),
                                                                                    (7, 39, 349, 'Sí'),
                                                                                    (7, 40, 350, '3 o más veces por semana'),
                                                                                    (7, 41, 351, '≥3/sem'),
                                                                                    (7, 42, 352, 'Sí'),
                                                                                    (7, 43, 353, 'No'),
                                                                                    (7, 45, 354, 'Diario'),
                                                                                    (7, 46, 355, 'Pozo'),
                                                                                    (7, 47, 356, 'Ninguno'),
                                                                                    (7, 48, 357, 'Positivo'),
                                                                                    (7, 51, 358, 'Histología / Biopsia'),
                                                                                    (7, 52, 359, '<1 año'),
                                                                                    (7, 53, 360, 'No'),
                                                                                    (7, 54, 361, 'No'),
                                                                                    (7, 55, 362, 'Intestinal'),
                                                                                    (7, 56, 363, 'Cuerpo'),
                                                                                    (7, 57, 364, 'T2N1M0'),
                                                                                    (8, 1, 365, 'Paciente Caso 8'),
                                                                                    (8, 2, 366, '912345008'),
                                                                                    (8, 3, 367, 'caso8@email.com'),
                                                                                    (8, 4, 368, '63'),
                                                                                    (8, 5, 369, 'Hombre'),
                                                                                    (8, 6, 370, 'Chilena'),
                                                                                    (8, 7, 371, 'Calle Rural 108'),
                                                                                    (8, 8, 372, 'Bulnes'),
                                                                                    (8, 9, 373, 'Chillán'),
                                                                                    (8, 10, 374, 'Rural'),
                                                                                    (8, 11, 375, 'Sí'),
                                                                                    (8, 12, 376, 'Básico'),
                                                                                    (8, 13, 377, 'Agricultor'),
                                                                                    (8, 14, 378, 'Fonasa'),
                                                                                    (8, 15, 379, 'Sí'),
                                                                                    (8, 16, 380, '01/09/2024'),
                                                                                    (8, 17, 381, 'Sí'),
                                                                                    (8, 18, 382, 'Sí'),
                                                                                    (8, 19, 383, 'Colon'),
                                                                                    (8, 20, 384, 'Gastritis crónica'),
                                                                                    (8, 21, 385, 'Sí'),
                                                                                    (8, 22, 386, 'Omeprazol'),
                                                                                    (8, 23, 387, 'No'),
                                                                                    (8, 24, 388, '70'),
                                                                                    (8, 25, 389, '1.68'),
                                                                                    (8, 26, 390, '24.4'),
                                                                                    (8, 27, 391, 'Fumador actual'),
                                                                                    (8, 28, 392, '≥20 cigarrillos/día (mucho)'),
                                                                                    (8, 29, 393, '>20 años'),
                                                                                    (8, 31, 394, 'Consumidor actual'),
                                                                                    (8, 32, 395, 'Frecuente (≥4 veces/semana)'),
                                                                                    (8, 33, 396, '≥5 tragos (mucho)'),
                                                                                    (8, 34, 397, '>20 años'),
                                                                                    (8, 36, 398, '≥3/sem'),
                                                                                    (8, 37, 399, 'Sí'),
                                                                                    (8, 38, 400, '≤2 porciones/día'),
                                                                                    (8, 39, 401, 'Sí'),
                                                                                    (8, 40, 402, '3 o más veces por semana'),
                                                                                    (8, 41, 403, '≥3/sem'),
                                                                                    (8, 42, 404, 'Sí'),
                                                                                    (8, 43, 405, 'No'),
                                                                                    (8, 45, 406, 'Diario'),
                                                                                    (8, 46, 407, 'Pozo'),
                                                                                    (8, 47, 408, 'Ninguno'),
                                                                                    (8, 48, 409, 'Positivo'),
                                                                                    (8, 51, 410, 'Histología / Biopsia'),
                                                                                    (8, 52, 411, '<1 año'),
                                                                                    (8, 53, 412, 'No'),
                                                                                    (8, 54, 413, 'No'),
                                                                                    (8, 55, 414, 'Difuso'),
                                                                                    (8, 56, 415, 'Cuerpo'),
                                                                                    (8, 57, 416, 'T3N0M0'),
                                                                                    (9, 1, 417, 'Paciente Caso 9'),
                                                                                    (9, 2, 418, '912345009'),
                                                                                    (9, 3, 419, 'caso9@email.com'),
                                                                                    (9, 4, 420, '64'),
                                                                                    (9, 5, 421, 'Mujer'),
                                                                                    (9, 6, 422, 'Chilena'),
                                                                                    (9, 7, 423, 'Calle Rural 109'),
                                                                                    (9, 8, 424, 'Quillón'),
                                                                                    (9, 9, 425, 'Chillán'),
                                                                                    (9, 10, 426, 'Rural'),
                                                                                    (9, 11, 427, 'Sí'),
                                                                                    (9, 12, 428, 'Básico'),
                                                                                    (9, 13, 429, 'Agricultor'),
                                                                                    (9, 14, 430, 'Fonasa'),
                                                                                    (9, 15, 431, 'Sí'),
                                                                                    (9, 16, 432, '01/01/2024'),
                                                                                    (9, 17, 433, 'Sí'),
                                                                                    (9, 18, 434, 'Sí'),
                                                                                    (9, 19, 435, 'Colon'),
                                                                                    (9, 20, 436, 'Gastritis crónica'),
                                                                                    (9, 21, 437, 'Sí'),
                                                                                    (9, 22, 438, 'Omeprazol'),
                                                                                    (9, 23, 439, 'No'),
                                                                                    (9, 24, 440, '71'),
                                                                                    (9, 25, 441, '1.69'),
                                                                                    (9, 26, 442, '24.7'),
                                                                                    (9, 27, 443, 'Fumador actual'),
                                                                                    (9, 28, 444, '≥20 cigarrillos/día (mucho)'),
                                                                                    (9, 29, 445, '>20 años'),
                                                                                    (9, 31, 446, 'Consumidor actual'),
                                                                                    (9, 32, 447, 'Frecuente (≥4 veces/semana)'),
                                                                                    (9, 33, 448, '≥5 tragos (mucho)'),
                                                                                    (9, 34, 449, '>20 años'),
                                                                                    (9, 36, 450, '≥3/sem'),
                                                                                    (9, 37, 451, 'Sí'),
                                                                                    (9, 38, 452, '≤2 porciones/día'),
                                                                                    (9, 39, 453, 'Sí'),
                                                                                    (9, 40, 454, '3 o más veces por semana'),
                                                                                    (9, 41, 455, '≥3/sem'),
                                                                                    (9, 42, 456, 'Sí'),
                                                                                    (9, 43, 457, 'No'),
                                                                                    (9, 45, 458, 'Diario'),
                                                                                    (9, 46, 459, 'Pozo'),
                                                                                    (9, 47, 460, 'Ninguno'),
                                                                                    (9, 48, 461, 'Positivo'),
                                                                                    (9, 51, 462, 'Histología / Biopsia'),
                                                                                    (9, 52, 463, '<1 año'),
                                                                                    (9, 53, 464, 'No'),
                                                                                    (9, 54, 465, 'No'),
                                                                                    (9, 55, 466, 'Intestinal'),
                                                                                    (9, 56, 467, 'Cuerpo'),
                                                                                    (9, 57, 468, 'T1N1M0'),
                                                                                    (10, 1, 469, 'Paciente Caso 10'),
                                                                                    (10, 2, 470, '912345010'),
                                                                                    (10, 3, 471, 'caso10@email.com'),
                                                                                    (10, 4, 472, '65'),
                                                                                    (10, 5, 473, 'Hombre'),
                                                                                    (10, 6, 474, 'Chilena'),
                                                                                    (10, 7, 475, 'Calle Rural 110'),
                                                                                    (10, 8, 476, 'Chillán'),
                                                                                    (10, 9, 477, 'Chillán'),
                                                                                    (10, 10, 478, 'Rural'),
                                                                                    (10, 11, 479, 'Sí'),
                                                                                    (10, 12, 480, 'Básico'),
                                                                                    (10, 13, 481, 'Agricultor'),
                                                                                    (10, 14, 482, 'Fonasa'),
                                                                                    (10, 15, 483, 'Sí'),
                                                                                    (10, 16, 484, '01/02/2024'),
                                                                                    (10, 17, 485, 'Sí'),
                                                                                    (10, 18, 486, 'Sí'),
                                                                                    (10, 19, 487, 'Colon'),
                                                                                    (10, 20, 488, 'Gastritis crónica'),
                                                                                    (10, 21, 489, 'Sí'),
                                                                                    (10, 22, 490, 'Omeprazol'),
                                                                                    (10, 23, 491, 'No'),
                                                                                    (10, 24, 492, '72'),
                                                                                    (10, 25, 493, '1.65'),
                                                                                    (10, 26, 494, '25.0'),
                                                                                    (10, 27, 495, 'Fumador actual'),
                                                                                    (10, 28, 496, '≥20 cigarrillos/día (mucho)'),
                                                                                    (10, 29, 497, '>20 años'),
                                                                                    (10, 31, 498, 'Consumidor actual'),
                                                                                    (10, 32, 499, 'Frecuente (≥4 veces/semana)'),
                                                                                    (10, 33, 500, '≥5 tragos (mucho)'),
                                                                                    (10, 34, 501, '>20 años'),
                                                                                    (10, 36, 502, '≥3/sem'),
                                                                                    (10, 37, 503, 'Sí'),
                                                                                    (10, 38, 504, '≤2 porciones/día'),
                                                                                    (10, 39, 505, 'Sí'),
                                                                                    (10, 40, 506, '3 o más veces por semana'),
                                                                                    (10, 41, 507, '≥3/sem'),
                                                                                    (10, 42, 508, 'Sí'),
                                                                                    (10, 43, 509, 'No'),
                                                                                    (10, 45, 510, 'Diario'),
                                                                                    (10, 46, 511, 'Pozo'),
                                                                                    (10, 47, 512, 'Ninguno'),
                                                                                    (10, 48, 513, 'Positivo'),
                                                                                    (10, 51, 514, 'Histología / Biopsia'),
                                                                                    (10, 52, 515, '<1 año'),
                                                                                    (10, 53, 516, 'No'),
                                                                                    (10, 54, 517, 'No'),
                                                                                    (10, 55, 518, 'Difuso'),
                                                                                    (10, 56, 519, 'Cuerpo'),
                                                                                    (10, 57, 520, 'T2N0M0'),
                                                                                    (11, 1, 521, 'Paciente Control 1'),
                                                                                    (11, 2, 522, '987654001'),
                                                                                    (11, 3, 523, 'control1@email.com'),
                                                                                    (11, 4, 524, '46'),
                                                                                    (11, 5, 525, 'Hombre'),
                                                                                    (11, 6, 526, 'Chilena'),
                                                                                    (11, 7, 527, 'Av. Libertad 401'),
                                                                                    (11, 8, 528, 'Chillán'),
                                                                                    (11, 9, 529, 'Chillán'),
                                                                                    (11, 10, 530, 'Urbana'),
                                                                                    (11, 11, 531, 'Sí'),
                                                                                    (11, 12, 532, 'Superior'),
                                                                                    (11, 13, 533, 'Profesor'),
                                                                                    (11, 14, 534, 'Isapre'),
                                                                                    (11, 15, 535, 'No'),
                                                                                    (11, 17, 536, 'No'),
                                                                                    (11, 20, 537, 'No'),
                                                                                    (11, 21, 538, 'No'),
                                                                                    (11, 23, 539, 'No'),
                                                                                    (11, 24, 540, '71'),
                                                                                    (11, 25, 541, '1.71'),
                                                                                    (11, 26, 542, '24.2'),
                                                                                    (11, 27, 543, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (11, 31, 544, 'Nunca'),
                                                                                    (11, 36, 545, '≤1/sem'),
                                                                                    (11, 37, 546, 'No'),
                                                                                    (11, 38, 547, '≥5 porciones/día'),
                                                                                    (11, 39, 548, 'No'),
                                                                                    (11, 40, 549, 'Casi nunca / Rara vez'),
                                                                                    (11, 41, 550, 'Nunca/Rara vez'),
                                                                                    (11, 42, 551, 'No'),
                                                                                    (11, 43, 552, 'No'),
                                                                                    (11, 45, 553, 'Nunca/Rara vez'),
                                                                                    (11, 46, 554, 'Red pública'),
                                                                                    (11, 47, 555, 'Ninguno'),
                                                                                    (11, 48, 556, 'Negativo'),
                                                                                    (11, 49, 557, 'No'),
                                                                                    (11, 50, 558, 'No'),
                                                                                    (11, 51, 559, 'Test de aliento'),
                                                                                    (11, 52, 560, '<1 año'),
                                                                                    (11, 53, 561, 'No'),
                                                                                    (11, 54, 562, 'No'),
                                                                                    (12, 1, 563, 'Paciente Control 2'),
                                                                                    (12, 2, 564, '987654002'),
                                                                                    (12, 3, 565, 'control2@email.com'),
                                                                                    (12, 4, 566, '47'),
                                                                                    (12, 5, 567, 'Mujer'),
                                                                                    (12, 6, 568, 'Chilena'),
                                                                                    (12, 7, 569, 'Av. Libertad 402'),
                                                                                    (12, 8, 570, 'Chillán'),
                                                                                    (12, 9, 571, 'Chillán'),
                                                                                    (12, 10, 572, 'Urbana'),
                                                                                    (12, 11, 573, 'Sí'),
                                                                                    (12, 12, 574, 'Superior'),
                                                                                    (12, 13, 575, 'Profesor'),
                                                                                    (12, 14, 576, 'Isapre'),
                                                                                    (12, 15, 577, 'No'),
                                                                                    (12, 17, 578, 'No'),
                                                                                    (12, 20, 579, 'No'),
                                                                                    (12, 21, 580, 'No'),
                                                                                    (12, 23, 581, 'No'),
                                                                                    (12, 24, 582, '72'),
                                                                                    (12, 25, 583, '1.72'),
                                                                                    (12, 26, 584, '24.4'),
                                                                                    (12, 27, 585, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (12, 31, 586, 'Nunca'),
                                                                                    (12, 36, 587, '≤1/sem'),
                                                                                    (12, 37, 588, 'No'),
                                                                                    (12, 38, 589, '≥5 porciones/día'),
                                                                                    (12, 39, 590, 'No'),
                                                                                    (12, 40, 591, 'Casi nunca / Rara vez'),
                                                                                    (12, 41, 592, 'Nunca/Rara vez'),
                                                                                    (12, 42, 593, 'No'),
                                                                                    (12, 43, 594, 'No'),
                                                                                    (12, 45, 595, 'Nunca/Rara vez'),
                                                                                    (12, 46, 596, 'Red pública'),
                                                                                    (12, 47, 597, 'Ninguno'),
                                                                                    (12, 48, 598, 'Negativo'),
                                                                                    (12, 49, 599, 'No'),
                                                                                    (12, 50, 600, 'No'),
                                                                                    (12, 51, 601, 'Test de aliento'),
                                                                                    (12, 52, 602, '<1 año'),
                                                                                    (12, 53, 603, 'No'),
                                                                                    (12, 54, 604, 'No'),
                                                                                    (13, 1, 605, 'Paciente Control 3'),
                                                                                    (13, 2, 606, '987654003'),
                                                                                    (13, 3, 607, 'control3@email.com'),
                                                                                    (13, 4, 608, '48'),
                                                                                    (13, 5, 609, 'Hombre'),
                                                                                    (13, 6, 610, 'Chilena'),
                                                                                    (13, 7, 611, 'Av. Libertad 403'),
                                                                                    (13, 8, 612, 'Chillán'),
                                                                                    (13, 9, 613, 'Chillán'),
                                                                                    (13, 10, 614, 'Urbana'),
                                                                                    (13, 11, 615, 'Sí'),
                                                                                    (13, 12, 616, 'Superior'),
                                                                                    (13, 13, 617, 'Profesor'),
                                                                                    (13, 14, 618, 'Isapre'),
                                                                                    (13, 15, 619, 'No'),
                                                                                    (13, 17, 620, 'No'),
                                                                                    (13, 20, 621, 'No'),
                                                                                    (13, 21, 622, 'No'),
                                                                                    (13, 23, 623, 'No'),
                                                                                    (13, 24, 624, '73'),
                                                                                    (13, 25, 625, '1.73'),
                                                                                    (13, 26, 626, '24.6'),
                                                                                    (13, 27, 627, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (13, 31, 628, 'Nunca'),
                                                                                    (13, 36, 629, '≤1/sem'),
                                                                                    (13, 37, 630, 'No'),
                                                                                    (13, 38, 631, '≥5 porciones/día'),
                                                                                    (13, 39, 632, 'No'),
                                                                                    (13, 40, 633, 'Casi nunca / Rara vez'),
                                                                                    (13, 41, 634, 'Nunca/Rara vez'),
                                                                                    (13, 42, 635, 'No'),
                                                                                    (13, 43, 636, 'No'),
                                                                                    (13, 45, 637, 'Nunca/Rara vez'),
                                                                                    (13, 46, 638, 'Red pública'),
                                                                                    (13, 47, 639, 'Ninguno'),
                                                                                    (13, 48, 640, 'Negativo'),
                                                                                    (13, 49, 641, 'No'),
                                                                                    (13, 50, 642, 'No'),
                                                                                    (13, 51, 643, 'Test de aliento'),
                                                                                    (13, 52, 644, '<1 año'),
                                                                                    (13, 53, 645, 'No'),
                                                                                    (13, 54, 646, 'No'),
                                                                                    (14, 1, 647, 'Paciente Control 4'),
                                                                                    (14, 2, 648, '987654004'),
                                                                                    (14, 3, 649, 'control4@email.com'),
                                                                                    (14, 4, 650, '49'),
                                                                                    (14, 5, 651, 'Mujer'),
                                                                                    (14, 6, 652, 'Chilena'),
                                                                                    (14, 7, 653, 'Av. Libertad 404'),
                                                                                    (14, 8, 654, 'Chillán'),
                                                                                    (14, 9, 655, 'Chillán'),
                                                                                    (14, 10, 656, 'Urbana'),
                                                                                    (14, 11, 657, 'Sí'),
                                                                                    (14, 12, 658, 'Superior'),
                                                                                    (14, 13, 659, 'Profesor'),
                                                                                    (14, 14, 660, 'Isapre'),
                                                                                    (14, 15, 661, 'No'),
                                                                                    (14, 17, 662, 'No'),
                                                                                    (14, 20, 663, 'No'),
                                                                                    (14, 21, 664, 'No'),
                                                                                    (14, 23, 665, 'No'),
                                                                                    (14, 24, 666, '74'),
                                                                                    (14, 25, 667, '1.74'),
                                                                                    (14, 26, 668, '24.8'),
                                                                                    (14, 27, 669, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (14, 31, 670, 'Nunca'),
                                                                                    (14, 36, 671, '≤1/sem'),
                                                                                    (14, 37, 672, 'No'),
                                                                                    (14, 38, 673, '≥5 porciones/día'),
                                                                                    (14, 39, 674, 'No'),
                                                                                    (14, 40, 675, 'Casi nunca / Rara vez'),
                                                                                    (14, 41, 676, 'Nunca/Rara vez'),
                                                                                    (14, 42, 677, 'No'),
                                                                                    (14, 43, 678, 'No'),
                                                                                    (14, 45, 679, 'Nunca/Rara vez'),
                                                                                    (14, 46, 680, 'Red pública'),
                                                                                    (14, 47, 681, 'Ninguno'),
                                                                                    (14, 48, 682, 'Negativo'),
                                                                                    (14, 49, 683, 'No'),
                                                                                    (14, 50, 684, 'No'),
                                                                                    (14, 51, 685, 'Test de aliento'),
                                                                                    (14, 52, 686, '<1 año'),
                                                                                    (14, 53, 687, 'No'),
                                                                                    (14, 54, 688, 'No'),
                                                                                    (15, 1, 689, 'Paciente Control 5'),
                                                                                    (15, 2, 690, '987654005'),
                                                                                    (15, 3, 691, 'control5@email.com'),
                                                                                    (15, 4, 692, '50'),
                                                                                    (15, 5, 693, 'Hombre'),
                                                                                    (15, 6, 694, 'Chilena'),
                                                                                    (15, 7, 695, 'Av. Libertad 405'),
                                                                                    (15, 8, 696, 'Chillán'),
                                                                                    (15, 9, 697, 'Chillán'),
                                                                                    (15, 10, 698, 'Urbana'),
                                                                                    (15, 11, 699, 'Sí'),
                                                                                    (15, 12, 700, 'Superior'),
                                                                                    (15, 13, 701, 'Profesor'),
                                                                                    (15, 14, 702, 'Isapre'),
                                                                                    (15, 15, 703, 'No'),
                                                                                    (15, 17, 704, 'No'),
                                                                                    (15, 20, 705, 'No'),
                                                                                    (15, 21, 706, 'No'),
                                                                                    (15, 23, 707, 'No'),
                                                                                    (15, 24, 708, '75'),
                                                                                    (15, 25, 709, '1.70'),
                                                                                    (15, 26, 710, '25.0'),
                                                                                    (15, 27, 711, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (15, 31, 712, 'Nunca'),
                                                                                    (15, 36, 713, '≤1/sem'),
                                                                                    (15, 37, 714, 'No'),
                                                                                    (15, 38, 715, '≥5 porciones/día'),
                                                                                    (15, 39, 716, 'No'),
                                                                                    (15, 40, 717, 'Casi nunca / Rara vez'),
                                                                                    (15, 41, 718, 'Nunca/Rara vez'),
                                                                                    (15, 42, 719, 'No'),
                                                                                    (15, 43, 720, 'No'),
                                                                                    (15, 45, 721, 'Nunca/Rara vez'),
                                                                                    (15, 46, 722, 'Red pública'),
                                                                                    (15, 47, 723, 'Ninguno'),
                                                                                    (15, 48, 724, 'Negativo'),
                                                                                    (15, 49, 725, 'No'),
                                                                                    (15, 50, 726, 'No'),
                                                                                    (15, 51, 727, 'Test de aliento'),
                                                                                    (15, 52, 728, '<1 año'),
                                                                                    (15, 53, 729, 'No'),
                                                                                    (15, 54, 730, 'No'),
                                                                                    (16, 1, 731, 'Paciente Control 6'),
                                                                                    (16, 2, 732, '987654006'),
                                                                                    (16, 3, 733, 'control6@email.com'),
                                                                                    (16, 4, 734, '51'),
                                                                                    (16, 5, 735, 'Mujer'),
                                                                                    (16, 6, 736, 'Chilena'),
                                                                                    (16, 7, 737, 'Av. Libertad 406'),
                                                                                    (16, 8, 738, 'Chillán'),
                                                                                    (16, 9, 739, 'Chillán'),
                                                                                    (16, 10, 740, 'Urbana'),
                                                                                    (16, 11, 741, 'Sí'),
                                                                                    (16, 12, 742, 'Superior'),
                                                                                    (16, 13, 743, 'Profesor'),
                                                                                    (16, 14, 744, 'Isapre'),
                                                                                    (16, 15, 745, 'No'),
                                                                                    (16, 17, 746, 'No'),
                                                                                    (16, 20, 747, 'No'),
                                                                                    (16, 21, 748, 'No'),
                                                                                    (16, 23, 749, 'No'),
                                                                                    (16, 24, 750, '76'),
                                                                                    (16, 25, 751, '1.71'),
                                                                                    (16, 26, 752, '25.2'),
                                                                                    (16, 27, 753, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (16, 31, 754, 'Nunca'),
                                                                                    (16, 36, 755, '≤1/sem'),
                                                                                    (16, 37, 756, 'No'),
                                                                                    (16, 38, 757, '≥5 porciones/día'),
                                                                                    (16, 39, 758, 'No'),
                                                                                    (16, 40, 759, 'Casi nunca / Rara vez'),
                                                                                    (16, 41, 760, 'Nunca/Rara vez'),
                                                                                    (16, 42, 761, 'No'),
                                                                                    (16, 43, 762, 'No'),
                                                                                    (16, 45, 763, 'Nunca/Rara vez'),
                                                                                    (16, 46, 764, 'Red pública'),
                                                                                    (16, 47, 765, 'Ninguno'),
                                                                                    (16, 48, 766, 'Negativo'),
                                                                                    (16, 49, 767, 'No'),
                                                                                    (16, 50, 768, 'No'),
                                                                                    (16, 51, 769, 'Test de aliento'),
                                                                                    (16, 52, 770, '<1 año'),
                                                                                    (16, 53, 771, 'No'),
                                                                                    (16, 54, 772, 'No'),
                                                                                    (17, 1, 773, 'Paciente Control 7'),
                                                                                    (17, 2, 774, '987654007'),
                                                                                    (17, 3, 775, 'control7@email.com'),
                                                                                    (17, 4, 776, '52'),
                                                                                    (17, 5, 777, 'Hombre'),
                                                                                    (17, 6, 778, 'Chilena'),
                                                                                    (17, 7, 779, 'Av. Libertad 407'),
                                                                                    (17, 8, 780, 'Chillán'),
                                                                                    (17, 9, 781, 'Chillán'),
                                                                                    (17, 10, 782, 'Urbana'),
                                                                                    (17, 11, 783, 'Sí'),
                                                                                    (17, 12, 784, 'Superior'),
                                                                                    (17, 13, 785, 'Profesor'),
                                                                                    (17, 14, 786, 'Isapre'),
                                                                                    (17, 15, 787, 'No'),
                                                                                    (17, 17, 788, 'No'),
                                                                                    (17, 20, 789, 'No'),
                                                                                    (17, 21, 790, 'No'),
                                                                                    (17, 23, 791, 'No'),
                                                                                    (17, 24, 792, '77'),
                                                                                    (17, 25, 793, '1.72'),
                                                                                    (17, 26, 794, '25.4'),
                                                                                    (17, 27, 795, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (17, 31, 796, 'Nunca'),
                                                                                    (17, 36, 797, '≤1/sem'),
                                                                                    (17, 37, 798, 'No'),
                                                                                    (17, 38, 799, '≥5 porciones/día'),
                                                                                    (17, 39, 800, 'No'),
                                                                                    (17, 40, 801, 'Casi nunca / Rara vez'),
                                                                                    (17, 41, 802, 'Nunca/Rara vez'),
                                                                                    (17, 42, 803, 'No'),
                                                                                    (17, 43, 804, 'No'),
                                                                                    (17, 45, 805, 'Nunca/Rara vez'),
                                                                                    (17, 46, 806, 'Red pública'),
                                                                                    (17, 47, 807, 'Ninguno'),
                                                                                    (17, 48, 808, 'Negativo'),
                                                                                    (17, 49, 809, 'No'),
                                                                                    (17, 50, 810, 'No'),
                                                                                    (17, 51, 811, 'Test de aliento'),
                                                                                    (17, 52, 812, '<1 año'),
                                                                                    (17, 53, 813, 'No'),
                                                                                    (17, 54, 814, 'No'),
                                                                                    (18, 1, 815, 'Paciente Control 8'),
                                                                                    (18, 2, 816, '987654008'),
                                                                                    (18, 3, 817, 'control8@email.com'),
                                                                                    (18, 4, 818, '53'),
                                                                                    (18, 5, 819, 'Mujer'),
                                                                                    (18, 6, 820, 'Chilena'),
                                                                                    (18, 7, 821, 'Av. Libertad 408'),
                                                                                    (18, 8, 822, 'Chillán'),
                                                                                    (18, 9, 823, 'Chillán'),
                                                                                    (18, 10, 824, 'Urbana'),
                                                                                    (18, 11, 825, 'Sí'),
                                                                                    (18, 12, 826, 'Superior'),
                                                                                    (18, 13, 827, 'Profesor'),
                                                                                    (18, 14, 828, 'Isapre'),
                                                                                    (18, 15, 829, 'No'),
                                                                                    (18, 17, 830, 'No'),
                                                                                    (18, 20, 831, 'No'),
                                                                                    (18, 21, 832, 'No'),
                                                                                    (18, 23, 833, 'No'),
                                                                                    (18, 24, 834, '78'),
                                                                                    (18, 25, 835, '1.73'),
                                                                                    (18, 26, 836, '25.6'),
                                                                                    (18, 27, 837, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (18, 31, 838, 'Nunca'),
                                                                                    (18, 36, 839, '≤1/sem'),
                                                                                    (18, 37, 840, 'No'),
                                                                                    (18, 38, 841, '≥5 porciones/día'),
                                                                                    (18, 39, 842, 'No'),
                                                                                    (18, 40, 843, 'Casi nunca / Rara vez'),
                                                                                    (18, 41, 844, 'Nunca/Rara vez'),
                                                                                    (18, 42, 845, 'No'),
                                                                                    (18, 43, 846, 'No'),
                                                                                    (18, 45, 847, 'Nunca/Rara vez'),
                                                                                    (18, 46, 848, 'Red pública'),
                                                                                    (18, 47, 849, 'Ninguno'),
                                                                                    (18, 48, 850, 'Negativo'),
                                                                                    (18, 49, 851, 'No'),
                                                                                    (18, 50, 852, 'No'),
                                                                                    (18, 51, 853, 'Test de aliento'),
                                                                                    (18, 52, 854, '<1 año'),
                                                                                    (18, 53, 855, 'No'),
                                                                                    (18, 54, 856, 'No'),
                                                                                    (19, 1, 857, 'Paciente Control 9'),
                                                                                    (19, 2, 858, '987654009'),
                                                                                    (19, 3, 859, 'control9@email.com'),
                                                                                    (19, 4, 860, '54'),
                                                                                    (19, 5, 861, 'Hombre'),
                                                                                    (19, 6, 862, 'Chilena'),
                                                                                    (19, 7, 863, 'Av. Libertad 409'),
                                                                                    (19, 8, 864, 'Chillán'),
                                                                                    (19, 9, 865, 'Chillán'),
                                                                                    (19, 10, 866, 'Urbana'),
                                                                                    (19, 11, 867, 'Sí'),
                                                                                    (19, 12, 868, 'Superior'),
                                                                                    (19, 13, 869, 'Profesor'),
                                                                                    (19, 14, 870, 'Isapre'),
                                                                                    (19, 15, 871, 'No'),
                                                                                    (19, 17, 872, 'No'),
                                                                                    (19, 20, 873, 'No'),
                                                                                    (19, 21, 874, 'No'),
                                                                                    (19, 23, 875, 'No'),
                                                                                    (19, 24, 876, '79'),
                                                                                    (19, 25, 877, '1.74'),
                                                                                    (19, 26, 878, '25.8'),
                                                                                    (19, 27, 879, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (19, 31, 880, 'Nunca'),
                                                                                    (19, 36, 881, '≤1/sem'),
                                                                                    (19, 37, 882, 'No'),
                                                                                    (19, 38, 883, '≥5 porciones/día'),
                                                                                    (19, 39, 884, 'No'),
                                                                                    (19, 40, 885, 'Casi nunca / Rara vez'),
                                                                                    (19, 41, 886, 'Nunca/Rara vez'),
                                                                                    (19, 42, 887, 'No'),
                                                                                    (19, 43, 888, 'No'),
                                                                                    (19, 45, 889, 'Nunca/Rara vez'),
                                                                                    (19, 46, 890, 'Red pública'),
                                                                                    (19, 47, 891, 'Ninguno'),
                                                                                    (19, 48, 892, 'Negativo'),
                                                                                    (19, 49, 893, 'No'),
                                                                                    (19, 50, 894, 'No'),
                                                                                    (19, 51, 895, 'Test de aliento'),
                                                                                    (19, 52, 896, '<1 año'),
                                                                                    (19, 53, 897, 'No'),
                                                                                    (19, 54, 898, 'No'),
                                                                                    (20, 1, 899, 'Paciente Control 10'),
                                                                                    (20, 2, 900, '987654010'),
                                                                                    (20, 3, 901, 'control10@email.com'),
                                                                                    (20, 4, 902, '55'),
                                                                                    (20, 5, 903, 'Mujer'),
                                                                                    (20, 6, 904, 'Chilena'),
                                                                                    (20, 7, 905, 'Av. Libertad 410'),
                                                                                    (20, 8, 906, 'Chillán'),
                                                                                    (20, 9, 907, 'Chillán'),
                                                                                    (20, 10, 908, 'Urbana'),
                                                                                    (20, 11, 909, 'Sí'),
                                                                                    (20, 12, 910, 'Superior'),
                                                                                    (20, 13, 911, 'Profesor'),
                                                                                    (20, 14, 912, 'Isapre'),
                                                                                    (20, 15, 913, 'No'),
                                                                                    (20, 17, 914, 'No'),
                                                                                    (20, 20, 915, 'No'),
                                                                                    (20, 21, 916, 'No'),
                                                                                    (20, 23, 917, 'No'),
                                                                                    (20, 24, 918, '80'),
                                                                                    (20, 25, 919, '1.70'),
                                                                                    (20, 26, 920, '26.0'),
                                                                                    (20, 27, 921, 'Nunca fumó (menos de 100 cigarrillos en la vida)'),
                                                                                    (20, 31, 922, 'Nunca'),
                                                                                    (20, 36, 923, '≤1/sem'),
                                                                                    (20, 37, 924, 'No'),
                                                                                    (20, 38, 925, '≥5 porciones/día'),
                                                                                    (20, 39, 926, 'No'),
                                                                                    (20, 40, 927, 'Casi nunca / Rara vez'),
                                                                                    (20, 41, 928, 'Nunca/Rara vez'),
                                                                                    (20, 42, 929, 'No'),
                                                                                    (20, 43, 930, 'No'),
                                                                                    (20, 45, 931, 'Nunca/Rara vez'),
                                                                                    (20, 46, 932, 'Red pública'),
                                                                                    (20, 47, 933, 'Ninguno'),
                                                                                    (20, 48, 934, 'Negativo'),
                                                                                    (20, 49, 935, 'No'),
                                                                                    (20, 50, 936, 'No'),
                                                                                    (20, 51, 937, 'Test de aliento'),
                                                                                    (20, 52, 938, '<1 año'),
                                                                                    (20, 53, 939, 'No'),
                                                                                    (20, 54, 940, 'No');

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
                                                       (1, 3),
                                                       (2, 2),
                                                       (2, 4),
                                                       (3, 1),
                                                       (3, 2),
                                                       (3, 3),
                                                       (4, 1),
                                                       (4, 2),
                                                       (4, 3),
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
                                                       (7, 1),
                                                       (7, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `snp_config`
--

CREATE TABLE `snp_config` (
                              `id_snp` bigint(20) NOT NULL,
                              `alelo_ref` varchar(255) DEFAULT NULL,
                              `alelo_riesgo` varchar(255) DEFAULT NULL,
                              `nombre_gen` varchar(255) NOT NULL,
                              `opcion1` varchar(255) DEFAULT NULL,
                              `opcion2` varchar(255) DEFAULT NULL,
                              `opcion3` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `snp_config`
--

INSERT INTO `snp_config` (`id_snp`, `alelo_ref`, `alelo_riesgo`, `nombre_gen`, `opcion1`, `opcion2`, `opcion3`) VALUES
                                                                                                                    (1, 'T', NULL, 'TLR9 rs5743836', 'TT', 'TC', 'CC'),
                                                                                                                    (2, 'T', NULL, 'TLR9 rs187084', 'TT', 'TC', 'CC'),
                                                                                                                    (3, 'G', NULL, 'miR-146a rs2910164', 'GG', 'GC', 'CC'),
                                                                                                                    (4, 'C', NULL, 'miR-196a2 rs11614913', 'CC', 'CT', 'TT'),
                                                                                                                    (5, 'C', NULL, 'MTHFR rs1801133', 'CC', 'CT', 'TT'),
                                                                                                                    (6, 'G', NULL, 'DNMT3B rs1569686', 'GG', 'GT', 'TT');

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
                           `preferencias_estadisticas` text DEFAULT NULL,
                           `rut` varchar(255) NOT NULL,
                           `telefono` varchar(255) DEFAULT NULL,
                           `tema` varchar(255) DEFAULT NULL,
                           `token_cambio_email` varchar(255) DEFAULT NULL,
                           `token_recuperacion` varchar(255) DEFAULT NULL,
                           `foto_perfil` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`activo`, `id_usuario`, `token_cambio_email_expiracion`, `token_rec_expiracion`, `apellidos`, `contrasena`, `email`, `nombres`, `preferencias_estadisticas`, `rut`, `telefono`, `tema`, `token_cambio_email`, `token_recuperacion`, `foto_perfil`) VALUES
                                                                                                                                                                                                                                                                              (b'1', 1, NULL, NULL, 'General', '$2a$10$7k7sIIQ927yaBGHnaUKGM.CcEczep7M7jwqzOblMQlGwU1oyKvo0W', 'admin@hospital.cl', 'Admin', NULL, '11.111.111-1', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                                                              (b'1', 2, NULL, NULL, 'Pérez', '$2a$10$59NrwnGXFQNt.M15c/ZpZ.3C1G8eA0EaIGlz4AvkFRHaIeGNMcUAW', 'medico@hospital.cl', 'Dr. Juan', NULL, '22.222.222-2', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                                                              (b'1', 3, NULL, NULL, 'Silva', '$2a$10$g5eN4YmqR7cWF2CIo8Xjb.N.rXGHgLj8iW9LOzRRpoQH3PIls.fdC', 'investigacion@ubiobio.cl', 'Ana', NULL, '33.333.333-3', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                                                              (b'1', 4, NULL, NULL, 'Estudiante', '$2a$10$/HZBmU6AErtM19wGq6q2gud9yVhijI1uc2IeSeX9hcvrCYWr38Lbi', 'pedro@alumnos.cl', 'Pedro', NULL, '44.444.444-4', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                                                                                                                                              (b'1', 5, NULL, NULL, 'XD', '$2a$10$5vFbB.2.Y6d..LTyQrqOKO3T1280gyCJ7EEBi03QtwBOb.DV/JqIW', 'pedro@alumnos.cl', 'Juanito', NULL, '55.555.555-5', NULL, NULL, NULL, NULL, NULL);

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
                                                       (4, 4),
                                                       (5, 5);

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
-- Indices de la tabla `muestra_genetica`
--
ALTER TABLE `muestra_genetica`
    ADD PRIMARY KEY (`id_muestra`),
  ADD KEY `FKitks5n8k6k1la0g8ugby39ohg` (`id_snp`);

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
  ADD KEY `FKax8hwm2wxx26i9ntdvq4iox5x` (`id_cat`),
  ADD KEY `FK27n2v0x8pr3pchp02xy29aam0` (`pregunta_controladora_id`);

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
-- Indices de la tabla `snp_config`
--
ALTER TABLE `snp_config`
    ADD PRIMARY KEY (`id_snp`);

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
-- AUTO_INCREMENT de la tabla `muestra_genetica`
--
ALTER TABLE `muestra_genetica`
    MODIFY `id_muestra` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
    MODIFY `id_opcion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
    MODIFY `participante_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
    MODIFY `id_perm` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `preguntas`
--
ALTER TABLE `preguntas`
    MODIFY `pregunta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
    MODIFY `registro_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `respuesta`
--
ALTER TABLE `respuesta`
    MODIFY `respuesta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=941;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
    MODIFY `rol_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `snp_config`
--
ALTER TABLE `snp_config`
    MODIFY `id_snp` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
    MODIFY `id_usuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- Filtros para la tabla `muestra_genetica`
--
ALTER TABLE `muestra_genetica`
    ADD CONSTRAINT `FKitks5n8k6k1la0g8ugby39ohg` FOREIGN KEY (`id_snp`) REFERENCES `snp_config` (`id_snp`);

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
    ADD CONSTRAINT `FK27n2v0x8pr3pchp02xy29aam0` FOREIGN KEY (`pregunta_controladora_id`) REFERENCES `preguntas` (`pregunta_id`),
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
