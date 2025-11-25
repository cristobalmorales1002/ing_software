package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.CategoriaDto;
import com.ingsoftware.proyectosemestral.DTO.CategoriaFullDto;
import com.ingsoftware.proyectosemestral.DTO.PreguntaDto;
import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Modelo.OpcionPregunta;
import com.ingsoftware.proyectosemestral.Modelo.Pregunta;
import com.ingsoftware.proyectosemestral.Modelo.TipoDato;
import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoriaServicio {

    private final CategoriaRepositorio categoriaRepositorio;

    @Autowired
    public CategoriaServicio(CategoriaRepositorio categoriaRepositorio) {
        this.categoriaRepositorio = categoriaRepositorio;
    }

    // --- 1. OBTENER ÁRBOL COMPLETO (CRÍTICO) ---
    @Transactional(readOnly = true)
    public List<CategoriaFullDto> obtenerEncuestaCompleta() {
        List<Categoria> categorias = categoriaRepositorio.findAll(Sort.by(Sort.Direction.ASC, "orden"));

        return categorias.stream().map(cat -> {
            CategoriaFullDto dto = new CategoriaFullDto();
            dto.setId_cat(cat.getId_cat());
            dto.setNombre(cat.getNombre());
            dto.setOrden(cat.getOrden());

            List<PreguntaDto> preguntasDto = cat.getPreguntas().stream()
                    .filter(Pregunta::isActivo)
                    .sorted(Comparator.comparingInt(Pregunta::getOrden))
                    .map(this::mapearPreguntaADto)
                    .collect(Collectors.toList());

            dto.setPreguntas(preguntasDto);
            return dto;
        }).collect(Collectors.toList());
    }

    // --- 2. CREAR CATEGORÍA ---
    @Transactional
    public CategoriaDto crearCategoria(CategoriaDto dto) {
        Categoria c = new Categoria();
        c.setNombre(dto.getNombre());
        c.setOrden(dto.getOrden() > 0 ? dto.getOrden() : 999); // Si no trae orden, al final

        Categoria guardada = categoriaRepositorio.save(c);
        return mapToSimpleDto(guardada);
    }

    // --- 3. RENOMBRAR CATEGORÍA ---
    @Transactional
    public CategoriaDto actualizarCategoria(Long id, CategoriaDto dto) {
        Categoria c = categoriaRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));

        c.setNombre(dto.getNombre());
        return mapToSimpleDto(categoriaRepositorio.save(c));
    }

    // --- 4. ELIMINAR (Cascada) ---
    @Transactional
    public void eliminarCategoria(Long id) {
        Categoria c = categoriaRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));
        categoriaRepositorio.delete(c);
    }

    // --- 5. REORDENAR CATEGORÍAS ---
    @Transactional
    public void reordenarCategorias(List<Long> idsOrdenados) {
        for (int i = 0; i < idsOrdenados.size(); i++) {
            Long id = idsOrdenados.get(i);
            int orden = i + 1; // variable effectively final

            categoriaRepositorio.findById(id).ifPresent(c -> {
                c.setOrden(orden);
                categoriaRepositorio.save(c);
            });
        }

    }

    // --- HELPERS ---
    private CategoriaDto mapToSimpleDto(Categoria c) {
        CategoriaDto dto = new CategoriaDto();
        dto.setId_cat(c.getId_cat());
        dto.setNombre(c.getNombre());
        dto.setOrden(c.getOrden());
        return dto;
    }

    private PreguntaDto mapearPreguntaADto(Pregunta entidad) {
        PreguntaDto dto = new PreguntaDto();
        dto.setPregunta_id(entidad.getPregunta_id());
        dto.setEtiqueta(entidad.getEtiqueta());
        dto.setCodigoStata(entidad.getCodigoStata());
        dto.setDescripcion(entidad.getDescripcion());
        dto.setTipo_dato(entidad.getTipo_dato());
        dto.setDato_sensible(entidad.isDato_sensible());
        dto.setActivo(entidad.isActivo());
        dto.setOrden(entidad.getOrden());
        dto.setCategoriaId(entidad.getCategoria().getId_cat());
        dto.setDicotomizacion(entidad.getDicotomizacion());
        dto.setSentido_corte(entidad.getSentido_corte());
        dto.setExportable(entidad.isExportable());
        dto.setTipoCorte(entidad.getTipoCorte());
        dto.setGenerarEstadistica(entidad.isGenerarEstadistica());

        if (entidad.getTipo_dato() == TipoDato.ENUM && entidad.getOpciones() != null) {
            List<String> listaOpciones = entidad.getOpciones().stream()
                    .sorted(Comparator.comparingInt(OpcionPregunta::getOrden))
                    .map(OpcionPregunta::getEtiqueta)
                    .collect(Collectors.toList());
            dto.setOpciones(listaOpciones);
        }
        return dto;
    }
}