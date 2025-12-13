package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.AnalisisGeneticoDto;
import com.ingsoftware.proyectosemestral.DTO.RegistroMuestraDto;
import com.ingsoftware.proyectosemestral.Modelo.SnpConfig;
import com.ingsoftware.proyectosemestral.Repositorio.SnpConfigRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.GeneticaServicio;
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
class GeneticaServicioTest {

    @Autowired private GeneticaServicio geneticaServicio;
    @Autowired private SnpConfigRepositorio snpRepo;

    private Long idConfig;
    private Long idPacienteFicticio = 999L;

    @BeforeEach
    void setUp() {
        SnpConfig config = new SnpConfig();
        config.setNombreGen("Gen-Test rs12345");
        config.setOpcion1("TT");
        config.setOpcion2("TC");
        config.setOpcion3("CC");
        config.setAleloRef("T");
        config.setAleloRiesgo("C");
        SnpConfig saved = snpRepo.save(config);
        idConfig = saved.getId_snp();
    }

    @Test
    void testInterpretacionModeloDominante() {
        RegistroMuestraDto dto = new RegistroMuestraDto();
        dto.setParticipanteId(idPacienteFicticio);
        dto.setSnpConfigId(idConfig);
        dto.setResultado("TC");

        geneticaServicio.guardarMuestra(dto);

        List<AnalisisGeneticoDto> analisis = geneticaServicio.obtenerAnalisisPorPaciente(idPacienteFicticio);

        assertFalse(analisis.isEmpty());
        AnalisisGeneticoDto resultado = analisis.get(0);

        assertEquals("Gen-Test rs12345", resultado.getNombreGen());
        assertEquals("Grupo Riesgo (Portador)", resultado.getInterpretacionDominante());
    }

    @Test
    void testInterpretacionModeloRecesivo() {
        RegistroMuestraDto dto = new RegistroMuestraDto();
        dto.setParticipanteId(idPacienteFicticio);
        dto.setSnpConfigId(idConfig);
        dto.setResultado("TC");

        geneticaServicio.guardarMuestra(dto);

        List<AnalisisGeneticoDto> analisis = geneticaServicio.obtenerAnalisisPorPaciente(idPacienteFicticio);
        AnalisisGeneticoDto resultado = analisis.get(0);

        assertEquals("No Riesgo", resultado.getInterpretacionRecesivo());
    }

    @Test
    void testInterpretacionHomocigotoRiesgo() {

        RegistroMuestraDto dto = new RegistroMuestraDto();
        dto.setParticipanteId(idPacienteFicticio);
        dto.setSnpConfigId(idConfig);
        dto.setResultado("CC");

        geneticaServicio.guardarMuestra(dto);

        List<AnalisisGeneticoDto> analisis = geneticaServicio.obtenerAnalisisPorPaciente(idPacienteFicticio);
        AnalisisGeneticoDto resultado = analisis.get(0);

        assertEquals("Grupo Riesgo (Portador)", resultado.getInterpretacionDominante());
        assertEquals("Grupo Riesgo (Homocigoto)", resultado.getInterpretacionRecesivo());
    }
}