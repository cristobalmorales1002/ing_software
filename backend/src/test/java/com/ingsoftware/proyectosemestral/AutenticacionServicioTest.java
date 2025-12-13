package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.AutenticacionServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class AutenticacionServicioTest {

    @Autowired private AutenticacionServicio autenticacionServicio;
    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private PasswordEncoder passwordEncoder;

    @MockitoBean
    private JavaMailSender javaMailSender;

    private Usuario usuarioTest;

    @BeforeEach
    void setUp() {
        if(usuarioRepositorio.findByEmail("user.auth@test.cl").isPresent()){
            usuarioTest = usuarioRepositorio.findByEmail("user.auth@test.cl").get();
        } else {
            usuarioTest = new Usuario();
            usuarioTest.setRut("99.999.999-K");
            usuarioTest.setNombres("Auth");
            usuarioTest.setApellidos("Test");
            usuarioTest.setEmail("user.auth@test.cl");
            usuarioTest.setContrasena("claveOriginal");
            usuarioTest.setActivo(true);
            usuarioTest = usuarioRepositorio.save(usuarioTest);
        }
    }

    @Test
    void testTokenExpiradoFalla() {
        usuarioTest.setTokenRecuperacion("123456");
        usuarioTest.setToken_rec_expiracion(LocalDateTime.now().minusHours(2));
        usuarioRepositorio.save(usuarioTest);

        RuntimeException ex = assertThrows(RuntimeException.class, () -> {
            autenticacionServicio.verificarTokenValido("123456");
        });

        assertEquals("El código de recuperación ha expirado", ex.getMessage());
    }

}