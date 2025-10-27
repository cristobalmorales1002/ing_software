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

        // 2) Resolver Categoria
        Categoria categoria = categoriaRepositorio.findById(dto.getCategoriaId())
                .orElseThrow(() -> new IllegalArgumentException("No existe Categoria con id=" + dto.getCategoriaId()));

        // 3) Construir Pregunta
        Pregunta p = new Pregunta();
        p.setEtiqueta(dto.getEtiqueta());
        p.setDescripcion(dto.getDescripcion());
        p.setTipo_dato(dto.getTipo_dato());
        p.setDato_sensible(dto.isDato_sensible());
        p.setActivo(dto.isActivo());
        p.setOrden(dto.getOrden());
        p.setCategoria(categoria);

        p.setDicotomizacion(dto.getDicotomizacion());
        p.setSentido_corte(dto.getSentido_corte());

        p = preguntaRepositorio.save(p);

        if (dto.getTipo_dato() == TipoDato.ENUM) {
            List<String> opciones = Optional.ofNullable(dto.getOpciones()).orElseGet(ArrayList::new);
            int i = 1;
            for (String etiqueta : opciones) {
                if (etiqueta == null || etiqueta.isBlank()) continue;
                OpcionPregunta op = new OpcionPregunta();
                op.setPregunta(p);
                op.setEtiqueta(etiqueta.trim());
                op.setOrden(i++);
                opcionPreguntaRepositorio.save(op);
            }
        }

        if (dto.getUsuarioId() != null) {
            var usrOpt = usuarioRepositorio.findById(dto.getUsuarioId());
            if (usrOpt.isPresent()) {
                var usr = usrOpt.get();
                String detalles = "Creó la pregunta ID=" + p.getPregunta_id()
                        + " (" + p.getEtiqueta() + ")";
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
    public void archivarPregunta(Long id) {
        Pregunta p = obtenerPorId(id);
        p.setActivo(false); // <--- ¡La clave es esta!
        preguntaRepositorio.save(p); // Guardamos el cambio de estado

        // Y por supuesto, registramos la acción
        var usrOpt = usuarioRepositorio.findById(id);
        if (usrOpt.isPresent()) {
            String detalles = "Archivó la pregunta ID=" + p.getPregunta_id()
                    + " (" + p.getEtiqueta() + ")";
            registroServicio.registrarAccion(usrOpt.get(), "ARCHIVAR_PREGUNTA", detalles);
        }
    }

    public Pregunta actualizarPregunta(Long id, PreguntaDto dto) {
        // 1. Buscamos la pregunta que queremos editar
        Pregunta p = obtenerPorId(id);

        // 2. Actualizamos los campos simples
        p.setEtiqueta(dto.getEtiqueta());
        p.setDescripcion(dto.getDescripcion());
        p.setTipo_dato(dto.getTipo_dato());
        p.setDato_sensible(dto.isDato_sensible());
        p.setActivo(dto.isActivo()); // Permitimos reactivarla
        p.setOrden(dto.getOrden());
        p.setDicotomizacion(dto.getDicotomizacion());
        p.setSentido_corte(dto.getSentido_corte());

        // 3. Actualizamos la Categoria (si cambió)
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
                opcionPreguntaRepositorio.save(op);
            }
        }
        if (dto.getUsuarioId() != null) {
            var usrOpt = usuarioRepositorio.findById(dto.getUsuarioId());
            if (usrOpt.isPresent()) {
                var usr = usrOpt.get();
                String detalles = "Actualizó la pregunta ID=" + p.getPregunta_id()
                        + " (" + p.getEtiqueta() + ")";
                // Usamos el método generalista de tu RegistroServicio
                registroServicio.registrarAccion(usr, "ACTUALIZAR_PREGUNTA", detalles);
            }
        }
        return p;
    }
}
