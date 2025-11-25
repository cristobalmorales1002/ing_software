package com.ingsoftware.proyectosemestral.Controlador;

import com.ingsoftware.proyectosemestral.DTO.CambioEmailDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioCreateDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioResponseDto;
import com.ingsoftware.proyectosemestral.Servicio.UsuarioServicio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;

import com.ingsoftware.proyectosemestral.DTO.UsuarioActualizarDto;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioControlador {

    private final UsuarioServicio usuarioServicio;

    @Autowired
    public UsuarioControlador(UsuarioServicio usuarioServicio) {
        this.usuarioServicio = usuarioServicio;
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UsuarioResponseDto>> getAll() {
        return ResponseEntity.ok(usuarioServicio.getAll());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UsuarioResponseDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(usuarioServicio.getById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UsuarioResponseDto> create(@Valid @RequestBody UsuarioCreateDto dto) {
        UsuarioResponseDto created = usuarioServicio.create(dto);
        return ResponseEntity.created(URI.create("/api/usuarios/" + created.getUsuarioId())).body(created);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UsuarioResponseDto> update(@PathVariable Long id, @Valid @RequestBody UsuarioCreateDto dto) {
        UsuarioResponseDto updated = usuarioServicio.update(id, dto);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        usuarioServicio.desactivate(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UsuarioResponseDto> updateProfile(Authentication authentication,
                                                            @Valid @RequestBody UsuarioActualizarDto dto) {
        String rut = authentication.getName();
        UsuarioResponseDto updated = usuarioServicio.updateProfile(rut, dto);
        return ResponseEntity.ok(updated);
    }

    @PostMapping("/me/email/solicitar")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> solicitarCambioEmail(Authentication authentication) {
        String rut = authentication.getName();
        usuarioServicio.solicitarCambioEmail(rut);
        return ResponseEntity.ok(Map.of("mensaje", "Token enviado a su correo actual."));
    }

    @PostMapping("/me/email/validar")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> validarTokenEmail(Authentication authentication, @RequestBody Map<String, String> body) {
        String rut = authentication.getName();
        String token = body.get("token");
        usuarioServicio.validarTokenEmail(rut, token);
        return ResponseEntity.ok(Map.of("valido", true));
    }

    @PutMapping("/me/email/confirmar")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> confirmarCambioEmail(Authentication authentication,
                                                  @Valid @RequestBody CambioEmailDto dto) {
        String rut = authentication.getName();
        usuarioServicio.confirmarCambioEmail(rut, dto.getToken(), dto.getNuevoEmail());
        return ResponseEntity.ok(Map.of("mensaje", "Correo electrónico actualizado exitosamente."));
    }
}