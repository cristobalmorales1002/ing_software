package com.ingsoftware.proyectosemestral.Seguridad;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class ManejadorFalloAutenticacion implements AuthenticationFailureHandler {
    @Override
    public void onAuthenticationFailure(HttpServletRequest peticion, HttpServletResponse respuesta, AuthenticationException excepcion) throws IOException, ServletException {
        respuesta.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        respuesta.getWriter().write("Autenticación fallida: " + excepcion.getMessage());
    }
}
