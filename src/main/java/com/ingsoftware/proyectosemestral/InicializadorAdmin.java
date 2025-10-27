package com.ingsoftware.proyectosemestral; // O tu paquete principal/configuracion

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class InicializadorAdmin implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(InicializadorAdmin.class);

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Autowired
    private RolRepositorio rolRepositorio;

    @Autowired
    private CategoriaRepositorio categoriaRepositorio;

    @Autowired
    private PasswordEncoder codificadorDeContrasena;

    @Override
    public void run(String... args) throws Exception {

        // --- 1. VERIFICACIÓN DEL ADMINISTRADOR ---
        logger.info("--- Verificando Usuario Administrador ---");
        String rutAdmin = "11.111.111-1";
        String contrasenaAdmin = "clavesecreta";
        String nombreRolAdmin = "ROLE_ADMIN";

        Optional<Usuario> adminExistente = usuarioRepositorio.findByRut(rutAdmin);

        if (adminExistente.isEmpty()) {
            logger.info("Usuario administrador no encontrado, creando uno nuevo...");

            Rol rolAdmin = rolRepositorio.findByNombre(nombreRolAdmin)
                    .orElseGet(() -> {
                        logger.warn("Rol {} no encontrado, creándolo...", nombreRolAdmin);
                        Rol nuevoRol = new Rol();
                        nuevoRol.setNombre(nombreRolAdmin);
                        return rolRepositorio.save(nuevoRol);
                    });

            Usuario admin = new Usuario();
            admin.setRut(rutAdmin);
            admin.setNombres("Admin");
            admin.setApellidos("Principal");
            admin.setEmail("admin@plataforma.cl");
            admin.setContrasena(codificadorDeContrasena.encode(contrasenaAdmin));
            admin.setActivo(true);
            admin.getRoles().add(rolAdmin);

            usuarioRepositorio.save(admin);
            logger.info("¡Usuario administrador (11.111.111-1) creado exitosamente!");

        } else {
            logger.info("El usuario administrador (11.111.111-1) ya existe.");
        }

        // --- 2. VERIFICACIÓN DEL MÉDICO ---
        logger.info("--- Verificando Usuario Médico ---");
        String rutMedico = "22.222.222-2";
        String contrasenaMedico = "clavemedico";
        String nombreRolMedico = "ROLE_MEDICO";

        Optional<Usuario> medicoExistente = usuarioRepositorio.findByRut(rutMedico);

        if (medicoExistente.isEmpty()) {
            logger.info("Usuario médico no encontrado, creando uno nuevo...");

            Rol rolMedico = rolRepositorio.findByNombre(nombreRolMedico)
                    .orElseGet(() -> {
                        logger.warn("Rol {} no encontrado, creándolo...", nombreRolMedico);
                        Rol nuevoRol = new Rol();
                        nuevoRol.setNombre(nombreRolMedico);
                        return rolRepositorio.save(nuevoRol);
                    });

            Usuario medico = new Usuario();
            medico.setRut(rutMedico);
            medico.setNombres("Doctora");
            medico.setApellidos("Prueba");
            medico.setEmail("medico@plataforma.cl");
            medico.setContrasena(codificadorDeContrasena.encode(contrasenaMedico));
            medico.setActivo(true);
            medico.getRoles().add(rolMedico);

            usuarioRepositorio.save(medico);
            logger.info("¡Usuario médico (22.222.222-2) creado exitosamente!");

        } else {
            logger.info("El usuario médico (22.222.222-2) ya existe.");
        }

        // --- 3. VERIFICACIÓN DE CATEGORÍAS BASE ---
        logger.info("--- Verificando Categorías Base ---");

        if (categoriaRepositorio.count() == 0) {
            logger.info("No se encontraron categorías, creando categorías por defecto...");

            Categoria cat1 = new Categoria();
            cat1.setNombre("Datos Demográficos");
            // cat1.setDescripcion(...); // <--- Línea eliminada
            cat1.setOrden(1);
            categoriaRepositorio.save(cat1);

            Categoria cat2 = new Categoria();
            cat2.setNombre("Hábitos");
            // cat2.setDescripcion(...); // <--- Línea eliminada
            cat2.setOrden(2);
            categoriaRepositorio.save(cat2);

            Categoria cat3 = new Categoria();
            cat3.setNombre("Antecedentes Mórbidos");
            // cat3.setDescripcion(...); // <--- Línea eliminada
            cat3.setOrden(3);
            categoriaRepositorio.save(cat3);

            logger.info("¡Categorías base (ID 1, 2, 3) creadas exitosamente!");
        } else {
            logger.info("Las categorías base ya existen.");
        }
    }
}