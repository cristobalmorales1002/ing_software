import { BrowserRouter, Routes, Route } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import RequestPasswordReset from './pages/RequestPasswordReset';

// Importamos las nuevas
import ResetPasswordCombined from './pages/ResetPasswordCombined';

import DashboardLayout from './layouts/DashboardLayout';

import ProtectedRoute from './components/ProtectedRoute';

import UserManagement from './pages/UserManagement';

import CasesControls from './pages/CasesControls';

import SurveyBuilder from './pages/SurveyBuilder';

const DashboardHome = () => <h2>ESTADÍSTICAS DEL ESTUDIO</h2>;
const CasosControles = () => <h2>CASOS Y CONTROLES</h2>;
const EditorEncuestas = () => <h2>FORMULARIO</h2>;
const Auditoria = () => <h2>REGISTRO DE AUDITORÍA</h2>;

function App() {
    return (
        <BrowserRouter>
            <div className="App">
                <Routes>
                    <Route path="/" element={<LoginPage />} />
                    <Route path="/recuperar-password" element={<RequestPasswordReset />} />

                    <Route path="/verificar-codigo" element={<ResetPasswordCombined />} />
                    <Route element={<ProtectedRoute />}>
                        <Route path="/dashboard" element={<DashboardLayout />}>
                            {/* Ruta por defecto (Estadísticas) */}
                            <Route index element={<DashboardHome />} />

                            {/* Las nuevas rutas que definimos en el Sidebar */}
                            <Route path="casos-controles" element={<CasesControls />} />
                            <Route path="encuestas" element={<SurveyBuilder />} />
                            <Route path="usuarios" element={<UserManagement />} />
                            <Route path="auditoria" element={<Auditoria />} />
                        </Route>
                    </Route>

                </Routes>
            </div>
        </BrowserRouter>
    );
}

export default App;