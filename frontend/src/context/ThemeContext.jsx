import { createContext, useState, useEffect, useContext } from 'react';
import api from '../api/axios';

const ThemeContext = createContext();

export const ThemeProvider = ({ children }) => {
    // 1. Estado inicial desde LocalStorage
    const [theme, setTheme] = useState(localStorage.getItem('appTheme') || 'dark');

    // 2. EFECTO: Aplicar visualmente (CSS y LocalStorage) cada vez que cambie el estado 'theme'
    useEffect(() => {
        localStorage.setItem('appTheme', theme);
        document.body.setAttribute('data-theme', theme);
    }, [theme]);

    // 3. FUNCIÓN DE SINCRONIZACIÓN (La llamaremos manualmente desde el Login)
    const syncTheme = async () => {
        try {
            // Verificamos si hay sesión antes de llamar
            if (localStorage.getItem('isLoggedIn') === 'true') {
                const res = await api.get('/api/usuarios/me');
                const savedTheme = res.data.tema;

                // Si la BD tiene un tema guardado, lo aplicamos
                if (savedTheme && (savedTheme === 'light' || savedTheme === 'dark')) {
                    setTheme(savedTheme);
                }
            }
        } catch (err) {
            console.error("No se pudo sincronizar el tema:", err);
        }
    };

    // Si recargas la página (F5), queremos que intente sincronizar igual
    useEffect(() => {
        syncTheme();
    }, []);

    // 4. FUNCIÓN TOGGLE (Cambiar tema con el botón)
    const toggleTheme = () => {
        const newTheme = theme === 'dark' ? 'light' : 'dark';
        setTheme(newTheme);

        // Si está logueado, guardamos la nueva elección en la BD
        if (localStorage.getItem('isLoggedIn') === 'true') {
            api.put('/api/usuarios/me/tema', { tema: newTheme })
                .catch(err => console.error("Error guardando preferencia de tema", err));
        }
    };

    return (
        <ThemeContext.Provider value={{ theme, toggleTheme, syncTheme }}>
            {children}
        </ThemeContext.Provider>
    );
};

export const useTheme = () => useContext(ThemeContext);