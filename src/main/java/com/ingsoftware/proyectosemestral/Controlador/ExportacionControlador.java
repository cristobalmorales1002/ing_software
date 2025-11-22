// En: proyectosemestral/Controlador/ExportacionControlador.java

package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.Servicio.ExportacionServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.ByteArrayInputStream;
import java.io.IOException;

@RestController
@RequestMapping("/api/exportar")
public class ExportacionControlador {

    @Autowired
    private ExportacionServicio exportacionServicio;

    @GetMapping("/excel")
    @PreAuthorize("hasAuthority('VER_LISTADO_PACIENTES') or hasRole('VISUALIZADOR')")
    public ResponseEntity<Resource> exportarAExcel(
            @RequestParam(defaultValue = "false") boolean anonimo,
            @RequestParam(defaultValue = "false") boolean dicotomizar
    ) throws IOException {

        ByteArrayInputStream streamDeDatos = exportacionServicio.generarExcel(anonimo, dicotomizar);

        InputStreamResource recurso = new InputStreamResource(streamDeDatos);

        String nombreArchivo;
        if (dicotomizar) {
            nombreArchivo = "export_dicotomizado.xlsx";
        } else {
            nombreArchivo = anonimo ? "export_anonimo.xlsx" : "export_completo.xlsx";
        }

        HttpHeaders headers = new HttpHeaders();

        headers.add("Content-Disposition", "attachment; filename=" + nombreArchivo);


        return ResponseEntity.ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(recurso);
    }
}