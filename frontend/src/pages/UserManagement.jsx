import { useState, useEffect } from 'react';
import { Table, Button, Modal, Form, Container, Row, Col, Badge, Spinner, Alert, Pagination, InputGroup, Toast, ToastContainer } from 'react-bootstrap';
import { PencilSquare, Trash, PlusLg, Search, ArrowCounterclockwise, CheckCircle, ExclamationCircle } from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut, validateRut } from '../utils/rutUtils';
import { COUNTRY_PHONE_DATA, getPhoneConfig } from '../utils/phoneUtils';

const UserManagement = () => {
    const [users, setUsers] = useState([]);
    const [isLoading, setIsLoading] = useState(false);

    // Estados de Error
    const [rutError, setRutError] = useState(null);
    const [emailError, setEmailError] = useState(null); // <--- NUEVO ESTADO DE ERROR

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
    const itemsPerPage = 5;

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

        // Limpiar errores al escribir
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
        setEmailError(null); // Resetear error
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
        setEmailError(null); // Resetear error
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

        // 1. Validación de RUT
        if (!validateRut(formData.rut)) {
            setRutError('RUT inválido.');
            return;
        }

        // 2. Validación de Email (Regex estándar) [NUEVO]
        // Formato: algo + @ + algo + . + algo (ej: nombre@dominio.cl)
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(formData.email)) {
            setEmailError('El formato del correo no es válido (ej: usuario@dominio.com).');
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
        <Container fluid className="p-0 position-relative" style={{minHeight: '100%'}}>
            <Row className="mb-4 align-items-center">
                <Col md={5}>
                    <h2 className="mb-0">GESTIÓN DE USUARIOS</h2>
                </Col>
                <Col md={7} className="d-flex justify-content-end gap-3">
                    <InputGroup style={{ maxWidth: '300px' }} className="search-bar-custom">
                        <InputGroup.Text className="bg-transparent border-end-0" style={{color: 'var(--text-muted)', borderColor: 'var(--border-color)'}}>
                            <Search />
                        </InputGroup.Text>
                        <Form.Control
                            placeholder="Buscar..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="shadow-none border-start-0"
                            style={{
                                backgroundColor: 'transparent',
                                borderColor: 'var(--border-color)',
                                color: 'var(--text-main)'
                            }}
                        />
                    </InputGroup>

                    <Button variant="primary" onClick={openCreateModal} className="d-flex align-items-center gap-2 text-nowrap">
                        <PlusLg /> Nuevo Usuario
                    </Button>
                </Col>
            </Row>

            <div className="table-responsive rounded border border-secondary border-opacity-25">
                <Table hover className="mb-0 align-middle text-nowrap">
                    <thead className="bg-light">
                    <tr>
                        <th>RUT</th>
                        <th>Nombre Completo</th>
                        <th className="text-center">Rol</th>
                        <th>Email</th>
                        <th>Teléfono</th>
                        <th className="text-center">Estado</th>
                        <th className="text-end">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    {isLoading ? (
                        <tr><td colSpan="7" className="text-center py-5"><Spinner animation="border" /></td></tr>
                    ) : currentUsers.length === 0 ? (
                        <tr><td colSpan="7" className="text-center py-5 text-muted" style={{color: 'var(--text-muted)'}}>
                            {searchTerm ? 'No se encontraron resultados.' : 'No hay usuarios registrados.'}
                        </td></tr>
                    ) : (
                        currentUsers.map((user) => {
                            const isActive = user.estadoU === 'ACTIVO' || user.estadoU === true;
                            return (
                                <tr key={user.usuarioId} style={{ opacity: isActive ? 1 : 0.6 }}>
                                    <td className="fw-bold">{user.rut}</td>
                                    <td>{user.nombres} {user.apellidos}</td>
                                    <td className="text-center">
                                        <Badge bg="info" text="dark" className="badge-rol">
                                            {formatRoleName(user.rol)}
                                        </Badge>
                                    </td>
                                    <td>{user.email}</td>
                                    <td>{user.telefono || '-'}</td>
                                    <td className="text-center">
                                        {isActive
                                            ? <Badge bg="success" className="badge-estado">Activo</Badge>
                                            : <Badge bg="secondary" className="badge-estado">Inactivo</Badge>}
                                    </td>
                                    <td className="text-end">
                                        <Button variant="outline-primary" size="sm" className="me-2" onClick={() => openEditModal(user)}>
                                            <PencilSquare />
                                        </Button>
                                        {isActive ? (
                                            <Button variant="outline-danger" size="sm" onClick={() => openStatusModal(user)} title="Desactivar usuario">
                                                <Trash />
                                            </Button>
                                        ) : (
                                            <Button variant="outline-success" size="sm" onClick={() => openStatusModal(user)} title="Reactivar usuario">
                                                <ArrowCounterclockwise />
                                            </Button>
                                        )}
                                    </td>
                                </tr>
                            );
                        })
                    )}
                    </tbody>
                </Table>
            </div>

            {filteredUsers.length > itemsPerPage && (
                <div className="d-flex justify-content-center mt-4">
                    <Pagination>
                        <Pagination.Prev onClick={() => paginate(currentPage - 1)} disabled={currentPage === 1} />
                        {[...Array(totalPages)].map((_, index) => (
                            <Pagination.Item key={index + 1} active={index + 1 === currentPage} onClick={() => paginate(index + 1)}>
                                {index + 1}
                            </Pagination.Item>
                        ))}
                        <Pagination.Next onClick={() => paginate(currentPage + 1)} disabled={currentPage === totalPages} />
                    </Pagination>
                </div>
            )}

            <Modal show={showFormModal} onHide={() => setShowFormModal(false)} backdrop="static" size="lg">
                <Modal.Header closeButton><Modal.Title>{isEditing ? 'Editar' : 'Crear'}</Modal.Title></Modal.Header>
                <Form onSubmit={handleSaveUser}>
                    <Modal.Body>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>RUT (*)</Form.Label>
                                <Form.Control type="text" name="rut" value={formData.rut} onChange={handleInputChange} isInvalid={!!rutError} maxLength={12} placeholder="12.345.678-9" required />
                                <Form.Control.Feedback type="invalid">{rutError}</Form.Control.Feedback>
                            </Form.Group></Col>

                            {/* --- 3. INPUT DE EMAIL CON VALIDACIÓN VISUAL --- */}
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Email (*)</Form.Label>
                                <Form.Control
                                    type="email"
                                    name="email"
                                    value={formData.email}
                                    onChange={handleInputChange}
                                    isInvalid={!!emailError} // Borde rojo si hay error
                                    required
                                />
                                <Form.Control.Feedback type="invalid">{emailError}</Form.Control.Feedback>
                            </Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Nombres (*)</Form.Label><Form.Control type="text" name="nombres" value={formData.nombres} onChange={handleInputChange} required /></Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Apellidos (*)</Form.Label><Form.Control type="text" name="apellidos" value={formData.apellidos} onChange={handleInputChange} required /></Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}>
                                <Form.Group className="mb-3">
                                    <Form.Label>Teléfono</Form.Label>
                                    <InputGroup>
                                        <Form.Select
                                            value={phoneData.code}
                                            onChange={handlePhoneCodeChange}
                                            style={{ maxWidth: '120px', borderRight: 'none', backgroundColor: 'var(--bg-input)', color: 'var(--text-main)' }}
                                        >
                                            {COUNTRY_PHONE_DATA.map((c) => (
                                                <option key={c.code} value={c.code}>{c.label}</option>
                                            ))}
                                        </Form.Select>
                                        <Form.Control
                                            type="text"
                                            placeholder={getPhoneConfig(phoneData.code).placeholder}
                                            value={phoneData.number}
                                            onChange={handlePhoneNumberChange}
                                            maxLength={15}
                                            style={{ borderLeft: '1px solid var(--border-color)' }}
                                        />
                                    </InputGroup>
                                </Form.Group>
                            </Col>
                            <Col md={6}>
                                <Form.Group className="mb-3"><Form.Label>Rol (*)</Form.Label>
                                    <Form.Select name="rol" value={formData.rol} onChange={handleInputChange}>
                                        <option value="ROLE_ADMIN">Administrador</option>
                                        <option value="ROLE_INVESTIGADOR">Investigador</option>
                                        <option value="ROLE_MEDICO">Médico</option>
                                        <option value="ROLE_ESTUDIANTE">Estudiante</option>
                                    </Form.Select>
                                </Form.Group>
                            </Col>
                        </Row>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button variant="secondary" onClick={() => setShowFormModal(false)}>Cancelar</Button>
                        <Button variant="primary" type="submit">{isEditing ? 'Actualizar' : 'Guardar'}</Button>
                    </Modal.Footer>
                </Form>
            </Modal>

            <Modal show={showStatusModal} onHide={() => setShowStatusModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>
                        {statusAction === 'desactivar' ? 'Confirmar Desactivación' : 'Confirmar Reactivación'}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    {statusAction === 'desactivar'
                        ? '¿Estás seguro de que deseas desactivar este usuario? Perderá acceso al sistema.'
                        : '¿Deseas reactivar este usuario? Volverá a tener acceso al sistema.'}
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowStatusModal(false)}>Cancelar</Button>
                    <Button
                        variant={statusAction === 'desactivar' ? 'danger' : 'success'}
                        onClick={handleToggleStatus}
                    >
                        {statusAction === 'desactivar' ? 'Desactivar' : 'Activar'}
                    </Button>
                </Modal.Footer>
            </Modal>

            <ToastContainer position="bottom-end" className="p-3" style={{ zIndex: 1100, position: 'fixed' }}>
                <Toast
                    onClose={() => setToastConfig({ ...toastConfig, show: false })}
                    show={toastConfig.show}
                    delay={4000}
                    autohide
                    bg={toastConfig.variant}
                >
                    <Toast.Header closeButton={true}>
                        {toastConfig.variant === 'success' ? <CheckCircle className="text-success me-2"/> : <ExclamationCircle className="text-danger me-2"/>}
                        <strong className="me-auto">Notificación</strong>
                    </Toast.Header>
                    <Toast.Body className={toastConfig.variant === 'danger' || toastConfig.variant === 'success' ? 'text-white' : ''}>
                        {toastConfig.message}
                    </Toast.Body>
                </Toast>
            </ToastContainer>

        </Container>
    );
};

export default UserManagement;