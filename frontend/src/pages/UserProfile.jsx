import { useState, useEffect } from 'react';
// 1. Agregamos InputGroup
import { Container, Row, Col, Card, Form, Button, Alert, Spinner, InputGroup } from 'react-bootstrap';
// 2. Agregamos Eye y EyeSlash
import { PersonCircle, Envelope, Phone, Lock, Save, PersonVcard, ShieldLock, Eye, EyeSlash } from 'react-bootstrap-icons';
import api from '../api/axios';

const UserProfile = () => {
    const [currentUser, setCurrentUser] = useState({
        nombres: '',
        apellidos: '',
        rut: '',
        rol: ''
    });

    const [formData, setFormData] = useState({
        email: '',
        telefono: '',
        password: '',
        confirmPassword: ''
    });

    // 3. Estados para controlar la visibilidad de cada campo independientemente
    const [showNewPass, setShowNewPass] = useState(false);
    const [showConfirmPass, setShowConfirmPass] = useState(false);

    const [isLoading, setIsLoading] = useState(false);
    const [message, setMessage] = useState({ type: '', text: '' });

    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const res = await api.get('/api/usuarios/me');
                const user = res.data;

                setCurrentUser({
                    nombres: user.nombres || '',
                    apellidos: user.apellidos || '',
                    rut: user.rut || '',
                    rol: user.rol || 'USUARIO'
                });

                setFormData(prev => ({
                    ...prev,
                    email: user.email || '',
                    telefono: user.telefono || ''
                }));

                localStorage.setItem('user', JSON.stringify(user));

            } catch (err) {
                console.error("Error cargando perfil", err);
                const localUser = JSON.parse(localStorage.getItem('user'));
                if (localUser) {
                    setCurrentUser({
                        nombres: localUser.nombres || '',
                        apellidos: localUser.apellidos || '',
                        rut: localUser.rut || '',
                        rol: localUser.rol || ''
                    });
                }
            }
        };

        fetchProfile();
    }, []);

    const handleInputChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage({ type: '', text: '' });

        if (formData.password || formData.confirmPassword) {
            if (formData.password !== formData.confirmPassword) {
                setMessage({ type: 'danger', text: 'Las contraseñas no coinciden.' });
                return;
            }
            if (formData.password.length < 6) {
                setMessage({ type: 'danger', text: 'La contraseña debe tener al menos 6 caracteres.' });
                return;
            }
        }

        setIsLoading(true);

        try {
            const payload = {
                email: formData.email,
                telefono: formData.telefono
            };
            if (formData.password) {
                payload.password = formData.password;
            }

            const res = await api.put('/api/usuarios/me', payload);

            setMessage({ type: 'success', text: 'Perfil actualizado correctamente.' });
            setFormData(prev => ({ ...prev, password: '', confirmPassword: '' }));

            const updatedUser = res.data;
            setCurrentUser(prev => ({ ...prev, ...updatedUser }));

            const oldUser = JSON.parse(localStorage.getItem('user'));
            const newUser = { ...oldUser, ...updatedUser };
            localStorage.setItem('user', JSON.stringify(newUser));

        } catch (err) {
            console.error(err);
            setMessage({
                type: 'danger',
                text: err.response?.data?.message || 'Error al actualizar el perfil.'
            });
        } finally {
            setIsLoading(false);
        }
    };

    // Estilo para el botón del ojo (para que coincida con el borde del input según el tema)
    const eyeButtonStyle = {
        backgroundColor: 'transparent',
        borderLeft: 'none',
        borderColor: 'var(--border-color)', // Usa la variable del tema
        color: 'var(--text-muted)'
    };

    // Estilo para el input (para quitar el borde derecho y unirlo al botón)
    const inputStyle = {
        borderRight: 'none'
    };

    return (
        <Container fluid className="p-0">
            <h2 className="mb-4">MI PERFIL</h2>

            {message.text && (
                <Alert variant={message.type} onClose={() => setMessage({ type: '', text: '' })} dismissible>
                    {message.text}
                </Alert>
            )}

            <Row>
                <Col md={4} className="mb-4">
                    <Card className="h-100 shadow-sm border-0">
                        <Card.Body className="text-center py-5">
                            <div className="mb-4">
                                <PersonCircle size={100} className="text-secondary opacity-75" />
                            </div>

                            <h4 className="fw-bold mb-1">
                                {currentUser.nombres} {currentUser.apellidos}
                            </h4>
                            <p className="mb-3" style={{ color: 'var(--text-muted)' }}>
                                {currentUser.rol ? currentUser.rol.replace('ROLE_', '') : ''}
                            </p>

                            <hr className="my-4 opacity-25"/>

                            <div className="text-start px-3">
                                <div className="mb-3">
                                    <label className="small fw-bold text-uppercase" style={{ color: 'var(--text-muted)' }}>
                                        RUT (Identificador)
                                    </label>
                                    <div className="d-flex align-items-center gap-2 fs-5">
                                        <PersonVcard className="text-primary"/>
                                        <span>{currentUser.rut}</span>
                                    </div>
                                </div>

                                <div>
                                    <label className="small fw-bold text-uppercase" style={{ color: 'var(--text-muted)' }}>
                                        Rol en el sistema
                                    </label>
                                    <div className="d-flex align-items-center gap-2 fs-5">
                                        <ShieldLock className="text-primary"/>
                                        <span>{currentUser.rol}</span>
                                    </div>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                <Col md={8}>
                    <Card className="shadow-sm border-0 h-100">
                        <Card.Header className="bg-transparent py-3">
                            <h5 className="mb-0">Editar Información de Contacto</h5>
                        </Card.Header>
                        <Card.Body className="p-4">
                            <Form onSubmit={handleSubmit}>
                                <Row>
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label className="fw-bold">
                                                <Envelope className="me-2"/>Correo Electrónico
                                            </Form.Label>
                                            <Form.Control
                                                type="email"
                                                name="email"
                                                value={formData.email}
                                                onChange={handleInputChange}
                                                required
                                            />
                                        </Form.Group>
                                    </Col>
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label className="fw-bold">
                                                <Phone className="me-2"/>Teléfono
                                            </Form.Label>
                                            <Form.Control
                                                type="text"
                                                name="telefono"
                                                value={formData.telefono}
                                                onChange={handleInputChange}
                                                placeholder="+569..."
                                            />
                                        </Form.Group>
                                    </Col>
                                </Row>

                                <hr className="my-4 opacity-25"/>
                                <h6 className="text-primary mb-3 fw-bold">Seguridad (Cambiar Contraseña)</h6>

                                <Row>
                                    {/* --- CAMPO NUEVA CONTRASEÑA CON OJO --- */}
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label>Nueva Contraseña</Form.Label>
                                            <InputGroup>
                                                <Form.Control
                                                    type={showNewPass ? "text" : "password"}
                                                    name="password"
                                                    value={formData.password}
                                                    onChange={handleInputChange}
                                                    placeholder="Dejar en blanco para mantener"
                                                    style={inputStyle}
                                                />
                                                <Button
                                                    variant="outline-secondary"
                                                    onClick={() => setShowNewPass(!showNewPass)}
                                                    style={eyeButtonStyle}
                                                    tabIndex="-1"
                                                >
                                                    {showNewPass ? <EyeSlash/> : <Eye/>}
                                                </Button>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>

                                    {/* --- CAMPO CONFIRMAR CONTRASEÑA CON OJO --- */}
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label>Repetir Nueva Contraseña</Form.Label>
                                            <InputGroup>
                                                <Form.Control
                                                    type={showConfirmPass ? "text" : "password"}
                                                    name="confirmPassword"
                                                    value={formData.confirmPassword}
                                                    onChange={handleInputChange}
                                                    placeholder="Confirmar contraseña"
                                                    disabled={!formData.password}
                                                    style={inputStyle}
                                                />
                                                <Button
                                                    variant="outline-secondary"
                                                    onClick={() => setShowConfirmPass(!showConfirmPass)}
                                                    style={eyeButtonStyle}
                                                    disabled={!formData.password}
                                                    tabIndex="-1"
                                                >
                                                    {showConfirmPass ? <EyeSlash/> : <Eye/>}
                                                </Button>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>
                                </Row>

                                <div className="d-flex justify-content-end mt-4">
                                    <Button variant="primary" type="submit" size="lg" disabled={isLoading}>
                                        {isLoading ? <Spinner animation="border" size="sm"/> : <><Save className="me-2"/> Guardar Cambios</>}
                                    </Button>
                                </div>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default UserProfile;