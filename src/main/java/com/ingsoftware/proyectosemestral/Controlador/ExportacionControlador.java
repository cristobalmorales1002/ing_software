// En: proyectosemestral/Controlador/ExportacionControlador.java

package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.Servicio.ExportacionServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders; // <<< ¡ASEGÚRATE DE TENER ESTE IMPORT!
import org.springframework.http.MediaType;  // <<< ¡Y ESTE!
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

        // 1. El servicio genera el Excel (Esto ya funciona)
        ByteArrayInputStream streamDeDatos = exportacionServicio.generarExcel(anonimo, dicotomizar);

        // 2. Prepara el recurso
        InputStreamResource recurso = new InputStreamResource(streamDeDatos);

        String nombreArchivo;
        if (dicotomizar) {
            nombreArchivo = "export_dicotomizado.xlsx";
        } else {
            nombreArchivo = anonimo ? "export_anonimo.xlsx" : "export_completo.xlsx";
        }

        // --- 3. LA PARTE CLAVE QUE ARREGLA TU PROBLEMA ---

        // Crea el objeto de Cabeceras HTTP
        HttpHeaders headers = new HttpHeaders();

        // ¡Esta es la línea mágica! Le dice al navegador/Postman:
        // "Esto es un archivo adjunto (attachment) y su nombre (filename) es este:"
        headers.add("Content-Disposition", "attachment; filename=" + nombreArchivo);

        // 4. Construye la respuesta CON las cabeceras
        return ResponseEntity.ok()
                .headers(headers) // <<< APLICA LAS CABECERAS
                .contentType(MediaType.APPLICATION_OCTET_STREAM) // Le dice que es un archivo binario genérico
                .body(recurso);
    }
}