import { useState, useRef, useEffect } from 'react';
import { Form, Button, Container, Row, Col, Card, Alert, Spinner } from 'react-bootstrap';
import { useLocation, useNavigate, Link } from 'react-router-dom';
import api from '../api/axios'; // Tu configuración de axios
import './Login.css';

function VerifyCode() {
    const [code, setCode] = useState(['', '', '', '', '', '']);
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    const inputRefs = useRef([]);
    const navigate = useNavigate();
    const location = useLocation();
    const email = location.state?.email;

    useEffect(() => {
        // Si el usuario llega aquí sin email (por url directa), lo mandamos al inicio
        if (!email) {
            navigate('/recuperar-password');
        }
        // Enfocar el primer input al cargar
        if (inputRefs.current[0]) inputRefs.current[0].focus();
    }, [email, navigate]);

    // --- Lógica de Inputs (Pestaña, Borrar, Escribir) ---
    const handleCodeChange = (index, value) => {
        if (!/^\d*$/.test(value)) return; // Solo números
        const newCode = [...code];
        newCode[index] = value.slice(-1);
        setCode(newCode);
        if (value && index < 5) inputRefs.current[index + 1].focus();
    };

    const handleKeyDown = (index, e) => {
        if (e.key === 'Backspace' && !code[index] && index > 0) {
            inputRefs.current[index - 1].focus();
        }
    };

    const handlePaste = (e) => {
        e.preventDefault();
        const data = e.clipboardData.getData('text').slice(0, 6).split('');
        if (data.length === 6 && data.every(c => /^\d$/.test(c))) {
            setCode(data);
            inputRefs.current[5].focus();
        }
    };

    // --- Envío al Backend ---
    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);

        const token = code.join('');
        if (token.length < 6) {
            setError('Por favor completa el código de 6 dígitos.');
            return;
        }

        setIsLoading(true);

        try {
            // 1. Consultamos al nuevo endpoint que creaste
            await api.post('/api/autenticacion/validar-token', { token: token });

            // 2. Si es 200 OK, pasamos a la siguiente pantalla
            // Enviamos el token y el email para usarlos en el cambio de clave
            navigate('/cambiar-password', { state: { email: email, token: token } });

        } catch (err) {
            // Si el backend responde error (400), mostramos el mensaje
            if (err.response && err.response.data) {
                setError(typeof err.response.data === 'string'
                    ? err.response.data
                    : 'El código es inválido o ha expirado.');
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
                <Col md={6} lg={5} xl={4}>
                    <Card className="shadow-sm">
                        <Card.Body className="p-4">
                            <div className="text-center mb-4">
                                <h4>Verificación de Seguridad</h4>
                                <p className="text-muted small">
                                    Ingresa el código de 6 dígitos enviado a <br/><strong>{email}</strong>
                                </p>
                            </div>

                            <Form onSubmit={handleSubmit}>
                                <div className="d-flex justify-content-center mb-4 gap-2" onPaste={handlePaste}>
                                    {code.map((digit, index) => (
                                        <Form.Control
                                            key={index}
                                            type="text"
                                            inputMode="numeric"
                                            maxLength={1}
                                            value={digit}
                                            ref={el => inputRefs.current[index] = el}
                                            onChange={(e) => handleCodeChange(index, e.target.value)}
                                            onKeyDown={(e) => handleKeyDown(index, e)}
                                            className="text-center p-2 code-input"
                                            style={{ width: '45px', height: '50px', fontSize: '1.2rem' }}
                                            disabled={isLoading}
                                        />
                                    ))}
                                </div>

                                {error && <Alert variant="danger">{error}</Alert>}

                                <div className="d-grid mb-3">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading}>
                                        {isLoading ? <Spinner animation="border" size="sm"/> : 'Verificar Código'}
                                    </Button>
                                </div>

                                <div className="text-center">
                                    <Link to="/recuperar-password" className="text-muted small text-decoration-none">
                                        ¿No recibiste el código? Volver atrás
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

export default VerifyCode;