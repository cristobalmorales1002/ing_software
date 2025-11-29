import { useState, useEffect, useRef } from 'react';
import { Container, Row, Col, Card, Form, Button, Alert, Spinner, InputGroup, Modal } from 'react-bootstrap';
import { PersonCircle, Envelope, Phone, Save, PersonVcard, ShieldLock, Eye, EyeSlash, CameraFill, PencilSquare, CheckCircle } from 'react-bootstrap-icons';
import api from '../api/axios';

// Lista de códigos de países comunes
const COUNTRY_CODES = [
    { code: '+56', label: '🇨🇱 Chile (+56)' },
    { code: '+54', label: '🇦🇷 Arg (+54)' },
    { code: '+51', label: '🇵🇪 Perú (+51)' },
    { code: '+591', label: '🇧🇴 Bol (+591)' },
    { code: '+55', label: '🇧🇷 Bra (+55)' },
    { code: '+57', label: '🇨🇴 Col (+57)' },
    { code: '+1', label: '🇺🇸 USA (+1)' },
    { code: '+34', label: '🇪🇸 Esp (+34)' },
];

const UserProfile = () => {
    const [currentUser, setCurrentUser] = useState({
        nombres: '',
        apellidos: '',
        rut: '',
        rol: '',
        fotoBase64: null,
        email: ''
    });

    // Estado separado para el teléfono (Visualmente separado)
    const [phoneData, setPhoneData] = useState({
        code: '+56', // Por defecto Chile
        number: ''
    });

    // Formulario de contraseñas
    const [formData, setFormData] = useState({
        password: '',
        confirmPassword: ''
    });

    // --- ESTADOS PARA CAMBIO DE EMAIL ---
    const [showEmailModal, setShowEmailModal] = useState(false);
    const [emailStep, setEmailStep] = useState(1);
    const [newEmailData, setNewEmailData] = useState({
        newEmail: '',
        currentPassword: '',
        token: ''
    });
    const [emailLoading, setEmailLoading] = useState(false);
    const [emailMsg, setEmailMsg] = useState({ type: '', text: '' });

    // Estados Generales UI
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
                fotoBase64: user.fotoBase64,
                email: user.email || ''
            });

            // LÓGICA PARA DETECTAR CÓDIGO DE PAÍS
            if (user.telefono) {
                // Buscamos si el teléfono guardado empieza con alguno de nuestros códigos
                const foundCode = COUNTRY_CODES.find(c => user.telefono.startsWith(c.code));
                if (foundCode) {
                    setPhoneData({
                        code: foundCode.code,
                        number: user.telefono.replace(foundCode.code, '') // Quitamos el código para dejar solo el número
                    });
                } else {
                    // Si no coincide con ninguno conocido, lo dejamos todo en el número (o default)
                    setPhoneData({ code: '+56', number: user.telefono });
                }
            } else {
                // Si no tiene teléfono, limpieza
                setPhoneData({ code: '+56', number: '' });
            }

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

    // Handler específico para el número (solo permitir dígitos)
    const handlePhoneChange = (e) => {
        const val = e.target.value;
        // Solo permitir números
        if (/^\d*$/.test(val)) {
            setPhoneData({ ...phoneData, number: val });
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage({ type: '', text: '' });

        // 1. VALIDACIÓN DE CONTRASEÑAS
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

        // 2. VALIDACIÓN DE TELÉFONO
        let finalPhone = '';
        if (phoneData.number) {
            if (phoneData.number.length < 8 || phoneData.number.length > 15) {
                setMessage({ type: 'danger', text: 'El número de teléfono parece inválido (largo incorrecto).' });
                return;
            }
            // Concatenamos Código + Número para enviar al backend
            finalPhone = phoneData.code + phoneData.number;
        }

        setIsLoading(true);

        try {
            const payload = { telefono: finalPhone }; // Enviamos el teléfono unido
            if (formData.password) payload.password = formData.password;

            await api.put('/api/usuarios/me', payload);

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

    // ... (Resto de lógica Modal Email se mantiene igual) ...
    const openEmailModal = () => {
        setEmailStep(1);
        setNewEmailData({ newEmail: '', currentPassword: '', token: '' });
        setEmailMsg({ type: '', text: '' });
        setShowEmailModal(true);
    };

    const handleEmailRequest = async () => {
        if(!newEmailData.newEmail || !newEmailData.currentPassword) {
            setEmailMsg({ type: 'danger', text: 'Complete todos los campos.' });
            return;
        }
        setEmailLoading(true);
        setEmailMsg({ type: '', text: '' });

        try {
            await api.post('/api/usuarios/me/email/solicitar', {
                nuevoEmail: newEmailData.newEmail,
                password: newEmailData.currentPassword
            });
            setEmailStep(2);
            setEmailMsg({ type: 'success', text: `Código enviado a ${newEmailData.newEmail}` });
        } catch (err) {
            const errorText = typeof err.response?.data === 'string' ? err.response.data : 'Error al solicitar cambio.';
            setEmailMsg({ type: 'danger', text: errorText });
        } finally {
            setEmailLoading(false);
        }
    };

    const handleEmailConfirm = async () => {
        if(!newEmailData.token) {
            setEmailMsg({ type: 'danger', text: 'Ingrese el código de verificación.' });
            return;
        }
        setEmailLoading(true);
        try {
            await api.put('/api/usuarios/me/email/confirmar', {
                token: newEmailData.token,
                nuevoEmail: newEmailData.newEmail
            });
            setShowEmailModal(false);
            setMessage({ type: 'success', text: 'Correo electrónico actualizado exitosamente.' });
            fetchProfile();
        } catch (err) {
            setEmailMsg({ type: 'danger', text: err.response?.data?.message || 'Código inválido.' });
        } finally {
            setEmailLoading(false);
        }
    };

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
                {/* TARJETA INFO USUARIO */}
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
                            <p className="mb-3" style={{ color: 'var(--text-muted)' }}>{getRoleLabel(currentUser.rol)}</p>
                            <hr className="my-4 opacity-25"/>
                            <div className="text-start px-3">
                                <div className="mb-3">
                                    <label className="small fw-bold text-uppercase" style={{ color: 'var(--text-muted)' }}>RUT</label>
                                    <div className="d-flex align-items-center gap-2 fs-5"><PersonVcard className="text-primary"/><span>{currentUser.rut}</span></div>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                {/* FORMULARIO DE EDICIÓN */}
                <Col md={8}>
                    <Card className="shadow-sm border-0 h-100">
                        <Card.Header className="bg-transparent py-3"><h5 className="mb-0">Editar Información</h5></Card.Header>
                        <Card.Body className="p-4">
                            <Form onSubmit={handleSubmit}>
                                <Row>
                                    {/* CORREO ELECTRÓNICO */}
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label className="fw-bold"><Envelope className="me-2"/>Correo Electrónico</Form.Label>
                                            <InputGroup>
                                                <Form.Control
                                                    type="email"
                                                    value={currentUser.email}
                                                    disabled
                                                    style={{backgroundColor: 'var(--hover-bg)'}}
                                                />
                                                <Button variant="outline-primary" onClick={openEmailModal}>
                                                    <PencilSquare /> Cambiar
                                                </Button>
                                            </InputGroup>
                                            <Form.Text className="text-muted">Para cambiarlo se requiere verificación.</Form.Text>
                                        </Form.Group>
                                    </Col>

                                    {/* --- TELÉFONO MEJORADO (SELECTOR DE PAÍS) --- */}
                                    <Col md={6}>
                                        <Form.Group className="mb-3">
                                            <Form.Label className="fw-bold"><Phone className="me-2"/>Teléfono</Form.Label>
                                            <InputGroup>
                                                {/* SELECTOR DE CÓDIGO */}
                                                <Form.Select
                                                    value={phoneData.code}
                                                    onChange={(e) => setPhoneData({ ...phoneData, code: e.target.value })}
                                                    style={{ maxWidth: '130px', borderRight: 'none', backgroundColor: 'var(--bg-input)', color: 'var(--text-main)' }}
                                                >
                                                    {COUNTRY_CODES.map((country) => (
                                                        <option key={country.code} value={country.code}>
                                                            {country.label}
                                                        </option>
                                                    ))}
                                                </Form.Select>

                                                {/* INPUT DE NÚMERO */}
                                                <Form.Control
                                                    type="text"
                                                    placeholder="912345678"
                                                    value={phoneData.number}
                                                    onChange={handlePhoneChange}
                                                    maxLength={15}
                                                    style={{ borderLeft: '1px solid var(--border-color)' }}
                                                />
                                            </InputGroup>
                                            <Form.Text className="text-muted">Solo números, sin espacios.</Form.Text>
                                        </Form.Group>
                                    </Col>
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

            {/* --- MODAL DE CAMBIO DE EMAIL (Sin cambios) --- */}
            <Modal show={showEmailModal} onHide={() => setShowEmailModal(false)} backdrop="static" centered>
                <Modal.Header closeButton>
                    <Modal.Title>Cambiar Correo Electrónico</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    {emailMsg.text && <Alert variant={emailMsg.type} className="mb-3 small">{emailMsg.text}</Alert>}

                    {emailStep === 1 ? (
                        <>
                            <p className="small text-muted">Ingrese su nuevo correo y su contraseña actual para verificar su identidad.</p>
                            <Form.Group className="mb-3">
                                <Form.Label>Nuevo Correo</Form.Label>
                                <Form.Control
                                    type="email"
                                    placeholder="nuevo@ejemplo.com"
                                    value={newEmailData.newEmail}
                                    onChange={e => setNewEmailData({...newEmailData, newEmail: e.target.value})}
                                />
                            </Form.Group>
                            <Form.Group className="mb-3">
                                <Form.Label>Contraseña Actual</Form.Label>
                                <Form.Control
                                    type="password"
                                    placeholder="********"
                                    value={newEmailData.currentPassword}
                                    onChange={e => setNewEmailData({...newEmailData, currentPassword: e.target.value})}
                                />
                            </Form.Group>
                        </>
                    ) : (
                        <>
                            <div className="text-center mb-4">
                                <CheckCircle size={40} className="text-success mb-2"/>
                                <p className="small text-muted">Hemos enviado un código de 6 dígitos a <strong>{newEmailData.newEmail}</strong>.</p>
                            </div>
                            <Form.Group className="mb-3">
                                <Form.Label className="fw-bold text-center w-100">Código de Verificación</Form.Label>
                                <Form.Control
                                    type="text"
                                    className="text-center fs-4 letter-spacing-2"
                                    maxLength={6}
                                    placeholder="000000"
                                    value={newEmailData.token}
                                    onChange={e => setNewEmailData({...newEmailData, token: e.target.value.replace(/\D/g,'')})}
                                />
                            </Form.Group>
                        </>
                    )}
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowEmailModal(false)}>Cancelar</Button>
                    {emailStep === 1 ? (
                        <Button variant="primary" onClick={handleEmailRequest} disabled={emailLoading}>
                            {emailLoading ? <Spinner size="sm" animation="border"/> : 'Enviar Código'}
                        </Button>
                    ) : (
                        <Button variant="success" onClick={handleEmailConfirm} disabled={emailLoading}>
                            {emailLoading ? <Spinner size="sm" animation="border"/> : 'Confirmar Cambio'}
                        </Button>
                    )}
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default UserProfile;