package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.UsuarioActualizarDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioCreateDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioResponseDto;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.UsuarioServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class UsuarioServicioTest {

    @Autowired
    private UsuarioServicio usuarioServicio;

    @Autowired
    private UsuarioRepositorio usuarioRepositorio;

    @Autowired
    private RolRepositorio rolRepositorio;

    private Rol crearRol(String nombre) {
        Rol r = new Rol();
        r.setNombre(nombre);
        return rolRepositorio.save(r);
    }

    @BeforeEach
    void setUp() {
        Rol rolAdmin = crearRol("ROLE_ADMIN");
        Rol rolEstudiante = crearRol("ROLE_ESTUDIANTE");

        UsuarioCreateDto adminDto = new UsuarioCreateDto();
        adminDto.setRut("11.111.111-1");
        adminDto.setNombres("Admin");
        adminDto.setApellidos("Test");
        adminDto.setEmail("admin@test.cl");
        adminDto.setPassword("clave123");
        adminDto.setRol("ROLE_ADMIN");
        usuarioServicio.create(adminDto);
    }

    @Test
    void testCrearUsuarioExitosamente() {
        UsuarioCreateDto dto = new UsuarioCreateDto();
        dto.setRut("1.111.111-1");
        dto.setNombres("Test");
        dto.setApellidos("Usuario");
        dto.setEmail("test.usuario@plataforma.cl");
        dto.setPassword("clave123");
        dto.setRol("ROLE_ESTUDIANTE");

        UsuarioResponseDto resultado = usuarioServicio.create(dto);

        assertNotNull(resultado.getUsuarioId());
        assertEquals("Test", resultado.getNombres());
        assertEquals("ROLE_ESTUDIANTE", resultado.getRol());
    }

    @Test
    void testCrearUsuarioFalla_RutDuplicado() {
        UsuarioCreateDto dto = new UsuarioCreateDto();
        dto.setRut("11.111.111-1"); // RUT Duplicado (del setUp)
        dto.setNombres("Test");
        dto.setApellidos("Duplicado");
        dto.setEmail("duplicado@plataforma.cl");
        dto.setPassword("clave123");
        dto.setRol("ROLE_ESTUDIANTE");

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            usuarioServicio.create(dto);
        });

        assertEquals("RUT ya registrado", exception.getMessage());
    }

    @Test
    void testCrearUsuarioFalla_EmailDuplicado() {
        UsuarioCreateDto dto = new UsuarioCreateDto();
        dto.setRut("2.222.222-2");
        dto.setNombres("Email");
        dto.setApellidos("Duplicado");
        dto.setEmail("admin@test.cl");
        dto.setPassword("clave123");
        dto.setRol("ROLE_ESTUDIANTE");

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            usuarioServicio.create(dto);
        });

        assertEquals("Email ya registrado", exception.getMessage());
    }

    @Test
    void testCrearUsuarioFalla_RolInvalido() {
        UsuarioCreateDto dto = new UsuarioCreateDto();
        dto.setRut("3.333.333-3");
        dto.setNombres("Rol");
        dto.setApellidos("Falso");
        dto.setEmail("rolfalso@plataforma.cl");
        dto.setPassword("clave123");
        dto.setRol("ROLE_INVENTADO");

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            usuarioServicio.create(dto);
        });

        assertTrue(exception.getMessage().contains("Rol no existe"));
    }

    @Test
    void testUsuarioActualizaSuPropioPerfil() {
        String rutAdmin = "11.111.111-1";

        UsuarioActualizarDto dto = new UsuarioActualizarDto();
        dto.setEmail("admin.nuevo.email@plataforma.cl");
        dto.setTelefono("123456789");

        UsuarioResponseDto resultado = usuarioServicio.updateProfile(rutAdmin, dto);

        assertEquals("admin.nuevo.email@plataforma.cl", resultado.getEmail());
        assertEquals("123456789", resultado.getTelefono());
    }

    @Test
    void testUsuarioActualizaPerfilFalla_EmailDuplicado() {
        // Creamos un segundo usuario
        UsuarioCreateDto dto = new UsuarioCreateDto();
        dto.setRut("4.444.444-4");
        dto.setNombres("Usuario");
        dto.setApellidos("Dos");
        dto.setEmail("usuario2@test.cl");
        dto.setPassword("clave123");
        dto.setRol("ROLE_ESTUDIANTE");
        usuarioServicio.create(dto);

        String rutAdmin = "11.111.111-1";
        UsuarioActualizarDto dtoUpdate = new UsuarioActualizarDto();
        dtoUpdate.setEmail("usuario2@test.cl"); // Email que ya existe

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            usuarioServicio.updateProfile(rutAdmin, dtoUpdate);
        });

        assertEquals("Email ya registrado", exception.getMessage());
    }
}