import React, { useState, useEffect } from 'react';
import { Container, Row, Col, ListGroup, Badge, Button, Form, Modal, InputGroup, Card } from 'react-bootstrap';
import {
    Envelope,
    Send,
    Inbox,
    Search,
    PlusLg,
    PersonCircle,
    Trash,
    Reply
} from 'react-bootstrap-icons';

// --- DATOS MOCK (SIMULACIÓN DE BACKEND) ---
const MOCK_USERS = [
    { id: 1, nombre: 'Juan Pérez', rol: 'ROLE_ADMIN', email: 'juan.perez@cybergene.cl' },
    { id: 2, nombre: 'Maria Gomez', rol: 'ROLE_INVESTIGADOR', email: 'maria.gomez@cybergene.cl' },
    { id: 3, nombre: 'Carlos Ruiz', rol: 'ROLE_MEDICO', email: 'carlos.ruiz@cybergene.cl' },
    { id: 4, nombre: 'Ana Torres', rol: 'ROLE_ESTUDIANTE', email: 'ana.torres@cybergene.cl' },
    { id: 99, nombre: 'Todos los Usuarios', rol: 'SISTEMA', email: 'all@cybergene.cl' }
];

const MOCK_MESSAGES = [
    { id: 1, senderId: 2, senderName: 'Maria Gomez', subject: 'Resultados Preliminares Caso #402', body: 'Hola, te adjunto los avances del caso clínico revisado ayer. Saludos.', date: '10:30 AM', read: false, type: 'received' },
    { id: 2, senderId: 3, senderName: 'Carlos Ruiz', subject: 'Duda sobre protocolo', body: 'Necesito confirmar si el protocolo de seguridad cambió para el laboratorio B.', date: 'Ayer', read: true, type: 'received' },
    { id: 3, senderId: 'me', senderName: 'Yo', recipientName: 'Juan Pérez', subject: 'Solicitud de vacaciones', body: 'Estimado, solicito días libres para la próxima semana.', date: '20 Nov', type: 'sent' }
];

