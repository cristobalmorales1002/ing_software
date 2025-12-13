import { useState, useEffect } from 'react';
import { Table, Button, Modal, Form, Container, Row, Col, Badge, Spinner, Pagination, InputGroup, Toast, ToastContainer } from 'react-bootstrap';
import { PencilSquare, Trash, PlusLg, Search, ArrowCounterclockwise, CheckCircle, ExclamationCircle } from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut, validateRut } from '../utils/rutUtils';
import { COUNTRY_PHONE_DATA, getPhoneConfig } from '../utils/phoneUtils';

const UserManagement = () => {
    const [users, setUsers] = useState([]);
    const [isLoading, setIsLoading] = useState(false);

    // Estados de Error
    const [rutError, setRutError] = useState(null);
    const [emailError, setEmailError] = useState(null);

    const [showFormModal, setShowFormModal] = useState(false);
    const [showStatusModal, setShowStatusModal] = useState(false);
    const [statusAction, setStatusAction] = useState('desactivar');

    const [isEditing, setIsEditing] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);

    const [toastConfig, setToastConfig] = useState({
        show: false,
        message: '',
        variant: 'success'
    });

    const initialFormState = {
        rut: '', nombres: '', apellidos: '', email: '',
        contrasena: '', activo: true, rol: 'ROLE_INVESTIGADOR'
    };
    const [formData, setFormData] = useState(initialFormState);
    const [phoneData, setPhoneData] = useState({ code: '+56', number: '' });

    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 10;

    const showNotification = (message, variant = 'success') => {
        setToastConfig({ show: true, message, variant });
    };

    const fetchUsers = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/usuarios');
            setUsers(res.data);
        } catch (err) {
            showNotification('Error al cargar la lista de usuarios.', 'danger');
        }
        finally { setIsLoading(false); }
    };

    useEffect(() => { fetchUsers(); }, []);

    const filteredUsers = users.filter((user) => {
        if (searchTerm === '') return true;
        const searchLower = searchTerm.toLowerCase();
        return (
            user.nombres.toLowerCase().includes(searchLower) ||
            user.apellidos.toLowerCase().includes(searchLower) ||
            user.rut.toLowerCase().includes(searchLower) ||
            user.email.toLowerCase().includes(searchLower)
        );
    });

    const sortedUsers = [...filteredUsers].sort((a, b) => {
        const isActiveA = a.estadoU === 'ACTIVO' || a.estadoU === true;
        const isActiveB = b.estadoU === 'ACTIVO' || b.estadoU === true;
        if (isActiveA && !isActiveB) return -1;
        if (!isActiveA && isActiveB) return 1;
        return 0;
    });

    useEffect(() => { setCurrentPage(1); }, [searchTerm]);

    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentUsers = sortedUsers.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(sortedUsers.length / itemsPerPage);
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    const handleInputChange = (e) => {
        const { name, value, type, checked } = e.target;

        // Limpiar error de email al escribir
        if (name === 'email') setEmailError(null);

        if (name === 'rut') {
            if (value.length > 12) return;
            const formatted = formatRut(value);
            setFormData({ ...formData, [name]: formatted });
            if (formatted.trim() === '') { setRutError(null); return; }
            if (formatted.length >= 8) {
                if (validateRut(formatted)) { setRutError(null); } else { setRutError('Dígito verificador incorrecto'); }
            } else { setRutError(null); }
        } else {
            setFormData({ ...formData, [name]: type === 'checkbox' ? checked : value });
        }
    };

    const handlePhoneCodeChange = (e) => {
        const newCode = e.target.value;
        const config = getPhoneConfig(newCode);
        let currentNumber = phoneData.number;
        if (currentNumber.length > config.maxLength) {
            currentNumber = currentNumber.slice(0, config.maxLength);
        }
        setPhoneData({ code: newCode, number: currentNumber });
    };

    const handlePhoneNumberChange = (e) => {
        const val = e.target.value;
        const config = getPhoneConfig(phoneData.code);
        if (/^\d*$/.test(val)) {
            if (val.length <= config.maxLength) {
                setPhoneData({ ...phoneData, number: val });
            }
        }
    };

    const openCreateModal = () => {
        setFormData(initialFormState);
        setPhoneData({ code: '+56', number: '' });
        setIsEditing(false);
        setRutError(null);
        setEmailError(null);
        setShowFormModal(true);
    };

    const openEditModal = (user) => {
        let pCode = '+56';
        let pNum = '';
        if (user.telefono) {
            const sortedCodes = [...COUNTRY_PHONE_DATA].sort((a, b) => b.code.length - a.code.length);
            const found = sortedCodes.find(c => user.telefono.startsWith(c.code));
            if (found) {
                pCode = found.code;
                pNum = user.telefono.replace(found.code, '');
            } else {
                pNum = user.telefono;
            }
        }
        setFormData({
            rut: user.rut,
            nombres: user.nombres,
            apellidos: user.apellidos,
            email: user.email,
            contrasena: '',
            activo: user.estadoU === 'ACTIVO' || user.estadoU === true,
            rol: user.rol || 'ROLE_INVESTIGADOR'
        });
        setPhoneData({ code: pCode, number: pNum });
        setRutError(null);
        setEmailError(null);
        setSelectedUser(user);
        setIsEditing(true);
        setShowFormModal(true);
    };

    const openStatusModal = (user) => {
        setSelectedUser(user);
        const isActive = user.estadoU === 'ACTIVO' || user.estadoU === true;
        setStatusAction(isActive ? 'desactivar' : 'activar');
        setShowStatusModal(true);
    };

    const handleSaveUser = async (e) => {
        e.preventDefault();
        setRutError(null);
        setEmailError(null);

        if (!validateRut(formData.rut)) {
            setRutError('RUT inválido.');
            return;
        }

        // --- VALIDACIÓN DE EMAIL ---
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(formData.email)) {
            setEmailError('Formato de correo inválido.');
            return;
        }

        let finalPhone = '';
        if (phoneData.number) {
            finalPhone = phoneData.code + phoneData.number;
        }

        try {
            const dataToSend = {
                rut: formData.rut, nombres: formData.nombres, apellidos: formData.apellidos,
                email: formData.email,
                telefono: finalPhone,
                rol: formData.rol,
                activo: formData.activo
            };

            if (isEditing) {
                await api.put(`/api/usuarios/${selectedUser.usuarioId}`, dataToSend);
                showNotification('Usuario actualizado correctamente.', 'success');
            } else {
                dataToSend.password = "Temporal123!";
                await api.post('/api/usuarios', dataToSend);
                showNotification('Usuario creado exitosamente. Se ha enviado el correo.', 'success');
            }

            fetchUsers();
            setShowFormModal(false);
        } catch (err) {
            const msg = err.response?.data?.message || 'Error al procesar la solicitud.';
            showNotification(msg, 'danger');
        }
    };

    const handleToggleStatus = async () => {
        try {
            if (statusAction === 'desactivar') {
                await api.delete(`/api/usuarios/${selectedUser.usuarioId}`);
                showNotification('Usuario desactivado correctamente.', 'warning');
            } else {
                await api.put(`/api/usuarios/${selectedUser.usuarioId}/activate`);
                showNotification('Usuario reactivado correctamente.', 'success');
            }
            fetchUsers();
            setShowStatusModal(false);
        } catch (err) {
            console.error(err);
            showNotification('Error al cambiar el estado del usuario.', 'danger');
        }
    };

    const formatRoleName = (role) => { switch(role) { case 'ROLE_ADMIN': return 'Administrador'; case 'ROLE_INVESTIGADOR': return 'Investigador'; case 'ROLE_MEDICO': return 'Médico'; case 'ROLE_ESTUDIANTE': return 'Estudiante'; case 'ROLE_VISUALIZADOR': return 'Visualizador'; default: return role; } };

    return (
        <Container fluid className="p-4 page-container-fixed d-flex flex-column">

            <div>
                <h2 className="mb-0">GESTIÓN DE USUARIOS</h2>
                <div className="d-flex gap-3 w-100 w-md-auto justify-content-end">
                    <InputGroup style={{ maxWidth: '300px' }} className="search-bar-custom">
                        <InputGroup.Text className="bg-transparent border-end-0" style={{color: 'var(--text-muted)', borderColor: 'var(--border-color)'}}><Search /></InputGroup.Text>
                        <Form.Control placeholder="Buscar..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="shadow-none border-start-0" style={{backgroundColor: 'transparent', borderColor: 'var(--border-color)', color: 'var(--text-main)'}} />
                    </InputGroup>
                    <Button variant="primary" onClick={openCreateModal} className="d-flex align-items-center gap-2 text-nowrap"><PlusLg /> Nuevo</Button>
                </div>
            </div>

            <div className="flex-grow-1 overflow-auto p-3">
                <div className="table-responsive rounded border border-secondary border-opacity-25">
                    <Table hover className="mb-0 align-middle text-nowrap bg-transparent">
                        <thead className="bg-light">
                        <tr><th>RUT</th><th>Nombre</th><th className="text-center">Rol</th><th>Email</th><th>Teléfono</th><th className="text-center">Estado</th><th className="text-end">Acciones</th></tr>
                        </thead>
                        <tbody>
                        {isLoading ? <tr><td colSpan="7" className="text-center py-5"><Spinner animation="border" /></td></tr> : currentUsers.length === 0 ? <tr><td colSpan="7" className="text-center py-5 text-muted">Sin resultados.</td></tr> :
                            currentUsers.map(u => (
                                <tr key={u.usuarioId} style={{ opacity: u.estadoU === 'ACTIVO' ? 1 : 0.6 }}>
                                    <td className="fw-bold">{u.rut}</td><td>{u.nombres} {u.apellidos}</td>
                                    <td className="text-center"><Badge bg="info" text="dark" className="badge-rol">{formatRoleName(u.rol)}</Badge></td>
                                    <td>{u.email}</td><td>{u.telefono || '-'}</td>
                                    <td className="text-center"><Badge bg={u.estadoU === 'ACTIVO' ? 'success' : 'secondary'} className="badge-estado">{u.estadoU === 'ACTIVO' ? 'Activo' : 'Inactivo'}</Badge></td>
                                    <td className="text-end">
                                        <Button variant="outline-primary" size="sm" className="me-2" onClick={() => openEditModal(u)}><PencilSquare /></Button>
                                        <Button variant={u.estadoU === 'ACTIVO' ? "outline-danger" : "outline-success"} size="sm" onClick={() => openStatusModal(u)}>{u.estadoU === 'ACTIVO' ? <Trash /> : <ArrowCounterclockwise />}</Button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </Table>
                </div>
            </div>

            {totalPages > 1 && (
                <div className="d-flex justify-content-center p-3 flex-shrink-0">
                    <Pagination>
                        <Pagination.Prev onClick={() => paginate(currentPage - 1)} disabled={currentPage === 1} />
                        {[...Array(totalPages)].map((_, i) => <Pagination.Item key={i + 1} active={i + 1 === currentPage} onClick={() => paginate(i + 1)}>{i + 1}</Pagination.Item>)}
                        <Pagination.Next onClick={() => paginate(currentPage + 1)} disabled={currentPage === totalPages} />
                    </Pagination>
                </div>
            )}

            {/* --- FORMULARIO CON NOVALIDATE --- */}
            <Modal show={showFormModal} onHide={() => setShowFormModal(false)} backdrop="static" size="lg">
                <Modal.Header closeButton><Modal.Title>{isEditing ? 'Editar usuario' : 'Crear usuario'}</Modal.Title></Modal.Header>
                {/* 1. AGREGADO noValidate */}
                <Form onSubmit={handleSaveUser} noValidate>
                    <Modal.Body>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>RUT</Form.Label><Form.Control type="text" name="rut" value={formData.rut} onChange={handleInputChange} isInvalid={!!rutError} maxLength={12} required /><Form.Control.Feedback type="invalid">{rutError}</Form.Control.Feedback></Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Email</Form.Label>
                                {/* 2. Feedback visual */}
                                <Form.Control type="email" name="email" value={formData.email} onChange={handleInputChange} isInvalid={!!emailError} required />
                                <Form.Control.Feedback type="invalid">{emailError}</Form.Control.Feedback>
                            </Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Nombres</Form.Label><Form.Control type="text" name="nombres" value={formData.nombres} onChange={handleInputChange} required /></Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Apellidos</Form.Label><Form.Control type="text" name="apellidos" value={formData.apellidos} onChange={handleInputChange} required /></Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Teléfono</Form.Label><InputGroup><Form.Select style={{maxWidth:'120px'}} value={phoneData.code} onChange={handlePhoneCodeChange}>{COUNTRY_PHONE_DATA.map(c => <option key={c.code} value={c.code}>{c.label}</option>)}</Form.Select><Form.Control type="text" placeholder={getPhoneConfig(phoneData.code).placeholder} value={phoneData.number} onChange={handlePhoneNumberChange} /></InputGroup></Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Rol</Form.Label><Form.Select name="rol" value={formData.rol} onChange={handleInputChange}><option value="ROLE_ADMIN">Administrador</option><option value="ROLE_INVESTIGADOR">Investigador</option><option value="ROLE_MEDICO">Médico</option><option value="ROLE_ESTUDIANTE">Estudiante</option></Form.Select></Form.Group></Col>
                        </Row>
                    </Modal.Body>
                    <Modal.Footer><Button variant="secondary" onClick={() => setShowFormModal(false)}>Cancelar</Button><Button variant="primary" type="submit">{isEditing ? 'Actualizar' : 'Guardar'}</Button></Modal.Footer>
                </Form>
            </Modal>

            <Modal show={showStatusModal} onHide={() => setShowStatusModal(false)}>
                <Modal.Header closeButton><Modal.Title>Confirmar</Modal.Title></Modal.Header>
                <Modal.Body>{statusAction === 'desactivar' ? '¿Desactivar usuario?' : '¿Reactivar usuario?'}</Modal.Body>
                <Modal.Footer><Button variant="secondary" onClick={() => setShowStatusModal(false)}>Cancelar</Button><Button variant={statusAction === 'desactivar' ? 'danger' : 'success'} onClick={handleToggleStatus}>{statusAction === 'desactivar' ? 'Desactivar' : 'Activar'}</Button></Modal.Footer>
            </Modal>

            <ToastContainer position="bottom-end" className="p-3"><Toast onClose={() => setToastConfig({ ...toastConfig, show: false })} show={toastConfig.show} delay={4000} autohide bg={toastConfig.variant}><Toast.Header closeButton={true}><strong className="me-auto">Notificación</strong></Toast.Header><Toast.Body className="text-white">{toastConfig.message}</Toast.Body></Toast></ToastContainer>
        </Container>
    );
};
export default UserManagement;