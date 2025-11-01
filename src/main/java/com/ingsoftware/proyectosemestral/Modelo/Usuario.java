package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idUsuario;

    @Column(unique = true, nullable = false)
    private String rut;

    @Column(nullable = false)
    private String nombres;

    @Column(nullable = false)
    private String apellidos;

    @Column(nullable = false)
    @Email
    private String email;

    @Column(nullable = false)
    private String contrasena;

    @Column
    private String telefono;

    @Column
    private boolean activo;

    @Column
    private String tokenRecuperacion;

    @Column
    private LocalDateTime token_rec_expiracion;

    /**
     * Define la relación Muchos-a-Muchos (N:M) entre Usuario y Rol.
     * Un usuario puede tener múltiples roles (ej. ser ADMIN e INVESTIGADOR).
     * Un rol puede tener múltiples usuarios.
     *
     * * fetch = FetchType.EAGER:
     * Le dice a JPA: "Cuando cargues un Usuario, por favor, carga INMEDIATAMENTE
     * todos sus Roles asociados". Esto es CRUCIAL para Spring Security,
     * ya que necesita saber los roles del usuario apenas inicia sesión.
     */
    @ManyToMany(fetch = FetchType.EAGER)

    /**
     * @JoinTable le dice a JPA cuál es la tabla intermedia (pivote) que une
     * a Usuario y Rol. JPA la manejará automáticamente.
     */
    @JoinTable(
            name = "usuario_rol", // El nombre exacto de tu tabla pivote en MySQL.

            // Define la columna de esta entidad (Usuario) en la tabla pivote.
            joinColumns = @JoinColumn(name = "usuario_id"),

            // Define la columna de la OTRA entidad (Rol) en la tabla pivote.
            inverseJoinColumns = @JoinColumn(name = "rol_id")
    )
    private Set<Rol> roles = new HashSet<>(); // Usamos un Set para evitar roles duplicados.

    public boolean tieneRol(String nombreRol) {
        if (this.roles == null || this.roles.isEmpty()) {
            return false;
        }
        for (Rol rol : this.roles) {
            if (rol != null && rol.getNombre().equalsIgnoreCase(nombreRol)) {
                return true;
            }
        }
        return false;
    }
}
