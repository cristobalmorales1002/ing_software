package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Modelo.Permiso;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;

import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PermisoRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Set;
// No se necesita el import de BiFunction

@Component
@Profile(("!test"))
public class InicializadorAdmin implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(InicializadorAdmin.class);

    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private RolRepositorio rolRepositorio;
    @Autowired private CategoriaRepositorio categoriaRepositorio;
    @Autowired private PasswordEncoder codificadorDeContrasena;
    @Autowired private PermisoRepositorio permisoRepositorio;

    private Permiso crearPermisoSiNoExiste(String nombre, String descripcion) {
        return permisoRepositorio.findByNombre(nombre)
                .orElseGet(() -> {
                    Permiso p = new Permiso();
                    p.setNombre(nombre);
                    p.setDescripcion(descripcion);
                    return permisoRepositorio.save(p);
                });
    }

    private Rol crearRolSiNoExiste(String nombre) {
        return rolRepositorio.findByNombre(nombre)
                .orElseGet(() -> {
                    Rol r = new Rol();
                    r.setNombre(nombre);
                    return rolRepositorio.save(r);
                });
    }

    // --- NUEVO MÉTODO DE AYUDA ---
    // Sigue el mismo patrón que los otros métodos de ayuda
    private Categoria crearCategoriaSiNoExiste(String nombre, int orden) {
        return categoriaRepositorio.findByNombre(nombre)
                .orElseGet(() -> {
                    logger.info("Creando categoría que falta: {}", nombre);
                    Categoria c = new Categoria();
                    c.setNombre(nombre);
                    c.setOrden(orden);
                    return categoriaRepositorio.save(c);
                });
    }


    @Override
    public void run(String... args) throws Exception {

        logger.info("--- Verificando Permisos Base ---");
        Permiso pCrearCaso = crearPermisoSiNoExiste("CREAR_CASO", "Permite crear un nuevo participante (Caso)");
        Permiso pCrearControl = crearPermisoSiNoExiste("CREAR_CONTROL", "Permite crear un nuevo participante (Control)");
        Permiso pEditarCaso = crearPermisoSiNoExiste("EDITAR_CASO", "Permite editar respuestas de un (Caso)");
        Permiso pEditarControl = crearPermisoSiNoExiste("EDITAR_CONTROL", "Permite editar respuestas de un (Control)");
        Permiso pVerPaciente = crearPermisoSiNoExiste("VER_PACIENTE", "Permite ver la ficha de un paciente");
        Permiso pVerListado = crearPermisoSiNoExiste("VER_LISTADO_PACIENTES", "Permite ver el listado de todos los pacientes");
        Permiso pEliminar = crearPermisoSiNoExiste("ELIMINAR_PACIENTE", "Permite archivar (borrado lógico) un paciente");

        logger.info("--- Verificando Roles ---");
        Rol rolAdmin = crearRolSiNoExiste("ROLE_ADMIN");
        Rol rolInvestigador = crearRolSiNoExiste("ROLE_INVESTIGADOR");
        Rol rolMedico = crearRolSiNoExiste("ROLE_MEDICO");
        Rol rolEstudiante = crearRolSiNoExiste("ROLE_ESTUDIANTE");

        logger.info("--- Asignando Permisos a Roles ---");
        rolAdmin.setPermisos(Set.of(pCrearControl, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolAdmin);

        rolInvestigador.setPermisos(Set.of(pCrearControl, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolInvestigador);

        rolMedico.setPermisos(Set.of(pCrearCaso, pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolMedico);

        rolEstudiante.setPermisos(Set.of(pCrearControl, pEditarControl, pVerPaciente));
        rolRepositorio.save(rolEstudiante);

        logger.info("--- Verificando Usuarios ---");
        crearUsuarioSiNoExiste("11.111.111-1", "clavesecreta", "Admin", "Principal", "admin@plataforma.cl", rolAdmin);
        crearUsuarioSiNoExiste("22.222.222-2", "clavemedico", "Doctora", "Prueba", "medico@plataforma.cl", rolMedico);
        crearUsuarioSiNoExiste("33.333.333-3", "claveestudiante", "Juanito", "Estudiante", "cristian.jimenez.fuentes2003@gmail.com", rolEstudiante);
        crearUsuarioSiNoExiste("44.444.444-4", "claveinvest", "Investigador", "Jefe", "invest@plataforma.cl", rolInvestigador);
        crearUsuarioSiNoExiste("55.555.555-5", "claveestudiante2", "Jose", "Estudiante", "estudiante2@plataforma.cl", rolEstudiante);

        // --- BLOQUE DE CATEGORÍAS MODIFICADO ---
        logger.info("--- Verificando Categorías Base ---");

        // Llamamos al nuevo helper para cada categoría del CRF
        crearCategoriaSiNoExiste("Datos sociodemográficos", 1);
        crearCategoriaSiNoExiste("Antecedentes clínicos", 2);
        crearCategoriaSiNoExiste("Variables antropométricas", 3);
        crearCategoriaSiNoExiste("Tabaquismo", 4);
        crearCategoriaSiNoExiste("Consumo de alcohol", 5);
        crearCategoriaSiNoExiste("Factores dietarios y ambientales", 6);
        crearCategoriaSiNoExiste("Infección por Helicobacter pylori", 7);
        crearCategoriaSiNoExiste("Muestras biológicas y genéticas", 8);
        crearCategoriaSiNoExiste("Histopatología (solo casos)", 9);

        logger.info("¡Verificación de categorías completada!");
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
            logger.info("Usuario {} creado.", rut);
        }
    }
}