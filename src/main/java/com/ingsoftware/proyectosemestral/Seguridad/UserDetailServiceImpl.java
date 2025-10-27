package com.ingsoftware.proyectosemestral.Seguridad;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserDetailServiceImpl implements UserDetailsService {
    @Autowired //La función de @Autowired es permitir la inyección automática de dependencias en Spring.
               //En este caso, está inyectando una instancia de UsuarioRepositorio en la clase UserDetailServiceImpl.
    private UsuarioRepositorio usuarioRepositorio;

    @Override
    @Transactional //La anotación @Transactional se utiliza para gestionar transacciones de base de datos en métodos específicos.
                   //En este caso, asegura que el metodo loadUserByUsername se ejecute dentro de una transacción.
    public UserDetails loadUserByUsername(String rut) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepositorio.findByRut(rut)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado con RUT: " + rut));

        return new UsuarioPrincipal(usuario);
    }
}
