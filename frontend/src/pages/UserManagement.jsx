import { useState, useEffect } from 'react';
import { Table, Button, Modal, Form, Container, Row, Col, Badge, Spinner, Alert, Pagination, InputGroup } from 'react-bootstrap';
import { PencilSquare, Trash, PlusLg, Search } from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut, validateRut } from '../utils/rutUtils';

const UserManagement = () => {
    // --- ESTADOS ---
    const [users, setUsers] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);
    const [rutError, setRutError] = useState(null);

    // Modales
    const [showFormModal, setShowFormModal] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [isEditing, setIsEditing] = useState(false);
    const [selectedUserId, setSelectedUserId] = useState(null);

    // Estado Formulario
    const initialFormState = {
        rut: '', nombres: '', apellidos: '', email: '', telefono: '',
        contrasena: '', activo: true, rol: 'ROLE_INVESTIGADOR'
    };
    const [formData, setFormData] = useState(initialFormState);

    // Buscador y Paginación
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 5;

    // --- CARGAR DATOS ---
    const fetchUsers = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/usuarios');
            setUsers(res.data);
        } catch (err) { setError('Error al cargar usuarios.'); }
        finally { setIsLoading(false); }
    };

    useEffect(() => { fetchUsers(); }, []);

    // --- FILTRO Y PAGINACIÓN ---
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

    useEffect(() => { setCurrentPage(1); }, [searchTerm]);

    const indexOfLastItem = currentPage * itemsPerPage;
    const indexOfFirstItem = indexOfLastItem - itemsPerPage;
    const currentUsers = filteredUsers.slice(indexOfFirstItem, indexOfLastItem);
    const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    // --- MANEJADORES ---
    const handleInputChange = (e) => {
        const { name, value, type, checked } = e.target;

        if (name === 'rut') {
            const formatted = formatRut(value);
            setFormData({ ...formData, [name]: formatted });

            if (formatted.trim() === '') {
                setRutError(null);
                return;
            }

            if (formatted.length >= 8) {
                if (validateRut(formatted)) {
                    setRutError(null);
                } else {
                    setRutError('Dígito verificador incorrecto');
                }
            } else {
                setRutError(null);
            }

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
        setSelectedUserId(user.usuarioId);
        setIsEditing(true);
        setShowFormModal(true);
        setError(null);
    };

    const openDeleteModal = (id) => { setSelectedUserId(id); setShowDeleteModal(true); };

    const handleSaveUser = async (e) => {
        e.preventDefault();
        setRutError(null); setError(null);

        if (!validateRut(formData.rut)) { setRutError('RUT inválido.'); return; }

        try {
            const dataToSend = {
                rut: formData.rut, nombres: formData.nombres, apellidos: formData.apellidos,
                email: formData.email, telefono: formData.telefono, rol: formData.rol,
                activo: true
            };

            if (isEditing) {
                await api.put(`/api/usuarios/${selectedUserId}`, dataToSend);
            } else {
                dataToSend.password = "Temporal123!";
                await api.post('/api/usuarios', dataToSend);
            }
            fetchUsers(); setShowFormModal(false);
        } catch (err) {
            const msg = err.response?.data?.message || 'Error al guardar.'; setError(msg);
        }
    };

    const handleDeleteUser = async () => { try { await api.delete(`/api/usuarios/${selectedUserId}`); fetchUsers(); setShowDeleteModal(false); } catch (err) { setError('Error al eliminar.'); } };
    const formatRoleName = (role) => { switch(role) { case 'ROLE_ADMIN': return 'Administrador'; case 'ROLE_INVESTIGADOR': return 'Investigador'; case 'ROLE_MEDICO': return 'Médico'; case 'ROLE_ESTUDIANTE': return 'Estudiante'; default: return role; } };

    return (
        <Container fluid className="p-0">
            {/* HEADER CON BUSCADOR REINTEGRADO */}
            <Row className="mb-4 align-items-center">
                <Col md={5}>
                    <h2 className="mb-0">GESTIÓN DE USUARIOS</h2>
                </Col>
                <Col md={7} className="d-flex justify-content-end gap-3">

                    {/* --- BUSCADOR --- */}
                    <InputGroup style={{ maxWidth: '300px' }}>
                        <InputGroup.Text
                            className="bg-transparent text-muted"
                            style={{ borderColor: '#2c3e50', borderRight: 'none' }}
                        >
                            <Search />
                        </InputGroup.Text>
                        <Form.Control
                            placeholder=" Buscar..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="ps-0 shadow-none"
                            style={{
                                borderColor: '#2c3e50',
                                borderLeft: 'none',
                                color: 'white',
                                backgroundColor: 'transparent'
                            }}
                        />
                    </InputGroup>

                    <Button variant="primary" onClick={openCreateModal} className="d-flex align-items-center gap-2 text-nowrap">
                        <PlusLg /> Nuevo Usuario
                    </Button>
                </Col>
            </Row>

            {error && <Alert variant="danger" onClose={() => setError(null)} dismissible>{error}</Alert>}

            {/* TABLA */}
            <div className="table-responsive rounded border border-secondary border-opacity-25">
                <Table hover className="mb-0 align-middle text-nowrap">
                    <thead className="bg-light">
                    <tr>
                        <th>RUT</th>
                        <th>Nombre Completo</th>
                        <th>Rol</th>
                        <th>Email</th>
                        <th>Teléfono</th>
                        <th>Estado</th>
                        <th className="text-end">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    {isLoading ? (
                        <tr><td colSpan="7" className="text-center py-5"><Spinner animation="border" /></td></tr>
                    ) : currentUsers.length === 0 ? (
                        <tr><td colSpan="7" className="text-center py-5 text-muted">
                            {searchTerm ? 'No se encontraron resultados.' : 'No hay usuarios registrados.'}
                        </td></tr>
                    ) : (
                        currentUsers.map((user) => (
                            <tr key={user.usuarioId}>
                                <td className="fw-bold">{user.rut}</td>
                                <td>{user.nombres} {user.apellidos}</td>
                                <td><Badge bg="info" text="dark">{formatRoleName(user.rol)}</Badge></td>
                                <td>{user.email}</td>
                                <td>{user.telefono || '-'}</td>
                                <td>
                                    {(user.estadoU === 'ACTIVO' || user.estadoU === true)
                                        ? <Badge bg="success">Activo</Badge>
                                        : <Badge bg="secondary">Inactivo</Badge>}
                                </td>
                                <td className="text-end">
                                    <Button variant="outline-primary" size="sm" className="me-2" onClick={() => openEditModal(user)}>
                                        <PencilSquare />
                                    </Button>
                                    <Button variant="outline-danger" size="sm" onClick={() => openDeleteModal(user.usuarioId)}>
                                        <Trash />
                                    </Button>
                                </td>
                            </tr>
                        ))
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

            {/* MODALES */}
            <Modal show={showFormModal} onHide={() => setShowFormModal(false)} backdrop="static" size="lg">
                <Modal.Header closeButton><Modal.Title>{isEditing ? 'Editar' : 'Crear'}</Modal.Title></Modal.Header>
                <Form onSubmit={handleSaveUser}>
                    <Modal.Body>
                        <Row>
                            <Col md={6}><Form.Group className="mb-3"><Form.Label>RUT (*)</Form.Label>
                                <Form.Control type="text" name="rut" value={formData.rut} onChange={handleInputChange} isInvalid={!!rutError} required />
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

            <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)}>
                <Modal.Header closeButton><Modal.Title>Confirmar Eliminación</Modal.Title></Modal.Header>
                <Modal.Body>¿Estás seguro?</Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>Cancelar</Button>
                    <Button variant="danger" onClick={handleDeleteUser}>Eliminar</Button>
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default UserManagement;