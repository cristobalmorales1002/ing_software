import { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Form, Button, Alert, Spinner } from 'react-bootstrap';
import { PersonCircle, Envelope, Phone, Lock, Save, PersonVcard, ShieldLock } from 'react-bootstrap-icons';
import api from '../api/axios';

const UserProfile = () => {
    // 1. Estado del Usuario (Datos de lectura)
    const [currentUser, setCurrentUser] = useState({
        nombres: '',
        apellidos: '',
        rut: '',
        rol: ''
    });

    // 2. Estado del Formulario (Datos de edición)
    const [formData, setFormData] = useState({
        email: '',
        telefono: '',
        password: '',
        confirmPassword: ''
    });

    const [isLoading, setIsLoading] = useState(false);
    const [message, setMessage] = useState({ type: '', text: '' });

    // Cargar datos iniciales
    useEffect(() => {
        const userStr = localStorage.getItem('user');
        if (userStr) {
            const user = JSON.parse(userStr);

            // Llenamos datos de solo lectura
            setCurrentUser({
                nombres: user.nombres || '',
                apellidos: user.apellidos || '',
                rut: user.rut || '',
                rol: user.rol || 'USUARIO'
            });

            // Llenamos el formulario editable
            setFormData(prev => ({
                ...prev,
                email: user.email || '',
                telefono: user.telefono || ''
            }));
        }
    }, []);

    const handleInputChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage({ type: '', text: '' });

        // Validaciones
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

            // Actualizar localStorage
            const oldUser = JSON.parse(localStorage.getItem('user'));
            const newUser = {
                ...oldUser,
                email: res.data.email,
                telefono: res.data.telefono
            };
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

    return (
        <Container fluid className="p-0">
            <h2 className="mb-4">MI PERFIL</h2>

            {message.text && (
                <Alert variant={message.type} onClose={() => setMessage({ type: '', text: '' })} dismissible>
                    {message.text}
                </Alert>
            )}

            <Row>
                {/* --- COLUMNA IZQUIERDA: DATOS FIJOS (Solo Lectura) --- */}
                <Col md={4} className="mb-4">
                    <Card className="h-100 shadow-sm border-0">
                        <Card.Body className="text-center py-5">
                            <div className="mb-4">
                                <PersonCircle size={100} className="text-secondary opacity-75" />
                            </div>

                            <h4 className="fw-bold mb-1">
                                {currentUser.nombres} {currentUser.apellidos}
                            </h4>
                            <p className="text-muted mb-3">
                                {currentUser.rol.replace('ROLE_', '')}
                            </p>

                            <hr className="my-4 opacity-25"/>

                            {/* Sección de Datos Fijos */}
                            <div className="text-start px-3">
                                <div className="mb-3">
                                    <label className="small text-muted fw-bold text-uppercase">RUT (Identificador)</label>
                                    <div className="d-flex align-items-center gap-2 fs-5">
                                        <PersonVcard className="text-primary"/>
                                        <span>{currentUser.rut}</span>
                                    </div>
                                </div>

                                <div>
                                    <label className="small text-muted fw-bold text-uppercase">Rol en el sistema</label>
                                    <div className="d-flex align-items-center gap-2 fs-5">
                                        <ShieldLock className="text-primary"/>
                                        <span>{currentUser.rol}</span>
                                    </div>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                {/* --- COLUMNA DERECHA: FORMULARIO EDITABLE --- */}
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
                                            {/* Quitamos className="text-white" para que se adapte al tema */}
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
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label>Nueva Contraseña</Form.Label>
                                            <Form.Control
                                                type="password"
                                                name="password"
                                                value={formData.password}
                                                onChange={handleInputChange}
                                                placeholder="Dejar en blanco para mantener la actual"
                                            />
                                        </Form.Group>
                                    </Col>
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label>Repetir Nueva Contraseña</Form.Label>
                                            <Form.Control
                                                type="password"
                                                name="confirmPassword"
                                                value={formData.confirmPassword}
                                                onChange={handleInputChange}
                                                placeholder="Confirmar contraseña"
                                                disabled={!formData.password}
                                            />
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