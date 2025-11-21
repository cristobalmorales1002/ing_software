// api.js - Configuración y funciones de API

const API_URL = 'http://localhost:8080/api';

// Obtener token del localStorage
function getToken() {
    return localStorage.getItem('token');
}

// Obtener usuario actual
function getCurrentUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
}

// Verificar autenticación
function checkAuth() {
    const token = getToken();
    if (!token) {
        window.location.href = 'login.html';
        return false;
    }
    return true;
}

// Cerrar sesión
function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = 'login.html';
}

// Configurar botón de logout
document.addEventListener('DOMContentLoaded', () => {
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', logout);
    }

    // Mostrar info del usuario en sidebar
    const user = getCurrentUser();
    if (user) {
        const userNameEl = document.getElementById('userName');
        const userRoleEl = document.getElementById('userRole');
        if (userNameEl) userNameEl.textContent = user.nombreCompleto;
        if (userRoleEl) userRoleEl.textContent = user.rol;

        // Ocultar enlaces según rol
        if (user.rol !== 'ADMIN') {
            const usuariosLink = document.getElementById('usuariosLink');
            const logsLink = document.getElementById('logsLink');
            const preguntasLink = document.getElementById('preguntasLink');

            if (usuariosLink) usuariosLink.style.display = 'none';
            if (logsLink) logsLink.style.display = 'none';

            // Médicos, estudiantes y visualizadores no pueden gestionar variables
            if (user.rol === 'MEDICO' || user.rol === 'ESTUDIANTE' || user.rol === 'VISUALIZADOR') {
                if (preguntasLink) preguntasLink.style.display = 'none';
            }
        }
    }
});

// Función genérica para hacer peticiones
async function fetchAPI(endpoint, options = {}) {
    const token = getToken();

    const config = {
        headers: {
            'Content-Type': 'application/json',
            ...(token && { 'Authorization': `Bearer ${token}` }),
            ...options.headers
        },
        ...options
    };

    try {
        const response = await fetch(`${API_URL}${endpoint}`, config);

        if (response.status === 401) {
            logout();
            throw new Error('No autorizado');
        }

        if (!response.ok) {
            const error = await response.text();
            throw new Error(error || 'Error en la petición');
        }

        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            return await response.json();
        }

        return await response.text();
    } catch (error) {
        console.error('Error en petición:', error);
        throw error;
    }
}

// API de Autenticación
const AuthAPI = {
    login: async (rut, password) => {
        return fetchAPI('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ rut, password })
        });
    },

    recuperarPassword: async (email) => {
        return fetchAPI(`/auth/recuperar-password?email=${email}`, {
            method: 'POST'
        });
    }
};

// API de Usuarios
const UsuarioAPI = {
    getAll: () => fetchAPI('/usuarios'),
    getById: (id) => fetchAPI(`/usuarios/${id}`),
    create: (usuario) => fetchAPI('/usuarios', {
        method: 'POST',
        body: JSON.stringify(usuario)
    }),
    update: (id, usuario) => fetchAPI(`/usuarios/${id}`, {
        method: 'PUT',
        body: JSON.stringify(usuario)
    }),
    delete: (id) => fetchAPI(`/usuarios/${id}`, {
        method: 'DELETE'
    })
};

// API de Participantes
const ParticipanteAPI = {
    getAll: () => fetchAPI('/participantes'),
    getById: (id) => fetchAPI(`/participantes/${id}`),
    getByCodigo: (codigo) => fetchAPI(`/participantes/codigo/${codigo}`),
    getByTipo: (tipo) => fetchAPI(`/participantes/tipo/${tipo}`),
    getEstadisticas: () => fetchAPI('/participantes/estadisticas'),
    create: (participante) => fetchAPI('/participantes', {
        method: 'POST',
        body: JSON.stringify(participante)
    }),
    update: (id, participante) => fetchAPI(`/participantes/${id}`, {
        method: 'PUT',
        body: JSON.stringify(participante)
    }),
    delete: (id) => fetchAPI(`/participantes/${id}`, {
        method: 'DELETE'
    })
};

// API de Preguntas
const PreguntaAPI = {
    getActivas: () => fetchAPI('/preguntas'),
    getTodas: () => fetchAPI('/preguntas/todas'),
    getById: (id) => fetchAPI(`/preguntas/${id}`),
    getByGrupo: (grupo) => fetchAPI(`/preguntas/grupo/${grupo}`),
    create: (pregunta) => fetchAPI('/preguntas', {
        method: 'POST',
        body: JSON.stringify(pregunta)
    }),
    update: (id, pregunta) => fetchAPI(`/preguntas/${id}`, {
        method: 'PUT',
        body: JSON.stringify(pregunta)
    }),
    delete: (id) => fetchAPI(`/preguntas/${id}`, {
        method: 'DELETE'
    })
};

// API de Respuestas
const RespuestaAPI = {
    getByParticipante: (participanteId) =>
        fetchAPI(`/respuestas/participante/${participanteId}`),

    getByPregunta: (preguntaId) =>
        fetchAPI(`/respuestas/pregunta/${preguntaId}`),

    guardar: (participanteId, preguntaId, valor) =>
        fetchAPI(`/respuestas?participanteId=${participanteId}&preguntaId=${preguntaId}&valor=${encodeURIComponent(valor)}`, {
            method: 'POST'
        }),

    guardarMultiples: (participanteId, respuestas) =>
        fetchAPI(`/respuestas/bulk?participanteId=${participanteId}`, {
            method: 'POST',
            body: JSON.stringify(respuestas)
        })
};

// Utilidades
function showAlert(message, type = 'success') {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.textContent = message;
    alertDiv.style.position = 'fixed';
    alertDiv.style.top = '20px';
    alertDiv.style.right = '20px';
    alertDiv.style.zIndex = '9999';
    alertDiv.style.minWidth = '300px';

    document.body.appendChild(alertDiv);

    setTimeout(() => {
        alertDiv.remove();
    }, 3000);
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-CL');
}

function formatDateTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString('es-CL');
}