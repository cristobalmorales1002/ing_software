// frontend/src/api/axios.js
import axios from 'axios';

// AHORA (IP del servidor + Puerto del Backend):
const BASE_URL = 'http://190.13.177.173:8031';

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

            localStorage.removeItem('isLoggedIn');
            localStorage.removeItem('user');
            localStorage.removeItem('token');

            if (window.location.pathname !== '/') {
                window.location.href = '/';
            }
        }
        return Promise.reject(error);
    }
);

export default api;