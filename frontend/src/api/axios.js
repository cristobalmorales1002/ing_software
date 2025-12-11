// frontend/src/api/axios.js
import axios from 'axios';

// Opción A: Hardcodeado (Más fácil para empezar)
const BASE_URL = 'http://localhost:8081';

// Opción B: Usando variables de entorno de Vite (La forma profesional)
// const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

const api = axios.create({
    baseURL: BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
    withCredentials: true // Importante si usas cookies/sesiones
});

api.interceptors.response.use(
    response => response,
    error => {

        if (error.response && (error.response.status === 401 || error.response.status === 403)) {

            // 1. Limpiamos la "memoria" del navegador
            localStorage.removeItem('isLoggedIn');
            localStorage.removeItem('user');
            localStorage.removeItem('token');

            // 2. Redirigimos forzosamente al login
            // Usamos window.location en vez de navigate para asegurar un refresco total
            if (window.location.pathname !== '/') {
                window.location.href = '/';
            }
        }
        return Promise.reject(error);
    }
);

export default api;