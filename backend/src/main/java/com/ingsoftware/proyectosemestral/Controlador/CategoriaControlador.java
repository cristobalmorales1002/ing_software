package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.CategoriaDto;
import com.ingsoftware.proyectosemestral.DTO.CategoriaFullDto;
import com.ingsoftware.proyectosemestral.Servicio.CategoriaServicio;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class CategoriaControlador {

    @Autowired
    private CategoriaServicio categoriaServicio;

    @GetMapping("/encuesta/completa")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<CategoriaFullDto>> getEncuestaCompleta() {
        return ResponseEntity.ok(categoriaServicio.obtenerEncuestaCompleta());
    }

    @PostMapping("/categorias")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<CategoriaDto> crearCategoria(@Valid @RequestBody CategoriaDto dto) {
        return ResponseEntity.ok(categoriaServicio.crearCategoria(dto));
    }

    @PutMapping("/categorias/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<CategoriaDto> actualizarCategoria(@PathVariable Long id, @Valid @RequestBody CategoriaDto dto) {
        return ResponseEntity.ok(categoriaServicio.actualizarCategoria(id, dto));
    }

    @DeleteMapping("/categorias/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> eliminarCategoria(@PathVariable Long id) {
        categoriaServicio.eliminarCategoria(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/categorias/reordenar")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<Void> reordenarCategorias(@RequestBody List<Long> idsOrdenados) {
        categoriaServicio.reordenarCategorias(idsOrdenados);
        return ResponseEntity.ok().build();
    }
}