import { useState, useEffect } from 'react';
import { Container, Row, Col, Form, InputGroup, Button, Card, ListGroup, Badge, Spinner, Modal, ProgressBar, Table } from 'react-bootstrap';
import { Search, PlusLg, PersonVcard, ClipboardPulse, ArrowRight, ArrowLeft, Save, FileEarmarkMedical } from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut } from '../utils/rutUtils';

const CasesControls = () => {
    // --- ESTADOS ---
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [isLoading, setIsLoading] = useState(false);

    const [filters, setFilters] = useState({ showCasos: true, showControles: true });

    // Estados del Modal
    const [showModal, setShowModal] = useState(false);
    const [isCase, setIsCase] = useState(true);
    const [surveyStructure, setSurveyStructure] = useState([]);
    const [currentStep, setCurrentStep] = useState(0);
    const [formData, setFormData] = useState({});
    const [loadingSurvey, setLoadingSurvey] = useState(false);

    // --- CARGAR DATOS ---
    const fetchPacientes = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/pacientes');
            const dataMapeada = res.data.map(p => ({
                dbId: p.participante_id,
                id: p.participanteCod || `P-${p.participante_id}`,
                tipo: p.esCaso ? 'CASO' : 'CONTROL',
                nombre: p.nombres ? `${p.nombres} ${p.apellidos}` : 'Sin Nombre',
                rut: p.rut,
                fechaIngreso: p.fechaIncl || '-',
                estado: p.activo ? 'Activo' : 'Inactivo',
                respuestas: p.respuestas || []
            }));
            setItems(dataMapeada);
            if (dataMapeada.length > 0) setSelectedItem(dataMapeada[0]);
        } catch (err) {
            console.error("Error cargando pacientes", err);
        } finally {
            setIsLoading(false);
        }
    };

    const fetchSurveyStructure = async () => {
        setLoadingSurvey(true);
        try {
            const [resCat, resVar] = await Promise.all([
                api.get('/api/categorias'),
                api.get('/api/variables')
            ]);
            const cats = Array.isArray(resCat.data) ? resCat.data : [];
            const vars = Array.isArray(resVar.data) ? resVar.data : [];

            const structure = cats.map(cat => ({
                ...cat,
                preguntas: vars.filter(v => v.categoriaId === cat.id_cat).sort((a, b) => a.orden - b.orden)
            })).filter(c => c.preguntas.length > 0).sort((a, b) => a.orden - b.orden);

            setSurveyStructure(structure);
        } catch (err) {
            console.error("Error cargando estructura", err);
            setSurveyStructure([]);
        } finally {
            setLoadingSurvey(false);
        }
    };

    useEffect(() => {
        fetchPacientes();
        fetchSurveyStructure();
    }, []);

    // --- HANDLERS ---
    const handleFilterChange = (e) => {
        const { name, checked } = e.target;
        setFilters({ ...filters, [name]: checked });
    };

    const filteredItems = items.filter(item => {
        const term = searchTerm.toLowerCase();
        const matchText = (item.id && item.id.toLowerCase().includes(term)) || (item.nombre && item.nombre.toLowerCase().includes(term));
        const matchType = (item.tipo === 'CASO' && filters.showCasos) || (item.tipo === 'CONTROL' && filters.showControles);
        return matchText && matchType;
    });

    // --- LÓGICA MODAL ---
    const handleOpenModal = (esCaso) => {
        setIsCase(esCaso);
        setFormData({});
        setCurrentStep(0);
        setShowModal(true);
    };

    const handleInputChange = (preguntaId, value, tipo) => {
        let val = value;
        if (tipo === 'RUT') val = formatRut(value);
        setFormData(prev => ({ ...prev, [preguntaId]: val }));
    };

    const handleNext = () => { if (currentStep < surveyStructure.length - 1) setCurrentStep(p => p + 1); };
    const handlePrev = () => { if (currentStep > 0) setCurrentStep(p => p - 1); };

    const handleSave = async () => {
        setShowModal(false);
        fetchPacientes();
    };

    const currentCat = surveyStructure[currentStep];
    const progress = Math.round(((currentStep + 1) / surveyStructure.length) * 100);

    return (
        <Container fluid className="p-0 d-flex flex-column" style={{ height: 'calc(100vh - 100px)' }}>

            {/* HEADER */}
            <div className="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                <h2 className="mb-0">CASOS Y CONTROLES</h2>
                <div className="d-flex gap-2">
                    <Button variant="outline-primary" onClick={() => handleOpenModal(false)}>
                        <PlusLg /> Nuevo Control
                    </Button>
                    <Button variant="primary" onClick={() => handleOpenModal(true)}>
                        <PlusLg /> Nuevo Caso
                    </Button>
                </div>
            </div>

            <Row className="flex-grow-1 overflow-hidden g-3">

                {/* --- IZQUIERDA (LISTA) --- */}
                <Col md={4} lg={3} className="d-flex flex-column h-100">
                    <Card className="h-100 shadow-sm border-0 overflow-hidden">

                        {/* Cabecera de la lista: Buscador y Filtros */}
                        <div className="p-3 border-bottom border-secondary border-opacity-25">
                            <InputGroup className="mb-3">
                                <InputGroup.Text
                                    className="bg-transparent border-secondary border-opacity-50"
                                    style={{ color: 'var(--text-muted)' }}
                                >
                                    <Search />
                                </InputGroup.Text>
                                <Form.Control
                                    placeholder="Buscar..."
                                    value={searchTerm}
                                    onChange={(e) => setSearchTerm(e.target.value)}
                                    className="border-secondary border-opacity-50 bg-transparent shadow-none"
                                    style={{
                                        borderLeft: 'none',
                                        color: 'var(--text-main)'
                                    }}
                                />
                            </InputGroup>

                            <div className="d-flex justify-content-around">
                                <Form.Check
                                    type="checkbox"
                                    label={<span className="small fw-bold" style={{color: 'var(--text-muted)'}}>Casos</span>}
                                    name="showCasos"
                                    checked={filters.showCasos}
                                    onChange={handleFilterChange}
                                    className="user-select-none"
                                />
                                <Form.Check
                                    type="checkbox"
                                    label={<span className="small fw-bold" style={{color: 'var(--text-muted)'}}>Controles</span>}
                                    name="showControles"
                                    checked={filters.showControles}
                                    onChange={handleFilterChange}
                                    className="user-select-none"
                                />
                            </div>
                        </div>

                        {/* Cuerpo de la lista con Scroll */}
                        <div className="flex-grow-1 overflow-auto">
                            <ListGroup variant="flush">
                                {filteredItems.length === 0 ? (
                                    <div className="text-center p-5" style={{ color: 'var(--text-muted)' }}>
                                        No se encontraron registros
                                    </div>
                                ) : (
                                    filteredItems.map(item => (
                                        <ListGroup.Item
                                            key={item.dbId}
                                            action
                                            active={selectedItem && selectedItem.dbId === item.dbId}
                                            onClick={() => setSelectedItem(item)}
                                            className="d-flex justify-content-between align-items-center py-3 border-bottom border-secondary border-opacity-10"
                                            style={{
                                                backgroundColor: selectedItem?.dbId === item.dbId ? 'var(--hover-bg)' : 'transparent',
                                                color: selectedItem?.dbId === item.dbId ? 'var(--accent-color)' : 'var(--text-main)',
                                                borderLeft: selectedItem?.dbId === item.dbId ? '4px solid var(--accent-color)' : '4px solid transparent',
                                                transition: 'all 0.2s'
                                            }}
                                        >
                                            <div className="d-flex flex-column">
                                                <span className="fw-bold">{item.id}</span>
                                                <small style={{fontSize: '0.75rem', opacity: 0.7}}>{item.nombre}</small>
                                            </div>
                                            <Badge bg={item.tipo === 'CASO' ? 'danger' : 'success'} pill className="opacity-75" style={{fontSize: '0.7em'}}>
                                                {item.tipo}
                                            </Badge>
                                        </ListGroup.Item>
                                    ))
                                )}
                            </ListGroup>
                        </div>
                    </Card>
                </Col>

                {/* --- DERECHA (DETALLE) --- */}
                <Col md={8} lg={9} className="h-100">
                    {selectedItem ? (
                        <Card className="h-100 shadow-sm border-0 overflow-hidden">
                            <Card.Header className="d-flex justify-content-between align-items-center py-3 border-bottom border-secondary border-opacity-25">
                                <div>
                                    <h4 className="mb-0 d-flex align-items-center gap-2">
                                        <PersonVcard className="text-primary"/> {selectedItem.nombre}
                                    </h4>
                                    <small className="text-muted font-monospace">{selectedItem.id} • Ingreso: {selectedItem.fechaIngreso}</small>
                                </div>
                                <Badge bg={selectedItem.tipo === 'CASO' ? 'danger' : 'success'} className="fs-6 px-3 py-2">
                                    {selectedItem.tipo}
                                </Badge>
                            </Card.Header>

                            <Card.Body className="p-0 overflow-auto">
                                <div className="table-responsive">
                                    <Table hover className="mb-0 align-middle">
                                        <thead className="bg-opacity-10 bg-secondary">
                                        <tr>
                                            <th className="ps-4 py-3 text-muted text-uppercase small" style={{width: '40%'}}>Variable</th>
                                            <th className="py-3 text-muted text-uppercase small">Valor Registrado</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td className="ps-4 fw-bold" style={{color: 'var(--text-muted)'}}>RUT</td>
                                            <td className="font-monospace text-primary">{selectedItem.rut || '-'}</td>
                                        </tr>
                                        <tr>
                                            <td className="ps-4 fw-bold" style={{color: 'var(--text-muted)'}}>Estado Ficha</td>
                                            <td>
                                                <Badge bg={selectedItem.estado === 'Activo' ? 'info' : 'secondary'}>
                                                    {selectedItem.estado}
                                                </Badge>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </Table>
                                </div>
                                <div className="p-5 text-center" style={{ color: 'var(--text-muted)' }}>
                                    <FileEarmarkMedical style={{ fontSize: '3rem' }} className="mb-3"/>
                                    <p>Selecciona "Editar Datos" para completar la ficha clínica.</p>
                                </div>
                            </Card.Body>
                        </Card>
                    ) : (
                        <Card className="h-100 border-0 shadow-sm d-flex align-items-center justify-content-center" style={{ color: 'var(--text-muted)' }}>
                            <div className="text-center opacity-50">
                                <ClipboardPulse style={{ fontSize: '4rem' }} className="mb-3" />
                                <h5>Selecciona un participante de la lista</h5>
                            </div>
                        </Card>
                    )}
                </Col>
            </Row>

            {/* MODAL WIZARD */}
            <Modal show={showModal} onHide={() => setShowModal(false)} backdrop="static" size="lg" centered>
                <Modal.Header closeButton>
                    <div className="w-100 me-3">
                        <Modal.Title className="mb-2 fs-5">
                            Ingresar Nuevo {isCase ? <span className="text-danger">Caso</span> : <span className="text-success">Control</span>}
                        </Modal.Title>
                        {surveyStructure.length > 0 && (
                            <div className="d-flex align-items-center gap-2 small">
                                <ProgressBar now={progress} variant={isCase ? "danger" : "success"} style={{height: '6px', flexGrow: 1}} />
                                <span className="text-muted text-nowrap">Paso {currentStep + 1}/{surveyStructure.length}</span>
                            </div>
                        )}
                    </div>
                </Modal.Header>

                <Modal.Body className="p-4" style={{ minHeight: '300px' }}>
                    {loadingSurvey ? (
                        <div className="text-center py-5"><Spinner animation="border" /></div>
                    ) : surveyStructure.length === 0 ? (

                        /* --- AQUÍ ESTÁ EL CAMBIO QUE ME PEDISTE --- */
                        <div className="text-center py-5" style={{ color: 'var(--text-muted)' }}>
                            No hay encuesta configurada.
                        </div>

                    ) : (
                        <div>
                            <h5 className="mb-4 text-primary border-bottom pb-2">{currentCat?.nombre}</h5>
                            <Row>
                                {currentCat?.preguntas.map(q => (
                                    <Col md={12} key={q.pregunta_id} className="mb-3">
                                        <Form.Group>
                                            <Form.Label className="d-flex justify-content-between">
                                                {q.etiqueta}
                                                {q.dato_sensible && <Badge bg="warning" text="dark" style={{fontSize:'0.6em'}}>SENSIBLE</Badge>}
                                            </Form.Label>
                                            {(() => {
                                                const val = formData[q.pregunta_id] || '';
                                                if(q.tipo_dato === 'ENUM') return <Form.Select value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'ENUM')}><option value="">Seleccione...</option></Form.Select>;
                                                if(q.tipo_dato === 'RUT') return <Form.Control value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'RUT')} maxLength={12} />;
                                                return <Form.Control type={q.tipo_dato === 'NUMERO' ? 'number' : 'text'} value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'TEXTO')}/>;
                                            })()}
                                        </Form.Group>
                                    </Col>
                                ))}
                            </Row>
                        </div>
                    )}
                </Modal.Body>
                <Modal.Footer className="justify-content-between">
                    <Button variant="secondary" onClick={handlePrev} disabled={currentStep === 0}><ArrowLeft className="me-2" /> Anterior</Button>
                    {currentStep === surveyStructure.length - 1 ? <Button variant="success" onClick={handleSave}><Save className="me-2" /> Guardar</Button> : <Button variant="primary" onClick={handleNext}>Siguiente <ArrowRight className="ms-2" /></Button>}
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default CasesControls;