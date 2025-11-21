import { useState, useEffect } from 'react';
import { Container, Accordion, Button, Modal, Form, Row, Col, Card, Badge, Table, InputGroup } from 'react-bootstrap';
import { PlusLg, PencilSquare, Trash, GripVertical } from 'react-bootstrap-icons';
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd';

// --- DATOS FALSOS INICIALES (MOCK DATA) ---
const INITIAL_MOCK_DATA = [
    {
        id_cat: "cat-1",
        nombre: 'Antecedentes Generales',
        orden: 1,
        preguntas: [
            { pregunta_id: "q-101", etiqueta: 'Nivel Educacional', tipo_dato: 'ENUM', activo: true, descripcion: 'Último nivel alcanzado', dato_sensible: false, opciones: [
                    { id_opcion: 1, etiqueta: 'Básica', orden: 1 },
                    { id_opcion: 2, etiqueta: 'Media', orden: 2 },
                    { id_opcion: 3, etiqueta: 'Universitaria', orden: 3 }
                ]},
            { pregunta_id: "q-102", etiqueta: 'RUT del Paciente', tipo_dato: 'RUT', activo: true, descripcion: '', dato_sensible: true, opciones: [] }
        ]
    },
    {
        id_cat: "cat-2",
        nombre: 'Hábitos y Consumo',
        orden: 2,
        preguntas: [
            { pregunta_id: "q-201", etiqueta: 'Fuma actualmente', tipo_dato: 'ENUM', activo: true, descripcion: '', dato_sensible: false, opciones: [
                    { id_opcion: 4, etiqueta: 'Sí', orden: 1 },
                    { id_opcion: 5, etiqueta: 'No', orden: 2 }
                ]},
            { pregunta_id: "q-202", etiqueta: 'Cigarrillos por día', tipo_dato: 'NUMERO', activo: true, descripcion: 'Promedio diario', dato_sensible: false, opciones: [] }
        ]
    }
];

