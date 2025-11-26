import { useState, useEffect, useRef } from 'react';
import { Container, Row, Col, Card, Form, Button, Alert, Spinner, InputGroup } from 'react-bootstrap';
import { PersonCircle, Envelope, Phone, Lock, Save, PersonVcard, ShieldLock, Eye, EyeSlash, CameraFill } from 'react-bootstrap-icons';
import api from '../api/axios';

const UserProfile = () => {
    const [currentUser, setCurrentUser] = useState({
        nombres: '',
        apellidos: '',
        rut: '',
        rol: '',
        fotoBase64: null
    });

    const [formData, setFormData] = useState({
        email: '',
        telefono: '',
        password: '',
        confirmPassword: ''
    });

    const [showNewPass, setShowNewPass] = useState(false);
    const [showConfirmPass, setShowConfirmPass] = useState(false);

    const [isLoading, setIsLoading] = useState(false);
    const [message, setMessage] = useState({ type: '', text: '' });

    const fileInputRef = useRef(null);

    const fetchProfile = async () => {
        try {
            const res = await api.get('/api/usuarios/me');
            const user = res.data;

            setCurrentUser({
                nombres: user.nombres || '',
                apellidos: user.apellidos || '',
                rut: user.rut || '',
                rol: user.rol || 'USUARIO',
                fotoBase64: user.fotoBase64
            });

            setFormData(prev => ({
                ...prev,
                email: user.email || '',
                telefono: user.telefono || ''
            }));

            localStorage.setItem('user', JSON.stringify(user));
        } catch (err) {
            console.error("Error cargando perfil", err);
        }
    };

    useEffect(() => {
        fetchProfile();
    }, []);

    const handlePhotoUpload = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        if (file.size > 5 * 1024 * 1024) {
            setMessage({ type: 'danger', text: 'La imagen es muy pesada (Max 5MB).' });
            return;
        }

        const formData = new FormData();
        formData.append('archivo', file);

        try {
            await api.post('/api/usuarios/me/foto', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            await fetchProfile();
            setMessage({ type: 'success', text: 'Foto de perfil actualizada.' });
        } catch (err) {
            console.error(err);
            setMessage({ type: 'danger', text: 'Error al subir la imagen.' });
        }
    };

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
            const payload = { email: formData.email, telefono: formData.telefono };
            if (formData.password) payload.password = formData.password;

            // --- CORRECCIÓN AQUÍ: Quitamos 'const res =' ---
            await api.put('/api/usuarios/me', payload);
            // -----------------------------------------------

            setMessage({ type: 'success', text: 'Perfil actualizado correctamente.' });
            setFormData(prev => ({ ...prev, password: '', confirmPassword: '' }));

            await fetchProfile();

        } catch (err) {
            console.error(err);
            setMessage({ type: 'danger', text: err.response?.data?.message || 'Error al actualizar.' });
        } finally {
            setIsLoading(false);
        }
    };

    // --- FUNCIÓN DE TRADUCCIÓN DE ROLES ---
    const getRoleLabel = (rol) => {
        switch (rol) {
            case 'ROLE_ADMIN': return 'Administrador';
            case 'ROLE_MEDICO': return 'Médico';
            case 'ROLE_INVESTIGADOR': return 'Investigador';
            case 'ROLE_ESTUDIANTE': return 'Estudiante';
            case 'ROLE_VISUALIZADOR': return 'Visualizador';
            default: return rol ? rol.replace('ROLE_', '') : '';
        }
    };

    const eyeButtonStyle = { backgroundColor: 'transparent', borderLeft: 'none', borderColor: 'var(--border-color)', color: 'var(--text-muted)' };
    const inputStyle = { borderRight: 'none' };

    return (
        <Container fluid className="p-0">
            <h2 className="mb-4">MI PERFIL</h2>

            {message.text && <Alert variant={message.type} onClose={() => setMessage({ type: '', text: '' })} dismissible>{message.text}</Alert>}

            <Row>
                <Col md={4} className="mb-4">
                    <Card className="h-100 shadow-sm border-0">
                        <Card.Body className="text-center py-5">

                            <div className="position-relative d-inline-block mb-4">
                                <div
                                    className="rounded-circle overflow-hidden d-flex align-items-center justify-content-center bg-light"
                                    style={{ width: '120px', height: '120px', border: '4px solid var(--bg-main)' }}
                                >
                                    {currentUser.fotoBase64 ? (
                                        <img
                                            src={`data:image/jpeg;base64,${currentUser.fotoBase64}`}
                                            alt="Perfil"
                                            style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                                        />
                                    ) : (
                                        <PersonCircle size={120} className="text-secondary opacity-50" />
                                    )}
                                </div>

                                <div
                                    className="position-absolute bottom-0 end-0 bg-primary text-white rounded-circle p-2 shadow-sm"
                                    style={{ cursor: 'pointer', width: '35px', height: '35px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
                                    onClick={() => fileInputRef.current.click()}
                                    title="Cambiar foto"
                                >
                                    <CameraFill size={16} />
                                </div>
                                <input
                                    type="file"
                                    ref={fileInputRef}
                                    style={{ display: 'none' }}
                                    accept="image/*"
                                    onChange={handlePhotoUpload}
                                />
                            </div>

                            <h4 className="fw-bold mb-1">{currentUser.nombres} {currentUser.apellidos}</h4>

                            <p className="mb-3" style={{ color: 'var(--text-muted)' }}>
                                {getRoleLabel(currentUser.rol)}
                            </p>

                            <hr className="my-4 opacity-25"/>

                            <div className="text-start px-3">
                                <div className="mb-3">
                                    <label className="small fw-bold text-uppercase" style={{ color: 'var(--text-muted)' }}>RUT (Identificador)</label>
                                    <div className="d-flex align-items-center gap-2 fs-5"><PersonVcard className="text-primary"/><span>{currentUser.rut}</span></div>
                                </div>
                                <div>
                                    <label className="small fw-bold text-uppercase" style={{ color: 'var(--text-muted)' }}>Rol en el sistema</label>
                                    <div className="d-flex align-items-center gap-2 fs-5">
                                        <ShieldLock className="text-primary"/>
                                        <span>{getRoleLabel(currentUser.rol)}</span>
                                    </div>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                <Col md={8}>
                    <Card className="shadow-sm border-0 h-100">
                        <Card.Header className="bg-transparent py-3"><h5 className="mb-0">Editar Información de Contacto</h5></Card.Header>
                        <Card.Body className="p-4">
                            <Form onSubmit={handleSubmit}>
                                <Row>
                                    <Col md={6}><Form.Group className="mb-3"><Form.Label className="fw-bold"><Envelope className="me-2"/>Correo Electrónico</Form.Label><Form.Control type="email" name="email" value={formData.email} onChange={handleInputChange} required /></Form.Group></Col>
                                    <Col md={6}><Form.Group className="mb-3"><Form.Label className="fw-bold"><Phone className="me-2"/>Teléfono</Form.Label><Form.Control type="text" name="telefono" value={formData.telefono} onChange={handleInputChange} placeholder="+569..." /></Form.Group></Col>
                                </Row>
                                <hr className="my-4 opacity-25"/>
                                <h6 className="text-primary mb-3 fw-bold">Seguridad (Cambiar Contraseña)</h6>
                                <Row>
                                    <Col md={6}>
                                        <Form.Group className="mb-3"><Form.Label>Nueva Contraseña</Form.Label>
                                            <InputGroup>
                                                <Form.Control type={showNewPass ? "text" : "password"} name="password" value={formData.password} onChange={handleInputChange} placeholder="Dejar en blanco para mantener" style={inputStyle}/>
                                                <Button variant="outline-secondary" onClick={() => setShowNewPass(!showNewPass)} style={eyeButtonStyle} tabIndex="-1">{showNewPass ? <EyeSlash/> : <Eye/>}</Button>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>
                                    <Col md={6}>
                                        <Form.Group className="mb-3"><Form.Label>Repetir Nueva Contraseña</Form.Label>
                                            <InputGroup>
                                                <Form.Control type={showConfirmPass ? "text" : "password"} name="confirmPassword" value={formData.confirmPassword} onChange={handleInputChange} placeholder="Confirmar contraseña" disabled={!formData.password} style={inputStyle}/>
                                                <Button variant="outline-secondary" onClick={() => setShowConfirmPass(!showConfirmPass)} style={eyeButtonStyle} disabled={!formData.password} tabIndex="-1">{showConfirmPass ? <EyeSlash/> : <Eye/>}</Button>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>
                                </Row>
                                <div className="d-flex justify-content-end mt-4"><Button variant="primary" type="submit" size="lg" disabled={isLoading}>{isLoading ? <Spinner animation="border" size="sm"/> : <><Save className="me-2"/> Guardar Cambios</>}</Button></div>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default UserProfile;