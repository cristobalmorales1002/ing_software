import { useState, useEffect } from 'react';
// 1. Agregamos InputGroup a los imports de Bootstrap
import { Form, Button, Container, Row, Col, Card, Alert, Spinner, InputGroup } from 'react-bootstrap';
import api from '../api/axios';
import { validateRut, formatRut } from '../utils/rutUtils.js';
import { Link, useNavigate } from 'react-router-dom';

// 2. Importamos los iconos del ojo
import { Eye, EyeSlash } from 'react-bootstrap-icons';

import './Login.css';
import logoCybergene from '../assets/logo-biocode.png';

// 3. IMPORTAR EL HOOK DEL TEMA
import { useTheme } from '../context/ThemeContext';

function LoginPage() {
    const [rut, setRut] = useState('');
    const [password, setPassword] = useState('');

    const [showPassword, setShowPassword] = useState(false);

    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    const navigate = useNavigate();

    // 4. OBTENER LA FUNCIÓN DE SINCRONIZACIÓN
    const { syncTheme } = useTheme();

    useEffect(() => {
        if (localStorage.getItem('isLoggedIn') === 'true') {
            navigate('/dashboard', { replace: true });
        }
    }, [navigate]);

    const handleRutChange = (e) => {
        setRut(formatRut(e.target.value));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);

        if (!validateRut(rut)) {
            setError('El RUT ingresado no es válido.');
            return;
        }
        if (password.trim() === '') {
            setError('La contraseña es obligatoria.');
            return;
        }

        setIsLoading(true);

        const body = new URLSearchParams();
        body.append('rut', rut);
        body.append('password', password);

        try {
            const res = await api.post('/login', body.toString(), {
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            });

            if (res.status === 200 || res.status === 204) {
                localStorage.setItem('isLoggedIn', 'true');

                // 5. ¡AQUÍ ESTÁ LA CLAVE!
                // Forzamos la carga del tema del usuario que acaba de entrar
                await syncTheme();

                navigate('/dashboard', { replace: true });
            } else {
                setError('Error al autenticar: ' + res.status);
            }
        } catch (err) {
            if (err.response && err.response.status === 401) {
                setError('Credenciales incorrectas');
            } else {
                setError('Error de red: ' + (err.message || 'desconocido'));
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <Container fluid className="login-page vh-100 d-flex align-items-center justify-content-center">
            <Row className="justify-content-md-center w-100">
                <Col md={5} lg={4}>
                    <Card className="login-card shadow-sm">
                        <Card.Body className="p-4 p-md-5">

                            <div className="login-header text-center mb-4">
                                <img src={logoCybergene} alt="Logo CyberGene" className="login-logo mb-6" />
                                <h3>Plataforma cáncer gástrico</h3>
                                <p className="text-muted">Sistema de gestión de datos de investigación</p>
                            </div>

                            <Form onSubmit={handleSubmit} className="login-form">
                                <Form.Group className="mb-3" controlId="rut">
                                    <Form.Label>RUT</Form.Label>
                                    <Form.Control
                                        type="text"
                                        placeholder="12.345.678-9"
                                        required
                                        value={rut}
                                        onChange={handleRutChange}
                                        maxLength={12}
                                    />
                                </Form.Group>

                                <Form.Group className="mb-4" controlId="password">
                                    <Form.Label>Contraseña</Form.Label>

                                    <InputGroup>
                                        <Form.Control
                                            type={showPassword ? "text" : "password"}
                                            placeholder="********"
                                            required
                                            value={password}
                                            onChange={(e) => setPassword(e.target.value)}
                                            style={{ borderRight: 'none' }}
                                        />
                                        <Button
                                            variant="outline-secondary"
                                            onClick={() => setShowPassword(!showPassword)}
                                            style={{ borderLeft: 'none', borderColor: '#dee2e6' }}
                                            title={showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}
                                        >
                                            {showPassword ? <EyeSlash /> : <Eye />}
                                        </Button>
                                    </InputGroup>
                                </Form.Group>

                                {error && (
                                    <Alert variant="danger" onClose={() => setError(null)} dismissible className="fs-6">
                                        {error}
                                    </Alert>
                                )}

                                <div className="d-grid mb-4">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading}>
                                        {isLoading ? (<><Spinner animation="border" size="sm" />&nbsp;Ingresando...</>) : 'Iniciar sesión'}
                                    </Button>
                                </div>

                                <div className="form-footer text-center">
                                    <Link to="/recuperar-password">¿Olvidaste tu contraseña?</Link>
                                </div>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
}

export default LoginPage;