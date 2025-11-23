import 'bootstrap/dist/css/bootstrap.min.css';
import './theme.css'; // <--- 1. IMPORTA EL CSS DE TEMAS AQUÍ

import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'
import { ThemeProvider } from './context/ThemeContext'; // <--- 2. IMPORTA EL CONTEXTO

createRoot(document.getElementById('root')).render(
    <StrictMode>
        <ThemeProvider> {/* <--- 3. ENVUELVE LA APP */}
            <App />
        </ThemeProvider>
    </StrictMode>,
)