import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Badge, Spinner, Alert, Button, Tooltip, OverlayTrigger, Form, InputGroup } from 'react-bootstrap';
import { PersonCircle, Envelope, Phone, ArrowLeft, Clipboard, Check, PersonVcard, ShieldLock, HeartPulse, Search, Book, Eye, Person } from 'react-bootstrap-icons';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../api/axios';
import { formatRut } from '../utils/rutUtils';
import { COUNTRY_PHONE_DATA } from '../utils/phoneUtils';

const UserDetails = () => {
    const { id } = useParams();
    const navigate = useNavigate();

    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [copiedField, setCopiedField] = useState(null);

    // --- UTILS ---
    const getRoleLabel = (rol) => {
        const iconMap = {
            'ROLE_ADMIN': ShieldLock,
            'ROLE_MEDICO': HeartPulse,
            'ROLE_INVESTIGADOR': Search,
            'ROLE_ESTUDIANTE': Book,
            'ROLE_VISUALIZADOR': Eye
        };
        const IconComponent = iconMap[rol] || Person;

        switch (rol) {
            case 'ROLE_ADMIN': return { label: 'Administrador', colorVar: 'var(--role-admin-bg)', icon: IconComponent };
            case 'ROLE_MEDICO': return { label: 'Médico', colorVar: 'var(--role-medico-bg)', icon: IconComponent };
            case 'ROLE_INVESTIGADOR': return { label: 'Investigador', colorVar: 'var(--role-investigador-bg)', icon: IconComponent };
            case 'ROLE_ESTUDIANTE': return { label: 'Estudiante', colorVar: 'var(--role-estudiante-bg)', icon: IconComponent };
            case 'ROLE_VISUALIZADOR': return { label: 'Visualizador', colorVar: 'var(--role-visualizador-bg)', icon: IconComponent };
            default: return { label: rol ? rol.replace('ROLE_', '') : 'Usuario', colorVar: 'var(--role-visualizador-bg)', icon: IconComponent };
        }
    };

    const formatPhone = (rawPhone) => {
        if (!rawPhone) return 'No registrado';
        const sortedCodes = [...COUNTRY_PHONE_DATA].sort((a, b) => b.code.length - a.code.length);
        const foundCode = sortedCodes.find(c => rawPhone.startsWith(c.code));
        if (foundCode) {
            const number = rawPhone.replace(foundCode.code, '');
            return `${foundCode.code} ${number}`;
        }
        return rawPhone;
    };

    const copyToClipboard = (text, field) => {
        if (!text || text === 'No registrado') return;
        navigator.clipboard.writeText(text);
        setCopiedField(field);
        setTimeout(() => setCopiedField(null), 2000);
    };

    useEffect(() => {
        const fetchUser = async () => {
            try {
                const res = await api.get(`/api/usuarios/${id}`);
                setUser(res.data);
            } catch (err) {
                console.error("Error cargando usuario", err);
                setError("No se pudo cargar la información del usuario.");
            } finally {
                setLoading(false);
            }
        };
        if (id) fetchUser();
    }, [id]);

    if (loading) return <div className="text-center py-5"><Spinner animation="border" variant="primary"/></div>;

    if (error || !user) return (
        <Alert variant="danger" className="mb-4">
            {error || "Usuario no encontrado."}
            <div className="mt-2"><Button variant="outline-danger" size="sm" onClick={() => navigate(-1)}>Volver</Button></div>
        </Alert>
    );

    const roleInfo = getRoleLabel(user.rol || user.role);
    const RoleIcon = roleInfo.icon;

    return (
        <Container fluid className="p-0">
            {/* HEADER */}
            <div className="d-flex align-items-center gap-3 mb-4">
                <Button variant="link" className="p-0 text-secondary" onClick={() => navigate(-1)} title="Volver">
                    <ArrowLeft size={28}/>
                </Button>
                <h2 className="mb-0 fw-bold" style={{color: 'var(--text-main)'}}>Detalles del Usuario</h2>
            </div>

            <Row className="g-4">
                {/* COLUMNA IZQUIERDA: TARJETA DE IDENTIDAD */}
                {/* CAMBIO AQUÍ: Aumenté el ancho a md={5} lg={4} para dar más espacio al nombre */}
                <Col md={5} lg={4}>
                    <Card className="h-100 shadow-sm border-0" style={{ backgroundColor: 'var(--bg-card)' }}>
                        <Card.Body className="text-center p-4 d-flex flex-column align-items-center justify-content-center">

                            {/* FOTO DE PERFIL */}
                            <div className="mb-4 position-relative">
                                <div className="rounded-circle overflow-hidden d-flex align-items-center justify-content-center mx-auto shadow-sm"
                                     style={{
                                         width: '150px',
                                         height: '150px',
                                         border: `5px solid var(--bg-main)`,
                                         backgroundColor: 'var(--bg-input)'
                                     }}>
                                    {user.fotoBase64 ? (
                                        <img src={`data:image/jpeg;base64,${user.fotoBase64}`} alt="Perfil" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                                    ) : (
                                        <PersonCircle size={150} style={{ color: 'var(--text-main)', opacity: 0.3 }} />
                                    )}
                                </div>
                            </div>

                            {/* NOMBRE (Debajo de la foto) */}
                            <h4 className="fw-bold mb-3 text-center" style={{color: 'var(--text-main)'}}>
                                {user.nombres} {user.apellidos}
                            </h4>

                            {/* Badge de Rol */}
                            <div className="mb-4">
                                <Badge
                                    className="px-3 py-2 rounded-pill text-uppercase d-inline-flex align-items-center gap-2 shadow-sm"
                                    style={{
                                        backgroundColor: roleInfo.colorVar,
                                        color: 'var(--role-text-color)',
                                        letterSpacing: '1px',
                                        fontWeight: '600'
                                    }}
                                >
                                    <RoleIcon size={16}/>
                                    {roleInfo.label}
                                </Badge>
                            </div>

                            {/* RUT */}
                            <div className="d-inline-flex align-items-center gap-2 px-3 py-2 rounded-pill border" style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                <PersonVcard className="text-primary"/>
                                <span className="fw-medium" style={{ color: 'var(--text-main)' }}>
                                    {user.rut ? formatRut(user.rut) : 'Sin RUT'}
                                </span>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                {/* COLUMNA DERECHA: INFORMACIÓN DE CONTACTO */}
                {/* CAMBIO AQUÍ: Reduje el ancho a md={7} lg={8} para compensar */}
                <Col md={7} lg={8}>
                    <Card className="shadow-sm border-0 h-100" style={{ backgroundColor: 'var(--bg-card)' }}>
                        <Card.Header className="py-3 bg-transparent border-bottom" style={{ borderColor: 'var(--border-color)' }}>
                            <h5 className="mb-0 fw-bold" style={{color: 'var(--text-main)'}}>Información de Contacto</h5>
                        </Card.Header>
                        <Card.Body className="p-4">
                            <Form>
                                <Row className="g-4">
                                    {/* Correo Electrónico (Arriba) */}
                                    <Col md={12}>
                                        <Form.Group>
                                            <Form.Label className="small text-muted text-uppercase fw-bold">Correo Electrónico</Form.Label>
                                            <InputGroup>
                                                <InputGroup.Text style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                                    <Envelope className="text-primary"/>
                                                </InputGroup.Text>
                                                <Form.Control
                                                    type="text"
                                                    value={user.email || 'No registrado'}
                                                    readOnly
                                                    style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)', color: 'var(--text-main)' }}
                                                />
                                                <OverlayTrigger placement="top" overlay={<Tooltip>{copiedField === 'email' ? '¡Copiado!' : 'Copiar'}</Tooltip>}>
                                                    <Button variant="outline-secondary" onClick={() => copyToClipboard(user.email, 'email')} disabled={!user.email} style={{ borderColor: 'var(--border-color)' }}>
                                                        {copiedField === 'email' ? <Check className="text-success"/> : <Clipboard/>}
                                                    </Button>
                                                </OverlayTrigger>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>

                                    {/* Teléfono (Abajo) */}
                                    <Col md={12}>
                                        <Form.Group>
                                            <Form.Label className="small text-muted text-uppercase fw-bold">Teléfono</Form.Label>
                                            <InputGroup>
                                                <InputGroup.Text style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                                    <Phone className="text-success"/>
                                                </InputGroup.Text>
                                                <Form.Control
                                                    type="text"
                                                    value={formatPhone(user.telefono)}
                                                    readOnly
                                                    style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)', color: 'var(--text-main)' }}
                                                />
                                                <OverlayTrigger placement="top" overlay={<Tooltip>{copiedField === 'phone' ? '¡Copiado!' : 'Copiar'}</Tooltip>}>
                                                    <Button variant="outline-secondary" onClick={() => copyToClipboard(user.telefono, 'phone')} disabled={!user.telefono} style={{ borderColor: 'var(--border-color)' }}>
                                                        {copiedField === 'phone' ? <Check className="text-success"/> : <Clipboard/>}
                                                    </Button>
                                                </OverlayTrigger>
                                            </InputGroup>
                                        </Form.Group>
                                    </Col>
                                </Row>
                            </Form>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default UserDetails;