package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.Servicio.PdfServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/pdf")
public class PdfControlador {

    @Autowired
    private PdfServicio pdfServicio;

    // 1. Descargar CRF Vacío (Plantilla)
    @GetMapping("/crf/vacio")
    @PreAuthorize("hasRole('ROLE_ADMIN') or hasRole('ROLE_INVESTIGADOR')")
    public ResponseEntity<byte[]> descargarCrfVacio() {
        byte[] pdfBytes = pdfServicio.generarCrfPdf(null); // null = sin paciente

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=CRF_Plantilla_Vacia.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }

    // 2. Descargar CRF Lleno (Paciente específico)
    @GetMapping("/crf/paciente/{id}")
    @PreAuthorize("hasRole('ROLE_ADMIN') or hasRole('ROLE_INVESTIGADOR')")
    public ResponseEntity<byte[]> descargarCrfPaciente(@PathVariable Long id) {
        byte[] pdfBytes = pdfServicio.generarCrfPdf(id);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=CRF_Paciente_" + id + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }
}