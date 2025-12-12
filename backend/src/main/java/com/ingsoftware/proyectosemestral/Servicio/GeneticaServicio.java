package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.AnalisisGeneticoDto;
import com.ingsoftware.proyectosemestral.DTO.RegistroMuestraDto;
import com.ingsoftware.proyectosemestral.Modelo.MuestraGenetica;
import com.ingsoftware.proyectosemestral.Modelo.SnpConfig;
import com.ingsoftware.proyectosemestral.Repositorio.MuestraGeneticaRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.SnpConfigRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class GeneticaServicio {

    private final SnpConfigRepositorio snpRepo;
    private final MuestraGeneticaRepositorio muestraRepo;

    @Autowired
    public GeneticaServicio(SnpConfigRepositorio snpRepo, MuestraGeneticaRepositorio muestraRepo) {
        this.snpRepo = snpRepo;
        this.muestraRepo = muestraRepo;
    }

    // 1. Obtener lista de configs (para llenar el formulario en el front)
    @Transactional(readOnly = true)
    public List<SnpConfig> obtenerConfiguraciones() {
        return snpRepo.findAll();
    }

    // 2. Guardar muestra del paciente
    @Transactional
    public void guardarMuestra(RegistroMuestraDto dto) {
        SnpConfig config = snpRepo.findById(dto.getSnpConfigId())
                .orElseThrow(() -> new RuntimeException("Configuración SNP no encontrada"));

        MuestraGenetica muestra = new MuestraGenetica();
        muestra.setParticipanteId(dto.getParticipanteId());
        muestra.setSnpConfig(config);
        muestra.setResultado(dto.getResultado());

        muestraRepo.save(muestra);
    }

    // 3. Obtener análisis procesado (Lógica Dominante/Recesivo)
    @Transactional(readOnly = true)
    public List<AnalisisGeneticoDto> obtenerAnalisisPorPaciente(Long participanteId) {
        List<MuestraGenetica> muestras = muestraRepo.findByParticipanteId(participanteId);

        return muestras.stream().map(m -> {
            SnpConfig conf = m.getSnpConfig();
            AnalisisGeneticoDto dto = new AnalisisGeneticoDto();

            dto.setNombreGen(conf.getNombreGen());
            dto.setResultadoPaciente(m.getResultado());

            // Modelo Codominante: Es el genotipo tal cual
            dto.setInterpretacionCodominante(m.getResultado());

            // Verificar si tenemos configurado el alelo de riesgo
            if (conf.getAleloRiesgo() != null && !conf.getAleloRiesgo().isEmpty()) {
                dto.setConfiguracionCompleta(true);
                String riesgo = conf.getAleloRiesgo();

                // --- LÓGICA DOMINANTE (Basta 1 alelo malo) ---
                if (m.getResultado().contains(riesgo)) {
                    dto.setInterpretacionDominante("Grupo Riesgo (Portador)");
                } else {
                    dto.setInterpretacionDominante("Referencia (Wild Type)");
                }

                // --- LÓGICA RECESIVA (Necesita 2 alelos malos) ---
                // Construimos el homocigoto de riesgo (Ej: CC si C es riesgo)
                String homoRiesgo = riesgo + riesgo;
                if (m.getResultado().equals(homoRiesgo)) {
                    dto.setInterpretacionRecesivo("Grupo Riesgo (Homocigoto)");
                } else {
                    dto.setInterpretacionRecesivo("No Riesgo");
                }

            } else {
                dto.setConfiguracionCompleta(false);
                dto.setInterpretacionDominante("Pendiente de config");
                dto.setInterpretacionRecesivo("Pendiente de config");
            }

            return dto;
        }).collect(Collectors.toList());
    }

    // 4. Método para inicializar datos (Opcional, útil para cargar los genes del PDF por primera vez)
    // Podrías llamar a esto desde un CommandLineRunner o manualmente
    @Transactional
    public void inicializarGenesBase() {
        if(snpRepo.count() == 0) {
            snpRepo.save(new SnpConfig(null, "TLR9 rs5743836", "TT", "TC", "CC", "T", null)); // Falta riesgo
            snpRepo.save(new SnpConfig(null, "miR-146a rs2910164", "GG", "GC", "CC", "G", null));
            // ... agregar el resto aquí
        }
    }

    // Guardar cuál es el alelo de riesgo
    @Transactional
    public SnpConfig actualizarConfiguracionRiesgo(Long idSnp, String nuevoAleloRiesgo) {
        SnpConfig config = snpRepo.findById(idSnp)
                .orElseThrow(() -> new RuntimeException("Config no encontrada"));

        config.setAleloRiesgo(nuevoAleloRiesgo);
        return snpRepo.save(config); // Al guardar, los reportes futuros usarán este dato
    }
}