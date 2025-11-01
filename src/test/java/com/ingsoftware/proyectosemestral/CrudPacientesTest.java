package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.Servicio.PacienteServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import com.ingsoftware.proyectosemestral.DTO.PacienteCreateDto;
import com.ingsoftware.proyectosemestral.DTO.PacienteResponseDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class CrudPacientesTest {

    @Autowired private PacienteServicio pacienteServicio;

    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private PacienteRepositorio pacienteRepositorio;
    @Autowired private PreguntaRepositorio preguntaRepositorio;
    @Autowired private CategoriaRepositorio categoriaRepositorio;
    @Autowired private RolRepositorio rolRepositorio;
    @Autowired private PermisoRepositorio permisoRepositorio;

    private Usuario admin;
    private Usuario medico;
    private Usuario investigador;
    private Usuario juanito;
    private Usuario jose;
    private Pregunta preguntaRUT;
    private PacienteResponseDto casoDelMedico;
    private PacienteResponseDto controlDeJuanito;
    private List<RespuestaDto> dtoRespuesta;


    private Permiso crearPermiso(String nombre, String descripcion) {
        Permiso p = new Permiso();
        p.setNombre(nombre);
        p.setDescripcion(descripcion);
        return permisoRepositorio.save(p);
    }

    @BeforeEach
    void setUp() {
        Permiso pCrearCaso = crearPermiso("CREAR_CASO", "Test");
        Permiso pCrearControl = crearPermiso("CREAR_CONTROL", "Test");
        Permiso pEditarCaso = crearPermiso("EDITAR_CASO", "Test");
        Permiso pEditarControl = crearPermiso("EDITAR_CONTROL", "Test");
        Permiso pVerPaciente = crearPermiso("VER_PACIENTE", "Test");
        Permiso pVerListado = crearPermiso("VER_LISTADO_PACIENTES", "Test");
        Permiso pEliminar = crearPermiso("ELIMINAR_PACIENTE", "Test");

        Rol rolAdmin = new Rol();
        rolAdmin.setNombre("ROLE_ADMIN");
        rolAdmin.setPermisos(Set.of(pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolAdmin);

        Rol rolInvestigador = new Rol();
        rolInvestigador.setNombre("ROLE_INVESTIGADOR");
        rolInvestigador.setPermisos(Set.of(pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolInvestigador);

        Rol rolMedico = new Rol();
        rolMedico.setNombre("ROLE_MEDICO");
        rolMedico.setPermisos(Set.of(pCrearCaso, pCrearControl, pEditarCaso, pEditarControl, pVerPaciente, pVerListado, pEliminar));
        rolRepositorio.save(rolMedico);

        Rol rolEstudiante = new Rol();
        rolEstudiante.setNombre("ROLE_ESTUDIANTE");
        rolEstudiante.setPermisos(Set.of(pCrearControl, pEditarControl, pVerPaciente));
        rolRepositorio.save(rolEstudiante);

        admin = new Usuario();
        admin.setRut("11.111.111-1");
        admin.setNombres("Admin");
        admin.setApellidos("Test");
        admin.setEmail("admin@test.cl");
        admin.setContrasena("test");
        admin.setActivo(true);
        admin.getRoles().add(rolAdmin);
        admin = usuarioRepositorio.save(admin);

        medico = new Usuario();
        medico.setRut("22.222.222-2");
        medico.setNombres("Medico");
        medico.setApellidos("Test");
        medico.setEmail("medico@test.cl");
        medico.setContrasena("test");
        medico.setActivo(true);
        medico.getRoles().add(rolMedico);
        medico = usuarioRepositorio.save(medico);

        juanito = new Usuario();
        juanito.setRut("33.333.333-3");
        juanito.setNombres("Juanito");
        juanito.setApellidos("Test");
        juanito.setEmail("juanito@test.cl");
        juanito.setContrasena("test");
        juanito.setActivo(true);
        juanito.getRoles().add(rolEstudiante);
        juanito = usuarioRepositorio.save(juanito);

        investigador = new Usuario();
        investigador.setRut("44.444.444-4");
        investigador.setNombres("Investigador");
        investigador.setApellidos("Test");
        investigador.setEmail("investigador@test.cl");
        investigador.setContrasena("test");
        investigador.setActivo(true);
        investigador.getRoles().add(rolInvestigador);
        investigador = usuarioRepositorio.save(investigador);

        jose = new Usuario();
        jose.setRut("55.555.555-5");
        jose.setNombres("Jose");
        jose.setApellidos("Test");
        jose.setEmail("jose@test.cl");
        jose.setContrasena("test");
        jose.setActivo(true);
        jose.getRoles().add(rolEstudiante);
        jose = usuarioRepositorio.save(jose);

        Categoria cat1 = new Categoria();
        cat1.setNombre("Datos Test");
        cat1.setOrden(1);
        cat1 = categoriaRepositorio.save(cat1);

        Pregunta p = new Pregunta();
        p.setEtiqueta("RUT Test");
        p.setDescripcion("RUT para prueba");
        p.setTipo_dato(TipoDato.TEXTO);
        p.setOrden(1);
        p.setCategoria(cat1);
        preguntaRUT = preguntaRepositorio.save(p);

        RespuestaDto respuestaCaso = new RespuestaDto();
        respuestaCaso.setPregunta_id(preguntaRUT.getPregunta_id());
        respuestaCaso.setValor("1.1.1-1");

        PacienteCreateDto casoDto = new PacienteCreateDto();
        casoDto.setEsCaso(true);
        casoDto.setFechaIncl(LocalDate.now());
        casoDto.setRespuestas(List.of(respuestaCaso));
        casoDelMedico = pacienteServicio.crearPacienteConRespuestas(casoDto, medico);

        RespuestaDto respuestaControl = new RespuestaDto();
        respuestaControl.setPregunta_id(preguntaRUT.getPregunta_id());
        respuestaControl.setValor("2.2.2-2");

        PacienteCreateDto controlDto = new PacienteCreateDto();
        controlDto.setEsCaso(false);
        controlDto.setFechaIncl(LocalDate.now());
        controlDto.setRespuestas(List.of(respuestaControl));
        controlDeJuanito = pacienteServicio.crearPacienteConRespuestas(controlDto, juanito);

        RespuestaDto respuestaEditada = new RespuestaDto();
        respuestaEditada.setPregunta_id(preguntaRUT.getPregunta_id());
        respuestaEditada.setValor("VALOR-EDITADO");

        dtoRespuesta = List.of(respuestaEditada);
    }

    @Test
    void testEstudianteFallaAlEditarCaso() {
        assertThrows(AccessDeniedException.class, () -> {
            pacienteServicio.actualizarRespuestasDePaciente(
                    casoDelMedico.getParticipante_id(),
                    dtoRespuesta,
                    jose
            );
        });
    }

    @Test
    void testEstudianteFallaAlEditarControlAjeno() {
        assertThrows(AccessDeniedException.class, () -> {
            pacienteServicio.actualizarRespuestasDePaciente(
                    controlDeJuanito.getParticipante_id(),
                    dtoRespuesta,
                    jose
            );
        });
    }

    @Test
    void testEstudianteEditaControlPropio() {
        assertDoesNotThrow(() -> {
            pacienteServicio.actualizarRespuestasDePaciente(
                    controlDeJuanito.getParticipante_id(),
                    dtoRespuesta,
                    juanito
            );
        });
    }

    @Test
    void testInvestigadorEditaCasoAjeno() {
        assertDoesNotThrow(() -> {
            pacienteServicio.actualizarRespuestasDePaciente(
                    casoDelMedico.getParticipante_id(),
                    dtoRespuesta,
                    investigador
            );
        });
    }

    @Test
    void testAdminEditaCasoAjeno() {
        assertDoesNotThrow(() -> {
            pacienteServicio.actualizarRespuestasDePaciente(
                    casoDelMedico.getParticipante_id(),
                    dtoRespuesta,
                    admin
            );
        });
    }

    @Test
    void testEstudianteFallaAlArchivar() {
        assertThrows(AccessDeniedException.class, () -> {
            pacienteServicio.archivarPaciente(
                    controlDeJuanito.getParticipante_id(),
                    juanito
            );
        });
    }

    @Test
    void testAdminArchivaPaciente() {
        pacienteServicio.archivarPaciente(
                controlDeJuanito.getParticipante_id(),
                admin
        );

        Paciente pacienteArchivado = pacienteRepositorio.findById(controlDeJuanito.getParticipante_id()).get();
        assertFalse(pacienteArchivado.getActivo());
    }
}