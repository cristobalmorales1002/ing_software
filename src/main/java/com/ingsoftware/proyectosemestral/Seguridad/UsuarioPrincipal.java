package com.ingsoftware.proyectosemestral.Seguridad;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

@Getter
public class UsuarioPrincipal implements UserDetails{
    private final Usuario usuario;
    private final Collection<? extends GrantedAuthority> autoridades; // Esto lo que hace es como que da un "ticket de permiso
                                                                      // donde hay 2 tipos de tickets, roles y permisos
                                                                      // donde la collection es una "bolsa" de tickets,
                                                                      // y el ? extends es para que pueda aceptar tanto roles como permisos de clase GrantedAuthority
                                                                      //(Autoridad otorgada), y clases que hereden de ella

    public UsuarioPrincipal(Usuario usuario) {
        this.usuario = usuario;

        //Lo que hacen estos streams es recibir un objeto usuario, luego obtener sus roles,
        //luego obtener los permisos de cada rol, luego mapear esos permisos a objetos SimpleGrantedAuthority,
        //y finalmente recolectarlos en un conjunto (Set) de autoridades, y así trabarlos de la forma que nos interesa en esta parte del codigo

        //Aqui se procesan los permisos
        Set<GrantedAuthority> listaDeAutoridades = usuario.getRoles().stream()
                .flatMap(rol -> rol.getPermisos().stream())
                        .map(permiso -> new SimpleGrantedAuthority(permiso.getNombre()))
                                .collect(Collectors.toSet());

        //Aqui se procesan los roles
        listaDeAutoridades.addAll(
                usuario.getRoles().stream()
                        .map(rol -> new SimpleGrantedAuthority(rol.getNombre()))
                        .collect(Collectors.toSet())
        );

        //Y aqui se asigna la lista de autoridades al atributo de la clase
        this.autoridades = listaDeAutoridades;
    }

    // --- MÉTODOS OBLIGATORIOS de UserDetails ---
    // (Deben ser implementados TODOS por el "contrato" de la interfaz)

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.autoridades; // Devuelve la lista de roles y permisos
    }

    @Override
    public String getPassword() {
        return this.usuario.getContrasena(); // Devuelve la contraseña encriptada
    }

    @Override
    public String getUsername() {
        return this.usuario.getRut(); // Devuelve el RUT (tu "username")
    }

    @Override
    public boolean isAccountNonExpired() {
        //Revisa si la cuenta ha EXPIRADO.
        //Como no tenemos ese requisito, devolvemos 'true' (No, no ha expirado).
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        //Revisa si la cuenta está BLOQUEADA.
        //Como no tenemos ese requisito, devolvemos 'true' (No, no está bloqueada).
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        //Revisa si las credenciales (contraseña) han EXPIRADO.
        //Como no tenemos ese requisito, devolvemos 'true' (No, no han expirado).
        return true;
    }

    @Override
    public boolean isEnabled() {
        // Usa el campo 'activo' de tu entidad Usuario
        //Revisa si la cuenta está HABILITADA.
        //Es el interruptor principal de "encendido/apagado".
        //Si un admin pone 'activo = false' en el Usuario, Spring
        //verá 'false' aquí y rechazará el login.
        return this.usuario.isActivo();
    }
}
