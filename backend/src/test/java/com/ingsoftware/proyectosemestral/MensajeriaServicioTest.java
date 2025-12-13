package com.ingsoftware.proyectosemestral;

import com.ingsoftware.proyectosemestral.DTO.MensajeEnvioDto;
import com.ingsoftware.proyectosemestral.Modelo.Rol;
import com.ingsoftware.proyectosemestral.Modelo.Usuario;
import com.ingsoftware.proyectosemestral.Repositorio.DestinatarioMensajeRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.RolRepositorio;
import com.ingsoftware.proyectosemestral.Repositorio.UsuarioRepositorio;
import com.ingsoftware.proyectosemestral.Servicio.MensajeriaServicio;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class MensajeriaServicioTest {

    @Autowired private MensajeriaServicio mensajeriaServicio;
    @Autowired private UsuarioRepositorio usuarioRepositorio;
    @Autowired private RolRepositorio rolRepositorio;
    @Autowired private DestinatarioMensajeRepositorio destinatarioRepo;

    private Usuario adminEmisor;
    private Usuario investigador1;
    private Usuario estudiante1;

    @BeforeEach
    void setUp() {
        Rol rAdmin = rolRepositorio.findByNombre("ROLE_ADMIN").orElseGet(() -> rolRepositorio.save(crearRol("ROLE_ADMIN")));
        Rol rInv = rolRepositorio.findByNombre("ROLE_INVESTIGADOR").orElseGet(() -> rolRepositorio.save(crearRol("ROLE_INVESTIGADOR")));
        Rol rEst = rolRepositorio.findByNombre("ROLE_ESTUDIANTE").orElseGet(() -> rolRepositorio.save(crearRol("ROLE_ESTUDIANTE")));

        adminEmisor = crearUsuario("99.999.999-9", "admin.msg@test.cl", rAdmin);
        investigador1 = crearUsuario("88.888.888-8", "inv.msg@test.cl", rInv);
        estudiante1 = crearUsuario("77.777.777-7", "est.msg@test.cl", rEst);
    }

    private Rol crearRol(String nombre) {
        Rol r = new Rol();
        r.setNombre(nombre);
        return r;
    }

    private Usuario crearUsuario(String rut, String email, Rol rol) {
        if (usuarioRepositorio.findByRut(rut).isPresent()) return usuarioRepositorio.findByRut(rut).get();
        Usuario u = new Usuario();
        u.setRut(rut);
        u.setNombres("Test");
        u.setApellidos("User");
        u.setEmail(email);
        u.setContrasena("123");
        u.setActivo(true);
        u.setRoles(new HashSet<>(Collections.singletonList(rol)));
        return usuarioRepositorio.save(u);
    }

    @Test
    void testEnviarMensajePorRol() {
        MensajeEnvioDto dto = new MensajeEnvioDto();
        dto.setAsunto("Aviso Importante");
        dto.setContenido("Reunión mañana");
        dto.setEnviarARol("ROLE_INVESTIGADOR");
        dto.setEnviarATodos(false);

        mensajeriaServicio.enviarMensaje(adminEmisor.getIdUsuario(), dto);


        long mensajesInvestigador = destinatarioRepo.countByDestinatario_IdUsuarioAndLeidoFalseAndEliminadoFalse(investigador1.getIdUsuario());
        assertTrue(mensajesInvestigador >= 1, "El investigador debería haber recibido el mensaje");

        boolean estudianteRecibio = destinatarioRepo.findByDestinatario_IdUsuarioAndEliminadoFalseOrderByMensaje_FechaEnvioDesc(estudiante1.getIdUsuario())
                .stream()
                .anyMatch(m -> m.getMensaje().getAsunto().equals("Aviso Importante"));

        assertFalse(estudianteRecibio, "El estudiante NO debería recibir un mensaje dirigido a Investigadores");
    }
}