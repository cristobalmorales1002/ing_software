import React, { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Badge, Spinner, Alert, Button, Tooltip, OverlayTrigger } from 'react-bootstrap';
import { PersonCircle, Envelope, Phone, ArrowLeft, Clipboard, Check, PersonVcard } from 'react-bootstrap-icons';
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
        switch (rol) {
            case 'ROLE_ADMIN': return { label: 'Administrador', bg: 'danger', icon: 'shield-lock' };
            case 'ROLE_MEDICO': return { label: 'Médico', bg: 'primary', icon: 'heart-pulse' };
            case 'ROLE_INVESTIGADOR': return { label: 'Investigador', bg: 'info', icon: 'search' };
            case 'ROLE_ESTUDIANTE': return { label: 'Estudiante', bg: 'success', icon: 'book' };
            case 'ROLE_VISUALIZADOR': return { label: 'Visualizador', bg: 'secondary', icon: 'eye' };
            default: return { label: rol ? rol.replace('ROLE_', '') : 'Usuario', bg: 'secondary', icon: 'person' };
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

    return (
        <Container fluid className="p-0">
            {/* HEADER */}
            <div className="d-flex align-items-center gap-3 mb-4">
                <Button variant="link" className="p-0 text-secondary" onClick={() => navigate(-1)} title="Volver">
                    <ArrowLeft size={28}/>
                </Button>
                <h2 className="mb-0 fw-bold">PERFIL DE USUARIO</h2>
            </div>

            <Row className="g-4">
                {/* COLUMNA IZQUIERDA: TARJETA DE IDENTIDAD */}
                <Col md={4}>
                    <Card className="h-100 shadow-sm border-0 overflow-hidden">
                        {/* Fondo decorativo superior */}
                        <div className={`bg-${roleInfo.bg} bg-opacity-10`} style={{ height: '80px' }}></div>

                        <Card.Body className="text-center pt-0 position-relative">
                            {/* Foto de Perfil superpuesta */}
                            <div className="d-inline-block position-relative mb-3" style={{ marginTop: '-60px' }}>
                                <div className="rounded-circle overflow-hidden d-flex align-items-center justify-content-center bg-white mx-auto shadow-sm"
                                     style={{ width: '130px', height: '130px', border: `4px solid var(--bg-card)` }}> {/* Borde del color de la tarjeta para que se vea bien en dark mode */}
                                    {user.fotoBase64 ? (
                                        <img src={`data:image/jpeg;base64,${user.fotoBase64}`} alt="Perfil" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                                    ) : (
                                        <PersonCircle size={130} className={`text-${roleInfo.bg} opacity-75`} />
                                    )}
                                </div>
                            </div>

                            <h3 className="fw-bold mb-1" style={{color: 'var(--text-main)'}}>{user.nombres || user.nombre} {user.apellidos}</h3>

                            <div className="mb-4">
                                <Badge bg={roleInfo.bg} className="px-3 py-2 rounded-pill text-uppercase shadow-sm" style={{ letterSpacing: '1px', fontWeight: '500' }}>
                                    {roleInfo.label}
                                </Badge>
                            </div>

                            {/* AQUI ESTÁ EL CAMBIO: RUT EN VEZ DE ID */}
                            <div className="d-flex justify-content-center">
                                <div className="d-flex align-items-center gap-2 px-3 py-2 rounded-pill border" style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                    <PersonVcard className="text-primary"/>
                                    <span className="fw-bold small" style={{ color: 'var(--text-main)' }}>
                                        {user.rut ? formatRut(user.rut) : 'Sin RUT'}
                                    </span>
                                </div>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                {/* COLUMNA DERECHA: CONTACTO (Diseño original mantenido) */}
                <Col md={8}>
                    <Card className="shadow-sm border-0 h-100">
                        <Card.Header className="py-3 border-bottom-0" style={{backgroundColor: 'var(--hover-bg)'}}>
                            <h5 className="mb-0 fw-bold" style={{color: 'var(--text-main)'}}>Información de Contacto</h5>
                        </Card.Header>
                        <Card.Body className="pt-4 pb-4 px-4 d-flex flex-column gap-4">

                            {/* EMAIL SECTION */}
                            <div className="p-3 border rounded transition-hover" style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                <div className="d-flex justify-content-between align-items-center mb-2">
                                    <div className="d-flex align-items-center gap-2">
                                        <Envelope className="text-primary fs-5"/>
                                        <span className="fw-bold text-uppercase small" style={{color: 'var(--text-muted)'}}>Correo Electrónico</span>
                                    </div>
                                </div>

                                <div className="d-flex align-items-center justify-content-between border rounded p-2 ps-3" style={{ backgroundColor: 'var(--bg-card)', borderColor: 'var(--border-color)' }}>
                                    <span className={`text-break fw-medium ${!user.email ? 'text-muted fst-italic' : ''}`} style={{ color: 'var(--text-main)' }}>
                                        {user.email || 'No registrado'}
                                    </span>

                                    <OverlayTrigger
                                        placement="top"
                                        overlay={<Tooltip>{copiedField === 'email' ? '¡Copiado!' : 'Copiar correo'}</Tooltip>}
                                    >
                                        <Button
                                            variant={copiedField === 'email' ? 'success' : 'outline-secondary'}
                                            size="sm"
                                            className="border-0 ms-2"
                                            onClick={() => copyToClipboard(user.email, 'email')}
                                            disabled={!user.email}
                                        >
                                            {copiedField === 'email' ? <Check size={20}/> : <Clipboard size={18}/>}
                                        </Button>
                                    </OverlayTrigger>
                                </div>
                            </div>

                            {/* PHONE SECTION */}
                            <div className="p-3 border rounded transition-hover" style={{ backgroundColor: 'var(--bg-input)', borderColor: 'var(--border-color)' }}>
                                <div className="d-flex justify-content-between align-items-center mb-2">
                                    <div className="d-flex align-items-center gap-2">
                                        <Phone className="text-success fs-5"/>
                                        <span className="fw-bold text-uppercase small" style={{color: 'var(--text-muted)'}}>Teléfono</span>
                                    </div>
                                </div>

                                <div className="d-flex align-items-center justify-content-between border rounded p-2 ps-3" style={{ backgroundColor: 'var(--bg-card)', borderColor: 'var(--border-color)' }}>
                                    <span className={`fw-medium ${!user.telefono ? 'text-muted fst-italic' : ''}`} style={{ color: 'var(--text-main)' }}>
                                        {formatPhone(user.telefono)}
                                    </span>

                                    <OverlayTrigger
                                        placement="top"
                                        overlay={<Tooltip>{copiedField === 'phone' ? '¡Copiado!' : 'Copiar teléfono'}</Tooltip>}
                                    >
                                        <Button
                                            variant={copiedField === 'phone' ? 'success' : 'outline-secondary'}
                                            size="sm"
                                            className="border-0 ms-2"
                                            onClick={() => copyToClipboard(user.telefono, 'phone')}
                                            disabled={!user.telefono}
                                        >
                                            {copiedField === 'phone' ? <Check size={20}/> : <Clipboard size={18}/>}
                                        </Button>
                                    </OverlayTrigger>
                                </div>
                            </div>

                        </Card.Body>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
};

export default UserDetails;