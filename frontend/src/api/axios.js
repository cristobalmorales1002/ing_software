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

export default api;