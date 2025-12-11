package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.*;
import com.ingsoftware.proyectosemestral.Modelo.*;
import com.ingsoftware.proyectosemestral.Repositorio.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VariableServicio {

    private final PreguntaRepositorio preguntaRepositorio;
    private final CategoriaRepositorio categoriaRepositorio;
    private final OpcionPreguntaRepositorio opcionPreguntaRepositorio;
    private final UsuarioRepositorio usuarioRepositorio;
    private final RegistroServicio registroServicio;

    // --- CREAR ---
    @Transactional
    public Pregunta crearPregunta(PreguntaDto dto) {
        if (dto.getCategoriaId() == null) throw new IllegalArgumentException("Categoría obligatoria");

        // Validar unicidad de etiqueta interna
        if (dto.getCodigoStata() != null && !dto.getCodigoStata().isBlank()) {
            if (preguntaRepositorio.existsByCodigoStata(dto.getCodigoStata())) {
                throw new IllegalArgumentException("La etiqueta '" + dto.getCodigoStata() + "' ya existe.");
            }
        }

        Categoria categoria = categoriaRepositorio.findById(dto.getCategoriaId())
                .orElseThrow(() -> new IllegalArgumentException("Categoría no encontrada"));

        Pregunta p = new Pregunta();
        mapearDatosBasicos(p, dto);
        p.setCategoria(categoria);
        // Si no trae orden, lo mandamos al final
        p.setOrden(dto.getOrden() > 0 ? dto.getOrden() : 999);

        // --- LÓGICA CRÍTICA: GUARDAR LISTA DE DICOTOMIZACIONES ---
        if (dto.getDicotomizaciones() != null) {
            for (DicotomizacionDto dDto : dto.getDicotomizaciones()) {
                Dicotomizacion dic = new Dicotomizacion();
                dic.setValor(dDto.getValor());
                dic.setSentido(dDto.getSentido());

                // VINCULACIÓN BIDIRECCIONAL IMPORTANTE
                dic.setPregunta(p);
                p.getDicotomizaciones().add(dic);
            }
        }
        // ---------------------------------------------------------

        p = preguntaRepositorio.save(p);
        guardarOpciones(p, dto);

        if(dto.getUsuarioId() != null) registrarAccion(dto.getUsuarioId(), "CREAR", p);

        return p;
    }

    // --- ACTUALIZAR ---
    @Transactional
    public Pregunta actualizarPregunta(Long id, PreguntaDto dto) {
        Pregunta p = preguntaRepositorio.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Pregunta no encontrada"));

        // Validar unicidad (excluyendo la propia pregunta)
        if (dto.getCodigoStata() != null && !dto.getCodigoStata().isBlank()) {
            if (preguntaRepositorio.existsByCodigoStataAndIdNot(dto.getCodigoStata(), id)) {
                throw new IllegalArgumentException("La etiqueta '" + dto.getCodigoStata() + "' ya está en uso.");
            }
        }

        mapearDatosBasicos(p, dto);

        // Actualizar Categoría (Si cambió)
        if (dto.getCategoriaId() != null && !p.getCategoria().getId_cat().equals(dto.getCategoriaId())) {
            Categoria nuevaCat = categoriaRepositorio.findById(dto.getCategoriaId())
                    .orElseThrow(() -> new IllegalArgumentException("Categoría destino no existe"));
            p.setCategoria(nuevaCat);
        }

        // --- LÓGICA CRÍTICA: ACTUALIZAR LISTA (Borrar viejas e insertar nuevas) ---
        // Gracias a orphanRemoval=true en la entidad Pregunta, al hacer clear() se borran de la BD.
        p.getDicotomizaciones().clear();

        if (dto.getDicotomizaciones() != null) {
            for (DicotomizacionDto dDto : dto.getDicotomizaciones()) {
                Dicotomizacion dic = new Dicotomizacion();
                dic.setValor(dDto.getValor());
                dic.setSentido(dDto.getSentido());

                // VINCULACIÓN
                dic.setPregunta(p);
                p.getDicotomizaciones().add(dic);
            }
        }
        // --------------------------------------------------------------------------

        guardarOpciones(p, dto);

        if(dto.getUsuarioId() != null) registrarAccion(dto.getUsuarioId(), "ACTUALIZAR", p);

        return preguntaRepositorio.save(p);
    }

    private void mapearDatosBasicos(Pregunta p, PreguntaDto dto) {
        p.setEtiqueta(dto.getEtiqueta());
        p.setCodigoStata(dto.getCodigoStata());
        p.setDescripcion(dto.getDescripcion());
        p.setTipo_dato(dto.getTipo_dato());
        p.setDato_sensible(dto.isDato_sensible());
        p.setActivo(dto.isActivo());
        p.setExportable(dto.isExportable());
        if(dto.getOrden() > 0) p.setOrden(dto.getOrden());
        p.setGenerarEstadistica(dto.isGenerarEstadistica());

        if (dto.getPreguntaControladoraId() != null) {
            Pregunta controladora = preguntaRepositorio.findById(dto.getPreguntaControladoraId())
                    .orElseThrow(() -> new IllegalArgumentException("Pregunta controladora no encontrada"));
            p.setPreguntaControladora(controladora);
        } else {
            p.setPreguntaControladora(null);
        }

    }

    private void guardarOpciones(Pregunta p, PreguntaDto dto) {
        opcionPreguntaRepositorio.deleteByPregunta(p);
        if (dto.getTipo_dato() == TipoDato.ENUM && dto.getOpciones() != null) {
            int i = 1;
            for (String txt : dto.getOpciones()) {
                OpcionPregunta op = new OpcionPregunta();
                op.setPregunta(p);
                op.setEtiqueta(txt);
                op.setOrden(i++);
                opcionPreguntaRepositorio.save(op);
            }
        }
    }

    // --- OTROS MÉTODOS ---
    @Transactional(readOnly = true)
    public List<Pregunta> obtenerTodasLasPreguntas() { return preguntaRepositorio.findAll(); }

    @Transactional(readOnly = true)
    public Pregunta obtenerPorId(Long id) { return preguntaRepositorio.findById(id).orElse(null); }

    @Transactional
    public void archivarPregunta(Long id, Long userId) {
        Pregunta p = preguntaRepositorio.findById(id).orElseThrow();
        p.setActivo(false);
        preguntaRepositorio.save(p);
        registrarAccion(userId, "ARCHIVAR", p);
    }

    @Transactional
    public void reordenarPreguntas(List<Long> ids) {
        for (int i = 0; i < ids.size(); i++) {
            Long id = ids.get(i);
            int orden = i + 1;
            preguntaRepositorio.findById(id).ifPresent(p -> {
                p.setOrden(orden);
                preguntaRepositorio.save(p);
            });
        }
    }

    private void registrarAccion(Long uid, String accion, Pregunta p) {
        usuarioRepositorio.findById(uid).ifPresent(u ->
                registroServicio.registrarAccion(u, accion, "Pregunta ID: " + p.getPregunta_id())
        );
    }
}