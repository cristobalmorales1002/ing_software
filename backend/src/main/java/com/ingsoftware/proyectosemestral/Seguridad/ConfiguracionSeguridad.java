package com.ingsoftware.proyectosemestral.Seguridad;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration //Esta anotación indica que la clase es una clase de configuración para Spring, lo que significa que puede contener definiciones de beans y configuraciones específicas para la aplicación.
@EnableWebSecurity //Esta anotación habilita las características de seguridad web en la aplicación Spring, permitiendo configurar aspectos como autenticación y autorización.
@EnableMethodSecurity //Esta anotación habilita la seguridad a nivel de metodo, lo que permite utilizar anotaciones como @PreAuthorize y @PostAuthorize para controlar el acceso a métodos específicos basados en roles o permisos.
public class ConfiguracionSeguridad {
    @Autowired
    private UserDetailServiceImpl userDetailService;
    @Autowired
    private ManejadorFalloAutenticacion manejadorFalloAutenticacion;

    @Bean //La anotación @Bean indica que el metodo produce un bean que debe ser gestionado por el contenedor de Spring.
    public SecurityFilterChain cadenaFiltroSeguridad(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auten -> auten
                .requestMatchers("/api/autenticacion/**").permitAll() // Permitir acceso sin autenticación a las rutas de autenticación
                .anyRequest().authenticated() // Requerir autenticación para cualquier otra solicitud
        ).formLogin(form -> form.loginProcessingUrl("/login").failureHandler(manejadorFalloAutenticacion)).logout(Customizer.withDefaults()).authenticationProvider(this.autenticacionProveedor());

        return http.build();
    }

    @Bean
    public AuthenticationProvider autenticacionProveedor() {
        DaoAuthenticationProvider proveedorAuten = new DaoAuthenticationProvider();
        //La linea anterior crea una instancia de DaoAuthenticationProvider, que es un proveedor de autenticación que utiliza un servicio de detalles de usuario (UserDetailsService) para autenticar a los usuarios.

        proveedorAuten.setUserDetailsService(userDetailService);
        //La linea anterior configura el proveedor de autenticación para que utilice la implementación personalizada de UserDetailsService (userDetailService) para cargar los detalles del usuario durante el proceso de autenticación.

        proveedorAuten.setPasswordEncoder(this.codificadorContrasena());
        //La linea anterior establece el codificador de contraseñas que se utilizará para verificar las contraseñas de los usuarios durante la autenticación.

        return proveedorAuten;
    }

    @Bean
    //Este metodo se utilizara mas adelante en el controlador, para lanzar el proceso de login
    public AuthenticationManager autenticacionGestor(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    //La siguiente configuracion es para el codificador de contraseñas, usando BCrypt
    @Bean
    public PasswordEncoder codificadorContrasena() {
        return new BCryptPasswordEncoder();
    }
}
