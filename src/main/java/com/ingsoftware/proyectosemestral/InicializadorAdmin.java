package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Set;

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

    // --- MÉTODOS HELPER ---

    private Permiso crearPermisoSiNoExiste(String nombre, String descripcion) {
        return permisoRepositorio.findByNombre(nombre)
                .orElseGet(() -> permisoRepositorio.save(new Permiso(null, nombre, descripcion, null)));
    }

    private Rol crearRolSiNoExiste(String nombre) {
        return rolRepositorio.findByNombre(nombre)
                .orElseGet(() -> {
                    Rol r = new Rol();
                    r.setNombre(nombre);
                    return rolRepositorio.save(r);
                });
    }

    private Categoria crearCategoriaSiNoExiste(String nombre, int orden) {
        return categoriaRepositorio.findByNombre(nombre)
                .orElseGet(() -> {
                    Categoria c = new Categoria();
                    c.setNombre(nombre);
                    c.setOrden(orden);
                    return categoriaRepositorio.save(c);
                });
    }

    // HELPER MEJORADO: Acepta valorDicotomizacion (valor fijo)
    private void crearPreguntaSiNoExiste(String etiqueta, String codigoStata, TipoDato tipo, int orden, String nombreCategoria, Double valorFijo) {
        if (preguntaRepositorio.findByEtiqueta(etiqueta).isEmpty()) {
            Categoria cat = categoriaRepositorio.findByNombre(nombreCategoria)
                    .orElseThrow(() -> new RuntimeException("Categoria no encontrada: " + nombreCategoria));

            Pregunta p = new Pregunta();
            p.setEtiqueta(etiqueta);
            p.setCodigoStata(codigoStata); // Seteamos el código para Stata
            p.setDescripcion("Pregunta base inicializada por sistema");
            p.setTipo_dato(tipo);
            p.setOrden(orden);
            p.setCategoria(cat);
            p.setActivo(true);
            p.setExportable(true);
            p.setDato_sensible(false);

            // Configuración de Dicotomización Fija (Dinámica)
            if (valorFijo != null) {
                p.setDicotomizacion(valorFijo); // Esto activará la 3ra columna en el Excel
                p.setTipoCorte(TipoCorte.VALOR_FIJO);
                p.setSentido_corte(SentidoCorte.MAYOR_O_IGUAL); // Por defecto: 1 si >= valor
            } else {
                p.setTipoCorte(TipoCorte.NINGUNO);
            }

            // Detección automática de PII
            if (tipo == TipoDato.RUT || etiqueta.toLowerCase().contains("nombre")) {
                p.setDato_sensible(true);
            }

            preguntaRepositorio.save(p);
            logger.info("Pregunta creada: {} (Corte Fijo: {})", etiqueta, valorFijo);
        }
    }

    // Sobrecarga para cuando no queremos valor fijo
    private void crearPreguntaSiNoExiste(String etiqueta, String codigoStata, TipoDato tipo, int orden, String nombreCategoria) {
        crearPreguntaSiNoExiste(etiqueta, codigoStata, tipo, orden, nombreCategoria, null);
    }

    @Override
    public void run(String... args) throws Exception {
        // 1. PERMISOS
        logger.info("--- Inicializando Seguridad ---");
        Permiso pCrearCaso = crearPermisoSiNoExiste("CREAR_CASO", "Crear participante Caso");
        Permiso pCrearControl = crearPermisoSiNoExiste("CREAR_CONTROL", "Crear participante Control");
        Permiso pEditarCaso = crearPermisoSiNoExiste("EDITAR_CASO", "Editar Caso");
        Permiso pEditarControl = crearPermisoSiNoExiste("EDITAR_CONTROL", "Editar Control");
        Permiso pVerPaciente = crearPermisoSiNoExiste("VER_PACIENTE", "Ver Ficha");
        Permiso pVerListado = crearPermisoSiNoExiste("VER_LISTADO_PACIENTES", "Ver lista completa");
        Permiso pEliminar = crearPermisoSiNoExiste("ELIMINAR_PACIENTE", "Archivar paciente");

        // 2. ROLES
        Rol rolAdmin = crearRolSiNoExiste("ROLE_ADMIN");
        Rol rolMedico = crearRolSiNoExiste("ROLE_MEDICO");
        Rol rolEstudiante = crearRolSiNoExiste("ROLE_ESTUDIANTE");
        Rol rolInvestigador = crearRolSiNoExiste("ROLE_INVESTIGADOR");

        // Asignación de permisos (Simplificado para el ejemplo)
        rolAdmin.setPermisos(Set.of(pCrearControl, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolAdmin);
        rolMedico.setPermisos(Set.of(pCrearCaso, pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolMedico);

        // 3. USUARIOS
        crearUsuarioSiNoExiste("11.111.111-1", "clavesecreta", "Admin", "Principal", "admin@plataforma.cl", rolAdmin);
        crearUsuarioSiNoExiste("22.222.222-2", "clavemedico", "Dra. Ana", "Perez", "medico@plataforma.cl", rolMedico);

        // 4. CATEGORÍAS
        logger.info("--- Inicializando CRF ---");
        crearCategoriaSiNoExiste("Identificación", 1);
        crearCategoriaSiNoExiste("Datos sociodemográficos", 2);
        crearCategoriaSiNoExiste("Variables antropométricas", 3);

        // 5. PREGUNTAS (Aquí está la prueba de dicotomización)

        // Identificación
        crearPreguntaSiNoExiste("Nombre completo", "nombre_completo", TipoDato.TEXTO, 1, "Identificación");
        crearPreguntaSiNoExiste("RUT", "rut_paciente", TipoDato.RUT, 2, "Identificación");

        // Sociodemográficos -> ¡AQUÍ PROBAMOS EL VALOR FIJO!
        // Definimos que para EDAD, queremos un corte extra en 60 años.
        crearPreguntaSiNoExiste("Edad", "edad_inc", TipoDato.NUMERO, 1, "Datos sociodemográficos", 60.0);

        crearPreguntaSiNoExiste("Sexo", "sexo", TipoDato.ENUM, 2, "Datos sociodemográficos");

        // Antropometría
        // Definimos corte fijo en IMC de 25.0 (Sobrepeso)
        crearPreguntaSiNoExiste("Peso (kg)", "peso_kg", TipoDato.NUMERO, 1, "Variables antropométricas");
        crearPreguntaSiNoExiste("Estatura (m)", "talla_m", TipoDato.NUMERO, 2, "Variables antropométricas");
        crearPreguntaSiNoExiste("Índice de masa corporal (IMC)", "imc_calc", TipoDato.NUMERO, 3, "Variables antropométricas", 25.0);

        logger.info("¡Inicialización Completa! Listo para probar exportación con cortes fijos.");
    }

    private void crearUsuarioSiNoExiste(String rut, String pass, String nom, String ap, String email, Rol rol) {
        if (usuarioRepositorio.findByRut(rut).isEmpty()) {
            Usuario u = new Usuario();
            u.setRut(rut);
            u.setNombres(nom);
            u.setApellidos(ap);
            u.setEmail(email);
            u.setContrasena(codificadorDeContrasena.encode(pass));
            u.setActivo(true);
            u.getRoles().add(rol);
            usuarioRepositorio.save(u);
        }
    }
}