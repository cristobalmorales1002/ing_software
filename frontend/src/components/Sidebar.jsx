import React, { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Badge } from 'react-bootstrap';
import './Sidebar.css';
import {
    Speedometer2,
    People,
    ClipboardData,
    PersonGear,
    JournalText,
    BoxArrowRight,
    Sun,
    Moon,
    PersonCircle,
    Envelope
} from 'react-bootstrap-icons';

import { useTheme } from '../context/ThemeContext';
import logoCybergene from '../assets/logo-biocode.png';

import api from '../api/axios';

const Sidebar = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const { theme, toggleTheme } = useTheme();

    const [userRole, setUserRole] = useState(null);

    useEffect(() => {
        const fetchUserRole = async () => {
            try {
                const res = await api.get('/api/usuarios/me');
                setUserRole(res.data.rol);
            } catch (error) {
                console.error("Error al obtener el perfil del usuario", error);
            }
        };

        fetchUserRole();
    }, []);

    const handleLogout = () => {
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('user');
        localStorage.removeItem('token');
        navigate('/', { replace: true });
    };

    const menuItems = [
        {
            path: '/dashboard',
            name: 'Estadísticas',
            icon: <Speedometer2 />,
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE', 'ROLE_VISUALIZADOR'] // Ejemplo: visible para todos
        },
        {
            path: '/dashboard/casos-controles',
            name: 'Casos y controles',
            icon: <People />,
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE', 'ROLE_VISUALIZADOR'] // Solo admin y usuarios normales
        },
        {
            path: '/dashboard/encuestas',
            name: 'Formulario',
            icon: <ClipboardData />,
            allowedRoles: ['ROLE_ADMIN']
        },
        {
            path: '/dashboard/usuarios',
            name: 'Gestión de usuarios',
            icon: <PersonGear />,
            allowedRoles: ['ROLE_ADMIN']
        },
        {
            path: '/dashboard/auditoria',
            name: 'Registro de auditoría',
            icon: <JournalText />,
            allowedRoles: ['ROLE_ADMIN']
        }
    ];

    // 5. Filtrar el menú basado en el rol actual
    const filteredMenuItems = menuItems.filter(item => {
        // Si el rol aún no carga, no mostramos nada (o podrías mostrar items públicos por defecto)
        if (!userRole) return false;

        // Si el ítem no tiene restricción, lo mostramos
        if (!item.allowedRoles) return true;

        // Verificamos si el rol del usuario está en la lista permitida
        return item.allowedRoles.includes(userRole);
    });

    return (
        <div className="sidebar">
            {/* LOGO */}
            <div className="logo-container">
                <img src={logoCybergene} alt="CyberGene Logo" className="logo-img" />
            </div>

            {/* MENÚ SUPERIOR (Renderizamos la lista filtrada) */}
            <div className="d-flex flex-column w-100">
                {filteredMenuItems.map((item, index) => (
                    <Link
                        to={item.path}
                        key={index}
                        className={`nav-link-custom ${location.pathname === item.path ? 'active' : ''}`}
                        title={item.name}
                    >
                        <span className="nav-icon">{item.icon}</span>
                        <span className="nav-text">{item.name}</span>
                    </Link>
                ))}
            </div>

            {/* --- ZONA INFERIOR (BLOQUE UNIDO) --- */}

            {/* 1. MODO CLARO/OSCURO */}
            <div
                className="nav-link-custom"
                onClick={toggleTheme}
                style={{cursor: 'pointer', marginTop: 'auto'}}
                title="Cambiar Tema"
            >
                <span className="nav-icon">{theme === 'dark' ? <Sun /> : <Moon />}</span>
                <span className="nav-text">{theme === 'dark' ? 'Modo Claro' : 'Modo Oscuro'}</span>
            </div>


            {/* MENSAJES */}
            <Link
                to="/dashboard/mensajes"
                className={`nav-link-custom ${location.pathname === '/dashboard/mensajes' ? 'active' : ''}`}
                title="Mensajes"
            >
            <span className="nav-icon">
                <Envelope />
            </span>

                        {/* Usamos flexbox y w-100 para separar el texto del badge */}
                        <span className="nav-text d-flex justify-content-between align-items-center w-100">
                Mensajes

                            {/* Solo mostramos el badge si hay mensajes (> 0) */}
                            {5 > 0 && (
                                <Badge bg="danger" pill className="ms-2" style={{ fontSize: '0.75rem' }}>
                                    5
                                </Badge>
                            )}
            </span>
            </Link>

            {/* 2. MI PERFIL */}
            <Link
                to="/dashboard/perfil"
                className={`nav-link-custom ${location.pathname === '/dashboard/perfil' ? 'active' : ''}`}
                title="Mi Perfil"
            >
                <span className="nav-icon"><PersonCircle /></span>
                <span className="nav-text">Mi Perfil</span>
            </Link>

            {/* 3. CERRAR SESIÓN */}
            <div className="logout-btn nav-link-custom" onClick={handleLogout} style={{cursor: 'pointer'}}>
                <span className="nav-icon"><BoxArrowRight /></span>
                <span className="nav-text">Cerrar Sesión</span>
            </div>
        </div>
    );
};

export default Sidebar;