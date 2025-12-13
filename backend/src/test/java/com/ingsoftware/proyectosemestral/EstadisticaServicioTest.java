package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.EstadisticaDto;
import com.ingsoftware.proyectosemestral.Modelo.OpcionPregunta;
import com.ingsoftware.proyectosemestral.Modelo.Paciente;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.Respuesta;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.PacienteRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.PreguntaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.EstadisticaServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.ActiveProfiles;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ActiveProfiles("test")
class EstadisticaServicioTest {

    @Mock private UsuarioRepositorio usuarioRepositorio;
    @Mock private PreguntaRepositorio preguntaRepositorio;
    @Mock private PacienteRepositorio pacienteRepositorio;

    @InjectMocks
    private EstadisticaServicio estadisticaServicio;

    private Usuario usuario;
    private Pregunta preguntaSexo;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        usuario = new Usuario();
        usuario.setRut("11.111.111-1");

        preguntaSexo = new Pregunta();
        preguntaSexo.setPregunta_id(1L);
        preguntaSexo.setEtiqueta("Sexo");
        preguntaSexo.setGenerarEstadistica(true);
        preguntaSexo.setActivo(true);
        OpcionPregunta op1 = new OpcionPregunta(1L, "Hombre", 1, preguntaSexo, null);
        OpcionPregunta op2 = new OpcionPregunta(2L, "Mujer", 2, preguntaSexo, null);
        preguntaSexo.setOpciones(List.of(op1, op2));
    }

    @Test
    void testCalculoCorrectoDePorcentajes() {
        when(usuarioRepositorio.findByRut(anyString())).thenReturn(Optional.of(usuario));
        usuario.setPreferenciasEstadisticas("1");
        when(preguntaRepositorio.findAllById(anyList())).thenReturn(List.of(preguntaSexo));

        List<Paciente> pacientes = new ArrayList<>();
        for(int i=0; i<3; i++) pacientes.add(crearPacienteConRespuesta(preguntaSexo, "Hombre"));
        pacientes.add(crearPacienteConRespuesta(preguntaSexo, "Mujer"));

        when(pacienteRepositorio.findByActivoTrue()).thenReturn(pacientes);


        List<EstadisticaDto> stats = estadisticaServicio.calcularEstadisticasDashboard("11.111.111-1");

        EstadisticaDto dtoSexo = stats.get(1);
        assertEquals("Sexo", dtoSexo.getTituloPregunta());

        EstadisticaDto.DatoGrafico hombres = buscarDato(dtoSexo, "Hombre");
        EstadisticaDto.DatoGrafico mujeres = buscarDato(dtoSexo, "Mujer");

        assertEquals(75.0, hombres.getPorcentaje());
        assertEquals(25.0, mujeres.getPorcentaje());
    }

    @Test
    void testPreferenciasPorDefecto() {
        usuario.setPreferenciasEstadisticas(null);
        when(usuarioRepositorio.findByRut(anyString())).thenReturn(Optional.of(usuario));

        when(preguntaRepositorio.findAll()).thenReturn(List.of(preguntaSexo));

        List<EstadisticaDto> stats = estadisticaServicio.calcularEstadisticasDashboard("11.111.111-1");

        boolean existeSexo = stats.stream().anyMatch(s -> "Sexo".equals(s.getTituloPregunta()));
        assertTrue(existeSexo, "Si las preferencias son null, debe mostrar 'Sexo' por defecto");
    }

    private Paciente crearPacienteConRespuesta(Pregunta p, String valor) {
        Paciente pac = new Paciente();
        pac.setActivo(true);
        Respuesta r = new Respuesta();
        r.setPregunta(p);
        r.setValor(valor);
        pac.setRespuestas(Set.of(r));
        return pac;
    }

    private EstadisticaDto.DatoGrafico buscarDato(EstadisticaDto dto, String etiqueta) {
        return dto.getDatos().stream()
                .filter(d -> d.getEtiqueta().equals(etiqueta))
                .findFirst().orElseThrow();
    }
}