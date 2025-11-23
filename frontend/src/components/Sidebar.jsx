import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
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
    PersonCircle
} from 'react-bootstrap-icons';

import { useTheme } from '../context/ThemeContext';
import logoCybergene from '../assets/logo-biocode.png';

const Sidebar = () => {
    const location = useLocation();
    const navigate = useNavigate();
    const { theme, toggleTheme } = useTheme();

    const handleLogout = () => {
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('user');
        localStorage.removeItem('token');
        navigate('/', { replace: true });
    };

    // Lista del menú principal (SIN perfil)
    const menuItems = [
        { path: '/dashboard', name: 'Estadísticas', icon: <Speedometer2 /> },
        { path: '/dashboard/casos-controles', name: 'Casos y controles', icon: <People /> },
        { path: '/dashboard/encuestas', name: 'Formulario', icon: <ClipboardData /> },
        { path: '/dashboard/usuarios', name: 'Gestión de usuarios', icon: <PersonGear /> },
        { path: '/dashboard/auditoria', name: 'Registro de auditoría', icon: <JournalText /> }
    ];

    return (
        <div className="sidebar">
            {/* LOGO */}
            <div className="logo-container">
                <img src={logoCybergene} alt="CyberGene Logo" className="logo-img" />
            </div>

            {/* MENÚ SUPERIOR */}
            <div className="d-flex flex-column w-100">
                {menuItems.map((item, index) => (
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

            {/* 1. MODO CLARO/OSCURO (Este empuja todo el bloque hacia abajo) */}
            <div
                className="nav-link-custom"
                onClick={toggleTheme}
                style={{cursor: 'pointer', marginTop: 'auto'}}
                title="Cambiar Tema"
            >
                <span className="nav-icon">{theme === 'dark' ? <Sun /> : <Moon />}</span>
                <span className="nav-text">{theme === 'dark' ? 'Modo Claro' : 'Modo Oscuro'}</span>
            </div>

            {/* 2. MI PERFIL (Pegado abajo del modo oscuro) */}
            <Link
                to="/dashboard/perfil"
                className={`nav-link-custom ${location.pathname === '/dashboard/perfil' ? 'active' : ''}`}
                title="Mi Perfil"
            >
                <span className="nav-icon"><PersonCircle /></span>
                <span className="nav-text">Mi Perfil</span>
            </Link>

            {/* 3. CERRAR SESIÓN (Pegado abajo del perfil) */}
            <div className="logout-btn nav-link-custom" onClick={handleLogout} style={{cursor: 'pointer'}}>
                <span className="nav-icon"><BoxArrowRight /></span>
                <span className="nav-text">Cerrar Sesión</span>
            </div>
        </div>
    );
};

export default Sidebar;