import { Outlet } from 'react-router-dom';
import Sidebar from '../components/Sidebar.jsx';
import { Container } from 'react-bootstrap';

import './DashBoardTheme.css';

const DashboardLayout = () => {
    return (
        <div className="d-flex dashboard-theme">
            {/* 1. El Sidebar Fijo */}
            <Sidebar />

            {/* 2. El Contenido Principal */}
            {/* Le damos un margen izquierdo de 80px para que el sidebar no tape el contenido */}
            <div style={{ marginLeft: '80px', width: '100%', transition: 'margin-left 0.3s', zIndex: 1 }}>


                {/* Aquí se renderizarán las páginas hijas (Dashboard, Pacientes, etc.) */}
                <Container fluid className="p-4">
                    <Outlet />
                </Container>
            </div>
        </div>
    );
};

export default DashboardLayout;