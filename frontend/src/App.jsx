import { BrowserRouter, Routes, Route } from 'react-router-dom';

// Páginas de Autenticación
import LoginPage from './pages/LoginPage';
import RequestPasswordReset from './pages/RequestPasswordReset';
import ResetPasswordCombined from './pages/ResetPasswordCombined';

// Layout y Seguridad
import DashboardLayout from './layouts/DashboardLayout';
import ProtectedRoute from './components/ProtectedRoute';

// Páginas del Sistema (Aquí importamos las reales)
import DashboardHome from './pages/DashboardHome';     // <--- NUEVO
import AuditLog from './pages/AuditLog';
import UserProfile from './pages/UserProfile';// <--- NUEVO
import UserManagement from './pages/UserManagement';
import CasesControls from './pages/CasesControls';
import SurveyBuilder from './pages/SurveyBuilder';

function App() {
    return (
        <BrowserRouter>
            <div className="App">
                <Routes>
                    {/* Rutas Públicas */}
                    <Route path="/" element={<LoginPage />} />
                    <Route path="/recuperar-password" element={<RequestPasswordReset />} />
                    <Route path="/verificar-codigo" element={<ResetPasswordCombined />} />

                    {/* Rutas Protegidas (Requieren Login) */}
                    <Route element={<ProtectedRoute />}>
                        <Route path="/dashboard" element={<DashboardLayout />}>

                            {/* 1. Dashboard Principal (Estadísticas) */}
                            <Route index element={<DashboardHome />} />

                            {/* 2. Módulos de Negocio */}
                            <Route path="casos-controles" element={<CasesControls />} />
                            <Route path="encuestas" element={<SurveyBuilder />} />

                            {/* 3. Gestión y Auditoría (Solo Admins idealmente) */}
                            <Route path="usuarios" element={<UserManagement />} />
                            <Route path="auditoria" element={<AuditLog />} />

                            {/* NUEVA RUTA PERFIL */}
                            <Route path="perfil" element={<UserProfile />} />

                        </Route>
                    </Route>

                </Routes>
            </div>
        </BrowserRouter>
    );
}

export default App;