const Messages = () => {
    // Estados principales
    const [activeTab, setActiveTab] = useState('inbox'); // 'inbox' | 'sent'
    const [messages, setMessages] = useState(MOCK_MESSAGES);
    const [searchTerm, setSearchTerm] = useState('');

    // Estados para Modales
    const [showCompose, setShowCompose] = useState(false);
    const [showRead, setShowRead] = useState(false);
    const [selectedMessage, setSelectedMessage] = useState(null);

    // Estados para Formulario de Redacción
    const [recipientQuery, setRecipientQuery] = useState('');
    const [suggestedRecipients, setSuggestedRecipients] = useState([]);
    const [selectedRecipient, setSelectedRecipient] = useState(null); // Usuario seleccionado
    const [newMessage, setNewMessage] = useState({ subject: '', body: '' });

    // --- LÓGICA DE FILTRADO DE MENSAJES ---
    const filteredMessages = messages.filter(msg => {
        const matchesTab = activeTab === 'inbox' ? msg.type === 'received' : msg.type === 'sent';
        const matchesSearch = msg.subject.toLowerCase().includes(searchTerm.toLowerCase()) ||
            msg.senderName.toLowerCase().includes(searchTerm.toLowerCase());
        return matchesTab && matchesSearch;
    });

    // --- LÓGICA DE BÚSQUEDA DE DESTINATARIOS ---
    useEffect(() => {
        if (recipientQuery.length > 0 && !selectedRecipient) {
            const lowerQuery = recipientQuery.toLowerCase();
            const suggestions = MOCK_USERS.filter(u =>
                u.nombre.toLowerCase().includes(lowerQuery) ||
                u.rol.toLowerCase().includes(lowerQuery)
            );
            setSuggestedRecipients(suggestions);
        } else {
            setSuggestedRecipients([]);
        }
    }, [recipientQuery, selectedRecipient]);

    // --- ACCIONES ---
    const handleSelectRecipient = (user) => {
        setSelectedRecipient(user);
        setRecipientQuery(user.nombre); // Mostrar nombre en el input
        setSuggestedRecipients([]); // Ocultar lista
    };

    const handleClearRecipient = () => {
        setSelectedRecipient(null);
        setRecipientQuery('');
    };

    const handleSendMessage = () => {
        if (!selectedRecipient || !newMessage.subject) return;

        // Simulamos envío agregando a la lista local
        const newMsgMock = {
            id: Date.now(),
            senderId: 'me',
            senderName: 'Yo',
            recipientName: selectedRecipient.nombre,
            subject: newMessage.subject,
            body: newMessage.body,
            date: 'Ahora',
            type: 'sent'
        };

        setMessages([newMsgMock, ...messages]);
        setShowCompose(false);
        resetComposeForm();
        setActiveTab('sent'); // Vamos a enviados para ver el mensaje
    };

    const resetComposeForm = () => {
        setRecipientQuery('');
        setSelectedRecipient(null);
        setNewMessage({ subject: '', body: '' });
    };

    const openReadModal = (msg) => {
        // Marcar como leído si es recibido
        if (msg.type === 'received' && !msg.read) {
            const updatedMsgs = messages.map(m => m.id === msg.id ? { ...m, read: true } : m);
            setMessages(updatedMsgs);
        }
        setSelectedMessage(msg);
        setShowRead(true);
    };

    return (
        <Container fluid className="p-0 h-100">
            <Row className="g-0 h-100">

                {/* 1. SIDEBAR IZQUIERDO (Navegación) */}
                <Col md={3} lg={2} className="bg-light border-end p-3 d-flex flex-column" style={{ minHeight: '80vh' }}>
                    <Button
                        variant="primary"
                        className="mb-4 shadow-sm w-100 d-flex align-items-center justify-content-center gap-2"
                        onClick={() => setShowCompose(true)}
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
                            {messages.filter(m => m.type === 'received' && !m.read).length > 0 && (
                                <Badge bg="danger" pill>
                                    {messages.filter(m => m.type === 'received' && !m.read).length}
                                </Badge>
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

                {/* 2. AREA PRINCIPAL (Lista de mensajes) */}
                <Col md={9} lg={10} className="p-4 bg-white">
                    <div className="d-flex justify-content-between align-items-center mb-3">
                        <h4 className="mb-0 text-secondary">
                            {activeTab === 'inbox' ? 'Bandeja de Entrada' : 'Mensajes Enviados'}
                        </h4>
                        <InputGroup style={{ maxWidth: '300px' }}>
                            <InputGroup.Text className="bg-white border-end-0"><Search/></InputGroup.Text>
                            <Form.Control
                                placeholder="Buscar mensaje..."
                                className="border-start-0 border-secondary-subtle shadow-none"
                                value={searchTerm}
                                onChange={e => setSearchTerm(e.target.value)}
                            />
                        </InputGroup>
                    </div>

                    <ListGroup variant="flush" className="border-top">
                        {filteredMessages.length === 0 ? (
                            <div className="text-center py-5 text-muted">
                                <Inbox size={40} className="mb-3 opacity-25"/>
                                <p>No hay mensajes en esta bandeja.</p>
                            </div>
                        ) : (
                            filteredMessages.map(msg => (
                                <ListGroup.Item
                                    key={msg.id}
                                    action
                                    onClick={() => openReadModal(msg)}
                                    className={`d-flex align-items-center p-3 border-bottom ${!msg.read && msg.type === 'received' ? 'bg-light fw-bold' : ''}`}
                                >
                                    {/* Icono Avatar */}
                                    <div className="me-3 text-secondary">
                                        <PersonCircle size={32} />
                                    </div>

                                    {/* Contenido Resumido */}
                                    <div className="flex-grow-1 overflow-hidden">
                                        <div className="d-flex justify-content-between">
                                            <span className="text-dark">
                                                {msg.type === 'received' ? msg.senderName : `Para: ${msg.recipientName}`}
                                            </span>
                                            <small className="text-muted">{msg.date}</small>
                                        </div>
                                        <div className="text-truncate text-secondary small">
                                            <span className={!msg.read && msg.type === 'received' ? 'text-dark' : ''}>
                                                {msg.subject}
                                            </span>
                                            <span className="mx-1">-</span>
                                            {msg.body}
                                        </div>
                                    </div>
                                </ListGroup.Item>
                            ))
                        )}
                    </ListGroup>
                </Col>
            </Row>

            {/* --- 3. MODAL: LEER MENSAJE --- */}
            <Modal show={showRead} onHide={() => setShowRead(false)} size="lg" centered>
                {selectedMessage && (
                    <>
                        <Modal.Header closeButton className="border-0 pb-0">
                            <Modal.Title className="fs-5">{selectedMessage.subject}</Modal.Title>
                        </Modal.Header>
                        <Modal.Body>
                            <div className="d-flex align-items-center mb-4">
                                <PersonCircle size={40} className="text-secondary me-3"/>
                                <div>
                                    <div className="fw-bold">
                                        {selectedMessage.type === 'received' ? selectedMessage.senderName : 'Yo'}
                                    </div>
                                    <div className="text-muted small">
                                        {selectedMessage.type === 'received' ? `Para: Mi` : `Para: ${selectedMessage.recipientName}`}
                                        {' • ' + selectedMessage.date}
                                    </div>
                                </div>
                            </div>
                            <div className="p-3 bg-light rounded" style={{ whiteSpace: 'pre-wrap' }}>
                                {selectedMessage.body}
                            </div>
                        </Modal.Body>
                        <Modal.Footer className="border-0">
                            <Button variant="outline-secondary" onClick={() => setShowRead(false)}>Cerrar</Button>
                            {selectedMessage.type === 'received' && (
                                <Button variant="primary">
                                    <Reply className="me-2"/> Responder
                                </Button>
                            )}
                        </Modal.Footer>
                    </>
                )}
            </Modal>

            {/* --- 4. MODAL: REDACTAR MENSAJE --- */}
            <Modal show={showCompose} onHide={() => setShowCompose(false)} size="lg" backdrop="static">
                <Modal.Header closeButton>
                    <Modal.Title>Nuevo Mensaje</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        {/* INPUT PARA BUSCAR USUARIO */}
                        <Form.Group className="mb-3 position-relative">
                            <Form.Label>Para:</Form.Label>
                            {selectedRecipient ? (
                                <div className="d-flex align-items-center gap-2 p-2 border rounded bg-light">
                                    <Badge bg="primary">{selectedRecipient.rol}</Badge>
                                    <span className="fw-bold">{selectedRecipient.nombre}</span>
                                    <small className="text-muted">({selectedRecipient.email})</small>
                                    <Button variant="close" size="sm" className="ms-auto" onClick={handleClearRecipient}></Button>
                                </div>
                            ) : (
                                <InputGroup>
                                    <InputGroup.Text><Search/></InputGroup.Text>
                                    <Form.Control
                                        type="text"
                                        placeholder="Buscar por nombre o rol (ej: Admin, Juan...)"
                                        value={recipientQuery}
                                        onChange={(e) => setRecipientQuery(e.target.value)}
                                        autoFocus
                                    />
                                </InputGroup>
                            )}

                            {/* LISTA DE SUGERENCIAS FLOTANTE */}
                            {suggestedRecipients.length > 0 && !selectedRecipient && (
                                <ListGroup className="position-absolute w-100 shadow mt-1" style={{ zIndex: 1050, maxHeight: '200px', overflowY: 'auto' }}>
                                    {suggestedRecipients.map(user => (
                                        <ListGroup.Item
                                            key={user.id}
                                            action
                                            onClick={() => handleSelectRecipient(user)}
                                            className="d-flex align-items-center justify-content-between"
                                        >
                                            <div>
                                                <strong>{user.nombre}</strong>
                                                <div className="small text-muted">{user.email}</div>
                                            </div>
                                            <Badge bg="secondary" className="ms-2">{user.rol}</Badge>
                                        </ListGroup.Item>
                                    ))}
                                </ListGroup>
                            )}
                        </Form.Group>

                        <Form.Group className="mb-3">
                            <Form.Label>Asunto:</Form.Label>
                            <Form.Control
                                type="text"
                                value={newMessage.subject}
                                onChange={e => setNewMessage({...newMessage, subject: e.target.value})}
                            />
                        </Form.Group>

                        <Form.Group className="mb-3">
                            <Form.Label>Mensaje:</Form.Label>
                            <Form.Control
                                as="textarea"
                                rows={6}
                                value={newMessage.body}
                                onChange={e => setNewMessage({...newMessage, body: e.target.value})}
                            />
                        </Form.Group>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="light" onClick={() => setShowCompose(false)}><Trash/></Button>
                    <Button
                        variant="primary"
                        onClick={handleSendMessage}
                        disabled={!selectedRecipient || !newMessage.subject}
                    >
                        <Send className="me-2"/> Enviar Mensaje
                    </Button>
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default Messages;