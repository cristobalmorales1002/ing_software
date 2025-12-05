import React, { useState, useEffect, useRef } from 'react';
import { Container, Row, Col, ListGroup, Badge, Button, Form, Modal, InputGroup, Spinner } from 'react-bootstrap';
import {
    Send,
    Inbox,
    Search,
    PlusLg,
    PersonCircle,
    Trash,
    Reply,
    X,
    Calendar3,
    ArrowCounterclockwise
} from 'react-bootstrap-icons';
import api from '../api/axios';

const Messages = () => {
    // --- ESTADOS ---
    const [activeTab, setActiveTab] = useState('inbox');
    const [messages, setMessages] = useState([]);
    const [isLoading, setIsLoading] = useState(false);

    // Estados de Filtros
    const [searchTerm, setSearchTerm] = useState('');
    const [dateFilters, setDateFilters] = useState({ inicio: '', fin: '' });

    const [unreadCount, setUnreadCount] = useState(0);
    const [currentUser, setCurrentUser] = useState(null);

    // Estados Modales
    const [showCompose, setShowCompose] = useState(false);
    const [showRead, setShowRead] = useState(false);
    const [selectedMessage, setSelectedMessage] = useState(null);

    // Estados Redacción
    const [recipientQuery, setRecipientQuery] = useState('');
    const [availableUsers, setAvailableUsers] = useState([]);
    const [selectedRecipients, setSelectedRecipients] = useState([]);
    const [newMessage, setNewMessage] = useState({ subject: '', body: '' });
    const [isSending, setIsSending] = useState(false);

    const searchInputRef = useRef(null);

    // --- HELPER: FORMATEAR ROLES ---
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

    // --- CARGA DE DATOS ---
    useEffect(() => {
        fetchCurrentUser();
        fetchAvailableUsers();
    }, []);

    useEffect(() => {
        fetchMessages();
        fetchUnreadCount();
        // Al cambiar de pestaña, limpiamos filtros para evitar confusión visual
        clearFilters();
    }, [activeTab]);

    const fetchCurrentUser = async () => {
        try {
            const res = await api.get('/api/usuarios/me');
            setCurrentUser(res.data);
        } catch (error) {
            console.error("Error obteniendo usuario actual", error);
        }
    };

    const fetchAvailableUsers = async () => {
        try {
            const res = await api.get('/api/usuarios');
            setAvailableUsers(res.data);
        } catch (error) {
            console.error("Error cargando usuarios.", error);
        }
    };

    const fetchMessages = async () => {
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
    };

    const fetchUnreadCount = async () => {
        try {
            const res = await api.get('/api/mensajes/noleidos/cantidad');
            setUnreadCount(res.data);
        } catch (error) {
            console.error(error);
        }
    };

    // --- MANEJO DE FILTROS ---
    const handleDateChange = (e) => {
        setDateFilters({ ...dateFilters, [e.target.name]: e.target.value });
    };

    const clearFilters = () => {
        setDateFilters({ inicio: '', fin: '' });
        setSearchTerm('');
    };

    // --- FILTRADO COMBINADO (TEXTO + FECHA) ---
    const filteredMessages = messages.filter(msg => {
        // 1. Filtro de Texto
        const searchLower = searchTerm.toLowerCase();
        const sender = msg.nombreEmisor || '';
        const receiver = msg.destinatariosResumen || msg.nombreDestinatario || '';
        const subject = msg.asunto || '';

        const matchesText = subject.toLowerCase().includes(searchLower) ||
            sender.toLowerCase().includes(searchLower) ||
            receiver.toLowerCase().includes(searchLower);

        // 2. Filtro de Fecha (Local)
        let matchesDate = true;
        if (dateFilters.inicio || dateFilters.fin) {
            const msgDate = new Date(msg.fechaEnvio);
            // Quitamos la hora para comparar solo fechas (00:00:00)
            msgDate.setHours(0, 0, 0, 0);

            if (dateFilters.inicio) {
                // Ajuste de zona horaria simple creando fecha con T00:00:00
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

    // --- LÓGICA DE BÚSQUEDA DE DESTINATARIOS ---
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

    // --- ENVÍO ---
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
            alert("Mensaje enviado exitosamente.");
        } catch (error) {
            console.error("Error enviando mensaje", error);
            alert("Error al enviar: " + (error.response?.data || error.message));
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
            alert("No se encontró el ID del usuario para respuesta automática.");
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
        const date = new Date(dateString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    };

    const renderListAvatar = (msg) => {
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

    return (
        <Container fluid className="p-0 h-100">
            <Row className="g-0 h-100">

                {/* SIDEBAR */}
                <Col md={3} lg={2} className="bg-light border-end p-3 d-flex flex-column" style={{ minHeight: '80vh' }}>
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

                {/* AREA PRINCIPAL */}
                <Col md={9} lg={10} className="p-4 bg-white">
                    {/* CABECERA CON FILTROS (Estilo AuditLog) */}
                    <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                        <h4 className="mb-0 text-secondary">
                            {activeTab === 'inbox' ? 'Bandeja de Entrada' : 'Mensajes Enviados'}
                        </h4>

                        {/* Bloque de Filtros */}
                        <div className="d-flex flex-wrap gap-3 align-items-center justify-content-end">

                            {/* Fechas Verticales */}
                            <div className="d-flex flex-column gap-1">
                                <InputGroup size="sm" className="shadow-sm" style={{width: '200px'}}>
                                    <InputGroup.Text className="bg-white border-secondary border-opacity-25 text-muted fw-bold" style={{width: '60px', fontSize: '0.8rem'}}>
                                        Desde
                                    </InputGroup.Text>
                                    <Form.Control
                                        type="date"
                                        name="inicio"
                                        value={dateFilters.inicio}
                                        onChange={handleDateChange}
                                        className="bg-white border-secondary border-opacity-25 shadow-none text-center"
                                        style={{fontSize: '0.85rem'}}
                                    />
                                </InputGroup>
                                <InputGroup size="sm" className="shadow-sm" style={{width: '200px'}}>
                                    <InputGroup.Text className="bg-white border-secondary border-opacity-25 text-muted fw-bold" style={{width: '60px', fontSize: '0.8rem'}}>
                                        Hasta
                                    </InputGroup.Text>
                                    <Form.Control
                                        type="date"
                                        name="fin"
                                        value={dateFilters.fin}
                                        onChange={handleDateChange}
                                        className="bg-white border-secondary border-opacity-25 shadow-none text-center"
                                        style={{fontSize: '0.85rem'}}
                                    />
                                </InputGroup>
                            </div>

                            {/* Icono Separador */}
                            <div className="text-muted opacity-25 d-none d-md-block">
                                <Calendar3 size={24} />
                            </div>

                            {/* Buscador */}
                            <InputGroup style={{ maxWidth: '250px' }} className="shadow-sm">
                                <InputGroup.Text className="bg-white text-muted border-secondary border-opacity-25"><Search/></InputGroup.Text>
                                <Form.Control
                                    placeholder="Buscar..."
                                    value={searchTerm}
                                    onChange={e => setSearchTerm(e.target.value)}
                                    className="bg-white border-secondary border-opacity-25 shadow-none"
                                />
                            </InputGroup>

                            {/* Botón Limpiar */}
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

                    <ListGroup variant="flush" className="border-top">
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
                                    className={`d-flex align-items-center p-3 border-bottom ${!msg.leido && activeTab === 'inbox' ? 'bg-light fw-bold' : ''}`}
                                >
                                    <div className="me-3 text-secondary">
                                        {renderListAvatar(msg)}
                                    </div>
                                    <div className="flex-grow-1 overflow-hidden">
                                        <div className="d-flex justify-content-between">
                                            <span className="text-dark fw-medium">
                                                {renderListHeader(msg)}
                                            </span>
                                            <small className="text-muted">{formatDate(msg.fechaEnvio)}</small>
                                        </div>
                                        <div className="text-truncate text-secondary small">
                                            <span className={!msg.leido && activeTab === 'inbox' ? 'text-dark' : ''}>
                                                {msg.asunto}
                                            </span>
                                            <span className="mx-1">-</span>
                                            {msg.contenido}
                                        </div>
                                    </div>
                                </ListGroup.Item>
                            ))
                        )}
                    </ListGroup>
                </Col>
            </Row>

            {/* MODAL LEER */}
            <Modal show={showRead} onHide={() => setShowRead(false)} size="lg" centered>
                {selectedMessage && (
                    <>
                        <Modal.Header closeButton className="border-bottom-0 pb-0">
                            <Modal.Title className="fs-5">{selectedMessage.asunto}</Modal.Title>
                        </Modal.Header>

                        <Modal.Body>
                            <div className="d-flex align-items-start mb-4 p-3 bg-light rounded">
                                <PersonCircle size={48} className="text-secondary me-3 mt-1"/>
                                <div className="flex-grow-1">
                                    <div className="d-flex justify-content-between">
                                        <div>
                                            <span className="text-muted small text-uppercase fw-bold">De:</span>
                                            <div className="fw-bold fs-6">
                                                {activeTab === 'inbox'
                                                    ? (selectedMessage.nombreEmisor)
                                                    : (currentUser ? `${currentUser.nombres || currentUser.nombre} (Mí)` : "Mí")
                                                }
                                                {activeTab === 'inbox' && selectedMessage.emailEmisor &&
                                                    <span className="text-muted fw-normal small ms-1">&lt;{selectedMessage.emailEmisor}&gt;</span>
                                                }
                                            </div>
                                        </div>
                                        <div className="text-end">
                                            <small className="text-muted">{formatDate(selectedMessage.fechaEnvio)}</small>
                                        </div>
                                    </div>
                                    <div className="mt-2">
                                        <span className="text-muted small text-uppercase fw-bold">Para:</span>
                                        <div className="text-dark">
                                            {activeTab === 'inbox'
                                                ? "Mí"
                                                : (selectedMessage.destinatariosResumen || "Varios destinatarios")
                                            }
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className="p-3" style={{ whiteSpace: 'pre-wrap', minHeight: '150px' }}>
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

            {/* MODAL REDACTAR (COMPLETO) */}
            <Modal show={showCompose} onHide={() => setShowCompose(false)} size="lg" backdrop="static">
                <Modal.Header closeButton>
                    <Modal.Title>Nuevo Mensaje</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group className="mb-3">
                            <Form.Label>Para:</Form.Label>
                            <div className="d-flex flex-wrap align-items-center gap-2 p-2 border rounded bg-white position-relative focus-within-shadow">
                                {selectedRecipients.map((recipient, idx) => (
                                    <Badge
                                        key={`${recipient.id}-${idx}`}
                                        bg={recipient.tipo === 'SPECIAL' ? 'danger' : recipient.tipo === 'ROLE' ? 'warning' : 'secondary'}
                                        text={recipient.tipo === 'ROLE' ? 'dark' : 'light'}
                                        className="d-flex align-items-center py-2 px-3 rounded-pill"
                                        style={{fontSize: '0.9em'}}
                                    >
                                        {recipient.tipo === 'USER' && <PersonCircle className="me-2"/>}
                                        {recipient.nombre}
                                        <X size={20} className="ms-2" style={{cursor: 'pointer'}} onClick={() => handleRemoveRecipient(recipient.id)} />
                                    </Badge>
                                ))}
                                <Form.Control
                                    ref={searchInputRef}
                                    type="text"
                                    className="border-0 shadow-none p-0"
                                    style={{ width: '200px', minWidth: '50px' }}
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
                                    <ListGroup className="position-absolute shadow start-0 w-100" style={{ top: '100%', zIndex: 1050, maxHeight: '200px', overflowY: 'auto' }}>
                                        {getSuggestions().length === 0 ? (
                                            <ListGroup.Item disabled className="text-muted small">No se encontraron resultados</ListGroup.Item>
                                        ) : (
                                            getSuggestions().map((s, i) => (
                                                <ListGroup.Item
                                                    key={i}
                                                    action
                                                    onClick={() => handleAddRecipient(s)}
                                                    className="d-flex align-items-center justify-content-between"
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
                    <Button variant="light" onClick={() => setShowCompose(false)}><Trash/></Button>
                    <Button variant="primary" onClick={handleSendMessage} disabled={selectedRecipients.length === 0 || !newMessage.subject || isSending}>
                        {isSending ? <Spinner size="sm" animation="border" className="me-2"/> : <Send className="me-2"/>}
                        Enviar Mensaje
                    </Button>
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default Messages;