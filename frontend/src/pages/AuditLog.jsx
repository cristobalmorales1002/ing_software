import { useState, useEffect, useCallback } from 'react';
import { Container, Row, Col, Table, Form, InputGroup, Button, Alert, Spinner, Badge, Pagination } from 'react-bootstrap';
import { Search, Calendar3, ArrowCounterclockwise } from 'react-bootstrap-icons';
import api from '../api/axios';

const AuditLog = () => {
    const [logs, setLogs] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);

    // Filtros
    const [searchTerm, setSearchTerm] = useState('');
    const [dateFilters, setDateFilters] = useState({ inicio: '', fin: '' });

    // Paginación del Backend
    const [currentPage, setCurrentPage] = useState(0);
    const [totalPages, setTotalPages] = useState(0);
    const itemsPerPage = 20;

    const fetchLogs = useCallback(async () => {
        setIsLoading(true);
        setError(null);
        try {
            // Preparamos los parámetros para Spring Boot
            const params = {
                page: currentPage,
                size: itemsPerPage,
                sort: 'registroFecha,desc' // Lo más nuevo primero
            };
            if (dateFilters.inicio) params.fechaInicio = dateFilters.inicio;
            if (dateFilters.fin) params.fechaFin = dateFilters.fin;

            const res = await api.get('/api/registros', { params });

            setLogs(res.data.content || []);
            setTotalPages(res.data.totalPages || 0);

        } catch (err) {
            console.error(err);
            setError('Error al cargar registros. Verifica tu conexión.');
        } finally {
            setIsLoading(false);
        }
    }, [currentPage, dateFilters]);

    useEffect(() => {
        fetchLogs();
    }, [fetchLogs]);

    // Handlers
    const handleDateChange = (e) => {
        setDateFilters({ ...dateFilters, [e.target.name]: e.target.value });
        setCurrentPage(0);
    };

    const clearFilters = () => {
        setDateFilters({ inicio: '', fin: '' });
        setSearchTerm('');
        setCurrentPage(0);
    };

    // Filtrado visual (texto)
    const filteredLogs = logs.filter(log => {
        if (!searchTerm) return true;
        const term = searchTerm.toLowerCase();
        return (
            (log.nombreUsuario && log.nombreUsuario.toLowerCase().includes(term)) ||
            (log.accion && log.accion.toLowerCase().includes(term)) ||
            (log.detalles && log.detalles.toLowerCase().includes(term))
        );
    });

    const formatDate = (dateString) => {
        if (!dateString) return '-';
        return new Date(dateString).toLocaleString('es-CL');
    };

    const getActionBadge = (accion) => {
        let variant = 'secondary';
        if (accion.includes('CREAR')) variant = 'success';
        if (accion.includes('EDITAR') || accion.includes('ACTUALIZAR')) variant = 'warning';
        if (accion.includes('ELIMINAR') || accion.includes('ARCHIVAR')) variant = 'danger';
        return <Badge bg={variant} text="dark">{accion}</Badge>;
    };

    return (
        <Container fluid className="p-0">
            <Row className="mb-4 align-items-center">
                <Col md={4}><h2 className="mb-0">REGISTRO DE AUDITORÍA</h2></Col>
                <Col md={8} className="d-flex justify-content-end gap-2 flex-wrap">
                    <InputGroup className="w-auto">
                        <InputGroup.Text className="bg-dark text-secondary border-secondary"><Calendar3 /></InputGroup.Text>
                        <Form.Control type="date" name="inicio" value={dateFilters.inicio} onChange={handleDateChange} className="bg-transparent text-white border-secondary shadow-none" />
                        <Form.Control type="date" name="fin" value={dateFilters.fin} onChange={handleDateChange} className="bg-transparent text-white border-secondary shadow-none" />
                    </InputGroup>
                    <InputGroup style={{ maxWidth: '250px' }}>
                        <InputGroup.Text className="bg-transparent text-muted border-secondary"><Search /></InputGroup.Text>
                        <Form.Control placeholder="Buscar..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="bg-transparent text-white border-secondary shadow-none" />
                    </InputGroup>
                    <Button variant="outline-secondary" onClick={clearFilters}><ArrowCounterclockwise /></Button>
                </Col>
            </Row>

            {error && <Alert variant="danger" dismissible onClose={()=>setError(null)}>{error}</Alert>}

            <div className="table-responsive rounded border border-secondary border-opacity-25">
                <Table hover className="mb-0 align-middle text-nowrap" style={{backgroundColor: 'transparent'}}>
                    <thead className="bg-light bg-opacity-10">
                    <tr><th>Fecha</th><th>Usuario</th><th>Acción</th><th>Detalles</th><th>ID Ref.</th></tr>
                    </thead>
                    <tbody>
                    {isLoading ? <tr><td colSpan="5" className="text-center py-5"><Spinner animation="border" variant="info"/></td></tr> :
                        filteredLogs.length === 0 ? <tr><td colSpan="5" className="text-center py-5 text-muted">Sin registros.</td></tr> :
                            filteredLogs.map(log => (
                                <tr key={log.id}>
                                    <td className="font-monospace small text-info">{formatDate(log.fecha)}</td>
                                    <td className="fw-bold">{log.nombreUsuario}</td>
                                    <td>{getActionBadge(log.accion)}</td>
                                    <td className="text-wrap" style={{maxWidth:'400px'}}><small>{log.detalles}</small></td>
                                    <td>{log.idRespuestaAfectada || '-'}</td>
                                </tr>
                            ))}
                    </tbody>
                </Table>
            </div>

            {totalPages > 1 && (
                <div className="d-flex justify-content-center mt-4">
                    <Pagination>
                        <Pagination.Prev onClick={() => setCurrentPage(p => Math.max(0, p - 1))} disabled={currentPage === 0} />
                        <Pagination.Item active>{currentPage + 1}</Pagination.Item>
                        <Pagination.Next onClick={() => setCurrentPage(p => Math.min(totalPages - 1, p + 1))} disabled={currentPage === totalPages - 1} />
                    </Pagination>
                </div>
            )}
        </Container>
    );
};
export default AuditLog;