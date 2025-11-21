import { useState, useEffect } from 'react';
import { Form, Button, Container, Row, Col, Card, Alert, Spinner } from 'react-bootstrap';
import api from '../api/axios';
import { validateRut, formatRut } from '../utils/rutUtils.js';
import { Link, useNavigate } from 'react-router-dom';

// 1. IMPORTAMOS EL CSS Y EL LOGO
import './Login.css';
import logoCybergene from '../assets/logo-biocode.png'; // <--- AJUSTA ESTA RUTA

function LoginPage() {
    const [rut, setRut] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    const navigate = useNavigate();

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
                navigate('/dashboard', { replace: true });
            } else if (res.status === 401) {
                setError('Credenciales incorrectas');
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
                        <Card.Body className="p-4 p-md-5"> {/* Un poco más de padding interno */}

                            <div className="login-header text-center mb-4">
                                {/* 2. AQUÍ AGREGAMOS EL LOGO */}
                                <img src={logoCybergene} alt="Logo CyberGene" className="login-logo mb-6" />

                                <h3>Plataforma Cáncer Gástrico</h3>
                                <p className="text-muted">Sistema de Gestión de Datos de Investigación</p>
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
                                    <Form.Control
                                        type="password"
                                        placeholder="********"
                                        required
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                    />
                                </Form.Group>

                                {error && (
                                    <Alert variant="danger" onClose={() => setError(null)} dismissible className="fs-6">
                                        {error}
                                    </Alert>
                                )}

                                <div className="d-grid mb-4">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading}>
                                        {isLoading ? (<><Spinner animation="border" size="sm" />&nbsp;Ingresando...</>) : 'Iniciar Sesión'}
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