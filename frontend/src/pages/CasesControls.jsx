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

    // Estados del Modal (Wizard)
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
                id: `P-${p.participante_id}`,
                tipo: p.esCaso ? 'CASO' : 'CONTROL',
                nombre: `${p.nombres} ${p.apellidos}`,
                rut: p.rut,
                fechaIngreso: p.fechaCreacion || '-',
                estado: p.activo ? 'Activo' : 'Inactivo',
                respuestas: p.respuestas || [] // Aquí asumimos que el backend manda las respuestas
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

            // Si la API falla, usamos arrays vacíos para no romper el map
            const cats = Array.isArray(resCat.data) ? resCat.data : [];
            const vars = Array.isArray(resVar.data) ? resVar.data : [];

            const structure = cats.map(cat => ({
                ...cat,
                preguntas: vars.filter(v => v.categoriaId === cat.id_cat).sort((a, b) => a.orden - b.orden)
            })).filter(c => c.preguntas.length > 0).sort((a, b) => a.orden - b.orden);

            setSurveyStructure(structure);
        } catch (err) {
            console.error("Error cargando estructura", err);
            // Fallback para que puedas ver el modal aunque falle la API
            setSurveyStructure([
                { nombre: 'Datos Demográficos', preguntas: [{ pregunta_id: 1, etiqueta: 'RUT', tipo_dato: 'RUT' }, { pregunta_id: 2, etiqueta: 'Nombre', tipo_dato: 'TEXTO' }] },
                { nombre: 'Antecedentes', preguntas: [{ pregunta_id: 3, etiqueta: 'Fuma', tipo_dato: 'BOOLEANO' }] }
            ]);
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
        const matchText = item.id.toLowerCase().includes(term) || item.nombre.toLowerCase().includes(term);
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
        console.log("Guardando...", formData);
        // await api.post(...)
        setShowModal(false);
        fetchPacientes();
    };

    const currentCat = surveyStructure[currentStep];
    const progress = Math.round(((currentStep + 1) / surveyStructure.length) * 100);

    return (
        <Container fluid className="p-0 d-flex flex-column" style={{ height: 'calc(100vh - 100px)' }}>
            {/* ESTILO LOCAL PARA FORZAR EL INPUT TRANSPARENTE */}
            <style>{`
                #caseSearchInput { 
                    background-color: transparent !important; 
                    color: white !important; 
                    border-left: none !important;
                }
                #caseSearchInput::placeholder { color: #adb5bd !important; }
            `}</style>

            {/* HEADER */}
            <div className="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                <h2 className="mb-0">CASOS Y CONTROLES</h2>
                <div className="d-flex gap-2">
                    <Button variant="outline-info" onClick={() => handleOpenModal(false)} className="d-flex align-items-center gap-2">
                        <PlusLg /> Nuevo Control
                    </Button>
                    <Button variant="primary" onClick={() => handleOpenModal(true)} className="d-flex align-items-center gap-2">
                        <PlusLg /> Nuevo Caso
                    </Button>
                </div>
            </div>

            <Row className="flex-grow-1 overflow-hidden">
                {/* --- IZQUIERDA --- */}
                <Col md={4} lg={3} className="d-flex flex-column h-100">
                    <div className="bg-dark-subtle p-3 rounded-top border border-secondary border-opacity-25 border-bottom-0">
                        <InputGroup className="mb-2">
                            <InputGroup.Text className="bg-transparent text-muted" style={{ borderColor: '#495057', borderRight: 'none' }}>
                                <Search />
                            </InputGroup.Text>
                            {/* INPUT CON ID PARA APLICAR ESTILO FORZADO */}
                            <Form.Control
                                id="caseSearchInput"
                                placeholder="Buscar..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="shadow-none"
                                style={{ borderColor: '#495057' }}
                            />
                        </InputGroup>

                        <div className="d-flex gap-3 px-1 justify-content-center">
                            <label className="d-flex align-items-center gap-2 small text-muted" style={{ cursor: 'pointer' }}>
                                <Form.Check type="checkbox" name="showCasos" checked={filters.showCasos} onChange={handleFilterChange} className="m-0" style={{ pointerEvents: 'none' }} readOnly />
                                Casos
                            </label>
                            <label className="d-flex align-items-center gap-2 small text-muted" style={{ cursor: 'pointer' }}>
                                <Form.Check type="checkbox" name="showControles" checked={filters.showControles} onChange={handleFilterChange} className="m-0" style={{ pointerEvents: 'none' }} readOnly />
                                Controles
                            </label>
                        </div>
                    </div>

                    <div className="flex-grow-1 overflow-auto rounded-bottom border border-secondary border-opacity-25 bg-dark bg-opacity-25">
                        <ListGroup variant="flush">
                            {filteredItems.length === 0 ? (
                                <div className="text-center p-4 text-muted small">No hay registros</div>
                            ) : (
                                filteredItems.map(item => (
                                    <ListGroup.Item key={item.dbId} action active={selectedItem && selectedItem.dbId === item.dbId} onClick={() => setSelectedItem(item)} className="d-flex justify-content-between align-items-center py-3 border-bottom border-secondary border-opacity-25" style={{ backgroundColor: selectedItem?.dbId === item.dbId ? 'rgba(77, 168, 218, 0.15)' : 'transparent', color: selectedItem?.dbId === item.dbId ? '#4da8da' : '#e0e6ed', cursor: 'pointer', borderLeft: selectedItem?.dbId === item.dbId ? '4px solid #4da8da' : '4px solid transparent' }}>
                                        <span className="fw-bold font-monospace">{item.id}</span>
                                        <Badge bg={item.tipo === 'CASO' ? 'danger' : 'success'} className="opacity-75 rounded-pill">{item.tipo}</Badge>
                                    </ListGroup.Item>
                                ))
                            )}
                        </ListGroup>
                    </div>
                </Col>

                {/* --- DERECHA (DETALLE) --- */}
                <Col md={8} lg={9} className="h-100 overflow-auto pb-4">
                    {selectedItem ? (
                        <Card className="border-secondary border-opacity-25 shadow-sm bg-transparent h-100">
                            <Card.Header className="d-flex justify-content-between align-items-center py-3 bg-dark-subtle border-bottom border-secondary border-opacity-25">
                                <div>
                                    <h3 className="mb-0 text-white d-flex align-items-center gap-3"><PersonVcard className="text-info"/> {selectedItem.nombre}</h3>
                                    <small className="text-muted font-monospace">{selectedItem.id} • Ingreso: {selectedItem.fechaIngreso}</small>
                                </div>
                                <Badge bg={selectedItem.tipo === 'CASO' ? 'danger' : 'success'} className="fs-6">{selectedItem.tipo}</Badge>
                            </Card.Header>

                            <Card.Body className="p-0">
                                {/* TABLA LIMPIA DE PREGUNTA / RESPUESTA */}
                                <div className="table-responsive">
                                    <Table hover className="mb-0 align-middle text-white" style={{ backgroundColor: 'transparent' }}>
                                        <thead className="bg-dark bg-opacity-50">
                                        <tr>
                                            <th style={{width: '50%', paddingLeft: '1.5rem'}}>Pregunta / Variable</th>
                                            <th style={{width: '50%'}}>Respuesta Registrada</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr><td className="ps-4 text-muted">RUT</td><td className="text-info fw-bold">{selectedItem.rut || '-'}</td></tr>
                                        {/* Aquí mapearíamos selectedItem.respuestas si existieran */}
                                        <tr><td className="ps-4 text-muted">Diagnóstico</td><td>{selectedItem.diagnostico}</td></tr>
                                        <tr><td className="ps-4 text-muted">Estado</td><td>{selectedItem.estado}</td></tr>
                                        </tbody>
                                    </Table>
                                </div>
                                <div className="p-5 text-center text-muted small border-top border-secondary border-opacity-25">
                                    <FileEarmarkMedical className="fs-1 mb-2 opacity-50"/>
                                    <p>Selecciona "Editar Datos" para completar más información de la ficha clínica.</p>
                                </div>
                            </Card.Body>
                        </Card>
                    ) : (
                        <div className="h-100 d-flex flex-column align-items-center justify-content-center text-muted opacity-50 border border-secondary border-opacity-25 rounded">
                            <ClipboardPulse style={{ fontSize: '5rem' }} className="mb-3" />
                            <h4>Selecciona un participante</h4>
                        </div>
                    )}
                </Col>
            </Row>

            {/* --- MODAL WIZARD (FORMULARIO) --- */}
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
                        <div className="text-center py-5 text-muted">No hay encuesta configurada. Ve a "Diseño de Encuestas".</div>
                    ) : (
                        <div>
                            <h5 className="mb-4 text-info border-bottom border-secondary border-opacity-25 pb-2">
                                {currentCat?.nombre}
                            </h5>
                            <Row>
                                {currentCat?.preguntas.map(q => (
                                    <Col md={12} key={q.pregunta_id} className="mb-3">
                                        <Form.Group>
                                            <Form.Label className="d-flex justify-content-between">
                                                {q.etiqueta}
                                                {q.dato_sensible && <Badge bg="warning" text="dark" style={{fontSize:'0.6em'}}>SENSIBLE</Badge>}
                                            </Form.Label>

                                            {/* Renderizado condicional de inputs */}
                                            {(() => {
                                                const val = formData[q.pregunta_id] || '';
                                                if(q.tipo_dato === 'ENUM') {
                                                    return <Form.Select value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'ENUM')}><option value="">Seleccione...</option><option value="OPC1">Opción Demo</option></Form.Select>;
                                                }
                                                if(q.tipo_dato === 'BOOLEANO') {
                                                    return <Form.Select value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'BOOLEANO')}><option value="">Seleccione...</option><option value="true">Sí</option><option value="false">No</option></Form.Select>;
                                                }
                                                if(q.tipo_dato === 'RUT') {
                                                    return <Form.Control value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'RUT')} maxLength={12} placeholder="12.345.678-9"/>;
                                                }
                                                return <Form.Control type={q.tipo_dato === 'NUMERO' ? 'number' : 'text'} value={val} onChange={e=>handleInputChange(q.pregunta_id, e.target.value, 'TEXTO')}/>;
                                            })()}

                                            {q.descripcion && <Form.Text className="text-muted small">{q.descripcion}</Form.Text>}
                                        </Form.Group>
                                    </Col>
                                ))}
                            </Row>
                        </div>
                    )}
                </Modal.Body>

                <Modal.Footer className="justify-content-between">
                    <Button variant="secondary" onClick={handlePrev} disabled={currentStep === 0}>
                        <ArrowLeft className="me-2" /> Anterior
                    </Button>
                    {currentStep === surveyStructure.length - 1 ? (
                        <Button variant="success" onClick={handleSave}>
                            <Save className="me-2" /> Guardar Ficha
                        </Button>
                    ) : (
                        <Button variant="primary" onClick={handleNext}>
                            Siguiente <ArrowRight className="ms-2" />
                        </Button>
                    )}
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default CasesControls;