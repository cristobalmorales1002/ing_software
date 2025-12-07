import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Container, Row, Col, ListGroup, Badge, Button, Form, Modal, InputGroup, Spinner, Toast, ToastContainer } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import {
    Send, Inbox, Search, PlusLg, PersonCircle, Trash, Reply, X, ArrowCounterclockwise, CheckCircle, ExclamationCircle
} from 'react-bootstrap-icons';
import api from '../api/axios';
import DateRangeFilter from '../components/DateRangeFilter';

const Messages = () => {
    const [activeTab, setActiveTab] = useState('inbox');
    const [messages, setMessages] = useState([]);
    const [isLoading, setIsLoading] = useState(false);

    const [searchTerm, setSearchTerm] = useState('');
    const [dateFilters, setDateFilters] = useState({ inicio: '', fin: '' });

    const [unreadCount, setUnreadCount] = useState(0);
    const [currentUser, setCurrentUser] = useState(null);

    const [showCompose, setShowCompose] = useState(false);
    const [showRead, setShowRead] = useState(false);
    const [selectedMessage, setSelectedMessage] = useState(null);

    const [recipientQuery, setRecipientQuery] = useState('');
    const [availableUsers, setAvailableUsers] = useState([]);
    const [selectedRecipients, setSelectedRecipients] = useState([]);
    const [newMessage, setNewMessage] = useState({ subject: '', body: '' });
    const [isSending, setIsSending] = useState(false);

    const [toastConfig, setToastConfig] = useState({
        show: false,
        message: '',
        variant: 'success'
    });

    const searchInputRef = useRef(null);

    const formatRole = (rawRole) => {
        if (!rawRole) return 'Usuario';
        const map = {
            'ROLE_ADMIN': 'Administrador',
            'ROLE_MEDICO': 'Médico',
            'ROLE_INVESTIGADOR': 'Investigador',
            'ROLE_ESTUDIANTE': 'Estudiante',
            'ROLE_USER': 'Usuario',
            'ROLE_VISUALIZADOR': 'Visualizador'
        };
        return map[rawRole] || rawRole.replace('ROLE_', '').charAt(0).toUpperCase() + rawRole.replace('ROLE_', '').slice(1).toLowerCase();
    };

    const showNotification = (message, variant = 'success') => {
        setToastConfig({ show: true, message, variant });
    };

    useEffect(() => {
        const fetchUserData = async () => {
            try {
                const [resMe, resUsers] = await Promise.all([
                    api.get('/api/usuarios/me'),
                    api.get('/api/usuarios')
                ]);
                setCurrentUser(resMe.data);
                setAvailableUsers(resUsers.data);
            } catch (error) {
                console.error("Error obteniendo datos de usuario", error);
            }
        };
        fetchUserData();
    }, []);

    const fetchMessages = useCallback(async () => {
        setIsLoading(true);
        try {
            const endpoint = activeTab === 'inbox' ? '/api/mensajes/entrada' : '/api/mensajes/enviados';
            const res = await api.get(endpoint);
            setMessages(res.data);
        } catch (error) {
            console.error("Error cargando mensajes", error);
            setMessages([]);
        } finally {
            setIsLoading(false);
        }
    }, [activeTab]);

    const fetchUnreadCount = useCallback(async () => {
        try {
            const res = await api.get('/api/mensajes/noleidos/cantidad');
            setUnreadCount(res.data);
        } catch (error) {
            console.error(error);
        }
    }, []);

    const clearFilters = useCallback(() => {
        setDateFilters({ inicio: '', fin: '' });
        setSearchTerm('');
    }, []);

    useEffect(() => {
        fetchMessages();
        fetchUnreadCount();
        clearFilters();
    }, [activeTab, fetchMessages, fetchUnreadCount, clearFilters]);

    const handleDateRangeChange = (newRange) => {
        setDateFilters(newRange);
    };

    const filteredMessages = messages.filter(msg => {
        const searchLower = searchTerm.toLowerCase();
        const sender = msg.nombreEmisor || '';
        const receiver = msg.destinatariosResumen || msg.nombreDestinatario || '';
        const subject = msg.asunto || '';

        const matchesText = subject.toLowerCase().includes(searchLower) ||
            sender.toLowerCase().includes(searchLower) ||
            receiver.toLowerCase().includes(searchLower);

        let matchesDate = true;
        if (dateFilters.inicio || dateFilters.fin) {
            const msgDate = new Date(msg.fechaEnvio);
            msgDate.setHours(0, 0, 0, 0);

            if (dateFilters.inicio) {
                const startDate = new Date(dateFilters.inicio + 'T00:00:00');
                if (msgDate < startDate) matchesDate = false;
            }
            if (matchesDate && dateFilters.fin) {
                const endDate = new Date(dateFilters.fin + 'T00:00:00');
                if (msgDate > endDate) matchesDate = false;
            }
        }
        return matchesText && matchesDate;
    });

    const getSuggestions = () => {
        if (!recipientQuery) return [];
        const lowerQuery = recipientQuery.toLowerCase();
        const currentUserId = currentUser?.usuarioId || currentUser?.id || currentUser?.idUsuario;

        let suggestions = availableUsers
            .map(u => ({
                id: u.usuarioId || u.id || u.idUsuario,
                nombre: u.nombre || u.nombres || 'Sin Nombre',
                rol: formatRole(u.rol || u.role),
                tipo: 'USER',
                valor: u.usuarioId || u.id || u.idUsuario
            }))
            .filter(u => {
                const matchesSearch = (u.nombre && u.nombre.toLowerCase().includes(lowerQuery)) ||
                    (u.rol && u.rol.toLowerCase().includes(lowerQuery));
                const isNotMe = u.id !== currentUserId;
                return matchesSearch && isNotMe;
            });

        if (currentUser?.rol === 'ROLE_ADMIN') {
            const specialGroups = [
                { id: 'ALL', nombre: 'Todos', rol: 'Sistema', tipo: 'SPECIAL', valor: 'ALL' },
                { id: 'ROLE_MEDICO', nombre: 'Médicos', rol: 'Grupo', tipo: 'ROLE', valor: 'ROLE_MEDICO' },
                { id: 'ROLE_INVESTIGADOR', nombre: 'Investigadores', rol: 'Grupo', tipo: 'ROLE', valor: 'ROLE_INVESTIGADOR' },
                { id: 'ROLE_ESTUDIANTE', nombre: 'Estudiantes', rol: 'Grupo', tipo: 'ROLE', valor: 'ROLE_ESTUDIANTE' },
                { id: 'ROLE_VISUALIZADOR', nombre: 'Visualizadores', rol: 'Grupo', tipo: 'ROLE', valor: 'ROLE_VISUALIZADOR' }
            ];
            const matchedGroups = specialGroups.filter(g => g.nombre.toLowerCase().includes(lowerQuery));
            suggestions = [...matchedGroups, ...suggestions];
        }

        return suggestions.filter(s => !selectedRecipients.some(sel => sel.id === s.id));
    };

    const handleAddRecipient = (recipient) => {
        setSelectedRecipients([...selectedRecipients, recipient]);
        setRecipientQuery('');
        searchInputRef.current?.focus();
    };

    const handleRemoveRecipient = (id) => {
        setSelectedRecipients(selectedRecipients.filter(r => r.id !== id));
    };

    const handleSendMessage = async () => {
        if (selectedRecipients.length === 0 || !newMessage.subject) return;
        setIsSending(true);

        const payload = {
            asunto: newMessage.subject,
            contenido: newMessage.body,
            destinatariosIds: [],
            enviarATodos: false,
            enviarARol: null
        };

        const allTag = selectedRecipients.find(r => r.tipo === 'SPECIAL' && r.valor === 'ALL');
        const roleTag = selectedRecipients.find(r => r.tipo === 'ROLE');

        if (allTag) {
            payload.enviarATodos = true;
        } else if (roleTag) {
            payload.enviarARol = roleTag.valor;
            payload.destinatariosIds = selectedRecipients.filter(r => r.tipo === 'USER').map(r => r.valor);
        } else {
            payload.destinatariosIds = selectedRecipients.map(r => r.valor);
        }

        try {
            await api.post('/api/mensajes/enviar', payload);
            setShowCompose(false);
            setNewMessage({ subject: '', body: '' });
            setSelectedRecipients([]);
            setRecipientQuery('');
            await fetchMessages();
            await fetchUnreadCount();
            showNotification('Mensaje enviado exitosamente.', 'success');
        } catch (error) {
            console.error("Error enviando mensaje", error);
            const errorMsg = error.response?.data || error.message;
            showNotification(`Error al enviar: ${errorMsg}`, 'danger');
        } finally {
            setIsSending(false);
        }
    };

    const resetComposeForm = () => {
        setRecipientQuery('');
        setSelectedRecipients([]);
        setNewMessage({ subject: '', body: '' });
    };

    const openReadModal = async (msg) => {
        setSelectedMessage(msg);
        setShowRead(true);

        if (activeTab === 'inbox' && !msg.leido) {
            try {
                await api.post(`/api/mensajes/leer/${msg.id}`);
                setMessages(prev => prev.map(m => m.id === msg.id ? { ...m, leido: true } : m));
                setUnreadCount(prev => Math.max(0, prev - 1));
            } catch (error) {
                console.error("Error marcando como leído", error);
            }
        }
    };

    const handleReply = () => {
        if (!selectedMessage) return;
        setShowRead(false);
        const originalUser = availableUsers.find(u => u.email === selectedMessage.emailEmisor);

        const recipientData = {
            id: originalUser ? (originalUser.usuarioId || originalUser.id) : 'temp_id',
            nombre: selectedMessage.nombreEmisor,
            rol: originalUser ? formatRole(originalUser.rol || originalUser.role) : 'Usuario',
            tipo: 'USER',
            valor: originalUser ? (originalUser.usuarioId || originalUser.id) : null
        };

        if (!recipientData.valor) {
            showNotification("No se encontró el ID del usuario para respuesta automática.", 'danger');
        } else {
            setSelectedRecipients([recipientData]);
        }

        setNewMessage({
            subject: `RE: ${selectedMessage.asunto}`,
            body: `\n\n--- En respuesta a ---\n${selectedMessage.contenido}`
        });
        setShowCompose(true);
    };

    const formatDate = (dateString) => {
        if (!dateString) return '';
        const fechaUTC = dateString.endsWith('Z') ? dateString : dateString + 'Z';
        const date = new Date(fechaUTC);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    };

    const renderListAvatar = () => {
        if (activeTab === 'sent') return <Send size={24} />;
        return <PersonCircle size={32} />;
    };

    const renderListHeader = (msg) => {
        if (activeTab === 'inbox') {
            return msg.nombreEmisor || "Desconocido";
        } else {
            return msg.destinatariosResumen ? `Para: ${msg.destinatariosResumen}` : "Para: (Varios)";
        }
    };

    const renderModalRecipients = (msg) => {
        if (!msg.destinatariosDetalle || msg.destinatariosDetalle.length === 0) {
            return msg.destinatariosResumen || "Varios destinatarios";
        }
        return msg.destinatariosDetalle.map((d, index) => (
            <span key={d.id || index}>
                <Link to={`/dashboard/usuarios/${d.id}`} className="text-decoration-none hover-link" style={{ color: 'var(--text-main)', fontWeight: 'bold' }}>
                    {d.nombre}
                </Link>
                {index < msg.destinatariosDetalle.length - 1 && ", "}
            </span>
        ));
    };

    return (
        <Container fluid className="p-0 h-100 position-relative">
            <Row className="g-0 h-100">
                <Col md={3} lg={2} className="border-end p-3 d-flex flex-column" style={{ minHeight: '80vh' }}>
                    <Button
                        variant="primary"
                        className="mb-4 shadow-sm w-100 d-flex align-items-center justify-content-center gap-2"
                        onClick={() => { resetComposeForm(); setShowCompose(true); }}
                    >
                        <PlusLg /> Redactar
                    </Button>
                    <ListGroup variant="flush" className="bg-transparent">
                        <ListGroup.Item
                            action
                            active={activeTab === 'inbox'}
                            onClick={() => setActiveTab('inbox')}
                            className="d-flex justify-content-between align-items-center border-0 rounded mb-1"
                        >
                            <span><Inbox className="me-2"/> Recibidos</span>
                            {unreadCount > 0 && (
                                <Badge bg="danger" pill>{unreadCount}</Badge>
                            )}
                        </ListGroup.Item>
                        <ListGroup.Item
                            action
                            active={activeTab === 'sent'}
                            onClick={() => setActiveTab('sent')}
                            className="border-0 rounded mb-1"
                        >
                            <Send className="me-2"/> Enviados
                        </ListGroup.Item>
                    </ListGroup>
                </Col>

                <Col md={9} lg={10} className="p-4 d-flex flex-column" style={{ backgroundColor: 'var(--bg-main)', height: '100vh', maxHeight: '100vh', overflow: 'hidden' }}>

                    <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3 flex-shrink-0">
                        <h4 className="mb-0 text-secondary">
                            {activeTab === 'inbox' ? 'Bandeja de Entrada' : 'Mensajes Enviados'}
                        </h4>
                        <div className="d-flex flex-wrap gap-3 align-items-center justify-content-end">
                            <div style={{zIndex: 1050}}>
                                <DateRangeFilter
                                    startDate={dateFilters.inicio}
                                    endDate={dateFilters.fin}
                                    onChange={handleDateRangeChange}
                                />
                            </div>
                            <InputGroup style={{ maxWidth: '250px' }} className="shadow-sm">
                                <InputGroup.Text
                                    className="border-secondary border-opacity-25"
                                    style={{ backgroundColor: 'var(--bg-input)', color: 'var(--text-muted)' }}
                                >
                                    <Search/>
                                </InputGroup.Text>
                                <Form.Control
                                    placeholder="Buscar..."
                                    value={searchTerm}
                                    onChange={e => setSearchTerm(e.target.value)}
                                    className="border-secondary border-opacity-25 shadow-none"
                                    style={{ backgroundColor: 'var(--bg-input)', color: 'var(--text-main)' }}
                                />
                            </InputGroup>
                            <Button
                                variant="outline-secondary"
                                onClick={clearFilters}
                                title="Limpiar Filtros"
                                className="border-opacity-25"
                            >
                                <ArrowCounterclockwise />
                            </Button>
                        </div>
                    </div>

                    <div className="flex-grow-1 overflow-auto rounded border"
                         style={{
                             borderColor: 'var(--border-color)',
                             backgroundColor: 'var(--bg-card)'
                         }}>

                        <ListGroup variant="flush">
                            {isLoading ? (
                                <div className="text-center py-5"><Spinner animation="border" variant="primary"/></div>
                            ) : filteredMessages.length === 0 ? (
                                <div className="text-center py-5 text-muted">
                                    <Inbox size={40} className="mb-3 opacity-25"/>
                                    <p>No hay mensajes que coincidan con los filtros.</p>
                                </div>
                            ) : (
                                filteredMessages.map(msg => (
                                    <ListGroup.Item
                                        key={msg.id}
                                        action
                                        onClick={() => openReadModal(msg)}
                                        className="d-flex align-items-center p-3 border-bottom"
                                        style={{
                                            backgroundColor: (!msg.leido && activeTab === 'inbox') ? 'var(--hover-bg)' : 'transparent',
                                            color: 'var(--text-main)',
                                            borderColor: 'var(--border-color)'
                                        }}
                                    >
                                        <div className="me-3 text-secondary">
                                            {renderListAvatar()}
                                        </div>

                                        <div className="flex-grow-1 overflow-hidden" style={{ minWidth: 0 }}>
                                            <div className="d-flex justify-content-between mb-1">
                                                <span className="fw-medium text-truncate" style={{ color: 'var(--text-main)' }}>
                                                    {renderListHeader(msg)}
                                                </span>
                                                <small style={{ color: 'var(--text-muted)', flexShrink: 0, marginLeft: '8px' }}>{formatDate(msg.fechaEnvio)}</small>
                                            </div>
                                            <div className="text-truncate small" style={{ color: 'var(--text-main)' }}>
                                                <span className={!msg.leido && activeTab === 'inbox' ? 'fw-bold' : ''}>
                                                    {msg.asunto}
                                                </span>
                                            </div>
                                        </div>
                                    </ListGroup.Item>
                                ))
                            )}
                        </ListGroup>
                    </div>
                </Col>
            </Row>

            <Modal show={showRead} onHide={() => setShowRead(false)} size="lg" centered>
                {selectedMessage && (
                    <>
                        <Modal.Header closeButton className="border-bottom-0 pb-0">
                            <Modal.Title className="fs-5">{selectedMessage.asunto}</Modal.Title>
                        </Modal.Header>
                        <Modal.Body>
                            <div className="d-flex align-items-start mb-4 p-3 rounded border"
                                 style={{ backgroundColor: 'rgba(255, 255, 255, 0.05)', borderColor: 'var(--border-color)' }}>
                                <PersonCircle size={48} className="text-secondary me-3 mt-1"/>
                                <div className="flex-grow-1">
                                    <div className="d-flex justify-content-between">
                                        <div>
                                            <span className="small text-uppercase fw-bold" style={{ color: 'var(--text-muted)' }}>De:</span>
                                            <div className="fw-bold fs-6" style={{ color: 'var(--text-main)' }}>
                                                {activeTab === 'inbox' ? (
                                                    <Link to={`/dashboard/usuarios/${selectedMessage.idEmisor}`} className="text-decoration-none hover-link" style={{ color: 'var(--text-main)' }}>
                                                        {selectedMessage.nombreEmisor}
                                                    </Link>
                                                ) : (
                                                    <Link to="/dashboard/perfil" className="text-decoration-none hover-link" style={{ color: 'var(--text-main)' }}>
                                                        {currentUser ? `${currentUser.nombres || currentUser.nombre} (Mí)` : "Mí"}
                                                    </Link>
                                                )}
                                                {activeTab === 'inbox' && selectedMessage.emailEmisor &&
                                                    <span className="fw-normal small ms-1" style={{ color: 'var(--text-muted)' }}>&lt;{selectedMessage.emailEmisor}&gt;</span>
                                                }
                                            </div>
                                        </div>
                                        <div className="text-end">
                                            <small style={{ color: 'var(--text-muted)' }}>{formatDate(selectedMessage.fechaEnvio)}</small>
                                        </div>
                                    </div>
                                    <div className="mt-2">
                                        <span className="small text-uppercase fw-bold" style={{ color: 'var(--text-muted)' }}>Para:</span>
                                        <div style={{ color: 'var(--text-main)' }}>
                                            {activeTab === 'inbox' ? (
                                                <Link to="/dashboard/perfil" className="text-decoration-none hover-link" style={{ color: 'var(--text-main)' }}>Mí</Link>
                                            ) : (
                                                renderModalRecipients(selectedMessage)
                                            )}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div className="p-3 rounded border mt-3"
                                 style={{
                                     backgroundColor: 'rgba(255, 255, 255, 0.05)',
                                     borderColor: 'var(--border-color)',
                                     color: 'var(--text-main)',
                                     whiteSpace: 'pre-wrap',
                                     wordBreak: 'break-word',
                                     overflowWrap: 'break-word',
                                     minHeight: '150px'
                                 }}>
                                {selectedMessage.contenido}
                            </div>
                        </Modal.Body>
                        <Modal.Footer className="border-top-0">
                            <Button variant="outline-secondary" onClick={() => setShowRead(false)}>Cerrar</Button>
                            {activeTab === 'inbox' && (
                                <Button variant="primary" onClick={handleReply}>
                                    <Reply className="me-2"/> Responder
                                </Button>
                            )}
                        </Modal.Footer>
                    </>
                )}
            </Modal>

            <Modal show={showCompose} onHide={() => setShowCompose(false)} size="lg" backdrop="static">
                <style>
                    {`
                        .btn-trash-custom {
                            color: var(--text-main) !important;
                            border-color: var(--border-color) !important;
                        }
                        .btn-trash-custom:hover {
                            color: #dc3545 !important;
                            border-color: #dc3545 !important;
                            background-color: transparent !important;
                        }
                        .dropdown-list-dark {
                            background-color: var(--bg-card) !important;
                            border: 1px solid var(--border-color) !important;
                        }
                        .dropdown-item-dark {
                            background-color: var(--bg-card) !important;
                            color: var(--text-main) !important;
                            border-bottom: 1px solid var(--border-color) !important;
                        }
                        .dropdown-item-dark:hover {
                            background-color: var(--hover-bg) !important;
                            color: var(--text-main) !important;
                        }
                        .dropdown-item-dark.disabled {
                            background-color: var(--bg-card) !important;
                            color: var(--text-muted) !important;
                        }
                    `}
                </style>
                <Modal.Header closeButton>
                    <Modal.Title>Nuevo Mensaje</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Label>Para:</Form.Label>
                            <div className="d-flex flex-wrap align-items-center gap-2 p-2 border rounded position-relative focus-within-shadow"
                                 style={{ backgroundColor: 'rgba(255, 255, 255, 0.05)', borderColor: 'var(--border-color)' }}>
                                {selectedRecipients.map((recipient, idx) => (
                                    <Badge
                                        key={`${recipient.id}-${idx}`}
                                        bg={recipient.tipo === 'SPECIAL' ? 'danger' : recipient.tipo === 'ROLE' ? 'warning' : 'primary'}
                                        text={recipient.tipo === 'ROLE' ? 'dark' : 'light'}
                                        className="d-flex align-items-center py-2 px-3 rounded-pill"
                                        style={{fontSize: '0.9em'}}
                                    >
                                        {recipient.tipo === 'USER' && <PersonCircle className="me-2"/>}
                                        {recipient.nombre}
                                        <X size={20} className="ms-2" style={{cursor: 'pointer'}} onClick={() => handleRemoveRecipient(recipient.id)} />
                                    </Badge>
                                ))}
                                <input
                                    ref={searchInputRef}
                                    type="text"
                                    className="border-0 shadow-none p-0"
                                    style={{
                                        width: '200px',
                                        minWidth: '50px',
                                        outline: 'none',
                                        backgroundColor: 'transparent',
                                        color: 'var(--text-main)'
                                    }}
                                    placeholder={selectedRecipients.length === 0 ? "Buscar nombre o rol..." : ""}
                                    value={recipientQuery}
                                    onChange={(e) => setRecipientQuery(e.target.value)}
                                    onKeyDown={(e) => {
                                        if (e.key === 'Backspace' && recipientQuery === '' && selectedRecipients.length > 0) {
                                            handleRemoveRecipient(selectedRecipients[selectedRecipients.length - 1].id);
                                        }
                                    }}
                                    autoFocus
                                />
                                {recipientQuery.length > 0 && (
                                    <ListGroup className="position-absolute shadow start-0 w-100 dropdown-list-dark" style={{ top: '100%', zIndex: 1050, maxHeight: '200px', overflowY: 'auto' }}>
                                        {getSuggestions().length === 0 ? (
                                            <ListGroup.Item disabled className="dropdown-item-dark disabled">No se encontraron resultados</ListGroup.Item>
                                        ) : (
                                            getSuggestions().map((s, i) => (
                                                <ListGroup.Item
                                                    key={i}
                                                    action
                                                    onClick={() => handleAddRecipient(s)}
                                                    className="d-flex align-items-center justify-content-between dropdown-item-dark"
                                                >
                                                    <div><strong>{s.nombre}</strong></div>
                                                    <Badge bg="light" text="dark" className="border">{s.rol}</Badge>
                                                </ListGroup.Item>
                                            ))
                                        )}
                                    </ListGroup>
                                )}
                            </div>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Asunto:</Form.Label>
                            <Form.Control type="text" value={newMessage.subject} onChange={e => setNewMessage({...newMessage, subject: e.target.value})} />
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Mensaje:</Form.Label>
                            <Form.Control as="textarea" rows={6} value={newMessage.body} onChange={e => setNewMessage({...newMessage, body: e.target.value})} />
                        </Form.Group>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="outline-secondary" className="btn-trash-custom" onClick={() => setShowCompose(false)}><Trash/></Button>
                    <Button variant="primary" onClick={handleSendMessage} disabled={selectedRecipients.length === 0 || !newMessage.subject || isSending}>
                        {isSending ? <Spinner size="sm" animation="border" className="me-2"/> : <Send className="me-2"/>}
                        Enviar Mensaje
                    </Button>
                </Modal.Footer>
            </Modal>

            <ToastContainer position="bottom-end" className="p-3" style={{ zIndex: 9999 }}>
                <Toast
                    onClose={() => setToastConfig({ ...toastConfig, show: false })}
                    show={toastConfig.show}
                    delay={3000}
                    autohide
                    bg={toastConfig.variant}
                >
                    <Toast.Body className={toastConfig.variant === 'light' ? 'text-dark' : 'text-white'}>
                        <div className="d-flex align-items-center gap-2">
                            {toastConfig.variant === 'success' ? <CheckCircle size={20} /> : <ExclamationCircle size={20} />}
                            <strong>{toastConfig.message}</strong>
                        </div>
                    </Toast.Body>
                </Toast>
            </ToastContainer>
        </Container>
    );
};

export default Messages;