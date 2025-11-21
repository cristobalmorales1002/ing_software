import { useState, useRef, useEffect } from 'react';
import { Form, Button, Container, Row, Col, Card, Alert, Spinner } from 'react-bootstrap';
import { useLocation, useNavigate } from 'react-router-dom';
import api from '../api/axios';
import './Login.css';

function ResetPasswordCombined() {
    // Estado para el código (6 dígitos)
    const [code, setCode] = useState(['', '', '', '', '', '']);
    // Estados para las contraseñas
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');

    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    const inputRefs = useRef([]);
    const navigate = useNavigate();
    const location = useLocation();
    const email = location.state?.email;

    useEffect(() => {
        if (!email) {
            // Si se pierde el email (recarga de pág), mejor volver al inicio
            navigate('/recuperar-password');
        }
        if (inputRefs.current[0]) inputRefs.current[0].focus();
    }, [email, navigate]);

    // --- Lógica de los Inputs de Código ---
    const handleCodeChange = (index, value) => {
        if (!/^\d*$/.test(value)) return;
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

    // --- Envío del Formulario ---
    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);
        setSuccess(null);

        const token = code.join('');

        // Validaciones básicas
        if (token.length < 6) {
            setError('El código debe tener 6 dígitos.');
            return;
        }
        if (password.length < 4) {
            setError('La contraseña es muy corta.');
            return;
        }
        if (password !== confirmPassword) {
            setError('Las contraseñas no coinciden.');
            return;
        }

        setIsLoading(true);

        try {
            // Llamamos a tu endpoint existente que pide Token + Nueva Clave
            // Nota: Tu DTO en Java espera "token" y "nuevaContrasena"
            const res = await api.post('/api/autenticacion/reset-clave', {
                token: token,
                nuevaContrasena: password
            });

            if (res.status === 200) {
                setSuccess('¡Contraseña cambiada con éxito!');
                // Redirigir al Login después de 3 segundos
                setTimeout(() => navigate('/'), 3000);
            }
        } catch (err) {
            if (err.response && err.response.data) {
                // Muestra el mensaje de error del backend (ej: "Token inválido")
                setError(typeof err.response.data === 'string'
                    ? err.response.data
                    : 'Error al cambiar la contraseña.');
            } else {
                setError('Error de conexión.');
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
                                <h4>Restablecer Contraseña</h4>
                                <p className="text-muted small">Ingresa el código enviado a {email}</p>
                            </div>

                            <Form onSubmit={handleSubmit}>
                                {/* Sección Código */}
                                <Form.Label>Código de Verificación</Form.Label>
                                <div className="d-flex justify-content-between mb-3 gap-1" onPaste={handlePaste}>
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
                                            className="text-center p-2"
                                            style={{ width: '40px', height: '45px' }}
                                        />
                                    ))}
                                </div>

                                <hr className="my-4"/>

                                {/* Sección Nueva Contraseña */}
                                <Form.Group className="mb-3">
                                    <Form.Label>Nueva Contraseña</Form.Label>
                                    <Form.Control
                                        type="password"
                                        required
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                    />
                                </Form.Group>

                                <Form.Group className="mb-4">
                                    <Form.Label>Confirmar Contraseña</Form.Label>
                                    <Form.Control
                                        type="password"
                                        required
                                        value={confirmPassword}
                                        onChange={(e) => setConfirmPassword(e.target.value)}
                                    />
                                </Form.Group>

                                {error && <Alert variant="danger">{error}</Alert>}
                                {success && <Alert variant="success">{success}</Alert>}

                                <div className="d-grid">
                                    <Button variant="primary" type="submit" disabled={isLoading}>
                                        {isLoading ? <Spinner animation="border" size="sm"/> : 'Cambiar Contraseña'}
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

export default ResetPasswordCombined;