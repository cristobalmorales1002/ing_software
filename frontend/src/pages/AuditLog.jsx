import { useState, useEffect, useCallback } from 'react';
import { Container, Row, Col, Table, Form, InputGroup, Button, Alert, Spinner, Badge, Pagination } from 'react-bootstrap';
import { Search, ArrowCounterclockwise, Calendar3 } from 'react-bootstrap-icons';
import api from '../api/axios';

const AuditLog = () => {
    const [logs, setLogs] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState(null);

    const [searchTerm, setSearchTerm] = useState('');
    const [dateFilters, setDateFilters] = useState({ inicio: '', fin: '' });

    const [currentPage, setCurrentPage] = useState(0);
    const [totalPages, setTotalPages] = useState(0);

    const itemsPerPage = 14;

    const fetchLogs = useCallback(async () => {
        setIsLoading(true);
        setError(null);
        try {
            const params = {
                page: currentPage,
                size: itemsPerPage,
                sort: 'registroFecha,desc'
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

    useEffect(() => { fetchLogs(); }, [fetchLogs]);

    const handleDateChange = (e) => {
        setDateFilters({ ...dateFilters, [e.target.name]: e.target.value });
        setCurrentPage(0);
    };

    const clearFilters = () => {
        setDateFilters({ inicio: '', fin: '' });
        setSearchTerm('');
        setCurrentPage(0);
    };

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
        const baseClass = "badge-audit-fixed";
        if (accion.includes('CREAR')) return <Badge className={`${baseClass} badge-audit-create`}>{accion}</Badge>;
        if (accion.includes('EDITAR') || accion.includes('ACTUALIZAR')) return <Badge bg="warning" text="dark" className={baseClass}>{accion}</Badge>;
        if (accion.includes('ELIMINAR') || accion.includes('ARCHIVAR')) return <Badge bg="danger" className={baseClass}>{accion}</Badge>;
        return <Badge bg="secondary" className={baseClass}>{accion}</Badge>;
    };

    const renderPaginationItems = () => {
        let items = [];
        const maxButtons = 10;
        let startPage = Math.max(0, currentPage - 4);
        let endPage = Math.min(totalPages, startPage + maxButtons);

        if (endPage - startPage < maxButtons) startPage = Math.max(0, endPage - maxButtons);

        for (let number = startPage; number < endPage; number++) {
            items.push(
                <Pagination.Item key={number} active={number === currentPage} onClick={() => setCurrentPage(number)}>
                    {number + 1}
                </Pagination.Item>
            );
        }
        return items;
    };

    return (
        <Container fluid className="p-0 d-flex flex-column" style={{height: 'calc(100vh - 100px)'}}>

            {/* HEADER */}
            <Row className="mb-4 align-items-center flex-shrink-0">
                <Col md={4}><h2 className="mb-0">REGISTRO DE AUDITORÍA</h2></Col>

                <Col md={8} className="d-flex justify-content-end gap-3 align-items-center">

                    {/* --- BLOQUE DE FECHAS VERTICAL --- */}
                    <div className="d-flex flex-column gap-1">
                        {/* Fila 1: Desde */}
                        <InputGroup size="sm" className="search-bar-custom shadow-sm" style={{width: '200px'}}>
                            <InputGroup.Text className="bg-transparent border-secondary border-opacity-25 text-muted fw-bold" style={{width: '60px'}}>
                                Desde
                            </InputGroup.Text>
                            <Form.Control
                                type="date"
                                name="inicio"
                                value={dateFilters.inicio}
                                onChange={handleDateChange}
                                className="bg-transparent border-secondary border-opacity-25 shadow-none text-center"
                                style={{color: 'var(--text-main)', fontSize: '0.85rem'}}
                            />
                        </InputGroup>

                        {/* Fila 2: Hasta */}
                        <InputGroup size="sm" className="search-bar-custom shadow-sm" style={{width: '200px'}}>
                            <InputGroup.Text className="bg-transparent border-secondary border-opacity-25 text-muted fw-bold" style={{width: '60px'}}>
                                Hasta
                            </InputGroup.Text>
                            <Form.Control
                                type="date"
                                name="fin"
                                value={dateFilters.fin}
                                onChange={handleDateChange}
                                className="bg-transparent border-secondary border-opacity-25 shadow-none text-center"
                                style={{color: 'var(--text-main)', fontSize: '0.85rem'}}
                            />
                        </InputGroup>
                    </div>

                    {/* Separador visual (Icono Grande) */}
                    <div className="text-muted opacity-25">
                        <Calendar3 size={24} />
                    </div>

                    {/* Buscador */}
                    <InputGroup style={{ maxWidth: '250px' }} className="search-bar-custom shadow-sm">
                        <InputGroup.Text className="bg-transparent text-muted border-secondary"><Search /></InputGroup.Text>
                        <Form.Control
                            placeholder="Buscar..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="bg-transparent text-body border-secondary shadow-none"
                        />
                    </InputGroup>

                    <Button variant="outline-secondary" onClick={clearFilters} title="Limpiar Filtros"><ArrowCounterclockwise /></Button>
                </Col>
            </Row>

            {error && <Alert variant="danger" dismissible onClose={()=>setError(null)}>{error}</Alert>}

            {/* TABLA */}
            <div className="table-responsive rounded border border-secondary border-opacity-25 flex-grow-1">
                <Table hover className="mb-0 align-middle text-nowrap" style={{backgroundColor: 'transparent'}}>
                    <thead className="bg-light bg-opacity-10">
                    <tr><th>Fecha / Hora</th><th>Usuario</th><th>Acción</th><th>Detalles</th><th>ID Ref.</th></tr>
                    </thead>
                    <tbody>
                    {isLoading ? <tr><td colSpan="5" className="text-center py-5"><Spinner animation="border" variant="info"/></td></tr> :
                        filteredLogs.length === 0 ? <tr><td colSpan="5" className="text-center py-5 text-muted">Sin registros.</td></tr> :
                            filteredLogs.map(log => (
                                <tr key={log.id}>
                                    <td className="font-monospace small text-info">{formatDate(log.fecha)}</td>
                                    <td className="fw-bold">{log.nombreUsuario}</td>
                                    <td>{getActionBadge(log.accion)}</td>
                                    <td className="text-wrap" style={{maxWidth:'400px', whiteSpace: 'normal'}}><small>{log.detalles}</small></td>
                                    <td>{log.idRespuestaAfectada || '-'}</td>
                                </tr>
                            ))}
                    </tbody>
                </Table>
            </div>

            <div className="d-flex justify-content-center mt-3 flex-shrink-0">
                {totalPages > 1 && (
                    <Pagination>
                        <Pagination.Prev onClick={() => setCurrentPage(p => Math.max(0, p - 1))} disabled={currentPage === 0} />
                        {renderPaginationItems()}
                        <Pagination.Next onClick={() => setCurrentPage(p => Math.min(totalPages - 1, p + 1))} disabled={currentPage === totalPages - 1} />
                    </Pagination>
                )}
            </div>
        </Container>
    );
};
export default AuditLog;