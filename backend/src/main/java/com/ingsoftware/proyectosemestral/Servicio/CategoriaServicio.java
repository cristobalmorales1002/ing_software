package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.Modelo.Categoria;
import com.ingsoftware.proyectosemestral.Repositorio.CategoriaRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CategoriaServicio {
    @Autowired
    private CategoriaRepositorio categoriaRepositorio;

    public List<Categoria> obtenerTodas() {
        return categoriaRepositorio.findAll();
    }
}