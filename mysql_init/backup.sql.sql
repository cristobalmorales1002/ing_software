-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-11-2025 a las 17:01:51
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
  `id_cat` bigint(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `orden` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_cat`, `nombre`, `orden`) VALUES
(1, 'Datos sociodemográficos', 1),
(2, 'Antecedentes clínicos', 2),
(3, 'Variables antropométricas', 3),
(4, 'Tabaquismo', 4),
(5, 'Consumo de alcohol', 5),
(6, 'Factores dietarios y ambientales', 6),
(7, 'Infección por Helicobacter pylori', 7),
(8, 'Muestras biológicas y genéticas', 8),
(9, 'Histopatología (solo casos)', 9),
(10, 'Identificación', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion_pregunta`
--

CREATE TABLE `opcion_pregunta` (
  `id_opcion` bigint(20) NOT NULL,
  `etiqueta` varchar(255) NOT NULL,
  `orden` int(11) NOT NULL,
  `valor_dicotomizado` double DEFAULT NULL,
  `pregunta_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `opcion_pregunta`
--

INSERT INTO `opcion_pregunta` (`id_opcion`, `etiqueta`, `orden`, `valor_dicotomizado`, `pregunta_id`) VALUES
(1, 'Hombre', 1, NULL, 3),
(2, 'Mujer', 2, NULL, 3),
(3, 'Urbana', 1, NULL, 6),
(4, 'Rural', 2, NULL, 6),
(5, '<5', 1, NULL, 7),
(6, '5 – 10', 2, NULL, 7),
(7, '>10', 3, NULL, 7),
(8, 'Básico', 1, NULL, 8),
(9, 'Medio', 2, NULL, 8),
(10, 'Superior', 3, NULL, 8),
(11, 'Sí', 1, NULL, 10),
(12, 'No', 2, NULL, 10),
(13, 'Sí', 1, NULL, 12),
(14, 'No', 2, NULL, 12),
(15, 'Sí', 1, NULL, 13),
(16, 'No', 2, NULL, 13),
(17, 'Sí', 1, NULL, 17),
(18, 'No', 2, NULL, 17),
(19, 'Nunca fumó', 1, NULL, 21),
(20, 'Exfumador', 2, NULL, 21),
(21, 'Fumador actual', 3, NULL, 21),
(22, '<18', 1, NULL, 22),
(23, '18–25', 2, NULL, 22),
(24, '>25', 3, NULL, 22),
(25, '1–9 cigarrillos/día (poco)', 1, NULL, 23),
(26, '10–19 cigarrillos/día (moderado)', 2, NULL, 23),
(27, '≥20 cigarrillos/día (mucho)', 3, NULL, 23),
(28, '<10 años', 1, NULL, 24),
(29, '10–20 años', 2, NULL, 24),
(30, '>20 años', 3, NULL, 24),
(31, '<5 años', 1, NULL, 25),
(32, '5–10 años', 2, NULL, 25),
(33, '>10 años', 3, NULL, 25),
(34, 'Nunca', 1, NULL, 26),
(35, 'Exconsumidor', 2, NULL, 26),
(36, 'Consumidor actual', 3, NULL, 26),
(37, 'Ocasional (menos de 1 vez/semana)', 1, NULL, 27),
(38, 'Regular (1–3 veces/semana)', 2, NULL, 27),
(39, 'Frecuente (≥4 veces/semana)', 3, NULL, 27),
(40, '1–2 tragos (poco)', 1, NULL, 28),
(41, '3–4 tragos (moderado)', 2, NULL, 28),
(42, '≥5 tragos (mucho)', 3, NULL, 28),
(43, '<10 años', 1, NULL, 29),
(44, '10–20 años', 2, NULL, 29),
(45, '>20 años', 3, NULL, 29),
(46, '<5 años', 1, NULL, 30),
(47, '5–10 años', 2, NULL, 30),
(48, '>10 años', 3, NULL, 30),
(49, '<1/sem', 1, NULL, 31),
(50, '1–2/sem', 2, NULL, 31),
(51, '≥3/sem', 3, NULL, 31),
(52, 'Sí', 1, NULL, 32),
(53, 'No', 2, NULL, 32),
(54, '≥5 porciones/día (adecuado/protector)', 1, NULL, 33),
(55, '3–4 porciones/día (intermedio)', 2, NULL, 33),
(56, '≤2 porciones/día (bajo/insuficiente, riesgo)', 3, NULL, 33),
(57, 'Sí', 1, NULL, 34),
(58, 'No', 2, NULL, 34),
(59, 'Nunca/Rara vez', 1, NULL, 35),
(60, '1–2/sem', 2, NULL, 35),
(61, '≥3/sem', 3, NULL, 35),
(62, 'Sí', 1, NULL, 36),
(63, 'No', 2, NULL, 36),
(64, 'Sí', 1, NULL, 37),
(65, 'No', 2, NULL, 37),
(66, 'Nunca/Rara vez', 1, NULL, 39),
(67, 'Estacional', 2, NULL, 39),
(68, 'Diario', 3, NULL, 39),
(69, 'Red pública', 1, NULL, 40),
(70, 'Pozo', 2, NULL, 40),
(71, 'Camión aljibe', 3, NULL, 40),
(72, 'Otra', 4, NULL, 40),
(73, 'Ninguno', 1, NULL, 42),
(74, 'Hervir', 2, NULL, 42),
(75, 'Filtro', 3, NULL, 42),
(76, 'Cloro', 4, NULL, 42),
(77, 'Test de aliento', 1, NULL, 43),
(78, 'Antígeno en deposiciones', 2, NULL, 43),
(79, 'Endoscopía/biopsia', 3, NULL, 43),
(80, 'Positivo', 1, NULL, 44),
(81, 'Negativo', 2, NULL, 44),
(82, '<1 año', 1, NULL, 45),
(83, '1–5 años', 2, NULL, 45),
(84, '>5 años', 3, NULL, 45),
(85, 'TT', 1, NULL, 47),
(86, 'TC', 2, NULL, 47),
(87, 'CC', 3, NULL, 47),
(88, 'TT', 1, NULL, 48),
(89, 'TC', 2, NULL, 48),
(90, 'CC', 3, NULL, 48),
(91, 'GG', 1, NULL, 49),
(92, 'GC', 2, NULL, 49),
(93, 'CC', 3, NULL, 49),
(94, 'CC', 1, NULL, 50),
(95, 'CT', 2, NULL, 50),
(96, 'TT', 3, NULL, 50),
(97, 'CC', 1, NULL, 51),
(98, 'CT', 2, NULL, 51),
(99, 'TT', 3, NULL, 51),
(100, 'GG', 1, NULL, 52),
(101, 'GT', 2, NULL, 52),
(102, 'TT', 3, NULL, 52),
(103, 'Intestinal', 1, NULL, 53),
(104, 'Difuso', 2, NULL, 53),
(105, 'Mixto', 3, NULL, 53),
(106, 'Otro', 4, NULL, 53),
(107, 'Cardias', 1, NULL, 55),
(108, 'Cuerpo', 2, NULL, 55),
(109, 'Antro', 3, NULL, 55),
(110, 'Difuso', 4, NULL, 55);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `participante_id` bigint(20) NOT NULL,
  `activo` bit(1) NOT NULL,
  `es_caso` bit(1) NOT NULL,
  `fecha_incl` date NOT NULL,
  `participante_cod` varchar(255) NOT NULL,
  `reclutador_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`participante_id`, `activo`, `es_caso`, `fecha_incl`, `participante_cod`, `reclutador_id`) VALUES
(1, b'1', b'1', '2025-10-20', 'CAS_001', 2),
(2, b'1', b'1', '2025-10-22', 'CAS_002', 2),
(3, b'1', b'1', '2025-10-25', 'CAS_003', 2),
(4, b'1', b'1', '2025-10-28', 'CAS_004', 2),
(5, b'1', b'1', '2025-11-02', 'CAS_005', 2),
(6, b'1', b'0', '2025-11-05', 'CONT_001', 2),
(7, b'1', b'0', '2025-11-06', 'CONT_002', 2),
(8, b'1', b'0', '2025-11-10', 'CONT_003', 2),
(9, b'1', b'0', '2025-11-12', 'CONT_004', 2),
(10, b'1', b'0', '2025-11-15', 'CONT_005', 2);

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
(1, 'Permite crear un nuevo participante (Caso)', 'CREAR_CASO'),
(2, 'Permite crear un nuevo participante (Control)', 'CREAR_CONTROL'),
(3, 'Permite editar respuestas de un (Caso)', 'EDITAR_CASO'),
(4, 'Permite editar respuestas de un (Control)', 'EDITAR_CONTROL'),
(5, 'Permite ver la ficha de un paciente', 'VER_PACIENTE'),
(6, 'Permite ver el listado de todos los pacientes', 'VER_LISTADO_PACIENTES'),
(7, 'Permite archivar (borrado lógico) un paciente', 'ELIMINAR_PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta`
--

CREATE TABLE `pregunta` (
  `pregunta_id` bigint(20) NOT NULL,
  `activo` bit(1) NOT NULL,
  `dato_sensible` bit(1) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `dicotomizacion` double DEFAULT NULL,
  `etiqueta` varchar(255) NOT NULL,
  `exportable` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL,
  `sentido_corte` enum('IGUAL_A','MAYOR_O_IGUAL','MAYOR_QUE','MENOR_O_IGUAL','MENOR_QUE') DEFAULT NULL,
  `tipo_corte` varchar(20) NOT NULL DEFAULT 'NINGUNO',
  `tipo_dato` enum('CELULAR','EMAIL','ENUM','NUMERO','RUT','TEXTO') NOT NULL,
  `categoria_id` bigint(20) NOT NULL,
  `codigo_stata` varchar(50) DEFAULT NULL,
  `generar_estadistica` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pregunta`
--

INSERT INTO `pregunta` (`pregunta_id`, `activo`, `dato_sensible`, `descripcion`, `dicotomizacion`, `etiqueta`, `exportable`, `orden`, `sentido_corte`, `tipo_corte`, `tipo_dato`, `categoria_id`, `codigo_stata`, `generar_estadistica`) VALUES
(1, b'1', b'1', 'Nombre completo del participante', NULL, 'Nombre completo', 1, 1, NULL, 'NINGUNO', 'TEXTO', 1, 'nombre_completo', 0),
(2, b'1', b'0', 'Edad en años', 60, 'Edad', 1, 2, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'NUMERO', 1, 'edad_inc', 0),
(3, b'1', b'0', 'Sexo del participante', NULL, 'Sexo', 1, 3, NULL, 'NINGUNO', 'ENUM', 1, 'sexo', 1),
(4, b'1', b'1', 'Nacionalidad del participante', NULL, 'Nacionalidad', 1, 4, NULL, 'NINGUNO', 'TEXTO', 1, 'nacionalidad', 0),
(5, b'1', b'1', 'Dirección del participante', NULL, 'Dirección', 1, 5, NULL, 'NINGUNO', 'TEXTO', 1, 'direccion', 0),
(6, b'1', b'0', 'Zona de residencia', NULL, 'Zona', 1, 6, NULL, 'NINGUNO', 'ENUM', 1, 'zona_residencia', 1),
(7, b'1', b'0', 'Años viviendo en la residencia actual', NULL, 'Años viviendo en la residencia actual', 1, 7, NULL, 'NINGUNO', 'ENUM', 1, 'anos_residencia', 1),
(8, b'1', b'0', 'Nivel educacional', NULL, 'Nivel educacional', 1, 8, NULL, 'NINGUNO', 'ENUM', 1, 'nivel_educ', 1),
(9, b'1', b'0', 'Ocupación actual', NULL, 'Ocupación actual', 1, 9, NULL, 'NINGUNO', 'TEXTO', 1, 'ocupacion', 0),
(10, b'1', b'0', 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', NULL, 'Diagnóstico histológico de adenocarcinoma gástrico (solo casos)', 1, 10, NULL, 'NINGUNO', 'ENUM', 2, 'diag_histologico', 1),
(11, b'1', b'0', 'Fecha de diagnóstico (solo casos)', NULL, 'Fecha de diagnóstico (solo casos)', 1, 11, NULL, 'NINGUNO', 'TEXTO', 2, 'fecha_diag', 0),
(12, b'1', b'0', 'Antecedentes familiares de cáncer gástrico', NULL, 'Antecedentes familiares de cáncer gástrico', 1, 12, NULL, 'NINGUNO', 'ENUM', 2, 'ant_fam_cg', 1),
(13, b'1', b'0', 'Antecedentes familiares de otros tipos de cáncer', NULL, 'Antecedentes familiares de otros tipos de cáncer', 1, 13, NULL, 'NINGUNO', 'ENUM', 2, 'ant_fam_otros', 1),
(14, b'1', b'0', '¿Cuál(es)? (Otros cánceres familiares)', NULL, '¿Cuál(es)? (Otros cánceres familiares)', 1, 14, NULL, 'NINGUNO', 'TEXTO', 2, 'ant_fam_otros_cual', 0),
(15, b'1', b'0', 'Otras enfermedades relevantes (ej. gastritis crónica, úlcera péptica, anemia)', NULL, 'Otras enfermedades relevantes', 1, 15, NULL, 'NINGUNO', 'TEXTO', 2, 'otras_enf', 0),
(16, b'1', b'0', 'Uso crónico de medicamentos (especificar: AINEs, IBP u otros que generen gastritis)', NULL, 'Uso crónico de medicamentos', 1, 16, NULL, 'NINGUNO', 'TEXTO', 2, 'uso_meds', 0),
(17, b'1', b'0', 'Cirugía gástrica previa (gastrectomía parcial)', NULL, 'Cirugía gástrica previa (gastrectomía parcial)', 1, 17, NULL, 'NINGUNO', 'ENUM', 2, 'cirugia_gastrica', 1),
(18, b'1', b'0', 'Peso en kilogramos', 70, 'Peso (kg)', 1, 18, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'NUMERO', 3, 'peso_kg', 0),
(19, b'1', b'0', 'Estatura en metros', 1.6, 'Estatura (m)', 1, 19, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'NUMERO', 3, 'talla_m', 0),
(20, b'1', b'0', 'Índice de masa corporal (IMC = peso/estatura²)', 25, 'Índice de masa corporal (IMC)', 1, 20, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'NUMERO', 3, 'imc_calc', 0),
(21, b'1', b'0', 'Estado de tabaquismo', NULL, 'Estado de tabaquismo', 1, 21, NULL, 'NINGUNO', 'ENUM', 4, 'fumador_status', 1),
(22, b'1', b'0', 'Edad de inicio (aprox.)', NULL, 'Edad de inicio (aprox.)', 1, 22, NULL, 'NINGUNO', 'ENUM', 4, 'edad_inicio_fuma', 1),
(23, b'1', b'0', 'Cantidad promedio fumada', 5, 'Cantidad promedio fumada', 1, 23, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'ENUM', 4, 'cig_dia_prom', 1),
(24, b'1', b'0', 'Tiempo total fumando', 10, 'Tiempo total fumando', 1, 24, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'ENUM', 4, 'tiempo_fumando', 1),
(25, b'1', b'0', 'Si exfumador: tiempo desde que dejó de fumar', NULL, 'Si exfumador: tiempo desde que dejó de fumar', 1, 25, NULL, 'NINGUNO', 'ENUM', 4, 'tiempo_exfumador', 1),
(26, b'1', b'0', 'Estado de consumo (Alcohol)', NULL, 'Estado de consumo (Alcohol)', 1, 26, NULL, 'NINGUNO', 'ENUM', 5, 'alcohol_status', 1),
(27, b'1', b'0', 'Frecuencia (Alcohol)', NULL, 'Frecuencia (Alcohol)', 1, 27, NULL, 'NINGUNO', 'ENUM', 5, 'alcohol_frec', 1),
(28, b'1', b'0', 'Cantidad típica por ocasión (Alcohol)', 3, 'Cantidad típica por ocasión (Alcohol)', 1, 28, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'ENUM', 5, 'alcohol_cant', 1),
(29, b'1', b'0', 'Años de consumo habitual (Alcohol)', 15, 'Años de consumo habitual (Alcohol)', 1, 29, 'MAYOR_O_IGUAL', 'VALOR_FIJO', 'ENUM', 5, 'alcohol_anos', 1),
(30, b'1', b'0', 'Si exconsumidor: tiempo desde que dejó de beber (Alcohol)', NULL, 'Si exconsumidor: tiempo desde que dejó de beber (Alcohol)', 1, 30, NULL, 'NINGUNO', 'ENUM', 5, 'tiempo_exbebedor', 1),
(31, b'1', b'0', 'Carnes procesadas/cecinas', NULL, 'Carnes procesadas/cecinas', 1, 31, NULL, 'NINGUNO', 'ENUM', 6, 'dieta_cecinas', 1),
(32, b'1', b'0', 'Alimentos muy salados (agrega sal sin probar)', NULL, 'Alimentos muy salados (agrega sal sin probar)', 1, 32, NULL, 'NINGUNO', 'ENUM', 6, 'dieta_sal', 1),
(33, b'1', b'0', 'Porciones de frutas y verduras frescas', NULL, 'Porciones de frutas y verduras frescas', 1, 33, NULL, 'NINGUNO', 'ENUM', 6, 'dieta_frutas_verduras', 1),
(34, b'1', b'0', 'Consumo frecuente de frituras (≥3 veces por semana)', NULL, 'Consumo frecuente de frituras (≥3 veces por semana)', 1, 34, NULL, 'NINGUNO', 'ENUM', 6, 'dieta_frituras', 1),
(35, b'1', b'0', 'Infusiones o bebidas muy calientes (tomadas sin dejar entibiar)', NULL, 'Infusiones o bebidas muy calientes', 1, 35, NULL, 'NINGUNO', 'ENUM', 6, 'dieta_calientes', 1),
(36, b'1', b'0', 'Exposición ocupacional a pesticidas', NULL, 'Exposición ocupacional a pesticidas', 1, 36, NULL, 'NINGUNO', 'ENUM', 6, 'exp_pesticidas', 1),
(37, b'1', b'0', 'Exposición a otros compuestos químicos', NULL, 'Exposición a otros compuestos químicos', 1, 37, NULL, 'NINGUNO', 'ENUM', 6, 'exp_quimicos_cual', 1),
(38, b'1', b'0', '¿Cuál(es)? (Compuestos químicos)', NULL, '¿Cuál(es)? (Compuestos químicos)', 1, 38, NULL, 'NINGUNO', 'TEXTO', 6, 'exp_quimicos_cual', 0),
(39, b'1', b'0', 'Humo de leña en el hogar (cocina/calefacción)', NULL, 'Humo de leña en el hogar', 1, 39, NULL, 'NINGUNO', 'ENUM', 6, 'exp_humo_lena', 1),
(40, b'1', b'0', 'Fuente principal de agua en el hogar', NULL, 'Fuente principal de agua en el hogar', 1, 40, NULL, 'NINGUNO', 'ENUM', 6, 'agua_fuente', 1),
(41, b'1', b'0', 'Otra (Fuente de agua)', NULL, 'Otra (Fuente de agua)', 1, 41, NULL, 'NINGUNO', 'TEXTO', 6, 'agua_otra', 0),
(42, b'1', b'0', 'Tratamiento del agua en casa', NULL, 'Tratamiento del agua en casa', 1, 42, NULL, 'NINGUNO', 'ENUM', 6, 'agua_tratamiento', 1),
(43, b'1', b'0', 'Prueba realizada (H. pylori)', NULL, 'Prueba realizada (H. pylori)', 1, 43, NULL, 'NINGUNO', 'ENUM', 7, 'hpylori_prueba', 1),
(44, b'1', b'0', 'Resultado (H. pylori)', NULL, 'Resultado (H. pylori)', 1, 44, NULL, 'NINGUNO', 'ENUM', 7, 'hpylori_res', 1),
(45, b'1', b'0', '¿Hace cuánto tiempo se realizó el test? (H. pylori)', NULL, '¿Hace cuánto tiempo se realizó el test? (H. pylori)', 1, 45, NULL, 'NINGUNO', 'ENUM', 7, 'hpylori_tiempo', 1),
(46, b'1', b'0', 'Fecha de toma de sangre', NULL, 'Fecha de toma de sangre', 1, 46, NULL, 'NINGUNO', 'TEXTO', 8, 'fecha_sangre', 0),
(47, b'1', b'0', 'TLR9 rs5743836', NULL, 'TLR9 rs5743836', 1, 47, NULL, 'NINGUNO', 'ENUM', 8, 'tlr9_574', 1),
(48, b'1', b'0', 'TLR9 rs187084', NULL, 'TLR9 rs187084', 1, 48, NULL, 'NINGUNO', 'ENUM', 8, 'tlr9_187', 1),
(49, b'1', b'0', 'miR-146a rs2910164', NULL, 'miR-146a rs2910164', 1, 49, NULL, 'NINGUNO', 'ENUM', 8, 'mir146a', 1),
(50, b'1', b'0', 'miR-196a2 rs11614913', NULL, 'miR-196a2 rs11614913', 1, 50, NULL, 'NINGUNO', 'ENUM', 8, 'mir196a2', 1),
(51, b'1', b'0', 'MTHFR rs1801133', NULL, 'MTHFR rs1801133', 1, 51, NULL, 'NINGUNO', 'ENUM', 8, 'mthfr_180', 1),
(52, b'1', b'0', 'DNMT3B rs1569686', NULL, 'DNMT3B rs1569686', 1, 52, NULL, 'NINGUNO', 'ENUM', 8, 'dnmt3b', 1),
(53, b'1', b'0', 'Tipo histológico', NULL, 'Tipo histológico', 1, 53, NULL, 'NINGUNO', 'ENUM', 9, 'tipo_histologico', 1),
(54, b'1', b'0', 'Otro (Tipo histológico)', NULL, 'Otro (Tipo histológico)', 1, 54, NULL, 'NINGUNO', 'TEXTO', 9, 'tipo_histologico_otro', 0),
(55, b'1', b'0', 'Localización tumoral', NULL, 'Localización tumoral', 1, 55, NULL, 'NINGUNO', 'ENUM', 9, 'localizacion_tumoral', 1),
(56, b'1', b'0', 'Estadio clínico (TNM)', NULL, 'Estadio clínico (TNM)', 1, 56, NULL, 'NINGUNO', 'TEXTO', 9, 'estadio_clinico_tnm', 0),
(57, b'1', b'1', 'Pregunta base inicializada por sistema', NULL, 'RUT', 1, 2, NULL, 'NINGUNO', 'RUT', 10, 'rut_paciente', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro`
--

CREATE TABLE `registro` (
  `registro_id` bigint(20) NOT NULL,
  `accion` varchar(255) NOT NULL,
  `detalles` varchar(1024) NOT NULL,
  `registro_fecha` datetime(6) NOT NULL,
  `respuesta_id` bigint(20) DEFAULT NULL,
  `usuario_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro`
--

INSERT INTO `registro` (`registro_id`, `accion`, `detalles`, `registro_fecha`, `respuesta_id`, `usuario_id`) VALUES
(1, 'CREAR_RESPUESTA', 'Valor: \'Carlos Soto Pérez\'', '2025-11-16 16:39:39.000000', 1, 2),
(2, 'CREAR_RESPUESTA', 'Valor: \'68\'', '2025-11-16 16:39:39.000000', 2, 2),
(3, 'CREAR_RESPUESTA', 'Valor: \'Hombre\'', '2025-11-16 16:39:39.000000', 3, 2),
(4, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:39:39.000000', 4, 2),
(5, 'CREAR_RESPUESTA', 'Valor: \'Calle Falsa 123, Santiago\'', '2025-11-16 16:39:39.000000', 5, 2),
(6, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:39:39.000000', 6, 2),
(7, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:39:39.000000', 7, 2),
(8, 'CREAR_RESPUESTA', 'Valor: \'Medio\'', '2025-11-16 16:39:39.000000', 8, 2),
(9, 'CREAR_RESPUESTA', 'Valor: \'Jubilado (Ex-Obrero)\'', '2025-11-16 16:39:39.000000', 9, 2),
(10, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:39.000000', 10, 2),
(11, 'CREAR_RESPUESTA', 'Valor: \'15/09/2025\'', '2025-11-16 16:39:39.000000', 11, 2),
(12, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:39.000000', 12, 2),
(13, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:39.000000', 13, 2),
(14, 'CREAR_RESPUESTA', 'Valor: \'Cáncer de Próstata (Padre)\'', '2025-11-16 16:39:39.000000', 14, 2),
(15, 'CREAR_RESPUESTA', 'Valor: \'Gastritis crónica, HTA\'', '2025-11-16 16:39:39.000000', 15, 2),
(16, 'CREAR_RESPUESTA', 'Valor: \'Losartán, Omeprazol (IBP)\'', '2025-11-16 16:39:39.000000', 16, 2),
(17, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:39.000000', 17, 2),
(18, 'CREAR_RESPUESTA', 'Valor: \'80\'', '2025-11-16 16:39:39.000000', 18, 2),
(19, 'CREAR_RESPUESTA', 'Valor: \'1.70\'', '2025-11-16 16:39:39.000000', 19, 2),
(20, 'CREAR_RESPUESTA', 'Valor: \'27.68\'', '2025-11-16 16:39:39.000000', 20, 2),
(21, 'CREAR_RESPUESTA', 'Valor: \'Fumador actual\'', '2025-11-16 16:39:39.000000', 21, 2),
(22, 'CREAR_RESPUESTA', 'Valor: \'<18\'', '2025-11-16 16:39:39.000000', 22, 2),
(23, 'CREAR_RESPUESTA', 'Valor: \'10–19 cigarrillos/día (moderado)\'', '2025-11-16 16:39:39.000000', 23, 2),
(24, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:39:39.000000', 24, 2),
(25, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:39:39.000000', 25, 2),
(26, 'CREAR_RESPUESTA', 'Valor: \'Regular (1–3 veces/semana)\'', '2025-11-16 16:39:39.000000', 26, 2),
(27, 'CREAR_RESPUESTA', 'Valor: \'3–4 tragos (moderado)\'', '2025-11-16 16:39:39.000000', 27, 2),
(28, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:39:39.000000', 28, 2),
(29, 'CREAR_RESPUESTA', 'Valor: \'≥3/sem\'', '2025-11-16 16:39:39.000000', 29, 2),
(30, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:39.000000', 30, 2),
(31, 'CREAR_RESPUESTA', 'Valor: \'≤2 porciones/día (bajo/insuficiente, riesgo)\'', '2025-11-16 16:39:39.000000', 31, 2),
(32, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:39.000000', 32, 2),
(33, 'CREAR_RESPUESTA', 'Valor: \'≥3/sem\'', '2025-11-16 16:39:39.000000', 33, 2),
(34, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:39.000000', 34, 2),
(35, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:39.000000', 35, 2),
(36, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:39:39.000000', 36, 2),
(37, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:39:39.000000', 37, 2),
(38, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:39:39.000000', 38, 2),
(39, 'CREAR_RESPUESTA', 'Valor: \'Endoscopía/biopsia\'', '2025-11-16 16:39:39.000000', 39, 2),
(40, 'CREAR_RESPUESTA', 'Valor: \'Positivo\'', '2025-11-16 16:39:39.000000', 40, 2),
(41, 'CREAR_RESPUESTA', 'Valor: \'<1 año\'', '2025-11-16 16:39:39.000000', 41, 2),
(42, 'CREAR_RESPUESTA', 'Valor: \'20/10/2025\'', '2025-11-16 16:39:39.000000', 42, 2),
(43, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:39:39.000000', 43, 2),
(44, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:39:39.000000', 44, 2),
(45, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:39:39.000000', 45, 2),
(46, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:39:39.000000', 46, 2),
(47, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:39:39.000000', 47, 2),
(48, 'CREAR_RESPUESTA', 'Valor: \'GT\'', '2025-11-16 16:39:39.000000', 48, 2),
(49, 'CREAR_RESPUESTA', 'Valor: \'Intestinal\'', '2025-11-16 16:39:39.000000', 49, 2),
(50, 'CREAR_RESPUESTA', 'Valor: \'Antro\'', '2025-11-16 16:39:39.000000', 50, 2),
(51, 'CREAR_RESPUESTA', 'Valor: \'T2N1M0\'', '2025-11-16 16:39:39.000000', 51, 2),
(52, 'CREAR_PACIENTE', 'Paciente creado con codigo: CAS_001', '2025-11-16 16:39:39.000000', NULL, 2),
(53, 'CREAR_RESPUESTA', 'Valor: \'Mónica Rojas Tapia\'', '2025-11-16 16:39:50.000000', 52, 2),
(54, 'CREAR_RESPUESTA', 'Valor: \'55\'', '2025-11-16 16:39:50.000000', 53, 2),
(55, 'CREAR_RESPUESTA', 'Valor: \'Mujer\'', '2025-11-16 16:39:50.000000', 54, 2),
(56, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:39:50.000000', 55, 2),
(57, 'CREAR_RESPUESTA', 'Valor: \'Av. Providencia 1000\'', '2025-11-16 16:39:50.000000', 56, 2),
(58, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:39:50.000000', 57, 2),
(59, 'CREAR_RESPUESTA', 'Valor: \'5 – 10\'', '2025-11-16 16:39:50.000000', 58, 2),
(60, 'CREAR_RESPUESTA', 'Valor: \'Superior\'', '2025-11-16 16:39:50.000000', 59, 2),
(61, 'CREAR_RESPUESTA', 'Valor: \'Contadora\'', '2025-11-16 16:39:50.000000', 60, 2),
(62, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:50.000000', 61, 2),
(63, 'CREAR_RESPUESTA', 'Valor: \'01/10/2025\'', '2025-11-16 16:39:50.000000', 62, 2),
(64, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:39:50.000000', 63, 2),
(65, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 64, 2),
(66, 'CREAR_RESPUESTA', 'Valor: \'Anemia\'', '2025-11-16 16:39:50.000000', 65, 2),
(67, 'CREAR_RESPUESTA', 'Valor: \'Hierro\'', '2025-11-16 16:39:50.000000', 66, 2),
(68, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 67, 2),
(69, 'CREAR_RESPUESTA', 'Valor: \'65\'', '2025-11-16 16:39:50.000000', 68, 2),
(70, 'CREAR_RESPUESTA', 'Valor: \'1.65\'', '2025-11-16 16:39:50.000000', 69, 2),
(71, 'CREAR_RESPUESTA', 'Valor: \'23.87\'', '2025-11-16 16:39:50.000000', 70, 2),
(72, 'CREAR_RESPUESTA', 'Valor: \'Exfumador\'', '2025-11-16 16:39:50.000000', 71, 2),
(73, 'CREAR_RESPUESTA', 'Valor: \'18–25\'', '2025-11-16 16:39:50.000000', 72, 2),
(74, 'CREAR_RESPUESTA', 'Valor: \'1–9 cigarrillos/día (poco)\'', '2025-11-16 16:39:50.000000', 73, 2),
(75, 'CREAR_RESPUESTA', 'Valor: \'10–20 años\'', '2025-11-16 16:39:50.000000', 74, 2),
(76, 'CREAR_RESPUESTA', 'Valor: \'5–10 años\'', '2025-11-16 16:39:50.000000', 75, 2),
(77, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:39:50.000000', 76, 2),
(78, 'CREAR_RESPUESTA', 'Valor: \'Ocasional (menos de 1 vez/semana)\'', '2025-11-16 16:39:50.000000', 77, 2),
(79, 'CREAR_RESPUESTA', 'Valor: \'1–2 tragos (poco)\'', '2025-11-16 16:39:50.000000', 78, 2),
(80, 'CREAR_RESPUESTA', 'Valor: \'<10 años\'', '2025-11-16 16:39:50.000000', 79, 2),
(81, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:39:50.000000', 80, 2),
(82, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 81, 2),
(83, 'CREAR_RESPUESTA', 'Valor: \'3–4 porciones/día (intermedio)\'', '2025-11-16 16:39:50.000000', 82, 2),
(84, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 83, 2),
(85, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:39:50.000000', 84, 2),
(86, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 85, 2),
(87, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:39:50.000000', 86, 2),
(88, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:39:50.000000', 87, 2),
(89, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:39:50.000000', 88, 2),
(90, 'CREAR_RESPUESTA', 'Valor: \'Filtro\'', '2025-11-16 16:39:50.000000', 89, 2),
(91, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:39:50.000000', 90, 2),
(92, 'CREAR_RESPUESTA', 'Valor: \'Positivo\'', '2025-11-16 16:39:50.000000', 91, 2),
(93, 'CREAR_RESPUESTA', 'Valor: \'1–5 años\'', '2025-11-16 16:39:50.000000', 92, 2),
(94, 'CREAR_RESPUESTA', 'Valor: \'22/10/2025\'', '2025-11-16 16:39:50.000000', 93, 2),
(95, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:39:50.000000', 94, 2),
(96, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:39:50.000000', 95, 2),
(97, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:39:50.000000', 96, 2),
(98, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:39:50.000000', 97, 2),
(99, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:39:50.000000', 98, 2),
(100, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:39:50.000000', 99, 2),
(101, 'CREAR_RESPUESTA', 'Valor: \'Difuso\'', '2025-11-16 16:39:50.000000', 100, 2),
(102, 'CREAR_RESPUESTA', 'Valor: \'Cuerpo\'', '2025-11-16 16:39:50.000000', 101, 2),
(103, 'CREAR_RESPUESTA', 'Valor: \'T3N1M0\'', '2025-11-16 16:39:50.000000', 102, 2),
(104, 'CREAR_PACIENTE', 'Paciente creado con codigo: CAS_002', '2025-11-16 16:39:50.000000', NULL, 2),
(105, 'CREAR_RESPUESTA', 'Valor: \'José Manuel Campos\'', '2025-11-16 16:40:00.000000', 103, 2),
(106, 'CREAR_RESPUESTA', 'Valor: \'72\'', '2025-11-16 16:40:00.000000', 104, 2),
(107, 'CREAR_RESPUESTA', 'Valor: \'Hombre\'', '2025-11-16 16:40:00.000000', 105, 2),
(108, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:40:00.000000', 106, 2),
(109, 'CREAR_RESPUESTA', 'Valor: \'Parcela 14, Melipilla\'', '2025-11-16 16:40:00.000000', 107, 2),
(110, 'CREAR_RESPUESTA', 'Valor: \'Rural\'', '2025-11-16 16:40:00.000000', 108, 2),
(111, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:40:00.000000', 109, 2),
(112, 'CREAR_RESPUESTA', 'Valor: \'Básico\'', '2025-11-16 16:40:00.000000', 110, 2),
(113, 'CREAR_RESPUESTA', 'Valor: \'Agricultor\'', '2025-11-16 16:40:00.000000', 111, 2),
(114, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:00.000000', 112, 2),
(115, 'CREAR_RESPUESTA', 'Valor: \'20/10/2025\'', '2025-11-16 16:40:00.000000', 113, 2),
(116, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:00.000000', 114, 2),
(117, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:00.000000', 115, 2),
(118, 'CREAR_RESPUESTA', 'Valor: \'Úlcera péptica (antigua)\'', '2025-11-16 16:40:00.000000', 116, 2),
(119, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:40:00.000000', 117, 2),
(120, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:00.000000', 118, 2),
(121, 'CREAR_RESPUESTA', 'Valor: \'68\'', '2025-11-16 16:40:00.000000', 119, 2),
(122, 'CREAR_RESPUESTA', 'Valor: \'1.68\'', '2025-11-16 16:40:00.000000', 120, 2),
(123, 'CREAR_RESPUESTA', 'Valor: \'24.1\'', '2025-11-16 16:40:00.000000', 121, 2),
(124, 'CREAR_RESPUESTA', 'Valor: \'Nunca fumó\'', '2025-11-16 16:40:00.000000', 122, 2),
(125, 'CREAR_RESPUESTA', 'Valor: \'Exconsumidor\'', '2025-11-16 16:40:00.000000', 123, 2),
(126, 'CREAR_RESPUESTA', 'Valor: \'Regular (1–3 veces/semana)\'', '2025-11-16 16:40:00.000000', 124, 2),
(127, 'CREAR_RESPUESTA', 'Valor: \'≥5 tragos (mucho)\'', '2025-11-16 16:40:00.000000', 125, 2),
(128, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:40:00.000000', 126, 2),
(129, 'CREAR_RESPUESTA', 'Valor: \'>10 años\'', '2025-11-16 16:40:00.000000', 127, 2),
(130, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:00.000000', 128, 2),
(131, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:00.000000', 129, 2),
(132, 'CREAR_RESPUESTA', 'Valor: \'≤2 porciones/día (bajo/insuficiente, riesgo)\'', '2025-11-16 16:40:00.000000', 130, 2),
(133, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:00.000000', 131, 2),
(134, 'CREAR_RESPUESTA', 'Valor: \'≥3/sem\'', '2025-11-16 16:40:00.000000', 132, 2),
(135, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:00.000000', 133, 2),
(136, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:00.000000', 134, 2),
(137, 'CREAR_RESPUESTA', 'Valor: \'Diario\'', '2025-11-16 16:40:00.000000', 135, 2),
(138, 'CREAR_RESPUESTA', 'Valor: \'Pozo\'', '2025-11-16 16:40:00.000000', 136, 2),
(139, 'CREAR_RESPUESTA', 'Valor: \'Hervir\'', '2025-11-16 16:40:00.000000', 137, 2),
(140, 'CREAR_RESPUESTA', 'Valor: \'Antígeno en deposiciones\'', '2025-11-16 16:40:00.000000', 138, 2),
(141, 'CREAR_RESPUESTA', 'Valor: \'Positivo\'', '2025-11-16 16:40:00.000000', 139, 2),
(142, 'CREAR_RESPUESTA', 'Valor: \'<1 año\'', '2025-11-16 16:40:00.000000', 140, 2),
(143, 'CREAR_RESPUESTA', 'Valor: \'25/10/2025\'', '2025-11-16 16:40:00.000000', 141, 2),
(144, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:00.000000', 142, 2),
(145, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:40:00.000000', 143, 2),
(146, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:40:00.000000', 144, 2),
(147, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:00.000000', 145, 2),
(148, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:40:00.000000', 146, 2),
(149, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:00.000000', 147, 2),
(150, 'CREAR_RESPUESTA', 'Valor: \'Mixto\'', '2025-11-16 16:40:00.000000', 148, 2),
(151, 'CREAR_RESPUESTA', 'Valor: \'Cuerpo\'', '2025-11-16 16:40:00.000000', 149, 2),
(152, 'CREAR_RESPUESTA', 'Valor: \'T4aN2M0\'', '2025-11-16 16:40:00.000000', 150, 2),
(153, 'CREAR_PACIENTE', 'Paciente creado con codigo: CAS_003', '2025-11-16 16:40:00.000000', NULL, 2),
(154, 'CREAR_RESPUESTA', 'Valor: \'Roberto Núñez\'', '2025-11-16 16:40:12.000000', 151, 2),
(155, 'CREAR_RESPUESTA', 'Valor: \'62\'', '2025-11-16 16:40:12.000000', 152, 2),
(156, 'CREAR_RESPUESTA', 'Valor: \'Hombre\'', '2025-11-16 16:40:12.000000', 153, 2),
(157, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:40:12.000000', 154, 2),
(158, 'CREAR_RESPUESTA', 'Valor: \'Los Leones 300, Providencia\'', '2025-11-16 16:40:12.000000', 155, 2),
(159, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:40:12.000000', 156, 2),
(160, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:40:12.000000', 157, 2),
(161, 'CREAR_RESPUESTA', 'Valor: \'Superior\'', '2025-11-16 16:40:12.000000', 158, 2),
(162, 'CREAR_RESPUESTA', 'Valor: \'Ingeniero\'', '2025-11-16 16:40:12.000000', 159, 2),
(163, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:12.000000', 160, 2),
(164, 'CREAR_RESPUESTA', 'Valor: \'02/10/2025\'', '2025-11-16 16:40:12.000000', 161, 2),
(165, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:12.000000', 162, 2),
(166, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:12.000000', 163, 2),
(167, 'CREAR_RESPUESTA', 'Valor: \'HTA\'', '2025-11-16 16:40:12.000000', 164, 2),
(168, 'CREAR_RESPUESTA', 'Valor: \'Enalapril\'', '2025-11-16 16:40:12.000000', 165, 2),
(169, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:12.000000', 166, 2),
(170, 'CREAR_RESPUESTA', 'Valor: \'85\'', '2025-11-16 16:40:12.000000', 167, 2),
(171, 'CREAR_RESPUESTA', 'Valor: \'1.78\'', '2025-11-16 16:40:12.000000', 168, 2),
(172, 'CREAR_RESPUESTA', 'Valor: \'26.83\'', '2025-11-16 16:40:12.000000', 169, 2),
(173, 'CREAR_RESPUESTA', 'Valor: \'Exfumador\'', '2025-11-16 16:40:12.000000', 170, 2),
(174, 'CREAR_RESPUESTA', 'Valor: \'18–25\'', '2025-11-16 16:40:12.000000', 171, 2),
(175, 'CREAR_RESPUESTA', 'Valor: \'≥20 cigarrillos/día (mucho)\'', '2025-11-16 16:40:12.000000', 172, 2),
(176, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:40:12.000000', 173, 2),
(177, 'CREAR_RESPUESTA', 'Valor: \'<5 años\'', '2025-11-16 16:40:12.000000', 174, 2),
(178, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:40:12.000000', 175, 2),
(179, 'CREAR_RESPUESTA', 'Valor: \'Ocasional (menos de 1 vez/semana)\'', '2025-11-16 16:40:12.000000', 176, 2),
(180, 'CREAR_RESPUESTA', 'Valor: \'1–2 tragos (poco)\'', '2025-11-16 16:40:13.000000', 177, 2),
(181, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:40:13.000000', 178, 2),
(182, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:13.000000', 179, 2),
(183, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:13.000000', 180, 2),
(184, 'CREAR_RESPUESTA', 'Valor: \'3–4 porciones/día (intermedio)\'', '2025-11-16 16:40:13.000000', 181, 2),
(185, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:13.000000', 182, 2),
(186, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:13.000000', 183, 2),
(187, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:13.000000', 184, 2),
(188, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:13.000000', 185, 2),
(189, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:13.000000', 186, 2),
(190, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:40:13.000000', 187, 2),
(191, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:40:13.000000', 188, 2),
(192, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:40:13.000000', 189, 2),
(193, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:40:13.000000', 190, 2),
(194, 'CREAR_RESPUESTA', 'Valor: \'1–5 años\'', '2025-11-16 16:40:13.000000', 191, 2),
(195, 'CREAR_RESPUESTA', 'Valor: \'28/10/2025\'', '2025-11-16 16:40:13.000000', 192, 2),
(196, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:13.000000', 193, 2),
(197, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:13.000000', 194, 2),
(198, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:13.000000', 195, 2),
(199, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:13.000000', 196, 2),
(200, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:13.000000', 197, 2),
(201, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:40:13.000000', 198, 2),
(202, 'CREAR_RESPUESTA', 'Valor: \'Intestinal\'', '2025-11-16 16:40:13.000000', 199, 2),
(203, 'CREAR_RESPUESTA', 'Valor: \'Cardias\'', '2025-11-16 16:40:13.000000', 200, 2),
(204, 'CREAR_RESPUESTA', 'Valor: \'T1bN0M0\'', '2025-11-16 16:40:13.000000', 201, 2),
(205, 'CREAR_PACIENTE', 'Paciente creado con codigo: CAS_004', '2025-11-16 16:40:13.000000', NULL, 2),
(206, 'CREAR_RESPUESTA', 'Valor: \'Lorena Álvarez Vera\'', '2025-11-16 16:40:21.000000', 202, 2),
(207, 'CREAR_RESPUESTA', 'Valor: \'49\'', '2025-11-16 16:40:21.000000', 203, 2),
(208, 'CREAR_RESPUESTA', 'Valor: \'Mujer\'', '2025-11-16 16:40:21.000000', 204, 2),
(209, 'CREAR_RESPUESTA', 'Valor: \'Peruana\'', '2025-11-16 16:40:21.000000', 205, 2),
(210, 'CREAR_RESPUESTA', 'Valor: \'Merced 500, Santiago\'', '2025-11-16 16:40:21.000000', 206, 2),
(211, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:40:21.000000', 207, 2),
(212, 'CREAR_RESPUESTA', 'Valor: \'5 – 10\'', '2025-11-16 16:40:21.000000', 208, 2),
(213, 'CREAR_RESPUESTA', 'Valor: \'Superior\'', '2025-11-16 16:40:21.000000', 209, 2),
(214, 'CREAR_RESPUESTA', 'Valor: \'Cocinera\'', '2025-11-16 16:40:21.000000', 210, 2),
(215, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:21.000000', 211, 2),
(216, 'CREAR_RESPUESTA', 'Valor: \'10/10/2025\'', '2025-11-16 16:40:21.000000', 212, 2),
(217, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:21.000000', 213, 2),
(218, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:21.000000', 214, 2),
(219, 'CREAR_RESPUESTA', 'Valor: \'Cáncer de Mama (Madre)\'', '2025-11-16 16:40:21.000000', 215, 2),
(220, 'CREAR_RESPUESTA', 'Valor: \'Resistencia a la Insulina\'', '2025-11-16 16:40:21.000000', 216, 2),
(221, 'CREAR_RESPUESTA', 'Valor: \'Metformina\'', '2025-11-16 16:40:21.000000', 217, 2),
(222, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:22.000000', 218, 2),
(223, 'CREAR_RESPUESTA', 'Valor: \'78\'', '2025-11-16 16:40:22.000000', 219, 2),
(224, 'CREAR_RESPUESTA', 'Valor: \'1.60\'', '2025-11-16 16:40:22.000000', 220, 2),
(225, 'CREAR_RESPUESTA', 'Valor: \'30.47\'', '2025-11-16 16:40:22.000000', 221, 2),
(226, 'CREAR_RESPUESTA', 'Valor: \'Fumador actual\'', '2025-11-16 16:40:22.000000', 222, 2),
(227, 'CREAR_RESPUESTA', 'Valor: \'>25\'', '2025-11-16 16:40:22.000000', 223, 2),
(228, 'CREAR_RESPUESTA', 'Valor: \'1–9 cigarrillos/día (poco)\'', '2025-11-16 16:40:22.000000', 224, 2),
(229, 'CREAR_RESPUESTA', 'Valor: \'10–20 años\'', '2025-11-16 16:40:22.000000', 225, 2),
(230, 'CREAR_RESPUESTA', 'Valor: \'Nunca\'', '2025-11-16 16:40:22.000000', 226, 2),
(231, 'CREAR_RESPUESTA', 'Valor: \'≥3/sem\'', '2025-11-16 16:40:22.000000', 227, 2),
(232, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:22.000000', 228, 2),
(233, 'CREAR_RESPUESTA', 'Valor: \'≤2 porciones/día (bajo/insuficiente, riesgo)\'', '2025-11-16 16:40:22.000000', 229, 2),
(234, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:22.000000', 230, 2),
(235, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:22.000000', 231, 2),
(236, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:22.000000', 232, 2),
(237, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:22.000000', 233, 2),
(238, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:22.000000', 234, 2),
(239, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:40:22.000000', 235, 2),
(240, 'CREAR_RESPUESTA', 'Valor: \'Hervir\'', '2025-11-16 16:40:22.000000', 236, 2),
(241, 'CREAR_RESPUESTA', 'Valor: \'Endoscopía/biopsia\'', '2025-11-16 16:40:22.000000', 237, 2),
(242, 'CREAR_RESPUESTA', 'Valor: \'Positivo\'', '2025-11-16 16:40:22.000000', 238, 2),
(243, 'CREAR_RESPUESTA', 'Valor: \'<1 año\'', '2025-11-16 16:40:22.000000', 239, 2),
(244, 'CREAR_RESPUESTA', 'Valor: \'02/11/2025\'', '2025-11-16 16:40:22.000000', 240, 2),
(245, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:40:22.000000', 241, 2),
(246, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:22.000000', 242, 2),
(247, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:40:22.000000', 243, 2),
(248, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:40:22.000000', 244, 2),
(249, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:22.000000', 245, 2),
(250, 'CREAR_RESPUESTA', 'Valor: \'GT\'', '2025-11-16 16:40:22.000000', 246, 2),
(251, 'CREAR_RESPUESTA', 'Valor: \'Otro\'', '2025-11-16 16:40:22.000000', 247, 2),
(252, 'CREAR_RESPUESTA', 'Valor: \'Linfoma MALT\'', '2025-11-16 16:40:22.000000', 248, 2),
(253, 'CREAR_RESPUESTA', 'Valor: \'Difuso\'', '2025-11-16 16:40:22.000000', 249, 2),
(254, 'CREAR_RESPUESTA', 'Valor: \'T1N0M0\'', '2025-11-16 16:40:22.000000', 250, 2),
(255, 'CREAR_PACIENTE', 'Paciente creado con codigo: CAS_005', '2025-11-16 16:40:22.000000', NULL, 2),
(256, 'CREAR_RESPUESTA', 'Valor: \'Ana Gutiérrez\'', '2025-11-16 16:40:33.000000', 251, 2),
(257, 'CREAR_RESPUESTA', 'Valor: \'45\'', '2025-11-16 16:40:33.000000', 252, 2),
(258, 'CREAR_RESPUESTA', 'Valor: \'Mujer\'', '2025-11-16 16:40:33.000000', 253, 2),
(259, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:40:33.000000', 254, 2),
(260, 'CREAR_RESPUESTA', 'Valor: \'Las Condes 7000\'', '2025-11-16 16:40:33.000000', 255, 2),
(261, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:40:33.000000', 256, 2),
(262, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:40:33.000000', 257, 2),
(263, 'CREAR_RESPUESTA', 'Valor: \'Superior\'', '2025-11-16 16:40:33.000000', 258, 2),
(264, 'CREAR_RESPUESTA', 'Valor: \'Abogada\'', '2025-11-16 16:40:33.000000', 259, 2),
(265, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:33.000000', 260, 2),
(266, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:33.000000', 261, 2),
(267, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:33.000000', 262, 2),
(268, 'CREAR_RESPUESTA', 'Valor: \'Ninguna\'', '2025-11-16 16:40:33.000000', 263, 2),
(269, 'CREAR_RESPUESTA', 'Valor: \'Anticonceptivos orales\'', '2025-11-16 16:40:34.000000', 264, 2),
(270, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:34.000000', 265, 2),
(271, 'CREAR_RESPUESTA', 'Valor: \'62\'', '2025-11-16 16:40:34.000000', 266, 2),
(272, 'CREAR_RESPUESTA', 'Valor: \'1.67\'', '2025-11-16 16:40:34.000000', 267, 2),
(273, 'CREAR_RESPUESTA', 'Valor: \'22.2\'', '2025-11-16 16:40:34.000000', 268, 2),
(274, 'CREAR_RESPUESTA', 'Valor: \'Nunca fumó\'', '2025-11-16 16:40:34.000000', 269, 2),
(275, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:40:34.000000', 270, 2),
(276, 'CREAR_RESPUESTA', 'Valor: \'Ocasional (menos de 1 vez/semana)\'', '2025-11-16 16:40:34.000000', 271, 2),
(277, 'CREAR_RESPUESTA', 'Valor: \'1–2 tragos (poco)\'', '2025-11-16 16:40:34.000000', 272, 2),
(278, 'CREAR_RESPUESTA', 'Valor: \'<10 años\'', '2025-11-16 16:40:34.000000', 273, 2),
(279, 'CREAR_RESPUESTA', 'Valor: \'<1/sem\'', '2025-11-16 16:40:34.000000', 274, 2),
(280, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:34.000000', 275, 2),
(281, 'CREAR_RESPUESTA', 'Valor: \'≥5 porciones/día (adecuado/protector)\'', '2025-11-16 16:40:34.000000', 276, 2),
(282, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:34.000000', 277, 2),
(283, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:34.000000', 278, 2),
(284, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:34.000000', 279, 2),
(285, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:34.000000', 280, 2),
(286, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:34.000000', 281, 2),
(287, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:40:34.000000', 282, 2),
(288, 'CREAR_RESPUESTA', 'Valor: \'Filtro\'', '2025-11-16 16:40:34.000000', 283, 2),
(289, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:40:34.000000', 284, 2),
(290, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:40:34.000000', 285, 2),
(291, 'CREAR_RESPUESTA', 'Valor: \'>5 años\'', '2025-11-16 16:40:34.000000', 286, 2),
(292, 'CREAR_RESPUESTA', 'Valor: \'05/11/2025\'', '2025-11-16 16:40:34.000000', 287, 2),
(293, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:34.000000', 288, 2),
(294, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:34.000000', 289, 2),
(295, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:40:34.000000', 290, 2),
(296, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:40:34.000000', 291, 2),
(297, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:34.000000', 292, 2),
(298, 'CREAR_RESPUESTA', 'Valor: \'GT\'', '2025-11-16 16:40:34.000000', 293, 2),
(299, 'CREAR_PACIENTE', 'Paciente creado con codigo: CONT_001', '2025-11-16 16:40:34.000000', NULL, 2),
(300, 'CREAR_RESPUESTA', 'Valor: \'Mario Valenzuela\'', '2025-11-16 16:40:41.000000', 294, 2),
(301, 'CREAR_RESPUESTA', 'Valor: \'58\'', '2025-11-16 16:40:41.000000', 295, 2),
(302, 'CREAR_RESPUESTA', 'Valor: \'Hombre\'', '2025-11-16 16:40:41.000000', 296, 2),
(303, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:40:41.000000', 297, 2),
(304, 'CREAR_RESPUESTA', 'Valor: \'Fundo El Roble, Coltauco\'', '2025-11-16 16:40:42.000000', 298, 2),
(305, 'CREAR_RESPUESTA', 'Valor: \'Rural\'', '2025-11-16 16:40:42.000000', 299, 2),
(306, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:40:42.000000', 300, 2),
(307, 'CREAR_RESPUESTA', 'Valor: \'Medio\'', '2025-11-16 16:40:42.000000', 301, 2),
(308, 'CREAR_RESPUESTA', 'Valor: \'Capataz\'', '2025-11-16 16:40:42.000000', 302, 2),
(309, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 303, 2),
(310, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 304, 2),
(311, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 305, 2),
(312, 'CREAR_RESPUESTA', 'Valor: \'Ninguna\'', '2025-11-16 16:40:42.000000', 306, 2),
(313, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:40:42.000000', 307, 2),
(314, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 308, 2),
(315, 'CREAR_RESPUESTA', 'Valor: \'75\'', '2025-11-16 16:40:42.000000', 309, 2),
(316, 'CREAR_RESPUESTA', 'Valor: \'1.75\'', '2025-11-16 16:40:42.000000', 310, 2),
(317, 'CREAR_RESPUESTA', 'Valor: \'24.49\'', '2025-11-16 16:40:42.000000', 311, 2),
(318, 'CREAR_RESPUESTA', 'Valor: \'Nunca fumó\'', '2025-11-16 16:40:42.000000', 312, 2),
(319, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:40:42.000000', 313, 2),
(320, 'CREAR_RESPUESTA', 'Valor: \'Regular (1–3 veces/semana)\'', '2025-11-16 16:40:42.000000', 314, 2),
(321, 'CREAR_RESPUESTA', 'Valor: \'1–2 tragos (poco)\'', '2025-11-16 16:40:42.000000', 315, 2),
(322, 'CREAR_RESPUESTA', 'Valor: \'>20 años\'', '2025-11-16 16:40:42.000000', 316, 2),
(323, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:42.000000', 317, 2),
(324, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 318, 2),
(325, 'CREAR_RESPUESTA', 'Valor: \'3–4 porciones/día (intermedio)\'', '2025-11-16 16:40:42.000000', 319, 2),
(326, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 320, 2),
(327, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:42.000000', 321, 2),
(328, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 322, 2),
(329, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:42.000000', 323, 2),
(330, 'CREAR_RESPUESTA', 'Valor: \'Estacional\'', '2025-11-16 16:40:42.000000', 324, 2),
(331, 'CREAR_RESPUESTA', 'Valor: \'Pozo\'', '2025-11-16 16:40:42.000000', 325, 2),
(332, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:40:42.000000', 326, 2),
(333, 'CREAR_RESPUESTA', 'Valor: \'Antígeno en deposiciones\'', '2025-11-16 16:40:42.000000', 327, 2),
(334, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:40:42.000000', 328, 2),
(335, 'CREAR_RESPUESTA', 'Valor: \'1–5 años\'', '2025-11-16 16:40:42.000000', 329, 2),
(336, 'CREAR_RESPUESTA', 'Valor: \'06/11/2025\'', '2025-11-16 16:40:42.000000', 330, 2),
(337, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:40:42.000000', 331, 2),
(338, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:42.000000', 332, 2),
(339, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:40:42.000000', 333, 2),
(340, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:42.000000', 334, 2),
(341, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:40:42.000000', 335, 2),
(342, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:40:42.000000', 336, 2),
(343, 'CREAR_PACIENTE', 'Paciente creado con codigo: CONT_002', '2025-11-16 16:40:42.000000', NULL, 2),
(344, 'CREAR_RESPUESTA', 'Valor: \'Teresa Morales\'', '2025-11-16 16:40:51.000000', 337, 2),
(345, 'CREAR_RESPUESTA', 'Valor: \'65\'', '2025-11-16 16:40:51.000000', 338, 2),
(346, 'CREAR_RESPUESTA', 'Valor: \'Mujer\'', '2025-11-16 16:40:51.000000', 339, 2),
(347, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:40:51.000000', 340, 2),
(348, 'CREAR_RESPUESTA', 'Valor: \'Maipú 1200\'', '2025-11-16 16:40:51.000000', 341, 2),
(349, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:40:51.000000', 342, 2),
(350, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:40:51.000000', 343, 2),
(351, 'CREAR_RESPUESTA', 'Valor: \'Medio\'', '2025-11-16 16:40:51.000000', 344, 2),
(352, 'CREAR_RESPUESTA', 'Valor: \'Dueña de casa\'', '2025-11-16 16:40:51.000000', 345, 2),
(353, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 346, 2),
(354, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 347, 2),
(355, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:51.000000', 348, 2),
(356, 'CREAR_RESPUESTA', 'Valor: \'Diabetes (Madre)\'', '2025-11-16 16:40:51.000000', 349, 2),
(357, 'CREAR_RESPUESTA', 'Valor: \'Artrosis\'', '2025-11-16 16:40:51.000000', 350, 2),
(358, 'CREAR_RESPUESTA', 'Valor: \'Paracetamol (AINE ocasional)\'', '2025-11-16 16:40:51.000000', 351, 2),
(359, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 352, 2),
(360, 'CREAR_RESPUESTA', 'Valor: \'70\'', '2025-11-16 16:40:51.000000', 353, 2),
(361, 'CREAR_RESPUESTA', 'Valor: \'1.62\'', '2025-11-16 16:40:51.000000', 354, 2),
(362, 'CREAR_RESPUESTA', 'Valor: \'26.67\'', '2025-11-16 16:40:51.000000', 355, 2),
(363, 'CREAR_RESPUESTA', 'Valor: \'Exfumador\'', '2025-11-16 16:40:51.000000', 356, 2),
(364, 'CREAR_RESPUESTA', 'Valor: \'18–25\'', '2025-11-16 16:40:51.000000', 357, 2),
(365, 'CREAR_RESPUESTA', 'Valor: \'1–9 cigarrillos/día (poco)\'', '2025-11-16 16:40:51.000000', 358, 2),
(366, 'CREAR_RESPUESTA', 'Valor: \'10–20 años\'', '2025-11-16 16:40:51.000000', 359, 2),
(367, 'CREAR_RESPUESTA', 'Valor: \'>10 años\'', '2025-11-16 16:40:51.000000', 360, 2),
(368, 'CREAR_RESPUESTA', 'Valor: \'Nunca\'', '2025-11-16 16:40:51.000000', 361, 2),
(369, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:51.000000', 362, 2),
(370, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 363, 2),
(371, 'CREAR_RESPUESTA', 'Valor: \'3–4 porciones/día (intermedio)\'', '2025-11-16 16:40:51.000000', 364, 2),
(372, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:40:51.000000', 365, 2),
(373, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:40:51.000000', 366, 2),
(374, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 367, 2),
(375, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:40:51.000000', 368, 2),
(376, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:40:51.000000', 369, 2),
(377, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:40:51.000000', 370, 2),
(378, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:40:51.000000', 371, 2),
(379, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:40:51.000000', 372, 2),
(380, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:40:52.000000', 373, 2),
(381, 'CREAR_RESPUESTA', 'Valor: \'1–5 años\'', '2025-11-16 16:40:52.000000', 374, 2),
(382, 'CREAR_RESPUESTA', 'Valor: \'10/11/2025\'', '2025-11-16 16:40:52.000000', 375, 2),
(383, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:40:52.000000', 376, 2),
(384, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:40:52.000000', 377, 2),
(385, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:40:52.000000', 378, 2),
(386, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:40:52.000000', 379, 2),
(387, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:40:52.000000', 380, 2),
(388, 'CREAR_RESPUESTA', 'Valor: \'GT\'', '2025-11-16 16:40:52.000000', 381, 2),
(389, 'CREAR_PACIENTE', 'Paciente creado con codigo: CONT_003', '2025-11-16 16:40:52.000000', NULL, 2),
(390, 'CREAR_RESPUESTA', 'Valor: \'Luis Jiménez\'', '2025-11-16 16:41:00.000000', 382, 2),
(391, 'CREAR_RESPUESTA', 'Valor: \'51\'', '2025-11-16 16:41:00.000000', 383, 2),
(392, 'CREAR_RESPUESTA', 'Valor: \'Hombre\'', '2025-11-16 16:41:00.000000', 384, 2),
(393, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:41:00.000000', 385, 2),
(394, 'CREAR_RESPUESTA', 'Valor: \'Gran Avenida 4500\'', '2025-11-16 16:41:00.000000', 386, 2),
(395, 'CREAR_RESPUESTA', 'Valor: \'Urbana\'', '2025-11-16 16:41:00.000000', 387, 2),
(396, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:41:00.000000', 388, 2),
(397, 'CREAR_RESPUESTA', 'Valor: \'Técnico\'', '2025-11-16 16:41:00.000000', 389, 2),
(398, 'CREAR_RESPUESTA', 'Valor: \'Comerciante\'', '2025-11-16 16:41:00.000000', 390, 2),
(399, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 391, 2),
(400, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 392, 2),
(401, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 393, 2),
(402, 'CREAR_RESPUESTA', 'Valor: \'Dislipidemia\'', '2025-11-16 16:41:00.000000', 394, 2),
(403, 'CREAR_RESPUESTA', 'Valor: \'Atorvastatina\'', '2025-11-16 16:41:00.000000', 395, 2),
(404, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 396, 2),
(405, 'CREAR_RESPUESTA', 'Valor: \'90\'', '2025-11-16 16:41:00.000000', 397, 2),
(406, 'CREAR_RESPUESTA', 'Valor: \'1.76\'', '2025-11-16 16:41:00.000000', 398, 2),
(407, 'CREAR_RESPUESTA', 'Valor: \'29.02\'', '2025-11-16 16:41:00.000000', 399, 2),
(408, 'CREAR_RESPUESTA', 'Valor: \'Nunca fumó\'', '2025-11-16 16:41:00.000000', 400, 2),
(409, 'CREAR_RESPUESTA', 'Valor: \'Consumidor actual\'', '2025-11-16 16:41:00.000000', 401, 2),
(410, 'CREAR_RESPUESTA', 'Valor: \'Ocasional (menos de 1 vez/semana)\'', '2025-11-16 16:41:00.000000', 402, 2),
(411, 'CREAR_RESPUESTA', 'Valor: \'3–4 tragos (moderado)\'', '2025-11-16 16:41:00.000000', 403, 2),
(412, 'CREAR_RESPUESTA', 'Valor: \'10–20 años\'', '2025-11-16 16:41:00.000000', 404, 2),
(413, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:41:00.000000', 405, 2),
(414, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 406, 2),
(415, 'CREAR_RESPUESTA', 'Valor: \'3–4 porciones/día (intermedio)\'', '2025-11-16 16:41:00.000000', 407, 2),
(416, 'CREAR_RESPUESTA', 'Valor: \'Sí\'', '2025-11-16 16:41:00.000000', 408, 2),
(417, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:41:00.000000', 409, 2),
(418, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 410, 2),
(419, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:00.000000', 411, 2),
(420, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:41:00.000000', 412, 2),
(421, 'CREAR_RESPUESTA', 'Valor: \'Red pública\'', '2025-11-16 16:41:00.000000', 413, 2),
(422, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:41:00.000000', 414, 2),
(423, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:41:00.000000', 415, 2),
(424, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:41:00.000000', 416, 2),
(425, 'CREAR_RESPUESTA', 'Valor: \'<1 año\'', '2025-11-16 16:41:00.000000', 417, 2),
(426, 'CREAR_RESPUESTA', 'Valor: \'12/11/2025\'', '2025-11-16 16:41:00.000000', 418, 2),
(427, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:41:00.000000', 419, 2),
(428, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:41:00.000000', 420, 2),
(429, 'CREAR_RESPUESTA', 'Valor: \'GC\'', '2025-11-16 16:41:00.000000', 421, 2),
(430, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:41:00.000000', 422, 2),
(431, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:41:00.000000', 423, 2),
(432, 'CREAR_RESPUESTA', 'Valor: \'GG\'', '2025-11-16 16:41:00.000000', 424, 2),
(433, 'CREAR_PACIENTE', 'Paciente creado con codigo: CONT_004', '2025-11-16 16:41:00.000000', NULL, 2),
(434, 'CREAR_RESPUESTA', 'Valor: \'Elena Castro\'', '2025-11-16 16:41:08.000000', 425, 2),
(435, 'CREAR_RESPUESTA', 'Valor: \'70\'', '2025-11-16 16:41:08.000000', 426, 2),
(436, 'CREAR_RESPUESTA', 'Valor: \'Mujer\'', '2025-11-16 16:41:08.000000', 427, 2),
(437, 'CREAR_RESPUESTA', 'Valor: \'Chilena\'', '2025-11-16 16:41:08.000000', 428, 2),
(438, 'CREAR_RESPUESTA', 'Valor: \'Plaza de Armas 100, Talagante\'', '2025-11-16 16:41:08.000000', 429, 2),
(439, 'CREAR_RESPUESTA', 'Valor: \'Rural\'', '2025-11-16 16:41:08.000000', 430, 2),
(440, 'CREAR_RESPUESTA', 'Valor: \'>10\'', '2025-11-16 16:41:08.000000', 431, 2),
(441, 'CREAR_RESPUESTA', 'Valor: \'Básico\'', '2025-11-16 16:41:08.000000', 432, 2),
(442, 'CREAR_RESPUESTA', 'Valor: \'Jubilada\'', '2025-11-16 16:41:08.000000', 433, 2),
(443, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 434, 2),
(444, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 435, 2),
(445, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 436, 2),
(446, 'CREAR_RESPUESTA', 'Valor: \'Ninguna\'', '2025-11-16 16:41:08.000000', 437, 2),
(447, 'CREAR_RESPUESTA', 'Valor: \'Ninguno\'', '2025-11-16 16:41:08.000000', 438, 2),
(448, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 439, 2),
(449, 'CREAR_RESPUESTA', 'Valor: \'64\'', '2025-11-16 16:41:08.000000', 440, 2),
(450, 'CREAR_RESPUESTA', 'Valor: \'1.58\'', '2025-11-16 16:41:08.000000', 441, 2),
(451, 'CREAR_RESPUESTA', 'Valor: \'25.64\'', '2025-11-16 16:41:08.000000', 442, 2),
(452, 'CREAR_RESPUESTA', 'Valor: \'Nunca fumó\'', '2025-11-16 16:41:08.000000', 443, 2),
(453, 'CREAR_RESPUESTA', 'Valor: \'Exconsumidor\'', '2025-11-16 16:41:08.000000', 444, 2),
(454, 'CREAR_RESPUESTA', 'Valor: \'Ocasional (menos de 1 vez/semana)\'', '2025-11-16 16:41:08.000000', 445, 2),
(455, 'CREAR_RESPUESTA', 'Valor: \'1–2 tragos (poco)\'', '2025-11-16 16:41:08.000000', 446, 2),
(456, 'CREAR_RESPUESTA', 'Valor: \'<10 años\'', '2025-11-16 16:41:08.000000', 447, 2),
(457, 'CREAR_RESPUESTA', 'Valor: \'>10 años\'', '2025-11-16 16:41:08.000000', 448, 2),
(458, 'CREAR_RESPUESTA', 'Valor: \'1–2/sem\'', '2025-11-16 16:41:08.000000', 449, 2),
(459, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 450, 2),
(460, 'CREAR_RESPUESTA', 'Valor: \'≥5 porciones/día (adecuado/protector)\'', '2025-11-16 16:41:08.000000', 451, 2),
(461, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 452, 2),
(462, 'CREAR_RESPUESTA', 'Valor: \'Nunca/Rara vez\'', '2025-11-16 16:41:08.000000', 453, 2),
(463, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 454, 2),
(464, 'CREAR_RESPUESTA', 'Valor: \'No\'', '2025-11-16 16:41:08.000000', 455, 2),
(465, 'CREAR_RESPUESTA', 'Valor: \'Estacional\'', '2025-11-16 16:41:08.000000', 456, 2),
(466, 'CREAR_RESPUESTA', 'Valor: \'Pozo\'', '2025-11-16 16:41:08.000000', 457, 2),
(467, 'CREAR_RESPUESTA', 'Valor: \'Hervir\'', '2025-11-16 16:41:08.000000', 458, 2),
(468, 'CREAR_RESPUESTA', 'Valor: \'Test de aliento\'', '2025-11-16 16:41:08.000000', 459, 2),
(469, 'CREAR_RESPUESTA', 'Valor: \'Negativo\'', '2025-11-16 16:41:08.000000', 460, 2),
(470, 'CREAR_RESPUESTA', 'Valor: \'>5 años\'', '2025-11-16 16:41:08.000000', 461, 2),
(471, 'CREAR_RESPUESTA', 'Valor: \'15/11/2025\'', '2025-11-16 16:41:08.000000', 462, 2),
(472, 'CREAR_RESPUESTA', 'Valor: \'TC\'', '2025-11-16 16:41:08.000000', 463, 2),
(473, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:41:08.000000', 464, 2),
(474, 'CREAR_RESPUESTA', 'Valor: \'CC\'', '2025-11-16 16:41:08.000000', 465, 2),
(475, 'CREAR_RESPUESTA', 'Valor: \'CT\'', '2025-11-16 16:41:08.000000', 466, 2),
(476, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:41:08.000000', 467, 2),
(477, 'CREAR_RESPUESTA', 'Valor: \'TT\'', '2025-11-16 16:41:08.000000', 468, 2),
(478, 'CREAR_PACIENTE', 'Paciente creado con codigo: CONT_005', '2025-11-16 16:41:08.000000', NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta`
--

CREATE TABLE `respuesta` (
  `respuesta_id` bigint(20) NOT NULL,
  `valor` varchar(255) NOT NULL,
  `paciente_id` bigint(20) NOT NULL,
  `pregunta_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `respuesta`
--

INSERT INTO `respuesta` (`respuesta_id`, `valor`, `paciente_id`, `pregunta_id`) VALUES
(1, 'Carlos Soto Pérez', 1, 1),
(2, '68', 1, 2),
(3, 'Hombre', 1, 3),
(4, 'Chilena', 1, 4),
(5, 'Calle Falsa 123, Santiago', 1, 5),
(6, 'Urbana', 1, 6),
(7, '>10', 1, 7),
(8, 'Medio', 1, 8),
(9, 'Jubilado (Ex-Obrero)', 1, 9),
(10, 'Sí', 1, 10),
(11, '15/09/2025', 1, 11),
(12, 'No', 1, 12),
(13, 'Sí', 1, 13),
(14, 'Cáncer de Próstata (Padre)', 1, 14),
(15, 'Gastritis crónica, HTA', 1, 15),
(16, 'Losartán, Omeprazol (IBP)', 1, 16),
(17, 'No', 1, 17),
(18, '80', 1, 18),
(19, '1.70', 1, 19),
(20, '27.68', 1, 20),
(21, 'Fumador actual', 1, 21),
(22, '<18', 1, 22),
(23, '10–19 cigarrillos/día (moderado)', 1, 23),
(24, '>20 años', 1, 24),
(25, 'Consumidor actual', 1, 26),
(26, 'Regular (1–3 veces/semana)', 1, 27),
(27, '3–4 tragos (moderado)', 1, 28),
(28, '>20 años', 1, 29),
(29, '≥3/sem', 1, 31),
(30, 'Sí', 1, 32),
(31, '≤2 porciones/día (bajo/insuficiente, riesgo)', 1, 33),
(32, 'Sí', 1, 34),
(33, '≥3/sem', 1, 35),
(34, 'No', 1, 36),
(35, 'No', 1, 37),
(36, 'Nunca/Rara vez', 1, 39),
(37, 'Red pública', 1, 40),
(38, 'Ninguno', 1, 42),
(39, 'Endoscopía/biopsia', 1, 43),
(40, 'Positivo', 1, 44),
(41, '<1 año', 1, 45),
(42, '20/10/2025', 1, 46),
(43, 'TC', 1, 47),
(44, 'TT', 1, 48),
(45, 'GC', 1, 49),
(46, 'CT', 1, 50),
(47, 'CC', 1, 51),
(48, 'GT', 1, 52),
(49, 'Intestinal', 1, 53),
(50, 'Antro', 1, 55),
(51, 'T2N1M0', 1, 56),
(52, 'Mónica Rojas Tapia', 2, 1),
(53, '55', 2, 2),
(54, 'Mujer', 2, 3),
(55, 'Chilena', 2, 4),
(56, 'Av. Providencia 1000', 2, 5),
(57, 'Urbana', 2, 6),
(58, '5 – 10', 2, 7),
(59, 'Superior', 2, 8),
(60, 'Contadora', 2, 9),
(61, 'Sí', 2, 10),
(62, '01/10/2025', 2, 11),
(63, 'Sí', 2, 12),
(64, 'No', 2, 13),
(65, 'Anemia', 2, 15),
(66, 'Hierro', 2, 16),
(67, 'No', 2, 17),
(68, '65', 2, 18),
(69, '1.65', 2, 19),
(70, '23.87', 2, 20),
(71, 'Exfumador', 2, 21),
(72, '18–25', 2, 22),
(73, '1–9 cigarrillos/día (poco)', 2, 23),
(74, '10–20 años', 2, 24),
(75, '5–10 años', 2, 25),
(76, 'Consumidor actual', 2, 26),
(77, 'Ocasional (menos de 1 vez/semana)', 2, 27),
(78, '1–2 tragos (poco)', 2, 28),
(79, '<10 años', 2, 29),
(80, '1–2/sem', 2, 31),
(81, 'No', 2, 32),
(82, '3–4 porciones/día (intermedio)', 2, 33),
(83, 'No', 2, 34),
(84, '1–2/sem', 2, 35),
(85, 'No', 2, 36),
(86, 'No', 2, 37),
(87, 'Nunca/Rara vez', 2, 39),
(88, 'Red pública', 2, 40),
(89, 'Filtro', 2, 42),
(90, 'Test de aliento', 2, 43),
(91, 'Positivo', 2, 44),
(92, '1–5 años', 2, 45),
(93, '22/10/2025', 2, 46),
(94, 'TT', 2, 47),
(95, 'TC', 2, 48),
(96, 'GG', 2, 49),
(97, 'CC', 2, 50),
(98, 'CT', 2, 51),
(99, 'GG', 2, 52),
(100, 'Difuso', 2, 53),
(101, 'Cuerpo', 2, 55),
(102, 'T3N1M0', 2, 56),
(103, 'José Manuel Campos', 3, 1),
(104, '72', 3, 2),
(105, 'Hombre', 3, 3),
(106, 'Chilena', 3, 4),
(107, 'Parcela 14, Melipilla', 3, 5),
(108, 'Rural', 3, 6),
(109, '>10', 3, 7),
(110, 'Básico', 3, 8),
(111, 'Agricultor', 3, 9),
(112, 'Sí', 3, 10),
(113, '20/10/2025', 3, 11),
(114, 'No', 3, 12),
(115, 'No', 3, 13),
(116, 'Úlcera péptica (antigua)', 3, 15),
(117, 'Ninguno', 3, 16),
(118, 'Sí', 3, 17),
(119, '68', 3, 18),
(120, '1.68', 3, 19),
(121, '24.1', 3, 20),
(122, 'Nunca fumó', 3, 21),
(123, 'Exconsumidor', 3, 26),
(124, 'Regular (1–3 veces/semana)', 3, 27),
(125, '≥5 tragos (mucho)', 3, 28),
(126, '>20 años', 3, 29),
(127, '>10 años', 3, 30),
(128, '1–2/sem', 3, 31),
(129, 'Sí', 3, 32),
(130, '≤2 porciones/día (bajo/insuficiente, riesgo)', 3, 33),
(131, 'Sí', 3, 34),
(132, '≥3/sem', 3, 35),
(133, 'Sí', 3, 36),
(134, 'No', 3, 37),
(135, 'Diario', 3, 39),
(136, 'Pozo', 3, 40),
(137, 'Hervir', 3, 42),
(138, 'Antígeno en deposiciones', 3, 43),
(139, 'Positivo', 3, 44),
(140, '<1 año', 3, 45),
(141, '25/10/2025', 3, 46),
(142, 'CC', 3, 47),
(143, 'TC', 3, 48),
(144, 'GC', 3, 49),
(145, 'TT', 3, 50),
(146, 'CT', 3, 51),
(147, 'TT', 3, 52),
(148, 'Mixto', 3, 53),
(149, 'Cuerpo', 3, 55),
(150, 'T4aN2M0', 3, 56),
(151, 'Roberto Núñez', 4, 1),
(152, '62', 4, 2),
(153, 'Hombre', 4, 3),
(154, 'Chilena', 4, 4),
(155, 'Los Leones 300, Providencia', 4, 5),
(156, 'Urbana', 4, 6),
(157, '>10', 4, 7),
(158, 'Superior', 4, 8),
(159, 'Ingeniero', 4, 9),
(160, 'Sí', 4, 10),
(161, '02/10/2025', 4, 11),
(162, 'No', 4, 12),
(163, 'No', 4, 13),
(164, 'HTA', 4, 15),
(165, 'Enalapril', 4, 16),
(166, 'No', 4, 17),
(167, '85', 4, 18),
(168, '1.78', 4, 19),
(169, '26.83', 4, 20),
(170, 'Exfumador', 4, 21),
(171, '18–25', 4, 22),
(172, '≥20 cigarrillos/día (mucho)', 4, 23),
(173, '>20 años', 4, 24),
(174, '<5 años', 4, 25),
(175, 'Consumidor actual', 4, 26),
(176, 'Ocasional (menos de 1 vez/semana)', 4, 27),
(177, '1–2 tragos (poco)', 4, 28),
(178, '>20 años', 4, 29),
(179, '1–2/sem', 4, 31),
(180, 'No', 4, 32),
(181, '3–4 porciones/día (intermedio)', 4, 33),
(182, 'No', 4, 34),
(183, 'Nunca/Rara vez', 4, 35),
(184, 'No', 4, 36),
(185, 'No', 4, 37),
(186, 'Nunca/Rara vez', 4, 39),
(187, 'Red pública', 4, 40),
(188, 'Ninguno', 4, 42),
(189, 'Test de aliento', 4, 43),
(190, 'Negativo', 4, 44),
(191, '1–5 años', 4, 45),
(192, '28/10/2025', 4, 46),
(193, 'TT', 4, 47),
(194, 'CC', 4, 48),
(195, 'CC', 4, 49),
(196, 'CC', 4, 50),
(197, 'TT', 4, 51),
(198, 'GG', 4, 52),
(199, 'Intestinal', 4, 53),
(200, 'Cardias', 4, 55),
(201, 'T1bN0M0', 4, 56),
(202, 'Lorena Álvarez Vera', 5, 1),
(203, '49', 5, 2),
(204, 'Mujer', 5, 3),
(205, 'Peruana', 5, 4),
(206, 'Merced 500, Santiago', 5, 5),
(207, 'Urbana', 5, 6),
(208, '5 – 10', 5, 7),
(209, 'Superior', 5, 8),
(210, 'Cocinera', 5, 9),
(211, 'Sí', 5, 10),
(212, '10/10/2025', 5, 11),
(213, 'No', 5, 12),
(214, 'Sí', 5, 13),
(215, 'Cáncer de Mama (Madre)', 5, 14),
(216, 'Resistencia a la Insulina', 5, 15),
(217, 'Metformina', 5, 16),
(218, 'No', 5, 17),
(219, '78', 5, 18),
(220, '1.60', 5, 19),
(221, '30.47', 5, 20),
(222, 'Fumador actual', 5, 21),
(223, '>25', 5, 22),
(224, '1–9 cigarrillos/día (poco)', 5, 23),
(225, '10–20 años', 5, 24),
(226, 'Nunca', 5, 26),
(227, '≥3/sem', 5, 31),
(228, 'Sí', 5, 32),
(229, '≤2 porciones/día (bajo/insuficiente, riesgo)', 5, 33),
(230, 'Sí', 5, 34),
(231, '1–2/sem', 5, 35),
(232, 'No', 5, 36),
(233, 'No', 5, 37),
(234, 'Nunca/Rara vez', 5, 39),
(235, 'Red pública', 5, 40),
(236, 'Hervir', 5, 42),
(237, 'Endoscopía/biopsia', 5, 43),
(238, 'Positivo', 5, 44),
(239, '<1 año', 5, 45),
(240, '02/11/2025', 5, 46),
(241, 'TC', 5, 47),
(242, 'TT', 5, 48),
(243, 'GC', 5, 49),
(244, 'CT', 5, 50),
(245, 'CC', 5, 51),
(246, 'GT', 5, 52),
(247, 'Otro', 5, 53),
(248, 'Linfoma MALT', 5, 54),
(249, 'Difuso', 5, 55),
(250, 'T1N0M0', 5, 56),
(251, 'Ana Gutiérrez', 6, 1),
(252, '45', 6, 2),
(253, 'Mujer', 6, 3),
(254, 'Chilena', 6, 4),
(255, 'Las Condes 7000', 6, 5),
(256, 'Urbana', 6, 6),
(257, '>10', 6, 7),
(258, 'Superior', 6, 8),
(259, 'Abogada', 6, 9),
(260, 'No', 6, 10),
(261, 'No', 6, 12),
(262, 'No', 6, 13),
(263, 'Ninguna', 6, 15),
(264, 'Anticonceptivos orales', 6, 16),
(265, 'No', 6, 17),
(266, '62', 6, 18),
(267, '1.67', 6, 19),
(268, '22.2', 6, 20),
(269, 'Nunca fumó', 6, 21),
(270, 'Consumidor actual', 6, 26),
(271, 'Ocasional (menos de 1 vez/semana)', 6, 27),
(272, '1–2 tragos (poco)', 6, 28),
(273, '<10 años', 6, 29),
(274, '<1/sem', 6, 31),
(275, 'No', 6, 32),
(276, '≥5 porciones/día (adecuado/protector)', 6, 33),
(277, 'No', 6, 34),
(278, 'Nunca/Rara vez', 6, 35),
(279, 'No', 6, 36),
(280, 'No', 6, 37),
(281, 'Nunca/Rara vez', 6, 39),
(282, 'Red pública', 6, 40),
(283, 'Filtro', 6, 42),
(284, 'Test de aliento', 6, 43),
(285, 'Negativo', 6, 44),
(286, '>5 años', 6, 45),
(287, '05/11/2025', 6, 46),
(288, 'TT', 6, 47),
(289, 'CC', 6, 48),
(290, 'GG', 6, 49),
(291, 'CT', 6, 50),
(292, 'CC', 6, 51),
(293, 'GT', 6, 52),
(294, 'Mario Valenzuela', 7, 1),
(295, '58', 7, 2),
(296, 'Hombre', 7, 3),
(297, 'Chilena', 7, 4),
(298, 'Fundo El Roble, Coltauco', 7, 5),
(299, 'Rural', 7, 6),
(300, '>10', 7, 7),
(301, 'Medio', 7, 8),
(302, 'Capataz', 7, 9),
(303, 'No', 7, 10),
(304, 'No', 7, 12),
(305, 'No', 7, 13),
(306, 'Ninguna', 7, 15),
(307, 'Ninguno', 7, 16),
(308, 'No', 7, 17),
(309, '75', 7, 18),
(310, '1.75', 7, 19),
(311, '24.49', 7, 20),
(312, 'Nunca fumó', 7, 21),
(313, 'Consumidor actual', 7, 26),
(314, 'Regular (1–3 veces/semana)', 7, 27),
(315, '1–2 tragos (poco)', 7, 28),
(316, '>20 años', 7, 29),
(317, '1–2/sem', 7, 31),
(318, 'No', 7, 32),
(319, '3–4 porciones/día (intermedio)', 7, 33),
(320, 'No', 7, 34),
(321, '1–2/sem', 7, 35),
(322, 'No', 7, 36),
(323, 'No', 7, 37),
(324, 'Estacional', 7, 39),
(325, 'Pozo', 7, 40),
(326, 'Ninguno', 7, 42),
(327, 'Antígeno en deposiciones', 7, 43),
(328, 'Negativo', 7, 44),
(329, '1–5 años', 7, 45),
(330, '06/11/2025', 7, 46),
(331, 'TC', 7, 47),
(332, 'TT', 7, 48),
(333, 'GC', 7, 49),
(334, 'CC', 7, 50),
(335, 'CT', 7, 51),
(336, 'GG', 7, 52),
(337, 'Teresa Morales', 8, 1),
(338, '65', 8, 2),
(339, 'Mujer', 8, 3),
(340, 'Chilena', 8, 4),
(341, 'Maipú 1200', 8, 5),
(342, 'Urbana', 8, 6),
(343, '>10', 8, 7),
(344, 'Medio', 8, 8),
(345, 'Dueña de casa', 8, 9),
(346, 'No', 8, 10),
(347, 'No', 8, 12),
(348, 'Sí', 8, 13),
(349, 'Diabetes (Madre)', 8, 14),
(350, 'Artrosis', 8, 15),
(351, 'Paracetamol (AINE ocasional)', 8, 16),
(352, 'No', 8, 17),
(353, '70', 8, 18),
(354, '1.62', 8, 19),
(355, '26.67', 8, 20),
(356, 'Exfumador', 8, 21),
(357, '18–25', 8, 22),
(358, '1–9 cigarrillos/día (poco)', 8, 23),
(359, '10–20 años', 8, 24),
(360, '>10 años', 8, 25),
(361, 'Nunca', 8, 26),
(362, '1–2/sem', 8, 31),
(363, 'No', 8, 32),
(364, '3–4 porciones/día (intermedio)', 8, 33),
(365, 'Sí', 8, 34),
(366, '1–2/sem', 8, 35),
(367, 'No', 8, 36),
(368, 'No', 8, 37),
(369, 'Nunca/Rara vez', 8, 39),
(370, 'Red pública', 8, 40),
(371, 'Ninguno', 8, 42),
(372, 'Test de aliento', 8, 43),
(373, 'Negativo', 8, 44),
(374, '1–5 años', 8, 45),
(375, '10/11/2025', 8, 46),
(376, 'TT', 8, 47),
(377, 'TC', 8, 48),
(378, 'GC', 8, 49),
(379, 'CT', 8, 50),
(380, 'CC', 8, 51),
(381, 'GT', 8, 52),
(382, 'Luis Jiménez', 9, 1),
(383, '51', 9, 2),
(384, 'Hombre', 9, 3),
(385, 'Chilena', 9, 4),
(386, 'Gran Avenida 4500', 9, 5),
(387, 'Urbana', 9, 6),
(388, '>10', 9, 7),
(389, 'Técnico', 9, 8),
(390, 'Comerciante', 9, 9),
(391, 'No', 9, 10),
(392, 'No', 9, 12),
(393, 'No', 9, 13),
(394, 'Dislipidemia', 9, 15),
(395, 'Atorvastatina', 9, 16),
(396, 'No', 9, 17),
(397, '90', 9, 18),
(398, '1.76', 9, 19),
(399, '29.02', 9, 20),
(400, 'Nunca fumó', 9, 21),
(401, 'Consumidor actual', 9, 26),
(402, 'Ocasional (menos de 1 vez/semana)', 9, 27),
(403, '3–4 tragos (moderado)', 9, 28),
(404, '10–20 años', 9, 29),
(405, '1–2/sem', 9, 31),
(406, 'No', 9, 32),
(407, '3–4 porciones/día (intermedio)', 9, 33),
(408, 'Sí', 9, 34),
(409, 'Nunca/Rara vez', 9, 35),
(410, 'No', 9, 36),
(411, 'No', 9, 37),
(412, 'Nunca/Rara vez', 9, 39),
(413, 'Red pública', 9, 40),
(414, 'Ninguno', 9, 42),
(415, 'Test de aliento', 9, 43),
(416, 'Negativo', 9, 44),
(417, '<1 año', 9, 45),
(418, '12/11/2025', 9, 46),
(419, 'TC', 9, 47),
(420, 'TC', 9, 48),
(421, 'GC', 9, 49),
(422, 'TT', 9, 50),
(423, 'CC', 9, 51),
(424, 'GG', 9, 52),
(425, 'Elena Castro', 10, 1),
(426, '70', 10, 2),
(427, 'Mujer', 10, 3),
(428, 'Chilena', 10, 4),
(429, 'Plaza de Armas 100, Talagante', 10, 5),
(430, 'Rural', 10, 6),
(431, '>10', 10, 7),
(432, 'Básico', 10, 8),
(433, 'Jubilada', 10, 9),
(434, 'No', 10, 10),
(435, 'No', 10, 12),
(436, 'No', 10, 13),
(437, 'Ninguna', 10, 15),
(438, 'Ninguno', 10, 16),
(439, 'No', 10, 17),
(440, '64', 10, 18),
(441, '1.58', 10, 19),
(442, '25.64', 10, 20),
(443, 'Nunca fumó', 10, 21),
(444, 'Exconsumidor', 10, 26),
(445, 'Ocasional (menos de 1 vez/semana)', 10, 27),
(446, '1–2 tragos (poco)', 10, 28),
(447, '<10 años', 10, 29),
(448, '>10 años', 10, 30),
(449, '1–2/sem', 10, 31),
(450, 'No', 10, 32),
(451, '≥5 porciones/día (adecuado/protector)', 10, 33),
(452, 'No', 10, 34),
(453, 'Nunca/Rara vez', 10, 35),
(454, 'No', 10, 36),
(455, 'No', 10, 37),
(456, 'Estacional', 10, 39),
(457, 'Pozo', 10, 40),
(458, 'Hervir', 10, 42),
(459, 'Test de aliento', 10, 43),
(460, 'Negativo', 10, 44),
(461, '>5 años', 10, 45),
(462, '15/11/2025', 10, 46),
(463, 'TC', 10, 47),
(464, 'TT', 10, 48),
(465, 'CC', 10, 49),
(466, 'CT', 10, 50),
(467, 'TT', 10, 51),
(468, 'TT', 10, 52);

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
(2, 'ROLE_INVESTIGADOR'),
(3, 'ROLE_MEDICO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `rol_id` bigint(20) NOT NULL,
  `permiso_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol_permiso`
--

INSERT INTO `rol_permiso` (`rol_id`, `permiso_id`) VALUES
(1, 2),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(2, 2),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(4, 2),
(4, 4),
(4, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` bigint(20) NOT NULL,
  `activo` bit(1) DEFAULT NULL,
  `apellidos` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nombres` varchar(255) NOT NULL,
  `rut` varchar(255) NOT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `token_recuperacion` varchar(255) DEFAULT NULL,
  `token_rec_expiracion` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `activo`, `apellidos`, `contrasena`, `email`, `nombres`, `rut`, `telefono`, `token_recuperacion`, `token_rec_expiracion`) VALUES
(1, b'1', 'Principal', '$2a$10$HBE2scxfgBxDgIz0z./OUOOblBUCjvgnSuqX/Zea7soC.rWdpreym', 'admin@plataforma.cl', 'Admin', '11.111.111-1', NULL, NULL, NULL),
(2, b'1', 'Prueba', '$2a$10$4TzOPSwSkP0o.DiWak9WsenM5IaRC4NmCPBGfmiN7exDVr2jVTQsu', 'medico@plataforma.cl', 'Doctora', '22.222.222-2', NULL, NULL, NULL),
(3, b'1', 'Estudiante', '$2a$10$SA6Gy7s8V4jExXtVUpaCE.kZVTQTEjD.VyKM1zt/IBFc6tNuqX9FO', 'cristian.jimenez.fuentes2003@gmail.com', 'Juanito', '33.333.333-3', NULL, NULL, NULL),
(4, b'1', 'Jefe', '$2a$10$OfZGiWBtzkQAFajTAKL6J..TzJGnsXDODjtl0oHlEqKGg4rw/p.Ne', 'invest@plataforma.cl', 'Investigador', '44.444.444-4', NULL, NULL, NULL),
(5, b'1', 'Estudiante', '$2a$10$NzJPDBvFaxoNJTWAjetYsu1itciGV13x8kvY/DOEsqMaVHmdwqavG', 'estudiante2@plataforma.cl', 'Jose', '55.555.555-5', NULL, NULL, NULL),
(6, b'1', 'Apellido', '$2a$10$bFv4kIBuNPuEOp0NvVANBOX1ZHJijKh7c1.41DUZ/9zY9SUYqGei2', 'ceconor214@bablace.com', 'Dr. Nuevo', '15.345.678-9', '+56987654321', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_rol`
--

CREATE TABLE `usuario_rol` (
  `usuario_id` bigint(20) NOT NULL,
  `rol_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_rol`
--

INSERT INTO `usuario_rol` (`usuario_id`, `rol_id`) VALUES
(1, 1),
(2, 3),
(3, 4),
(4, 2),
(5, 4),
(6, 3);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_cat`);

--
-- Indices de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
  ADD PRIMARY KEY (`id_opcion`),
  ADD KEY `FKfi0g890y9huvjbg8slhx12xpe` (`pregunta_id`);

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
-- Indices de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`pregunta_id`),
  ADD KEY `FKa62e8tsgbdtx4n3lqov0uc1uh` (`categoria_id`);

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
  ADD KEY `FKd9oyrwyjw1otr38btjeevanif` (`pregunta_id`);

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
  ADD PRIMARY KEY (`rol_id`,`permiso_id`),
  ADD KEY `FKfyao8wd0o5tsyem1w55s3141k` (`permiso_id`);

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
  ADD PRIMARY KEY (`usuario_id`,`rol_id`),
  ADD KEY `FK610kvhkwcqk2pxeewur4l7bd1` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_cat` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
  MODIFY `id_opcion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

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
-- AUTO_INCREMENT de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `pregunta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT de la tabla `registro`
--
ALTER TABLE `registro`
  MODIFY `registro_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=479;

--
-- AUTO_INCREMENT de la tabla `respuesta`
--
ALTER TABLE `respuesta`
  MODIFY `respuesta_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=469;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `rol_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `opcion_pregunta`
--
ALTER TABLE `opcion_pregunta`
  ADD CONSTRAINT `FKfi0g890y9huvjbg8slhx12xpe` FOREIGN KEY (`pregunta_id`) REFERENCES `pregunta` (`pregunta_id`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `FKk850gvh3kplkn9f9mdainwuqq` FOREIGN KEY (`reclutador_id`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD CONSTRAINT `FKa62e8tsgbdtx4n3lqov0uc1uh` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id_cat`);

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
  ADD CONSTRAINT `FKd9oyrwyjw1otr38btjeevanif` FOREIGN KEY (`pregunta_id`) REFERENCES `pregunta` (`pregunta_id`);

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
