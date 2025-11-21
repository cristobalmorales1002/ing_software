import { Navigate, Outlet } from 'react-router-dom';

const ProtectedRoute = () => {
    const isAuth = localStorage.getItem('isLoggedIn');

    // Si no está logueado, lo pateamos al Login ("/")
    if (!isAuth) {
        return <Navigate to="/" replace />;
    }

    // Si sí está logueado, dejamos mostrar el contenido (Outlet)
    return <Outlet />;
};

export default ProtectedRoute;