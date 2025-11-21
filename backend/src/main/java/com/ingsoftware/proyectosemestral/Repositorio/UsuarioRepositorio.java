package com.ingsoftware.proyectosemestral.Repositorio;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioRepositorio extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByRut(String rut);
    List<Usuario> findByNombresContaining(String nombres);
    List<Usuario> findByApellidosContaining(String apellidos);
    List<Usuario> findByActivo(boolean activo);
    Optional<Usuario> findByTelefono(String telefono);
    Optional<Usuario> findByEmail(String email);
    Optional<Usuario> findByTokenRecuperacion(String token);
}
