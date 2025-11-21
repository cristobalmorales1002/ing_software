import { useState } from 'react';
import { Form, Button, Container, Row, Col, Card, Alert, Spinner } from 'react-bootstrap';
import api from '../api/axios'; // Asegúrate de importar tu instancia de axios
import { useNavigate, Link } from 'react-router-dom';
import './Login.css';

function RequestPasswordReset() {
    const [email, setEmail] = useState('');
    const [message, setMessage] = useState(null); // Para mensaje verde de éxito
    const [error, setError] = useState(null);     // Para mensaje rojo de error
    const [isLoading, setIsLoading] = useState(false);

    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);
        setMessage(null);

        if (email.trim() === '') {
            setError('El correo es obligatorio.');
            return;
        }

        setIsLoading(true);

        try {

            const res = await api.post('/api/autenticacion/recuperar-clave', { email: email });

            if (res.status === 200) {
                setMessage('Código enviado correctamente. Revisa tu correo.');
                setTimeout(() => {
                    navigate('/verificar-codigo', { state: { email: email } });
                }, 2000);
            }
        } catch (err) {
            if (err.response && err.response.status === 400) {
                setError(err.response.data || 'Error al procesar la solicitud.');
            } else {
                setError('Error de conexión. Inténtalo más tarde.');
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
                        <Card.Body className="p-4">
                            <div className="login-header text-center mb-4">
                                <h3>Recuperar Contraseña</h3>
                                <p className="text-muted">Ingresa tu correo para recibir el código de verificación</p>
                            </div>

                            <Form onSubmit={handleSubmit}>
                                <Form.Group className="mb-4" controlId="email">
                                    <Form.Label>Correo Electrónico</Form.Label>
                                    <Form.Control
                                        type="email"
                                        placeholder="ejemplo@cancer.cl"
                                        required
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                    />
                                </Form.Group>

                                {/* Alerta de Error */}
                                {error && (
                                    <Alert variant="danger" onClose={() => setError(null)} dismissible>
                                        {error}
                                    </Alert>
                                )}

                                {/* Alerta de Éxito */}
                                {message && (
                                    <Alert variant="success">
                                        {message}
                                    </Alert>
                                )}

                                <div className="d-grid mb-3">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading}>
                                        {isLoading ? (
                                            <>
                                                <Spinner animation="border" size="sm" />&nbsp;Enviando...
                                            </>
                                        ) : 'Enviar código'}
                                    </Button>
                                </div>

                                <div className="form-footer text-center">
                                    {/* Usamos Link para volver al login sin recargar la página */}
                                    <Link to="/" className="text-decoration-none">
                                        Volver al inicio de sesión
                                    </Link>
                                </div>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
}

export default RequestPasswordReset;