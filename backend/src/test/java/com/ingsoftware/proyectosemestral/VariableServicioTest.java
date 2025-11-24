package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import com.ingsoftware.proyectosemestral.Servicio.VariableServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class VariableServicioTest {

    @Autowired private VariableServicio variableServicio;
    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private CategoriaRepositorio categoriaRepositorio;
    @Autowired private PreguntaRepositorio preguntaRepositorio;
    @Autowired private OpcionPreguntaRepositorio opcionPreguntaRepositorio;
    @Autowired private RolRepositorio rolRepositorio;
    @Autowired private PermisoRepositorio permisoRepositorio;

    private Usuario admin;
    private Categoria categoriaTest;
    private Long adminId;

    private Rol crearRol(String nombre) {
        Rol r = new Rol();
        r.setNombre(nombre);
        return rolRepositorio.save(r);
    }

    private Permiso crearPermiso(String nombre, String descripcion) {
        Permiso p = new Permiso();
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        return permisoRepositorio.save(p);
    }

    @BeforeEach
    void setUp() {
        Rol rolAdmin = crearRol("ROLE_ADMIN");

        admin = new Usuario();
        admin.setRut("11.111.111-1");
        admin.setNombres("Admin");
        admin.setApellidos("Test");
        admin.setEmail("admin@test.cl");
        admin.setContrasena("test");
        admin.setActivo(true);
        admin.getRoles().add(rolAdmin);
        admin = usuarioRepositorio.save(admin);
        adminId = admin.getIdUsuario();

        Categoria cat1 = new Categoria();
        cat1.setNombre("Datos Test");
        cat1.setOrden(1);
        categoriaTest = categoriaRepositorio.save(cat1);
    }

    @Test
    void testAdminCreaPregunta_TipoTexto_ConExito() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("RUT");
        dto.setDescripcion("RUT del paciente");
        dto.setTipo_dato(TipoDato.TEXTO);
        dto.setCategoriaId(categoriaTest.getId_cat());
        dto.setUsuarioId(adminId);

        Pregunta resultado = variableServicio.crearPregunta(dto);

        assertNotNull(resultado.getPregunta_id());
        assertEquals("RUT", resultado.getEtiqueta());

        List<OpcionPregunta> opciones = opcionPreguntaRepositorio.findByPregunta(resultado);
        assertEquals(0, opciones.size());
    }

    @Test
    void testAdminCreaPregunta_TipoEnum_ConExito() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("¿Fuma?");
        dto.setDescripcion("Hábito tabáquico");
        dto.setTipo_dato(TipoDato.ENUM);
        dto.setCategoriaId(categoriaTest.getId_cat());
        dto.setUsuarioId(adminId);
        dto.setOpciones(List.of("Sí", "No", "Ocasional"));

        Pregunta resultado = variableServicio.crearPregunta(dto);

        assertNotNull(resultado.getPregunta_id());
        assertEquals("¿Fuma?", resultado.getEtiqueta());

        List<OpcionPregunta> opciones = opcionPreguntaRepositorio.findByPregunta(resultado);
        assertEquals(3, opciones.size());
        assertEquals("Sí", opciones.get(0).getEtiqueta());
    }

    @Test
    void testAdminArchivaPregunta_ConExito() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("Pregunta a archivar");
        dto.setDescripcion("Esta es una descripción de prueba");
        dto.setTipo_dato(TipoDato.TEXTO);
        dto.setCategoriaId(categoriaTest.getId_cat());
        dto.setUsuarioId(adminId);
        Pregunta preguntaCreada = variableServicio.crearPregunta(dto);

        assertTrue(preguntaCreada.isActivo());

        variableServicio.archivarPregunta(preguntaCreada.getPregunta_id(), adminId);

        Pregunta preguntaArchivada = preguntaRepositorio.findById(preguntaCreada.getPregunta_id()).get();
        assertFalse(preguntaArchivada.isActivo());
    }

    @Test
    void testAdminActualizaOpcionesDePreguntaEnum_ConExito() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("¿Fuma?");
        dto.setDescripcion("Hábito tabáquico");
        dto.setTipo_dato(TipoDato.ENUM);
        dto.setCategoriaId(categoriaTest.getId_cat());
        dto.setUsuarioId(adminId);
        dto.setOpciones(List.of("Sí", "No"));
        Pregunta preguntaCreada = variableServicio.crearPregunta(dto);

        assertEquals(2, opcionPreguntaRepositorio.findByPregunta(preguntaCreada).size());

        PreguntaDto dtoActualizado = new PreguntaDto();
        dtoActualizado.setEtiqueta("¿Fuma? (Actualizado)");
        dtoActualizado.setDescripcion("Hábito tabáquico actualizado");
        dtoActualizado.setTipo_dato(TipoDato.ENUM);
        dtoActualizado.setCategoriaId(categoriaTest.getId_cat());
        dtoActualizado.setUsuarioId(adminId);
        dtoActualizado.setOpciones(List.of("Positivo", "Negativo", "No Sabe"));

        variableServicio.actualizarPregunta(preguntaCreada.getPregunta_id(), dtoActualizado);

        List<OpcionPregunta> opcionesNuevas = opcionPreguntaRepositorio.findByPregunta(preguntaCreada);
        assertEquals(3, opcionesNuevas.size());
        assertEquals("Positivo", opcionesNuevas.get(0).getEtiqueta());
    }

    @Test
    void testCrearPreguntaFalla_CategoriaInvalida() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("Test");
        dto.setDescripcion("Test desc");
        dto.setTipo_dato(TipoDato.TEXTO);
        dto.setCategoriaId(9999L);
        dto.setUsuarioId(adminId);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            variableServicio.crearPregunta(dto);
        });

        assertTrue(exception.getMessage().contains("No existe Categoria con id=9999"));
    }

    @Test
    void testCrearPreguntaFalla_TipoDatoNulo() {
        PreguntaDto dto = new PreguntaDto();
        dto.setEtiqueta("Test");
        dto.setDescripcion("Test desc");
        dto.setTipo_dato(null);
        dto.setCategoriaId(categoriaTest.getId_cat());
        dto.setUsuarioId(adminId);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            variableServicio.crearPregunta(dto);
        });

        assertEquals("tipo_dato es obligatorio", exception.getMessage());
    }

    @Test
    void testArchivarPreguntaFalla_IdInvalido() {
        Long idPreguntaInvalido = 9999L;

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            variableServicio.archivarPregunta(idPreguntaInvalido, adminId);
        });

        assertTrue(exception.getMessage().contains("No existe Pregunta con id=9999"));
    }
}