import { useState, useEffect, useMemo } from 'react'; // <--- IMPORTANTE: AGREGAR useMemo
import { Container, Row, Col, Form, InputGroup, Button, Card, ListGroup, Badge, Spinner, Modal, ProgressBar, Table, OverlayTrigger, Tooltip } from 'react-bootstrap';
import {
    Search, PlusLg, PersonVcard, ClipboardPulse, ArrowRight, ArrowLeft,
    Save, FileEarmarkPdf, Download,
    ExclamationTriangle, QuestionCircle
} from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut } from '../utils/rutUtils';

const CasesControls = () => {
    // --- ESTADOS ---
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const [isSaving, setIsSaving] = useState(false);

    const [filters, setFilters] = useState({ showCasos: true, showControles: true });
    const [selectedIds, setSelectedIds] = useState(new Set());
    const [isDownloading, setIsDownloading] = useState(false);

    // Estados del Modal
    const [showModal, setShowModal] = useState(false);
    const [isCase, setIsCase] = useState(true);
    const [surveyStructure, setSurveyStructure] = useState([]);
    const [currentStep, setCurrentStep] = useState(0);
    const [formData, setFormData] = useState({});
    const [loadingSurvey, setLoadingSurvey] = useState(false);

    const [userRole, setUserRole] = useState(null);

    // ... (funciones fetchPacientes y fetchSurveyStructure siguen igual) ...

    // AGREGA ESTA FUNCIÓN PARA OBTENER EL ROL (Igual que en Reports.jsx)
    const fetchUserRole = async () => {
        try {
            const res = await api.get('/api/usuarios/me');
            setUserRole(res.data.rol);
        } catch (error) {
            console.error("Error al obtener rol:", error);
        }
    };

    // --- CARGAR DATOS ---
    const fetchPacientes = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/pacientes');

            if (!Array.isArray(res.data)) {
                console.error("Respuesta inválida:", res.data);
                if (typeof res.data === 'string' && res.data.startsWith('<')) {
                    alert("Sesión expirada.");
                }
                setItems([]);
                return;
            }

            const dataMapeada = res.data.map(p => ({
                dbId: p.participante_id,
                id: p.participanteCod || `P-${p.participante_id}`,
                tipo: p.esCaso ? 'CASO' : 'CONTROL',
                fechaIngreso: p.fechaIncl,
                estado: 'Activo',
                respuestas: p.respuestas || []
            }));

            setItems(dataMapeada);
            if (dataMapeada.length > 0 && !selectedItem) setSelectedItem(dataMapeada[0]);

        } catch (err) {
            console.error("Error cargando pacientes", err);
        } finally {
            setIsLoading(false);
        }
    };

    const fetchSurveyStructure = async () => {
        setLoadingSurvey(true);
        try {
            const res = await api.get('/api/encuesta/completa');
            const structure = Array.isArray(res.data) ? res.data : [];
            const structureClean = structure.map(cat => ({
                ...cat,
                preguntas: (cat.preguntas || []).sort((a, b) => a.orden - b.orden)
            })).sort((a, b) => a.orden - b.orden);

            setSurveyStructure(structureClean);
        } catch (err) {
            console.error("Error estructura", err);
            setSurveyStructure([]);
        } finally {
            setLoadingSurvey(false);
        }
    };

    const getMissingCount = (patient) => {
        if (!patient || !surveyStructure || surveyStructure.length === 0) return 0;
        const allQuestions = surveyStructure.flatMap(cat => cat.preguntas || []);
        const missing = allQuestions.filter(q => {
            const hasAnswer = patient.respuestas && patient.respuestas.some(r =>
                (r.preguntaId === q.pregunta_id) || (r.pregunta_id === q.pregunta_id)
            );
            return !hasAnswer;
        });
        return missing.length;
    };

    useEffect(() => {
        fetchPacientes();
        fetchSurveyStructure();
        fetchUserRole();
    }, []);

    const hasRole = (allowedRoles) => userRole && allowedRoles.includes(userRole);

    // 2. Filtro Inteligente
    const filteredItems = useMemo(() => {
        // Función auxiliar para quitar tildes y pasar a minúsculas
        // Esto permite que "genero" encuentre "Género"
        const normalize = (text) =>
            text ? text.toString().toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim() : "";

        const term = normalize(searchTerm);

        // 1. Filtro base por Tipo (Caso/Control)
        let result = items.filter(item =>
            (item.tipo === 'CASO' && filters.showCasos) ||
            (item.tipo === 'CONTROL' && filters.showControles)
        );

        if (!term) return result;

        // 2. DETECCIÓN DE BÚSQUEDA AVANZADA (Si hay ":")
        // Ejemplo: "edad: 56" o "sexo: fem edad: 20"
        if (term.includes(':')) {
            const rawTerm = searchTerm.toLowerCase(); // Usamos el original para el regex
            // Regex ajustado para capturar "clave: valor"
            const regex = /([a-z0-9_ñáéíóú\s]+):\s*([^:]+?)(?=\s+[a-z0-9_ñáéíóú\s]+:|$)/gi;

            let match;
            const criteria = [];

            while ((match = regex.exec(rawTerm)) !== null) {
                criteria.push({
                    key: normalize(match[1]),   // ej: "edad"
                    value: normalize(match[2])  // ej: "56"
                });
            }

            // Si falló el regex pero hay dos puntos, devolvemos vacío por seguridad
            if (criteria.length === 0) return [];

            // Obtenemos todas las preguntas planas
            const allQuestions = surveyStructure.flatMap(cat => cat.preguntas || []);

            return result.filter(patient => {
                // El paciente debe cumplir TODOS los criterios (Lógica AND)
                return criteria.every(criterion => {

                    // A. Buscar preguntas cuya ETIQUETA o CÓDIGO coincida con lo buscado
                    // Ej: Busco "edad", encuentro la pregunta con id 45 llamada "Edad del paciente"
                    const matchingQuestions = allQuestions.filter(q => {
                        const label = normalize(q.etiqueta);
                        const code = normalize(q.codigoStata);
                        return label.includes(criterion.key) || (code && code.includes(criterion.key));
                    });

                    if (matchingQuestions.length === 0) return false;

                    // B. Verificar si el paciente tiene la respuesta correcta en ALGUNA de esas preguntas
                    return matchingQuestions.some(q => {
                        // Buscamos la respuesta del paciente para esta pregunta ID
                        // IMPORTANTE: Chequeamos ambas nomenclaturas (preguntaId y pregunta_id) para evitar errores
                        const answer = patient.respuestas?.find(r =>
                            (r.preguntaId == q.pregunta_id) ||
                            (r.pregunta_id == q.pregunta_id)
                        );

                        if (!answer || !answer.valor) return false;

                        // Comparamos el valor normalizado
                        // Ej: valor en DB "56 años", búsqueda "56" -> Match
                        return normalize(answer.valor).includes(criterion.value);
                    });
                });
            });

        } else {
            // 3. BÚSQUEDA SIMPLE (Por ID)
            // Si no hay dos puntos, buscamos solo en el ID del paciente
            return result.filter(item =>
                normalize(item.id).includes(term)
            );
        }
    }, [items, searchTerm, filters, surveyStructure]);


    // --- HANDLERS UI ---
    const handleFilterChange = (e) => {
        const { name, checked } = e.target;
        setFilters({ ...filters, [name]: checked });
    };

    const handleToggleSelect = (id) => {
        const newSet = new Set(selectedIds);
        if (newSet.has(id)) newSet.delete(id); else newSet.add(id);
        setSelectedIds(newSet);
    };

    const handleSelectAll = (e) => {
        if (e.target.checked) {
            const allVisibleIds = filteredItems.map(i => i.dbId);
            setSelectedIds(new Set(allVisibleIds));
        } else {
            setSelectedIds(new Set());
        }
    };

    const handleBulkDownload = async () => {
        if (selectedIds.size === 0) return;
        setIsDownloading(true);
        try {
            const idsArray = Array.from(selectedIds);
            const response = await api.post('/api/pdf/crf/zip', idsArray, { responseType: 'blob' });
            const urlBlob = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = urlBlob;
            link.setAttribute('download', `CRFs_Lote_${new Date().toISOString().slice(0,10)}.zip`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            console.error(err);
            alert("Error al generar ZIP.");
        } finally {
            setIsDownloading(false);
        }
    };

    const handleDownloadPdf = async (pacienteId, codigo) => {
        try {
            const response = await api.get(`/api/pdf/crf/paciente/${pacienteId}`, { responseType: 'blob' });
            const urlBlob = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = urlBlob;
            link.setAttribute('download', `CRF_${codigo}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) {
            console.error(err);
            alert("Error al generar PDF.");
        }
    };

    // --- MODAL Y GUARDADO ---
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
        setIsSaving(true);
        try {
            const respuestasDTO = Object.entries(formData).map(([key, value]) => ({
                preguntaId: parseInt(key),
                valor: value
            }));
            const payload = { esCaso: isCase, respuestas: respuestasDTO };

            await api.post('/api/pacientes', payload);
            setShowModal(false);
            setFormData({});
            fetchPacientes();
        } catch (err) {
            console.error(err);
            const msg = err.response?.data?.message || "Error al guardar";
            alert(msg);
        } finally {
            setIsSaving(false);
        }
    };

    const currentCat = surveyStructure[currentStep];
    const progress = Math.round(((currentStep + 1) / surveyStructure.length) * 100);

    return (
        <Container fluid className="p-0 d-flex flex-column" style={{ height: 'calc(100vh - 100px)' }}>

            {/* HEADER */}
            <div className="d-flex justify-content-between align-items-center mb-3 flex-shrink-0">
                <h2 className="mb-0">CASOS Y CONTROLES</h2>
                <div className="d-flex gap-2">

                    {/* BOTÓN NUEVO CONTROL: Estudiante, Médico, Investigador, Admin */}
                    {hasRole(['ROLE_ESTUDIANTE', 'ROLE_MEDICO', 'ROLE_INVESTIGADOR', 'ROLE_ADMIN']) && (
                        <Button variant="outline-primary" onClick={() => handleOpenModal(false)}>
                            <PlusLg /> Nuevo Control
                        </Button>
                    )}

                    {/* BOTÓN NUEVO CASO: Solo Médico (según tu instrucción) */}
                    {/* Nota: A veces los admin también quieren entrar, si es así agrega 'ROLE_ADMIN' al array */}
                    {hasRole(['ROLE_MEDICO']) && (
                        <Button variant="primary" onClick={() => handleOpenModal(true)}>
                            <PlusLg /> Nuevo Caso
                        </Button>
                    )}

                </div>
            </div>

            <Row className="flex-grow-1 overflow-hidden g-3">

                {/* --- COLUMNA IZQUIERDA (LISTA) --- */}
                <Col md={4} lg={3} className="d-flex flex-column h-100">
                    <Card className="h-100 shadow-sm border-0 overflow-hidden">

                        {/* CABECERA */}
                        <div className="p-3 border-bottom border-secondary border-opacity-25">
                            <InputGroup className="mb-3">
                                <InputGroup.Text className="bg-transparent border-secondary border-opacity-50" style={{ color: 'var(--text-muted)' }}>
                                    <Search />
                                </InputGroup.Text>
                                <Form.Control
                                    placeholder='Buscar ID o "Sexo: Femenino Edad: 25"...'
                                    value={searchTerm}
                                    onChange={(e) => setSearchTerm(e.target.value)}
                                    className="border-secondary border-opacity-50 bg-transparent shadow-none"
                                    style={{ borderLeft: 'none', color: 'var(--text-main)' }}
                                />
                            </InputGroup>

                            <div className="d-flex justify-content-around mb-3">
                                <Form.Check type="checkbox" label={<span className="small fw-bold text-muted">Casos</span>} name="showCasos" checked={filters.showCasos} onChange={handleFilterChange} className="user-select-none"/>
                                <Form.Check type="checkbox" label={<span className="small fw-bold text-muted">Controles</span>} name="showControles" checked={filters.showControles} onChange={handleFilterChange} className="user-select-none"/>
                            </div>

                            <div className="d-flex align-items-center justify-content-between bg-primary bg-opacity-10 p-2 rounded border border-primary border-opacity-25">
                                <Form.Check type="checkbox" label={<span className="small fw-bold ms-1">Seleccionar Todos</span>} checked={filteredItems.length > 0 && selectedIds.size === filteredItems.length} onChange={handleSelectAll} className="m-0 user-select-none"/>
                                {selectedIds.size > 0 && (
                                    <Button size="sm" variant="primary" onClick={handleBulkDownload} disabled={isDownloading} className="py-0 px-2" style={{fontSize: '0.8rem'}}>
                                        {isDownloading ? <Spinner size="sm" animation="border"/> : <><Download className="me-1"/> Descargar ({selectedIds.size})</>}
                                    </Button>
                                )}
                            </div>
                        </div>

                        {/* CUERPO LISTA */}
                        <div className="flex-grow-1 overflow-auto">
                            <ListGroup variant="flush">
                                {filteredItems.length === 0 ? (
                                    <div className="text-center p-5 text-muted">
                                        {searchTerm ? 'No hay coincidencias.' : 'No se encontraron registros.'}
                                    </div>
                                ) : (
                                    filteredItems.map(item => (
                                        <ListGroup.Item
                                            key={item.dbId}
                                            action
                                            active={selectedItem && selectedItem.dbId === item.dbId}
                                            className="d-flex align-items-center py-3 border-bottom border-secondary border-opacity-10 px-2"
                                            style={{
                                                backgroundColor: selectedItem?.dbId === item.dbId ? 'var(--hover-bg)' : 'transparent',
                                                color: selectedItem?.dbId === item.dbId ? 'var(--accent-color)' : 'var(--text-main)',
                                                borderLeft: selectedItem?.dbId === item.dbId ? '4px solid var(--accent-color)' : '4px solid transparent',
                                                transition: 'all 0.2s',
                                                cursor: 'pointer'
                                            }}
                                            onClick={() => setSelectedItem(item)}
                                        >
                                            <div className="me-3" onClick={(e) => e.stopPropagation()}>
                                                <Form.Check type="checkbox" checked={selectedIds.has(item.dbId)} onChange={() => handleToggleSelect(item.dbId)}/>
                                            </div>

                                            <div className="d-flex justify-content-between align-items-center flex-grow-1">
                                                <div className="d-flex flex-column justify-content-center">
                                                    <div className="d-flex align-items-center gap-2">
                                                        {(() => {
                                                            const missing = getMissingCount(item);
                                                            if (missing > 0) {
                                                                return (
                                                                    <Badge bg="warning" text="dark" pill title={`Faltan ${missing} respuestas`} className="d-flex align-items-center px-2 py-1" style={{fontSize: '0.7rem'}}>
                                                                        <ExclamationTriangle className="me-1"/> {missing}
                                                                    </Badge>
                                                                );
                                                            }
                                                            return null;
                                                        })()}
                                                        <span className="fw-bold">{item.id}</span>
                                                    </div>
                                                </div>

                                                <Badge bg={item.tipo === 'CASO' ? 'danger' : 'success'} pill className="opacity-75" style={{fontSize: '0.7em'}}>
                                                    {item.tipo}
                                                </Badge>
                                            </div>
                                        </ListGroup.Item>
                                    ))
                                )}
                            </ListGroup>
                        </div>
                    </Card>
                </Col>

                {/* --- COLUMNA DERECHA (DETALLE) --- */}
                <Col md={8} lg={9} className="h-100">
                    {selectedItem ? (
                        <Card className="h-100 shadow-sm border-0 overflow-hidden">
                            <Card.Header className="d-flex justify-content-between align-items-center py-3 border-bottom border-secondary border-opacity-25 bg-white">
                                <div>
                                    <h4 className="mb-0 d-flex align-items-center gap-2 text-primary">
                                        <PersonVcard />
                                        {selectedItem.id}
                                    </h4>
                                    <small className="text-muted">
                                        Fecha Ingreso: {selectedItem.fechaIngreso ? new Date(selectedItem.fechaIngreso).toLocaleDateString() : '-'}
                                    </small>
                                </div>
                                <div className="d-flex gap-2 align-items-center">
                                    <Button variant="outline-danger" size="sm" onClick={() => handleDownloadPdf(selectedItem.dbId, selectedItem.id)} title="Descargar PDF">
                                        <FileEarmarkPdf className="me-2"/> PDF
                                    </Button>
                                    <Badge bg={selectedItem.tipo === 'CASO' ? 'danger' : 'success'} className="fs-6 px-3 py-2">
                                        {selectedItem.tipo}
                                    </Badge>
                                </div>
                            </Card.Header>

                            <Card.Body className="p-0 overflow-auto bg-light bg-opacity-10">
                                {surveyStructure.map((cat) => {
                                    const preguntasDeCategoria = cat.preguntas || [];
                                    return (
                                        <div key={cat.id_cat} className="mb-4 bg-white shadow-sm mx-3 mt-3 rounded border border-light">
                                            <div className="px-4 py-2 bg-secondary bg-opacity-10 border-bottom fw-bold text-uppercase small text-muted d-flex align-items-center">
                                                <ClipboardPulse className="me-2"/> {cat.nombre}
                                            </div>

                                            <Table hover className="mb-0 align-middle">
                                                <tbody>
                                                {preguntasDeCategoria.map((pregunta) => {
                                                    const respuesta = selectedItem.respuestas?.find(r =>
                                                        r.preguntaId === pregunta.pregunta_id ||
                                                        r.pregunta_id === pregunta.pregunta_id
                                                    );

                                                    const cellContent = respuesta && respuesta.valor ? (
                                                        <span className="text-primary fw-medium">{respuesta.valor}</span>
                                                    ) : (
                                                        <span className="text-danger d-flex align-items-center gap-2 small bg-danger bg-opacity-10 px-2 py-1 rounded fit-content" style={{width: 'fit-content'}}>
                                                            <ExclamationTriangle />
                                                            <span className="fst-italic">No registrado</span>
                                                        </span>
                                                    );

                                                    return (
                                                        <tr key={pregunta.pregunta_id}>
                                                            <td className="ps-4 py-3" style={{width: '60%'}}>
                                                                <div className="fw-bold text-dark">{pregunta.etiqueta}</div>
                                                                {pregunta.dato_sensible && <Badge bg="warning" text="dark" style={{fontSize:'0.6em'}}>SENSIBLE</Badge>}
                                                            </td>
                                                            <td className="py-3">{cellContent}</td>
                                                        </tr>
                                                    );
                                                })}
                                                </tbody>
                                            </Table>
                                        </div>
                                    );
                                })}
                                {surveyStructure.length === 0 && (
                                    <div className="text-center p-5 text-muted">No se ha cargado la estructura del formulario.</div>
                                )}
                            </Card.Body>
                        </Card>
                    ) : (
                        <Card className="h-100 border-0 shadow-sm d-flex align-items-center justify-content-center bg-light" style={{ color: 'var(--text-muted)' }}>
                            <div className="text-center opacity-50">
                                <ClipboardPulse style={{ fontSize: '4rem' }} className="mb-3" />
                                <h5>Selecciona un participante para ver su ficha clínica completa</h5>
                            </div>
                        </Card>
                    )}
                </Col>
            </Row>

            {/* MODAL WIZARD */}
            {/* keyboard={false} para evitar cierre con Escape */}
            <Modal
                show={showModal}
                onHide={() => setShowModal(false)}
                backdrop="static"
                keyboard={false}
                size="lg"
                centered
            >
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
                        <div className="text-center py-5 text-muted">No hay encuesta configurada.</div>
                    ) : (
                        <div>
                            <h5 className="mb-4 text-primary border-bottom pb-2">{currentCat?.nombre}</h5>
                            <Row>
                                {currentCat?.preguntas.map(q => (
                                    <Col md={12} key={q.pregunta_id} className="mb-3">
                                        <Form.Group>
                                            {/* --- MODIFICADO: TOOLTIP AGREGADO --- */}
                                            <Form.Label className="d-flex justify-content-between align-items-center w-100">
                                                <div className="d-flex align-items-center">
                                                    <span>{q.etiqueta}</span>
                                                    {/* Mostrar ícono de ayuda solo si hay descripción */}
                                                    {q.descripcion && (
                                                        <OverlayTrigger
                                                            placement="top"
                                                            overlay={<Tooltip id={`tooltip-${q.pregunta_id}`}>{q.descripcion}</Tooltip>}
                                                        >
                                                            <QuestionCircle className="ms-2 text-info" style={{ cursor: 'help' }} />
                                                        </OverlayTrigger>
                                                    )}
                                                </div>
                                                {q.dato_sensible && <Badge bg="warning" text="dark" style={{fontSize:'0.6em'}}>SENSIBLE</Badge>}
                                            </Form.Label>
                                            {/* ------------------------------------- */}

                                            {(() => {
                                                const val = formData[q.pregunta_id] || '';

                                                if(q.tipo_dato === 'ENUM') {
                                                    return (
                                                        <Form.Select
                                                            value={val}
                                                            onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'ENUM')}
                                                        >
                                                            <option value="">Seleccione...</option>
                                                            {q.opciones && q.opciones.map((opt, idx) => (
                                                                <option key={idx} value={opt}>{opt}</option>
                                                            ))}
                                                        </Form.Select>
                                                    );
                                                }
                                                if(q.tipo_dato === 'RUT') {
                                                    return <Form.Control value={val} onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'RUT')} maxLength={12} placeholder="12.345.678-9"/>;
                                                }
                                                return <Form.Control type={q.tipo_dato === 'NUMERO' ? 'number' : 'text'} value={val} onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'TEXTO')}/>;
                                            })()}
                                        </Form.Group>
                                    </Col>
                                ))}
                            </Row>
                        </div>
                    )}
                </Modal.Body>
                <Modal.Footer className="justify-content-between">
                    <Button variant="secondary" onClick={handlePrev} disabled={currentStep === 0 || isSaving}>
                        <ArrowLeft className="me-2" /> Anterior
                    </Button>
                    {currentStep === surveyStructure.length - 1 ? (
                        <Button variant="success" onClick={handleSave} disabled={isSaving}>
                            {isSaving ? <Spinner size="sm" animation="border" className="me-2"/> : <Save className="me-2" />}
                            Guardar
                        </Button>
                    ) : (
                        <Button variant="primary" onClick={handleNext} disabled={isSaving}>
                            Siguiente <ArrowRight className="ms-2" />
                        </Button>
                    )}
                </Modal.Footer>
            </Modal>
        </Container>
    );
};

export default CasesControls;