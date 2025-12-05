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
    Envelope,
    FileEarmarkText
} from 'react-bootstrap-icons';

import { useTheme } from '../context/ThemeContext';
import logoCybergene from '../assets/logo-biocode.png';

import api from '../api/axios';

const Sidebar = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const { theme, toggleTheme } = useTheme();

    const [userRole, setUserRole] = useState(null);
    // 1. Estado para el contador de mensajes
    const [unreadCount, setUnreadCount] = useState(0);

    useEffect(() => {
        const fetchUserRole = async () => {
            try {
                const res = await api.get('/api/usuarios/me');
                setUserRole(res.data.rol);
            } catch (error) {
                console.error("Error al obtener el perfil del usuario", error);
            }
        };

        // 2. Función para obtener conteo de mensajes no leídos
        const fetchUnreadCount = async () => {
            try {
                const res = await api.get('/api/mensajes/noleidos/cantidad');
                setUnreadCount(res.data);
            } catch (error) {
                console.error("Error al cargar mensajes no leídos", error);
            }
        };

        fetchUserRole();
        fetchUnreadCount();

        // Opcional: Podrías poner un intervalo para actualizar cada X segundos
        // const interval = setInterval(fetchUnreadCount, 30000);
        // return () => clearInterval(interval);

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
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE', 'ROLE_VISUALIZADOR']
        },
        {
            path: '/dashboard/casos-controles',
            name: 'Casos y controles',
            icon: <People />,
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE', 'ROLE_VISUALIZADOR']
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
        },
        {
            path: '/dashboard/documentos',
            name: 'Documentos',
            icon: <FileEarmarkText />,
            allowedRoles: ['ROLE_ADMIN', 'ROLE_INVESTIGADOR', 'ROLE_MEDICO', 'ROLE_ESTUDIANTE', 'ROLE_VISUALIZADOR']
        }
    ];

    const filteredMenuItems = menuItems.filter(item => {
        if (!userRole) return false;
        if (!item.allowedRoles) return true;
        return item.allowedRoles.includes(userRole);
    });

    return (
        <div className="sidebar">
            <div className="logo-container">
                <img src={logoCybergene} alt="CyberGene Logo" className="logo-img" />
            </div>

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

            {/* --- ZONA INFERIOR --- */}

            <div
                className="nav-link-custom"
                onClick={toggleTheme}
                style={{cursor: 'pointer', marginTop: 'auto'}}
                title="Cambiar Tema"
            >
                <span className="nav-icon">{theme === 'dark' ? <Sun /> : <Moon />}</span>
                <span className="nav-text">{theme === 'dark' ? 'Modo Claro' : 'Modo Oscuro'}</span>
            </div>

            {/* MENSAJES CON BADGE DINÁMICO */}
            <Link
                to="/dashboard/mensajes"
                className={`nav-link-custom ${location.pathname === '/dashboard/mensajes' ? 'active' : ''}`}
                title="Mensajes"
            >
                <span className="nav-icon">
                    <Envelope />
                </span>
                <span className="nav-text d-flex justify-content-between align-items-center w-100">
                    Mensajes
                    {/* 3. Renderizado condicional basado en el estado real */}
                    {unreadCount > 0 && (
                        <Badge bg="danger" pill className="ms-2" style={{ fontSize: '0.75rem' }}>
                            {unreadCount}
                        </Badge>
                    )}
                </span>
            </Link>

            <Link
                to="/dashboard/perfil"
                className={`nav-link-custom ${location.pathname === '/dashboard/perfil' ? 'active' : ''}`}
                title="Mi Perfil"
            >
                <span className="nav-icon"><PersonCircle /></span>
                <span className="nav-text">Mi Perfil</span>
            </Link>

            <div className="logout-btn nav-link-custom" onClick={handleLogout} style={{cursor: 'pointer'}}>
                <span className="nav-icon"><BoxArrowRight /></span>
                <span className="nav-text">Cerrar Sesión</span>
            </div>
        </div>
    );
};

export default Sidebar;