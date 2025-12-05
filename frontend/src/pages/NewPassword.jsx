import { useState, useEffect } from 'react';
import { Form, Button, Container, Row, Col, Card, Alert, Spinner } from 'react-bootstrap';
import { useLocation, useNavigate } from 'react-router-dom';
import api from '../api/axios';
import './Login.css';

function NewPassword() {
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');

    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    const navigate = useNavigate();
    const location = useLocation();

    // Recuperamos los datos que nos pasó VerifyCode.jsx
    const { token, email } = location.state || {};

    useEffect(() => {
        // Seguridad: Si no hay token en el estado (acceso directo por URL), sacamos al usuario
        if (!token) {
            navigate('/recuperar-password');
        }
    }, [token, navigate]);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);

        // Validaciones locales
        if (password.length < 6) {
            setError('La contraseña debe tener al menos 6 caracteres.');
            return;
        }
        if (password !== confirmPassword) {
            setError('Las contraseñas no coinciden.');
            return;
        }

        setIsLoading(true);

        try {
            // Llamamos a resetearClave.
            // Tu DTO Java espera: { "token": "...", "nuevaContrasena": "..." }
            const res = await api.post('/api/autenticacion/reset-clave', {
                token: token,
                nuevaContrasena: password
            });

            if (res.status === 200) {
                setSuccess('¡Contraseña actualizada correctamente!');
                // Redirigimos al Login después de 3 segundos
                setTimeout(() => navigate('/'), 3000);
            }
        } catch (err) {
            if (err.response && err.response.data) {
                // Mensaje del backend (ej: "Token expirado" si tardó mucho)
                setError(typeof err.response.data === 'string'
                    ? err.response.data
                    : 'Error al cambiar la contraseña.');
            } else {
                setError('Error de conexión con el servidor.');
            }
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <Container fluid className="login-page vh-100 d-flex align-items-center justify-content-center">
            <Row className="justify-content-md-center w-100">
                <Col md={5} lg={4}>
                    <Card className="shadow-sm">
                        <Card.Body className="p-4">
                            <div className="text-center mb-4">
                                <h4>Nueva Contraseña</h4>
                                <p className="text-muted small">Establece la nueva contraseña para <strong>{email}</strong></p>
                            </div>

                            <Form onSubmit={handleSubmit}>
                                <Form.Group className="mb-3">
                                    <Form.Label>Nueva Contraseña</Form.Label>
                                    <Form.Control
                                        type="password"
                                        required
                                        placeholder="Mínimo 6 caracteres"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        disabled={isLoading || success}
                                    />
                                </Form.Group>

                                <Form.Group className="mb-4">
                                    <Form.Label>Confirmar Contraseña</Form.Label>
                                    <Form.Control
                                        type="password"
                                        required
                                        placeholder="Repetir contraseña"
                                        value={confirmPassword}
                                        onChange={(e) => setConfirmPassword(e.target.value)}
                                        disabled={isLoading || success}
                                    />
                                </Form.Group>

                                {error && <Alert variant="danger">{error}</Alert>}
                                {success && <Alert variant="success">{success}</Alert>}

                                <div className="d-grid">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading || success}>
                                        {isLoading ? <Spinner animation="border" size="sm"/> : 'Restablecer Contraseña'}
                                    </Button>
                                </div>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
}

export default NewPassword;