const SurveyBuilder = () => {
    // ESTADOS
    const [categories, setCategories] = useState([]);

    // Modales
    const [showCatModal, setShowCatModal] = useState(false);
    const [showQModal, setShowQModal] = useState(false);

    // Edición
    const [editingCat, setEditingCat] = useState(null);
    const [editingQuestion, setEditingQuestion] = useState(null);
    const [targetCatId, setTargetCatId] = useState(null); // ID de la categoría dueña de la pregunta

    // Formularios
    const [catForm, setCatForm] = useState({ nombre: '' });

    const initialQuestionState = {
        etiqueta: '', descripcion: '', tipo_dato: 'TEXTO',
        orden: 0, dato_sensible: false, activo: true,
        dicotomizacion: '', sentido_corte: 'NINGUNO', exportable: true,
        opciones: []
    };
    const [qForm, setQForm] = useState(initialQuestionState);
    const [newOptionText, setNewOptionText] = useState('');

    // Cargar datos falsos al inicio
    useEffect(() => {
        setCategories(INITIAL_MOCK_DATA);
    }, []);

    // --- LÓGICA DRAG AND DROP (SOLO FRONTEND) ---
    const handleDragEnd = (result) => {
        const { source, destination, type } = result;
        if (!destination) return;
        if (source.droppableId === destination.droppableId && source.index === destination.index) return;

        const newCategories = [...categories];

        // 1. REORDENAR CATEGORÍAS
        if (type === 'CATEGORY') {
            const [movedCat] = newCategories.splice(source.index, 1);
            newCategories.splice(destination.index, 0, movedCat);
            // Actualizar orden visual
            const updated = newCategories.map((cat, idx) => ({ ...cat, orden: idx + 1 }));
            setCategories(updated);
        }
        // 2. REORDENAR PREGUNTAS (Incluso entre categorías)
        else if (type === 'QUESTION') {
            const sourceCatId = source.droppableId.replace('questions-', '');
            const destCatId = destination.droppableId.replace('questions-', '');

            const sourceCat = newCategories.find(c => c.id_cat.toString() === sourceCatId);
            const destCat = newCategories.find(c => c.id_cat.toString() === destCatId);

            const [movedQuestion] = sourceCat.preguntas.splice(source.index, 1);
            destCat.preguntas.splice(destination.index, 0, movedQuestion);

            // Recalcular orden interno
            sourceCat.preguntas.forEach((q, idx) => q.orden = idx + 1);
            if (sourceCatId !== destCatId) {
                destCat.preguntas.forEach((q, idx) => q.orden = idx + 1);
            }

            setCategories(newCategories);
        }
    };

    // --- GESTIÓN CATEGORÍAS ---
    const handleSaveCategory = () => {
        if (editingCat) {
            // Editar existente
            const updated = categories.map(c => c.id_cat === editingCat.id_cat ? { ...c, ...catForm } : c);
            setCategories(updated);
        } else {
            // Crear nueva
            const newCat = {
                id_cat: `cat-${Date.now()}`,
                ...catForm,
                orden: categories.length + 1,
                preguntas: []
            };
            setCategories([...categories, newCat]);
        }
        setShowCatModal(false);
    };

    const handleDeleteCategory = (catId) => {
        if(window.confirm("¿Eliminar esta categoría y todas sus preguntas?")) {
            setCategories(categories.filter(c => c.id_cat !== catId));
        }
    };

    const openCatModal = (cat = null) => {
        setEditingCat(cat);
        setCatForm(cat ? { nombre: cat.nombre } : { nombre: '' });
        setShowCatModal(true);
    };

    // --- GESTIÓN PREGUNTAS ---
    const handleSaveQuestion = () => {
        const newQ = {
            pregunta_id: editingQuestion ? editingQuestion.pregunta_id : `q-${Date.now()}`,
            ...qForm
        };

        const updatedCats = categories.map(cat => {
            // Buscamos la categoría destino
            if (cat.id_cat === targetCatId) {
                let updatedQuestions;
                if (editingQuestion) {
                    // Editar: Reemplazamos la pregunta en su lugar
                    updatedQuestions = cat.preguntas.map(q => q.pregunta_id === editingQuestion.pregunta_id ? newQ : q);
                } else {
                    // Crear: Agregamos al final
                    updatedQuestions = [...cat.preguntas, newQ];
                }
                return { ...cat, preguntas: updatedQuestions };
            }
            return cat;
        });

        setCategories(updatedCats);
        setShowQModal(false);
    };

    const handleDeleteQuestion = (catId, qId) => {
        if(!window.confirm("¿Eliminar esta pregunta?")) return;

        const updatedCats = categories.map(cat => {
            if (cat.id_cat === catId) {
                return { ...cat, preguntas: cat.preguntas.filter(q => q.pregunta_id !== qId) };
            }
            return cat;
        });
        setCategories(updatedCats);
    };

    const openQuestionModal = (catId, question = null) => {
        setTargetCatId(catId);
        setEditingQuestion(question);
        if (question) {
            // Al editar, copiamos el objeto pregunta al formulario
            setQForm({ ...question });
        } else {
            // Al crear, reseteamos el formulario
            setQForm({ ...initialQuestionState });
        }
        setShowQModal(true);
    };

    // --- GESTIÓN OPCIONES (Dentro del Modal) ---
    const addOption = () => {
        if (!newOptionText.trim()) return;
        const newOpt = { id_opcion: Date.now(), etiqueta: newOptionText, orden: qForm.opciones.length + 1 };
        setQForm({ ...qForm, opciones: [...qForm.opciones, newOpt] });
        setNewOptionText('');
    };

    const removeOption = (id) => {
        setQForm({ ...qForm, opciones: qForm.opciones.filter(o => o.id_opcion !== id) });
    };

    return (
        <Container fluid className="p-0">
            {/* HEADER */}
            <div className="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 className="mb-0">Diseñador de Encuestas</h2>
                    <p className="text-muted small">Versión de Diseño (Mock Data)</p>
                </div>
                <Button variant="primary" onClick={() => openCatModal()} className="d-flex align-items-center gap-2">
                    <PlusLg /> Nueva Categoría
                </Button>
            </div>

            {/* ÁREA DE ARRASTRE PRINCIPAL */}
            <DragDropContext onDragEnd={handleDragEnd}>
                <Droppable droppableId="all-categories" type="CATEGORY">
                    {(provided) => (
                        <div {...provided.droppableProps} ref={provided.innerRef}>

                            <Accordion defaultActiveKey={['0']} alwaysOpen>
                                {categories.map((cat, index) => (

                                    <Draggable key={cat.id_cat} draggableId={cat.id_cat.toString()} index={index}>
                                        {(provided) => (
                                            <div ref={provided.innerRef} {...provided.draggableProps} className="mb-3">
                                                <Accordion.Item eventKey={cat.id_cat.toString()} className="border-secondary border-opacity-25 bg-transparent">
                                                    <Accordion.Header>
                                                        <div className="d-flex align-items-center w-100">
                                                            {/* HANDLE CATEGORÍA */}
                                                            <div {...provided.dragHandleProps} className="me-3 text-muted p-2" style={{ cursor: 'grab' }} onClick={(e) => e.stopPropagation()}>
                                                                <GripVertical size={20} />
                                                            </div>

                                                            <div className="d-flex justify-content-between w-100 me-3 align-items-center">
                                                                <span className="fw-bold text-info"><span className="me-2">#{index + 1}</span> {cat.nombre}</span>
                                                                <Badge bg="secondary" pill>{cat.preguntas.length}</Badge>
                                                            </div>
                                                        </div>
                                                    </Accordion.Header>

                                                    <Accordion.Body className="bg-dark bg-opacity-10">
                                                        {/* BARRA DE ACCIONES CATEGORÍA */}
                                                        <div className="d-flex justify-content-between mb-3 pb-2 border-bottom border-secondary border-opacity-25">
                                                            <div className="d-flex gap-2">
                                                                <Button variant="outline-secondary" size="sm" onClick={() => openCatModal(cat)}><PencilSquare /> Editar</Button>
                                                                <Button variant="outline-danger" size="sm" onClick={() => handleDeleteCategory(cat.id_cat)}><Trash /></Button>
                                                            </div>
                                                            <Button variant="outline-info" size="sm" onClick={() => openQuestionModal(cat.id_cat)}><PlusLg /> Agregar Pregunta</Button>
                                                        </div>

                                                        {/* LISTA DE PREGUNTAS DROPPABLE */}
                                                        <Droppable droppableId={`questions-${cat.id_cat}`} type="QUESTION">
                                                            {(provided) => (
                                                                <div ref={provided.innerRef} {...provided.droppableProps} className="d-flex flex-column gap-2" style={{ minHeight: '10px' }}>
                                                                    {cat.preguntas.length === 0 && <div className="text-center text-muted py-2 small fst-italic">Arrastra preguntas aquí o crea una nueva</div>}

                                                                    {cat.preguntas.map((q, qIndex) => (
                                                                        <Draggable key={q.pregunta_id} draggableId={q.pregunta_id.toString()} index={qIndex}>
                                                                            {(provided) => (
                                                                                <Card ref={provided.innerRef} {...provided.draggableProps} className="border-secondary border-opacity-25 bg-dark-subtle">
                                                                                    <Card.Body className="p-2 px-3 d-flex justify-content-between align-items-center">
                                                                                        <div className="d-flex gap-3 align-items-center">
                                                                                            {/* HANDLE PREGUNTA */}
                                                                                            <div {...provided.dragHandleProps} className="text-muted" style={{cursor: 'grab'}}><GripVertical /></div>

                                                                                            <div className="d-flex flex-column">
                                                                                                <div className="d-flex gap-2 align-items-center">
                                                                                                    <span className="fw-bold text-white">{q.etiqueta}</span>
                                                                                                    {q.dato_sensible && <Badge bg="danger" style={{fontSize:'0.6rem'}}>SENSIBLE</Badge>}
                                                                                                    {!q.activo && <Badge bg="secondary" style={{fontSize:'0.6rem'}}>INACTIVO</Badge>}
                                                                                                </div>
                                                                                                <span className="text-muted small fst-italic">{q.descripcion || 'Sin descripción'}</span>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div className="d-flex align-items-center gap-2">
                                                                                            <Badge bg="dark" className="border border-secondary text-light">{q.tipo_dato}</Badge>
                                                                                            <Button variant="link" className="text-muted p-0" onClick={() => openQuestionModal(cat.id_cat, q)}><PencilSquare /></Button>
                                                                                            <Button variant="link" className="text-danger p-0 ms-2" onClick={() => handleDeleteQuestion(cat.id_cat, q.pregunta_id)}><Trash /></Button>
                                                                                        </div>
                                                                                    </Card.Body>
                                                                                </Card>
                                                                            )}
                                                                        </Draggable>
                                                                    ))}
                                                                    {provided.placeholder}
                                                                </div>
                                                            )}
                                                        </Droppable>
                                                    </Accordion.Body>
                                                </Accordion.Item>
                                            </div>
                                        )}
                                    </Draggable>
                                ))}
                                {provided.placeholder}
                            </Accordion>
                        </div>
                    )}
                </Droppable>
            </DragDropContext>

            {/* --- MODAL CATEGORÍA --- */}
            <Modal show={showCatModal} onHide={() => setShowCatModal(false)} backdrop="static" centered>
                <Modal.Header closeButton><Modal.Title>{editingCat ? 'Editar Categoría' : 'Nueva Categoría'}</Modal.Title></Modal.Header>
                <Modal.Body>
                    <Form.Group className="mb-3"><Form.Label>Nombre</Form.Label><Form.Control type="text" value={catForm.nombre} onChange={e => setCatForm({...catForm, nombre: e.target.value})} /></Form.Group>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowCatModal(false)}>Cancelar</Button>
                    <Button variant="primary" onClick={handleSaveCategory}>Guardar</Button>
                </Modal.Footer>
            </Modal>

            {/* --- MODAL PREGUNTA --- */}
            <Modal show={showQModal} onHide={() => setShowQModal(false)} backdrop="static" size="lg">
                <Modal.Header closeButton><Modal.Title>{editingQuestion ? 'Editar Pregunta' : 'Nueva Pregunta'}</Modal.Title></Modal.Header>
                <Modal.Body>
                    <Row>
                        <Col md={8}>
                            <Form.Group className="mb-3">
                                <Form.Label>Pregunta</Form.Label>
                                <Form.Control type="text" value={qForm.etiqueta} onChange={e => setQForm({...qForm, etiqueta: e.target.value})} />
                            </Form.Group>
                        </Col>
                        <Col md={4}>
                            <Form.Group className="mb-3">
                                <Form.Label>Tipo</Form.Label>
                                {/* Selects sincronizados con tus ENUMs de Java */}
                                <Form.Select value={qForm.tipo_dato} onChange={e => setQForm({...qForm, tipo_dato: e.target.value})}>
                                    <option value="TEXTO">Texto Libre</option>
                                    <option value="NUMERO">Numérico</option>
                                    <option value="RUT">RUT (Chileno)</option>
                                    <option value="CELULAR">Celular</option>
                                    <option value="EMAIL">Email</option>
                                    <option value="ENUM">Selección Múltiple (ENUM)</option>
                                </Form.Select>
                            </Form.Group>
                        </Col>
                    </Row>
                    <Form.Group className="mb-3">
                        <Form.Label>Descripción</Form.Label>
                        <Form.Control as="textarea" rows={2} value={qForm.descripcion} onChange={e => setQForm({...qForm, descripcion: e.target.value})} />
                    </Form.Group>

                    {/* SECCIÓN OPCIONES */}
                    {qForm.tipo_dato === 'ENUM' && (
                        <div className="border border-secondary border-opacity-25 rounded p-3 bg-dark bg-opacity-10 mb-3">
                            <label className="mb-2 text-info small fw-bold">OPCIONES DE SELECCIÓN</label>
                            <InputGroup className="mb-3">
                                <Form.Control
                                    placeholder="Nueva opción..."
                                    value={newOptionText}
                                    onChange={e => setNewOptionText(e.target.value)}
                                    className="bg-transparent text-white border-secondary"
                                />
                                <Button variant="outline-primary" onClick={addOption}>Agregar</Button>
                            </InputGroup>
                            <div style={{maxHeight: '150px', overflowY: 'auto'}}>
                                <Table size="sm" borderless className="mb-0" style={{ backgroundColor: 'transparent' }}>
                                    <tbody style={{ backgroundColor: 'transparent' }}>
                                    {qForm.opciones.map((opt, idx) => (
                                        <tr key={idx} style={{ backgroundColor: 'transparent' }}>
                                            <td className="text-white" style={{ backgroundColor: 'transparent' }}>{opt.etiqueta}</td>
                                            <td className="text-end" style={{ backgroundColor: 'transparent' }}>
                                                <Trash className="text-danger cursor-pointer" onClick={() => removeOption(opt.id_opcion)} />
                                            </td>
                                        </tr>
                                    ))}
                                    </tbody>
                                </Table>
                            </div>
                        </div>
                    )}

                    <div className="d-flex gap-4 mt-3">
                        <Form.Check type="switch" label="Dato Sensible" checked={qForm.dato_sensible} onChange={e => setQForm({...qForm, dato_sensible: e.target.checked})} />
                        <Form.Check type="switch" label="Activo" checked={qForm.activo} onChange={e => setQForm({...qForm, activo: e.target.checked})} />
                        <Form.Check type="switch" label="Exportable" checked={qForm.exportable} onChange={e => setQForm({...qForm, exportable: e.target.checked})} />
                    </div>

                    {/* SECCIÓN AVANZADA */}
                    <Accordion className="mt-3 border-0">
                        <Accordion.Item eventKey="0" className="bg-transparent border-0">
                            <Accordion.Header><span className="small text-muted">Opciones Avanzadas</span></Accordion.Header>
                            <Accordion.Body>
                                <Row>
                                    <Col>
                                        <Form.Label>Valor de Corte (Dicotomización)</Form.Label>
                                        <Form.Control type="number" value={qForm.dicotomizacion || ''} onChange={e => setQForm({...qForm, dicotomizacion: e.target.value})} size="sm"/>
                                    </Col>
                                    <Col>
                                        <Form.Label>Sentido del Corte</Form.Label>
                                        <Form.Select value={qForm.sentido_corte || 'NINGUNO'} onChange={e => setQForm({...qForm, sentido_corte: e.target.value})} size="sm">
                                            <option value="NINGUNO">Ninguno</option>
                                            <option value="MAYOR">Mayor que</option>
                                            <option value="MENOR">Menor que</option>
                                            <option value="IGUAL">Igual a</option>
                                        </Form.Select>
                                    </Col>
                                </Row>
                            </Accordion.Body>
                        </Accordion.Item>
                    </Accordion>

                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowQModal(false)}>Cancelar</Button>
                    <Button variant="primary" onClick={handleSaveQuestion}>Guardar Pregunta</Button>
                </Modal.Footer>
            </Modal>

        </Container>
    );
};

export default SurveyBuilder;