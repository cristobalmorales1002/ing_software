package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VariableServicio {

    private final PreguntaRepositorio preguntaRepositorio;
    private final CategoriaRepositorio categoriaRepositorio;
    private final OpcionPreguntaRepositorio opcionPreguntaRepositorio;
    private final UsuarioRepositorio usuarioRepositorio;
    private final RegistroServicio registroServicio;

    @Transactional
    public Pregunta crearPregunta(PreguntaDto dto) {
        if (dto.getCategoriaId() == null) {
            throw new IllegalArgumentException("categoriaId es obligatorio");
        }
        if (dto.getTipo_dato() == null) {
            throw new IllegalArgumentException("tipo_dato es obligatorio");
        }

        Categoria categoria = categoriaRepositorio.findById(dto.getCategoriaId())
                .orElseThrow(() -> new IllegalArgumentException("No existe Categoria con id=" + dto.getCategoriaId()));

        Pregunta p = new Pregunta();
        p.setEtiqueta(dto.getEtiqueta());
        p.setCodigoStata(dto.getCodigoStata());
        p.setDescripcion(dto.getDescripcion());
        p.setTipo_dato(dto.getTipo_dato());
        p.setDato_sensible(dto.isDato_sensible());
        p.setActivo(dto.isActivo());
        p.setOrden(dto.getOrden());
        p.setCategoria(categoria);

        p.setDicotomizacion(dto.getDicotomizacion());
        p.setSentido_corte(dto.getSentido_corte());

        p.setExportable(dto.isExportable());
        p.setTipoCorte(dto.getTipoCorte() != null ? dto.getTipoCorte() : TipoCorte.NINGUNO);

        // --- REGLA DE NEGOCIO: ESTADÍSTICAS ---
        // Solo permitimos activar estadísticas si la pregunta tiene opciones (ENUM)
        if (dto.getTipo_dato() == TipoDato.ENUM) {
            p.setGenerarEstadistica(dto.isGenerarEstadistica());
        } else {
            p.setGenerarEstadistica(false); // Forzamos false para texto/números
        }

        p = preguntaRepositorio.save(p);

        // Crear opciones si el tipo es ENUM
        if (dto.getTipo_dato() == TipoDato.ENUM) {
            List<String> opciones = Optional.ofNullable(dto.getOpciones()).orElseGet(ArrayList::new);
            int i = 1;
            for (String etiqueta : opciones) {
                if (etiqueta == null || etiqueta.isBlank()) continue;

                OpcionPregunta op = new OpcionPregunta();
                op.setPregunta(p);
                op.setEtiqueta(etiqueta.trim());
                op.setOrden(i++);
                op.setValorDicotomizado(null);

                opcionPreguntaRepositorio.save(op);
            }
        }

        if (dto.getUsuarioId() != null) {
            var usrOpt = usuarioRepositorio.findById(dto.getUsuarioId());
            if (usrOpt.isPresent()) {
                var usr = usrOpt.get();
                String detalles = "Creó la pregunta ID=" + p.getPregunta_id() + " (" + p.getEtiqueta() + ")";
                registroServicio.registrarAccion(usr, "CREAR_PREGUNTA", detalles);
            }
        }

        return p;
    }

    @Transactional(readOnly = true)
    public Pregunta obtenerPorId(Long id) {
        return preguntaRepositorio.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("No existe Pregunta con id=" + id));
    }

    @Transactional
    public void archivarPregunta(Long idPregunta, Long idUsuario) {
        Pregunta p = obtenerPorId(idPregunta);

        p.setActivo(false);
        preguntaRepositorio.save(p);

        var usrOpt = usuarioRepositorio.findById(idUsuario);
        if (usrOpt.isPresent()) {
            String detalles = "Archivó la pregunta ID=" + p.getPregunta_id() + " (" + p.getEtiqueta() + ")";
            registroServicio.registrarAccion(usrOpt.get(), "ARCHIVAR_PREGUNTA", detalles);
        }
    }

    @Transactional(readOnly = true)
    public List<Pregunta> obtenerTodasLasPreguntas() {
        return preguntaRepositorio.findAll();
    }

    @Transactional
    public Pregunta actualizarPregunta(Long id, PreguntaDto dto) {
        Pregunta p = obtenerPorId(id);

        p.setEtiqueta(dto.getEtiqueta());
        p.setCodigoStata(dto.getCodigoStata());
        p.setDescripcion(dto.getDescripcion());
        p.setTipo_dato(dto.getTipo_dato());
        p.setDato_sensible(dto.isDato_sensible());
        p.setActivo(dto.isActivo());
        p.setOrden(dto.getOrden());
        p.setDicotomizacion(dto.getDicotomizacion());
        p.setSentido_corte(dto.getSentido_corte());
        p.setExportable(dto.isExportable());

        if (dto.getTipoCorte() != null) {
            p.setTipoCorte(dto.getTipoCorte());
        }

        // --- REGLA DE NEGOCIO: ESTADÍSTICAS (ACTUALIZACIÓN) ---
        if (dto.getTipo_dato() == TipoDato.ENUM) {
            p.setGenerarEstadistica(dto.isGenerarEstadistica());
        } else {
            p.setGenerarEstadistica(false);
        }

        if (dto.getCategoriaId() != null && !p.getCategoria().getId_cat().equals(dto.getCategoriaId())) {
            Categoria categoria = categoriaRepositorio.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new IllegalArgumentException("No existe Categoria con id=" + dto.getCategoriaId()));
            p.setCategoria(categoria);
        }

        opcionPreguntaRepositorio.deleteByPregunta(p);

        if (dto.getTipo_dato() == TipoDato.ENUM) {
            List<String> opciones = Optional.ofNullable(dto.getOpciones()).orElseGet(ArrayList::new);
            int i = 1;
            for (String etiqueta : opciones) {
                if (etiqueta == null || etiqueta.isBlank()) continue;

                OpcionPregunta op = new OpcionPregunta();
                op.setPregunta(p);
                op.setEtiqueta(etiqueta.trim());
                op.setOrden(i++);
                op.setValorDicotomizado(null);

                opcionPreguntaRepositorio.save(op);
            }
        }

        if (dto.getUsuarioId() != null) {
            var usrOpt = usuarioRepositorio.findById(dto.getUsuarioId());
            if (usrOpt.isPresent()) {
                var usr = usrOpt.get();
                String detalles = "Actualizó la pregunta ID=" + p.getPregunta_id() + " (" + p.getEtiqueta() + ")";
                registroServicio.registrarAccion(usr, "ACTUALIZAR_PREGUNTA", detalles);
            }
        }

        return preguntaRepositorio.save(p);
    }
}