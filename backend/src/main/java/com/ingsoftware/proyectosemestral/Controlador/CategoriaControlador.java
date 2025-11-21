package com.ingsoftware.proyectosemestral.Controlador;
import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio; // O Servicio si lo tienes
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categorias") // <--- ESTO ES LO QUE FALTABA
public class CategoriaControlador {

    @Autowired
    private CategoriaRepositorio categoriaRepositorio;
    // Lo ideal sería usar un CategoriaServicio, pero para probar rápido usa el repo

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<Categoria>> obtenerTodas() {
        return ResponseEntity.ok(categoriaRepositorio.findAll());
    }
}