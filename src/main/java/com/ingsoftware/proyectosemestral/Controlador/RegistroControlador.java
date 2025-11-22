package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.RegistroResponseDto;
import com.ingsoftware.proyectosemestral.Servicio.RegistroServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/registros")
public class RegistroControlador {

    @Autowired
    private RegistroServicio registroServicio;

    @GetMapping
    @PreAuthorize("hasRole('ROLE_ADMIN')") // Solo el admin debería ver logs completos
    public ResponseEntity<Page<RegistroResponseDto>> obtenerLogs(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin,
            @PageableDefault(size = 50, sort = "registroFecha", direction = Sort.Direction.DESC) Pageable pageable
    ) {

        // Pageable maneja automáticamente los parametros: ?page=0&size=50&sort=...
        Page<RegistroResponseDto> logs = registroServicio.obtenerLogsPaginados(fechaInicio, fechaFin, pageable);

        return ResponseEntity.ok(logs);
    }
}