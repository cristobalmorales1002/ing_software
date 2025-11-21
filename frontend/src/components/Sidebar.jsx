import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import './Sidebar.css';
import {
    Speedometer2,   // Dashboard
    People,         // Casos
    ClipboardData,  // Encuestas
    PersonGear,     // Usuarios
    JournalText,    // Auditoría
    BoxArrowRight
} from 'react-bootstrap-icons';

import logoCybergene from '../assets/logo-biocode.png';

// 🔴 CAMBIA ESTO PARA PROBAR: 'ROLE_ADMIN' | 'ROLE_INVESTIGADOR' | 'ROLE_MEDICO' | 'ROLE_ESTUDIANTE'
const USER_ROLE = 'ROLE_ADMIN';

const Sidebar = () => {
    const location = useLocation();
    const navigate = useNavigate();

    // FUNCIÓN PARA CERRAR SESIÓN
    const handleLogout = () => {
        // 1. Borramos la bandera
        localStorage.removeItem('isLoggedIn');

        // 2. Redirigimos al Login
        navigate('/', { replace: true });
    };

    const menuItems = [
        {
            path: '/dashboard',
            name: 'Estadísticas',
            icon: <Speedometer2 />,
            // Visible para TODOS
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE']
        },
        {
            path: '/dashboard/casos-controles',
            name: 'Casos y controles',
            icon: <People />,
            // El corazón del sistema: Visible para todos
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE']
        },
        {
            path: '/dashboard/encuestas',
            name: 'Formulario',
            icon: <ClipboardData />,
            // Solo Investigadores y Admins pueden modificar la estructura de las preguntas
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR']
        },
        {
            path: '/dashboard/usuarios',
            name: 'Gestión de usuarios',
            icon: <PersonGear />,
            // Solo el Admin puede crear cuentas nuevas
            allowedRoles: ['ROLE_ADMIN']
        },
        {
            path: '/dashboard/auditoria',
            name: 'Registro de auditoría',
            icon: <JournalText />,
            // Solo el Admin puede ver quién hizo qué
            allowedRoles: ['ROLE_ADMIN']
        }
    ];

    return (
        <div className="sidebar">
            {/* --- AQUÍ ESTÁ EL CAMBIO DEL LOGO --- */}
            <div className="logo-container">
                <img src={logoCybergene} alt="CyberGene Logo" className="logo-img" />
            </div>
            {/* ----------------------------------- */}

            <div className="d-flex flex-column w-100">
                {menuItems.map((item, index) => {
                    // Si el rol actual NO está en la lista de permitidos, no renderizamos nada
                    if (!item.allowedRoles.includes(USER_ROLE)) return null;

                    return (
                        <Link
                            to={item.path}
                            key={index}
                            className={`nav-link-custom ${location.pathname === item.path ? 'active' : ''}`}
                            title={item.name}
                        >
                            <span className="nav-icon">{item.icon}</span>
                            <span className="nav-text">{item.name}</span>
                        </Link>
                    );
                })}
            </div>

            <div className="logout-btn nav-link-custom" onClick={handleLogout}>
                <span className="nav-icon"><BoxArrowRight /></span>
                <span className="nav-text">Cerrar Sesión</span>
            </div>
        </div>
    );
};

export default Sidebar;