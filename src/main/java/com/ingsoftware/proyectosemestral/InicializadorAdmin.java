package com.ingsoftware.proyectosemestral; // O tu paquete principal/configuracion

import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
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
    private PasswordEncoder codificadorDeContrasena;

    @Override
    public void run(String... args) throws Exception {
        logger.info("Verificando si el usuario administrador existe...");

        String rutAdmin = "11.111.111-1";
        String contrasenaAdmin = "clavesecreta";
        String nombreRolAdmin = "ROLE_ADMIN";

        Optional<Usuario> usuarioExistente = usuarioRepositorio.findByRut(rutAdmin);

        if (usuarioExistente.isEmpty()) {
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
            admin.setEmail("colocar-correo-aca");
            admin.setContrasena(codificadorDeContrasena.encode(contrasenaAdmin));
            admin.setActivo(true);
            admin.getRoles().add(rolAdmin);

            usuarioRepositorio.save(admin);
            logger.info("¡Usuario administrador creado exitosamente!");

        } else {
            logger.info("El usuario administrador ya existe.");
        }
    }
}