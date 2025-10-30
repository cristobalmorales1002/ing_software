package com.ingsoftware.proyectosemestral.Servicio;

import com.ingsoftware.proyectosemestral.DTO.UsuarioCreateDto;
import com.ingsoftware.proyectosemestral.DTO.UsuarioResponseDto;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.DTO.UsuarioProfileUpdateDto;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UsuarioServicio {

    private final UsuarioRepositorio usuarioRepositorio;
    private final RolRepositorio rolRepositorio;
    private final PasswordEncoder passwordEncoder;
    private final RegistroServicio registroServicio; // opcional, inyectar si lo usas

    @Autowired
    public UsuarioServicio(UsuarioRepositorio usuarioRepositorio,
                          RolRepositorio rolRepositorio,
                          PasswordEncoder passwordEncoder,
                          RegistroServicio registroServicio) {
        this.usuarioRepositorio = usuarioRepositorio;
        this.rolRepositorio = rolRepositorio;
        this.passwordEncoder = passwordEncoder;
        this.registroServicio = registroServicio;
    }

    // LISTAR
    public List<UsuarioResponseDto> getAll() {
        return usuarioRepositorio.findAll().stream()
                .map(this::toResponseDto)
                .collect(Collectors.toList());
    }

    // OBTENER POR ID
    public UsuarioResponseDto getById(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        return toResponseDto(u);
    }

    // CREAR
    @Transactional
    public UsuarioResponseDto create(UsuarioCreateDto dto) {
        // validaciones de unicidad
        usuarioRepositorio.findByRut(dto.getRut()).ifPresent(x -> {
            throw new RuntimeException("RUT ya registrado");
        });
        usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> {
            throw new RuntimeException("Email ya registrado");
        });

        Usuario u = new Usuario();
        u.setRut(dto.getRut());
        u.setNombres(dto.getNombres());
        u.setApellidos(dto.getApellidos());
        u.setEmail(dto.getEmail());
        u.setTelefono(dto.getTelefono());
        u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        u.setActivo(true);

        // asignar rol (esperando que rol exista)
        Rol rol = rolRepositorio.findByNombre(dto.getRol())
                .orElseThrow(() -> new RuntimeException("Rol no existe: " + dto.getRol()));
        u.getRoles().add(rol);

        Usuario saved = usuarioRepositorio.save(u);

    // opcional: registrar la acción
        if (registroServicio != null) {
            // registroServicio.registrarAccion(...);
        }

        return toResponseDto(saved);
    }

    // ACTUALIZAR (puedes separar DTOs para update si quieres)
    @Transactional
    public UsuarioResponseDto update(Long id, UsuarioCreateDto dto) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));

        // si cambias rut/email, validar unicidad
        if (!u.getRut().equals(dto.getRut())) {
            usuarioRepositorio.findByRut(dto.getRut()).ifPresent(x -> { throw new RuntimeException("RUT ya en uso"); });
            u.setRut(dto.getRut());
        }
        if (!u.getEmail().equals(dto.getEmail())) {
            usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> { throw new RuntimeException("Email ya en uso"); });
            u.setEmail(dto.getEmail());
        }

        u.setNombres(dto.getNombres());
        u.setApellidos(dto.getApellidos());
        u.setTelefono(dto.getTelefono());

    // si viene password no vacía, actualizarla
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        }

    // actualizar rol si cambió
        Rol nuevoRol = rolRepositorio.findByNombre(dto.getRol())
                .orElseThrow(() -> new RuntimeException("Rol no existe: " + dto.getRol()));
        u.getRoles().clear();
        u.getRoles().add(nuevoRol);

        Usuario saved = usuarioRepositorio.save(u);
        return toResponseDto(saved);
    }

    // DESACTIVAR (el frontend espera toggle)
    @Transactional
    public void desactivate(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(false);
        usuarioRepositorio.save(u);
    }

    @Transactional
    public void activate(Long id) {
        Usuario u = usuarioRepositorio.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado: " + id));
        u.setActivo(true);
        usuarioRepositorio.save(u);
    }

    /**
     * Actualiza el perfil del usuario identificado por su RUT (username en Security).
     * Solo permite cambiar email, telefono y password.
     */
    @Transactional
    public UsuarioResponseDto updateProfile(String rut, UsuarioProfileUpdateDto dto) {
        Usuario u = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con RUT: " + rut));

        if (dto.getEmail() != null && !dto.getEmail().isBlank() && !dto.getEmail().equals(u.getEmail())) {
            usuarioRepositorio.findByEmail(dto.getEmail()).ifPresent(x -> {
                throw new RuntimeException("Email ya registrado");
            });
            u.setEmail(dto.getEmail());
        }

        if (dto.getTelefono() != null) {
            u.setTelefono(dto.getTelefono());
        }

        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            u.setContrasena(passwordEncoder.encode(dto.getPassword()));
        }

        Usuario saved = usuarioRepositorio.save(u);
        return toResponseDto(saved);
    }

    // MAPEADOR (puedes mover a UsuarioMapper si prefieres)
    private UsuarioResponseDto toResponseDto(Usuario u) {
        String rolNombre = u.getRoles().stream()
                .findFirst()
                .map(Rol::getNombre)
                .orElse("SIN_ROL");

        return UsuarioResponseDto.builder()
                .usuarioId(u.getIdUsuario())
                .rut(u.getRut())
                .nombres(u.getNombres())
                .apellidos(u.getApellidos())
                .email(u.getEmail())
                .telefono(u.getTelefono())
                .rol(rolNombre)
                .estadoU(u.isActivo() ? "ACTIVO" : "INACTIVO")
                .build();
    }
}
