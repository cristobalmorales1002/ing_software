import { useState, useEffect } from 'react';
import { Table, Button, Modal, Form, Container, Row, Col, Badge, Spinner, Alert, Pagination, InputGroup } from 'react-bootstrap';
// 1. IMPORTAMOS EL NUEVO ICONO PARA RESTAURAR
import { PencilSquare, Trash, PlusLg, Search, ArrowCounterclockwise } from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut, validateRut } from '../utils/rutUtils';

const UserManagement = () => {
    const [users, setUsers] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);
    const [rutError, setRutError] = useState(null);

    const [showFormModal, setShowFormModal] = useState(false);

    // Cambiamos el nombre del estado para que sea genérico (sirve para activar o desactivar)
    const [showStatusModal, setShowStatusModal] = useState(false);
    const [statusAction, setStatusAction] = useState('desactivar'); // 'desactivar' o 'activar'

    const [isEditing, setIsEditing] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null); // Guardamos el usuario completo, no solo el ID

    const initialFormState = {
        rut: '', nombres: '', apellidos: '', email: '', telefono: '',
        contrasena: '', activo: true, rol: 'ROLE_INVESTIGADOR'
    };
    const [formData, setFormData] = useState(initialFormState);

    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 5;

    const fetchUsers = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/usuarios');
            setUsers(res.data);
        } catch (err) { setError('Error al cargar usuarios.'); }
        finally { setIsLoading(false); }
    };

    useEffect(() => { fetchUsers(); }, []);

    // 1. FILTRADO
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

    // 2. NUEVA LÓGICA DE ORDENAMIENTO: Inactivos al final
    const sortedUsers = [...filteredUsers].sort((a, b) => {
        const isActiveA = a.estadoU === 'ACTIVO' || a.estadoU === true;
        const isActiveB = b.estadoU === 'ACTIVO' || b.estadoU === true;

        // Si A es activo y B inactivo, A va primero (-1)
        if (isActiveA && !isActiveB) return -1;
        // Si A es inactivo y B activo, B va primero (1)
        if (!isActiveA && isActiveB) return 1;
        // Si son iguales, mantenemos el orden (o podrías ordenar por nombre/rut)
        return 0;
    });

    useEffect(() => { setCurrentPage(1); }, [searchTerm]);

    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;

    // Usamos sortedUsers para la paginación en lugar de filteredUsers
    const currentUsers = sortedUsers.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(sortedUsers.length / itemsPerPage);
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    const handleInputChange = (e) => {
        const { name, value, type, checked } = e.target;
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

    const openCreateModal = () => { setFormData(initialFormState); setIsEditing(false); setRutError(null); setShowFormModal(true); setError(null); };

    const openEditModal = (user) => {
        setFormData({
            rut: user.rut,
            nombres: user.nombres,
            apellidos: user.apellidos,
            email: user.email,
            telefono: user.telefono || '',
            contrasena: '',
            activo: user.estadoU === 'ACTIVO' || user.estadoU === true,
            rol: user.rol || 'ROLE_INVESTIGADOR'
        });
        setRutError(null);
        setSelectedUser(user); // Guardamos el usuario completo
        setIsEditing(true);
        setShowFormModal(true);
        setError(null);
    };

    // 3. ABRIR MODAL DE CAMBIO DE ESTADO (ACTIVAR/DESACTIVAR)
    const openStatusModal = (user) => {
        setSelectedUser(user);
        const isActive = user.estadoU === 'ACTIVO' || user.estadoU === true;
        setStatusAction(isActive ? 'desactivar' : 'activar');
        setShowStatusModal(true);
    };

    const handleSaveUser = async (e) => {
        e.preventDefault();
        setRutError(null); setError(null);
        if (!validateRut(formData.rut)) { setRutError('RUT inválido.'); return; }
        try {
            const dataToSend = {
                rut: formData.rut, nombres: formData.nombres, apellidos: formData.apellidos,
                email: formData.email, telefono: formData.telefono, rol: formData.rol,
                activo: formData.activo // Esto respeta lo que diga el checkbox del form
            };
            if (isEditing) {
                await api.put(`/api/usuarios/${selectedUser.usuarioId}`, dataToSend);
            } else {
                dataToSend.password = "Temporal123!";
                await api.post('/api/usuarios', dataToSend);
            }
            fetchUsers(); setShowFormModal(false);
        } catch (err) {
            const msg = err.response?.data?.message || 'Error al guardar.'; setError(msg);
        }
    };

    // 4. LÓGICA DE TOGGLE (ACTIVAR/DESACTIVAR)
    // 4. LÓGICA DE TOGGLE (ACTIVAR/DESACTIVAR) ACTUALIZADA
    const handleToggleStatus = async () => {
        try {
            if (statusAction === 'desactivar') {
                // Si la acción es desactivar, llamamos al DELETE (Tu backend ejecuta desactivate)
                await api.delete(`/api/usuarios/${selectedUser.usuarioId}`);
            } else {
                // Si la acción es activar, llamamos al endpoint específico de activar
                // Nota: Asegúrate de que en tu backend la ruta sea "/{id}/activate"
                await api.put(`/api/usuarios/${selectedUser.usuarioId}/activate`);
            }

            // Recargamos la lista y cerramos el modal
            fetchUsers();
            setShowStatusModal(false);
        } catch (err) {
            console.error(err);
            setError('Error al cambiar el estado del usuario.');
        }
    };

    const formatRoleName = (role) => { switch(role) { case 'ROLE_ADMIN': return 'Administrador'; case 'ROLE_INVESTIGADOR': return 'Investigador'; case 'ROLE_MEDICO': return 'Médico'; case 'ROLE_ESTUDIANTE': return 'Estudiante'; case 'ROLE_VISUALIZADOR': return 'Visualizador'; default: return role; } };

    return (
        <Container fluid className="p-0">
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

            {error && <Alert variant="danger" onClose={() => setError(null)} dismissible>{error}</Alert>}

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
                                    {/* Bajamos opacidad si es inactivo para efecto visual */}
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

                                        {/* 5. BOTÓN DINÁMICO: BASURA O RESTAURAR */}
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

            {/* PAGINACIÓN */}
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

            {/* MODAL CREAR/EDITAR */}
            <Modal show={showFormModal} onHide={() => setShowFormModal(false)} backdrop="static" size="lg">
                <Modal.Header closeButton><Modal.Title>{isEditing ? 'Editar' : 'Crear'}</Modal.Title></Modal.Header>
                <Form onSubmit={handleSaveUser}>
                    <Modal.Body>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>RUT (*)</Form.Label>
                                <Form.Control type="text" name="rut" value={formData.rut} onChange={handleInputChange} isInvalid={!!rutError} maxLength={12} placeholder="12.345.678-9" required />
                                <Form.Control.Feedback type="invalid">{rutError}</Form.Control.Feedback>
                            </Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Email (*)</Form.Label><Form.Control type="email" name="email" value={formData.email} onChange={handleInputChange} required /></Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Nombres (*)</Form.Label><Form.Control type="text" name="nombres" value={formData.nombres} onChange={handleInputChange} required /></Form.Group></Col>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Apellidos (*)</Form.Label><Form.Control type="text" name="apellidos" value={formData.apellidos} onChange={handleInputChange} required /></Form.Group></Col>
                        </Row>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>Teléfono</Form.Label><Form.Control type="text" name="telefono" value={formData.telefono} onChange={handleInputChange} /></Form.Group></Col>
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

            {/* 6. MODAL DINÁMICO DE ACTIVACIÓN/DESACTIVACIÓN */}
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
        </Container>
    );
};

export default UserManagement;