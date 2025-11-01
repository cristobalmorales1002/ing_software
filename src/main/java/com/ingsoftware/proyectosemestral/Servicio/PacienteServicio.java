package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.PacienteCreateDto;
import com.ingsoftware.proyectosemestral.DTO.PacienteResponseDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaDto;
import com.ingsoftware.proyectosemestral.DTO.RespuestaResponseDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PacienteServicio {

    @Autowired private PacienteRepositorio pacienteRepositorio;
    @Autowired private PreguntaRepositorio preguntaRepositorio;
    @Autowired private RespuestaRepositorio respuestaRepositorio;
    @Autowired private RegistroServicio registroServicio;
    @Autowired private UsuarioRepositorio usuarioRepositorio;

    private List<RespuestaResponseDto> guardarOActualizarRespuestas(Paciente paciente, List<RespuestaDto> respuestasDto, Usuario usuario){
        List<RespuestaResponseDto> dtosDeRespuesta = new ArrayList<>();

        for(RespuestaDto dto: respuestasDto) {
            Pregunta pregunta = preguntaRepositorio.findById(dto.getPregunta_id())
                    .orElseThrow(() -> new EntityNotFoundException("Pregunta no encontrada con ID: " + dto.getPregunta_id()));

            Optional<Respuesta> optRespuesta = respuestaRepositorio.findByPacienteAndPregunta(paciente, pregunta);
            Respuesta respuestaGuardada;

            if(optRespuesta.isPresent()){
                Respuesta respuestaExistente = optRespuesta.get();
                String valorAnterior = respuestaExistente.getValor();
                if(!valorAnterior.equals(dto.getValor())){
                    respuestaExistente.setValor(dto.getValor());
                    respuestaGuardada = respuestaRepositorio.save(respuestaExistente);
                    registroServicio.registrarAccion(usuario, "ACTUALIZAR_RESPUESTA",
                            "Valor anterior: '" + valorAnterior + "', Nuevo valor: '" + dto.getValor() +"'",
                            respuestaGuardada);
                } else {
                    respuestaGuardada = respuestaExistente;
                }
            } else {
                Respuesta nuevaRespuesta = new Respuesta();
                nuevaRespuesta.setPaciente(paciente);
                nuevaRespuesta.setPregunta(pregunta);
                nuevaRespuesta.setValor(dto.getValor());
                respuestaGuardada = respuestaRepositorio.save(nuevaRespuesta);
                registroServicio.registrarAccion(usuario, "CREAR_RESPUESTA",
                        "Valor: '" + dto.getValor() + "'",
                        respuestaGuardada);
            }

            RespuestaResponseDto rDto = new RespuestaResponseDto();
            rDto.setRespuesta_id(respuestaGuardada.getRespuesta_id());
            rDto.setValor(respuestaGuardada.getValor());
            rDto.setPregunta_id(respuestaGuardada.getPregunta().getPregunta_id());
            dtosDeRespuesta.add(rDto);
        }
        return dtosDeRespuesta;
    }

    private String generarCodigoPaciente(boolean esCaso) {
        String prefijo = esCaso ? "CAS_" : "CONT_";
        long conteo = pacienteRepositorio.countByEsCaso(esCaso);
        return prefijo + String.format("%03d", conteo + 1);
    }

    @Transactional
    public PacienteResponseDto crearPacienteConRespuestas(PacienteCreateDto dto, Usuario reclutador) {
        Paciente paciente = new Paciente();
        paciente.setEsCaso(dto.getEsCaso());
        paciente.setFechaIncl(dto.getFechaIncl());
        paciente.setActivo(true);
        paciente.setReclutador(reclutador);
        paciente.setParticipanteCod(generarCodigoPaciente(dto.getEsCaso()));

        Paciente pacienteGuardado = pacienteRepositorio.save(paciente);

        List<RespuestaResponseDto> respuestasGuardadasDtos =
                guardarOActualizarRespuestas(pacienteGuardado, dto.getRespuestas(), reclutador);

        registroServicio.registrarAccion(reclutador, "CREAR_PACIENTE",
                "Paciente creado con codigo: " + pacienteGuardado.getParticipanteCod());

        PacienteResponseDto responseDto = new PacienteResponseDto();
        responseDto.setParticipante_id(pacienteGuardado.getParticipante_id());
        responseDto.setParticipanteCod(pacienteGuardado.getParticipanteCod());
        responseDto.setEsCaso(pacienteGuardado.getEsCaso());
        responseDto.setFechaIncl(pacienteGuardado.getFechaIncl());
        responseDto.setRespuestas(respuestasGuardadasDtos);

        return responseDto;
    }

    @Transactional
    public Paciente actualizarRespuestasDePaciente(Long pacienteId, List<RespuestaDto> respuestasDto, Usuario usuario){
        Paciente paciente = pacienteRepositorio.findById(pacienteId)
                .orElseThrow(() -> new EntityNotFoundException("Paciente no encontrado con ID: " + pacienteId));

        boolean esAdminOInvestigador = usuario.tieneRol("ROLE_ADMIN") || usuario.tieneRol("ROLE_INVESTIGADOR");
        boolean esMedico = usuario.tieneRol("ROLE_MEDICO");
        boolean esEstudiante = usuario.tieneRol("ROLE_ESTUDIANTE");

        if (paciente.getEsCaso()) {
            if (!esMedico && !esAdminOInvestigador) {
                throw new AccessDeniedException("Acceso denegado: Solo los Médicos pueden editar 'Casos'.");
            }
        } else {
            if (esEstudiante && !paciente.getReclutador().equals(usuario)) {
                throw new AccessDeniedException("Acceso denegado: Los estudiantes solo pueden editar los controles que ellos mismos ingresaron.");
            }
        }

        guardarOActualizarRespuestas(paciente, respuestasDto, usuario);
        return paciente;
    }

    @Transactional(readOnly = true)
    public PacienteResponseDto getPacienteById(Long pacienteId){
        Paciente paciente = pacienteRepositorio.findById(pacienteId)
                .orElseThrow(() -> new EntityNotFoundException("Paciente no encontrado: " + pacienteId));
        return convertirA_PacienteResponseDto(paciente);
    }

    @Transactional(readOnly = true)
    public List<PacienteResponseDto> getAllPacientes(){
        return pacienteRepositorio.findAll()
                .stream()
                .map(this::convertirA_PacienteResponseDto)
                .collect(Collectors.toList());
    }

    private PacienteResponseDto convertirA_PacienteResponseDto(Paciente paciente){
        PacienteResponseDto dto = new PacienteResponseDto();
        dto.setParticipante_id(paciente.getParticipante_id());
        dto.setParticipanteCod(paciente.getParticipanteCod());
        dto.setEsCaso(paciente.getEsCaso());
        dto.setFechaIncl(paciente.getFechaIncl());

        List<RespuestaResponseDto> respuestasDto = paciente.getRespuestas().stream()
                .map(respuesta -> {
                    RespuestaResponseDto rDto = new RespuestaResponseDto();
                    rDto.setRespuesta_id(respuesta.getRespuesta_id());
                    rDto.setValor(respuesta.getValor());
                    if (respuesta.getPregunta() != null) {
                        rDto.setPregunta_id(respuesta.getPregunta().getPregunta_id());
                    }
                    return rDto;
                })
                .collect(Collectors.toList());

        dto.setRespuestas(respuestasDto);
        return dto;
    }

    @Transactional
    public void archivarPaciente(Long pacienteId, Usuario usuario){
        if (usuario.tieneRol("ROLE_ESTUDIANTE")) {
            throw new AccessDeniedException("Acceso denegado: Los estudiantes no tienen permiso para archivar participantes.");
        }

        Paciente paciente = pacienteRepositorio.findById(pacienteId)
                .orElseThrow(() -> new EntityNotFoundException("Paciente no encontrado con ID: " + pacienteId));

        paciente.setActivo(false);
        pacienteRepositorio.save(paciente);

        registroServicio.registrarAccion(usuario, "ARCHIVAR_PACIENTE",
                "Se archivó el paciente: " + paciente.getParticipanteCod());
    }
}