// auth.js - Lógica de autenticación

document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const errorMessage = document.getElementById('errorMessage');
    const forgotPasswordLink = document.getElementById('forgotPasswordLink');

    // Manejar submit del formulario
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const rut = document.getElementById('rut').value;
        const password = document.getElementById('password').value;

        // Ocultar mensaje de error previo
        errorMessage.style.display = 'none';

        // Cambiar texto del botón
        const submitBtn = loginForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Iniciando sesión...';
        submitBtn.disabled = true;

        try {
            const response = await fetch('http://localhost:8080/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ rut, password })
            });

            if (!response.ok) {
                throw new Error('Credenciales inválidas');
            }

            const data = await response.json();

            // Guardar token y usuario en localStorage
            localStorage.setItem('token', data.token);
            localStorage.setItem('user', JSON.stringify({
                rut: data.rut,
                nombreCompleto: data.nombreCompleto,
                rol: data.rol,
                email: data.email
            }));

            // Redirigir al dashboard
            window.location.href = 'dashboard.html';

        } catch (error) {
            errorMessage.textContent = error.message || 'Error al iniciar sesión';
            errorMessage.style.display = 'block';

            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        }
    });

    // Manejar recuperación de contraseña
    forgotPasswordLink.addEventListener('click', async (e) => {
        e.preventDefault();

        const email = prompt('Ingresa tu email para recuperar la contraseña:');

        if (email) {
            try {
                const response = await fetch(
                    `http://localhost:8080/api/auth/recuperar-password?email=${email}`,
                    { method: 'POST' }
                );

                if (response.ok) {
                    const message = await response.text();
                    alert('Se ha enviado un token de recuperación. Por favor revisa tu email.\n\n' + message);
                } else {
                    throw new Error('Email no encontrado');
                }
            } catch (error) {
                alert('Error: ' + error.message);
            }
        }
    });
});