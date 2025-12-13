import { useState, useEffect } from 'react';
import { Modal, Button, Form, Row, Col, InputGroup, Table, Accordion, Badge } from 'react-bootstrap';
// --- CAMBIO: Agregamos Diagram3 para el ícono de dependencia
import { Trash, ListCheck, Scissors, Tag, QuestionCircle, Diagram3 } from 'react-bootstrap-icons';

// --- CAMBIO: Agregamos allQuestions a las props para tener la lista de preguntas controladoras
const QuestionFormModal = ({ show, onHide, question, onSave, isEditing, allQuestions = [] }) => {
    // Estado inicial limpio
    const initialState = {
        etiqueta: '',
        codigoStata: '',
        descripcion: '',
        tipo_dato: 'TEXTO',
        orden: 0,
        dato_sensible: false,
        activo: true,
        dicotomizaciones: [],
        exportable: true,
        generarEstadistica: false,
        opciones: [],
        // --- CAMBIO: Campos para lógica de dependencia
        preguntaControladoraId: '',
        valorEsperadoControladora: ''
    };

    const [form, setForm] = useState(initialState);

    // Estados temporales para inputs dinámicos
    const [newOptionText, setNewOptionText] = useState('');
    const [newDicValue, setNewDicValue] = useState('');
    const [newDicSentido, setNewDicSentido] = useState('MAYOR');

    // Cargar datos cuando se abre el modal
    useEffect(() => {
        if (show) {
            if (question) {
                setForm({
                    ...initialState,
                    ...question,
                    dicotomizaciones: question.dicotomizaciones || [],
                    opciones: question.opciones ? question.opciones.map(o => o.etiqueta || o) : [],
                    // --- CAMBIO: Asegurar carga de datos de dependencia
                    preguntaControladoraId: question.preguntaControladoraId || '',
                    valorEsperadoControladora: question.valorEsperadoControladora || ''
                });
            } else {
                setForm(initialState);
            }
            setNewOptionText('');
            setNewDicValue('');
            setNewDicSentido('MAYOR');
        }
    }, [show, question]);

    // Handlers
    const handleChange = (e) => {
        const { name, value, type, checked } = e.target;
        setForm(prev => ({
            ...prev,
            [name]: type === 'checkbox' || type === 'switch' ? checked : value
        }));
    };

    // --- CAMBIO: Handler específico para cambio de pregunta controladora
    // Resetea el valor esperado si cambia la pregunta padre
    const handleParentChange = (e) => {
        const val = e.target.value;
        setForm(prev => ({
            ...prev,
            preguntaControladoraId: val ? Number(val) : '', // Convertir a número si no es vacío
            valorEsperadoControladora: '' // Resetear respuesta esperada al cambiar de padre
        }));
    };

    const handleCodigoChange = (e) => {
        const val = e.target.value.replace(/\s+/g, '_');
        setForm(prev => ({ ...prev, codigoStata: val }));
    };

    // --- Lógica Opciones (ENUM) ---
    const addOption = () => {
        if (!newOptionText.trim()) return;
        setForm(prev => ({
            ...prev,
            opciones: [...prev.opciones, newOptionText.trim()]
        }));
        setNewOptionText('');
    };

    const removeOption = (idx) => {
        setForm(prev => ({
            ...prev,
            opciones: prev.opciones.filter((_, i) => i !== idx)
        }));
    };

    // --- Lógica Dicotomizaciones ---
    const addDicotomizacion = () => {
        if (newDicValue === '' || newDicValue === null || newDicValue === undefined) return;

        const newDic = {
            id_dicotomizacion: null,
            valor: parseFloat(newDicValue),
            sentido: newDicSentido
        };
        setForm(prev => ({
            ...prev,
            dicotomizaciones: [...prev.dicotomizaciones, newDic]
        }));
        setNewDicValue('');
    };

    const removeDicotomizacion = (idx) => {
        setForm(prev => ({
            ...prev,
            dicotomizaciones: prev.dicotomizaciones.filter((_, i) => i !== idx)
        }));
    };

    const handleSubmit = () => {
        onSave(form);
    };

    // --- CAMBIO: Lógica auxiliar para buscar la pregunta padre seleccionada y sus opciones
    // Filtramos para que solo muestre ENUMS y no se muestre a sí misma
    const possibleParents = allQuestions.filter(q =>
        q.tipo_dato === 'ENUM' &&
        q.pregunta_id !== form.pregunta_id // Evitar depender de sí misma (si ya tiene ID)
    );

    const selectedParentQuestion = form.preguntaControladoraId
        ? possibleParents.find(q => q.pregunta_id === Number(form.preguntaControladoraId))
        : null;

    return (
        <Modal show={show} onHide={onHide} backdrop="static" size="lg" centered>
            <Modal.Header closeButton>
                <Modal.Title>{isEditing ? 'Editar Pregunta' : 'Nueva pregunta'}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Row>
                    <Col md={12} className="mb-3">
                        <Form.Group>
                            <Form.Label className="fw-bold"><QuestionCircle /> Pregunta</Form.Label>
                            <Form.Control
                                type="text"
                                name="etiqueta"
                                placeholder="Ej: ¿Cuál es su fecha de nacimiento?"
                                value={form.etiqueta}
                                onChange={handleChange}
                                autoFocus
                            />
                        </Form.Group>
                    </Col>

                    <Col md={8}>
                        <Form.Group className="mb-3">
                            <Form.Label className="fw-bold text-muted small"><Tag /> Etiqueta (Nombre interno/Variable)</Form.Label>
                            <Form.Control
                                type="text"
                                name="codigoStata"
                                placeholder="Ej: fecha_nacimiento"
                                value={form.codigoStata || ''}
                                onChange={handleCodigoChange}
                                className="font-monospace text-primary"
                            />
                            <Form.Text className="text-muted" style={{ fontSize: '0.75rem' }}>
                                Sin espacios. Debe ser único en toda la encuesta.
                            </Form.Text>
                        </Form.Group>
                    </Col>
                    <Col md={4}>
                        <Form.Group className="mb-3">
                            <Form.Label className="fw-bold text-muted small">Tipo de dato</Form.Label>
                            <Form.Select name="tipo_dato" value={form.tipo_dato} onChange={handleChange}>
                                <option value="TEXTO">Texto libre</option>
                                <option value="NUMERO">Numérico</option>
                                <option value="RUT">RUT</option>
                                <option value="CELULAR">Celular</option>
                                <option value="EMAIL">Email</option>
                                <option value="ENUM">Selección múltiple</option>
                            </Form.Select>
                        </Form.Group>
                    </Col>
                </Row>

                <Form.Group className="mb-3">
                    <Form.Label className="fw-bold text-muted small">Descripción detallada</Form.Label>
                    <Form.Control
                        as="textarea"
                        rows={2}
                        name="descripcion"
                        value={form.descripcion}
                        onChange={handleChange}
                    />
                </Form.Group>

                {form.tipo_dato === 'ENUM' && (
                    <div className="enum-box">
                        <label className="mb-2 text-info small fw-bold">
                            <ListCheck /> OPCIONES DE SELECCIÓN
                        </label>

                        <InputGroup className="mb-3">
                            <Form.Control
                                placeholder="Nueva opción..."
                                value={newOptionText}
                                onChange={e => setNewOptionText(e.target.value)}
                                onKeyDown={e => e.key === 'Enter' && addOption()}
                                className="bg-transparent border-secondary"
                            />
                            <Button variant="outline-primary" onClick={addOption}>Agregar</Button>
                        </InputGroup>

                        <div className="enum-list-container">
                            <Table size="sm" borderless className="mb-0">
                                <tbody>
                                {form.opciones.map((opt, idx) => (
                                    <tr key={idx}>
                                        <td className="fw-medium">{opt}</td>
                                        <td className="text-end" style={{ width: '50px' }}>
                                            <Trash
                                                className="text-danger cursor-pointer opacity-75 hover-opacity-100"
                                                onClick={() => removeOption(idx)}
                                                title="Eliminar opción"
                                            />
                                        </td>
                                    </tr>
                                ))}
                                </tbody>
                            </Table>
                        </div>
                        {form.opciones.length === 0 && (
                            <div className="text-muted small mt-1 ps-1 fst-italic">
                                No hay opciones agregadas aún.
                            </div>
                        )}
                    </div>
                )}

                <div className="d-flex gap-4 mt-3 p-2 border rounded border-secondary border-opacity-25 bg-secondary bg-opacity-10">
                    <Form.Check type="switch" name="dato_sensible" label="Dato sensible" checked={form.dato_sensible} onChange={handleChange} />
                </div>

                {/* --- CAMBIO PRINCIPAL: SECCIÓN DEPENDENCIA (Arriba de dicotomización) --- */}
                <Accordion className="mt-3 border-0">
                    <Accordion.Item eventKey="0" className="bg-transparent border-0">
                        <Accordion.Header>
                            <span className="small text-muted fw-bold"><Diagram3 className="me-2" /> Lógica de Dependencia</span>
                        </Accordion.Header>
                        <Accordion.Body className="bg-da bg-opacity-10 border border-secondary border-opacity-25 rounded">
                            <Row>
                                <Col md={6}>
                                    <Form.Group>
                                        <Form.Label className="small text-primary fw-bold">No mostrar cuando...</Form.Label>
                                        <Form.Select
                                            value={form.preguntaControladoraId || ''}
                                            onChange={handleParentChange}
                                            size="sm"
                                        >
                                            <option value="">-- Siempre visible --</option>
                                            {possibleParents.map(p => (
                                                <option key={p.pregunta_id} value={p.pregunta_id}>
                                                    {p.etiqueta.length > 40 ? p.etiqueta.substring(0,40)+'...' : p.etiqueta}
                                                </option>
                                            ))}
                                        </Form.Select>
                                        <Form.Text className="text-muted small" style={{fontSize: '0.7rem'}}>
                                            Seleccione una pregunta tipo "Selección" anterior.
                                        </Form.Text>
                                    </Form.Group>
                                </Col>
                                <Col md={6}>
                                    <Form.Group>
                                        <Form.Label className="small text-primary fw-bold">La respuesta es...</Form.Label>
                                        <Form.Select
                                            name="valorEsperadoControladora"
                                            value={form.valorEsperadoControladora}
                                            onChange={handleChange}
                                            size="sm"
                                            disabled={!form.preguntaControladoraId}
                                        >
                                            <option value="">-- Seleccione valor --</option>
                                            {selectedParentQuestion?.opciones?.map((opt, idx) => (
                                                <option key={idx} value={opt}>{opt}</option>
                                            ))}
                                        </Form.Select>
                                    </Form.Group>
                                </Col>
                            </Row>
                        </Accordion.Body>
                    </Accordion.Item>
                </Accordion>
                {/* ------------------------------------------------------------- */}

                {/* SECCIÓN DICOTOMIZACIÓN */}
                <Accordion className="mt-3 border-0">
                    <Accordion.Item eventKey="0" className="bg-transparent border-0">
                        <Accordion.Header>
                            <span className="small text-muted fw-bold"><Scissors className="me-2" /> Dicotomización</span>
                        </Accordion.Header>
                        <Accordion.Body className="bg-dark bg-opacity-10 border border-secondary border-opacity-25 rounded">
                            <Row className="align-items-end mb-3">
                                <Col>
                                    <Form.Label className="small">Valor de corte</Form.Label>
                                    {/* --- CAMBIO: Renderizado condicional según tipo de dato --- */}
                                    {form.tipo_dato === 'ENUM' ? (
                                        <Form.Select
                                            value={newDicValue}
                                            onChange={e => setNewDicValue(e.target.value)}
                                            size="sm"
                                            disabled={form.opciones.length === 0}
                                        >
                                            <option value="">-- Seleccione opción --</option>
                                            {form.opciones.map((opt, idx) => (
                                                // El value será el índice (0, 1, 2...) que representa el valor numérico
                                                <option key={idx} value={idx}>
                                                    {opt}
                                                </option>
                                            ))}
                                        </Form.Select>
                                    ) : (
                                        <Form.Control
                                            type="number"
                                            placeholder="Ej: 4.5"
                                            value={newDicValue}
                                            onChange={e => setNewDicValue(e.target.value)}
                                            size="sm"
                                        />
                                    )}
                                </Col>
                                <Col>
                                    <Form.Label className="small">Condición</Form.Label>
                                    <Form.Select
                                        value={newDicSentido}
                                        onChange={e => setNewDicSentido(e.target.value)}
                                        size="sm"
                                    >
                                        <option value="MAYOR_QUE">Mayor que</option>
                                        <option value="MENOR_QUE">Menor que</option>
                                        <option value="IGUAL_A">Igual a</option>
                                        <option value="MAYOR_O_IGUAL">Mayor o igual</option>
                                        <option value="MENOR_O_IGUAL">Menor o igual</option>
                                    </Form.Select>
                                </Col>
                                <Col xs="auto">
                                    <Button variant="outline-success" size="sm" onClick={addDicotomizacion}>Agregar</Button>
                                </Col>
                            </Row>
                            {form.dicotomizaciones.length > 0 ? (
                                <Table
                                    size="sm"
                                    borderless
                                    hover
                                    className="mb-0 small rounded overflow-hidden"
                                    style={{
                                        backgroundColor: 'var(--bg-form)',
                                        color: 'var(--text-main)',
                                        '--bs-table-bg': 'var(--bg-form)',
                                        '--bs-table-color': 'var(--text-main)',
                                        '--bs-table-accent-bg': 'transparent'
                                    }}
                                >
                                    <thead>
                                    <tr>
                                        <th className="text-muted font-monospace">Condición</th>
                                        <th className="text-muted font-monospace">Valor</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody style={{ backgroundColor: 'transparent' }}>
                                    {form.dicotomizaciones.map((dic, idx) => (
                                        <tr key={idx}>
                                            <td className="text-info">{dic.sentido}</td>
                                            <td className="fw-bold">{dic.valor}</td>
                                            <td className="text-end">
                                                <Trash className="text-danger cursor-pointer" onClick={() => removeDicotomizacion(idx)} />
                                            </td>
                                        </tr>
                                    ))}
                                    </tbody>
                                </Table>
                            ) : <div className="text-center text-muted small fst-italic">No hay reglas definidas.</div>}
                        </Accordion.Body>
                    </Accordion.Item>
                </Accordion>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide}>Cancelar</Button>
                <Button variant="primary" onClick={handleSubmit}>Guardar pregunta</Button>
            </Modal.Footer>
        </Modal>
    );
};

export default QuestionFormModal;