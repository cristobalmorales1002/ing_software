import { useState, useEffect } from 'react';
import { Modal, Button, Form, Row, Col, InputGroup, Table, Accordion, Badge } from 'react-bootstrap';
import { Trash, ListCheck, Scissors, Tag, QuestionCircle } from 'react-bootstrap-icons';

const QuestionFormModal = ({ show, onHide, question, onSave, isEditing }) => {
    // Estado inicial limpio
    const initialState = {
        etiqueta: '',        // Pregunta visible
        codigoStata: '',     // Variable interna
        descripcion: '',
        tipo_dato: 'TEXTO',
        orden: 0,
        dato_sensible: false,
        activo: true,
        dicotomizaciones: [],
        exportable: true,
        generarEstadistica: false,
        opciones: []         // Strings
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
                    // Asegurar arrays
                    dicotomizaciones: question.dicotomizaciones || [],
                    opciones: question.opciones ? question.opciones.map(o => o.etiqueta || o) : [] // Manejar si vienen como objetos o strings
                });
            } else {
                setForm(initialState);
            }
            // Limpiar inputs temporales
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

    const handleCodigoChange = (e) => {
        // Reemplaza espacios por guion bajo automáticamente
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
        if (!newDicValue) return;
        const newDic = {
            id_dicotomizacion: null, // Backend lo genera
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

    return (
        <Modal show={show} onHide={onHide} backdrop="static" size="lg" centered>
            <Modal.Header closeButton>
                <Modal.Title>{isEditing ? 'Editar Pregunta' : 'Nueva Pregunta'}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Row>
                    <Col md={12} className="mb-3">
                        <Form.Group>
                            <Form.Label className="fw-bold"><QuestionCircle /> Pregunta (Texto Visible)</Form.Label>
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
                            <Form.Label className="fw-bold text-muted small"><Tag /> Etiqueta (Nombre Interno/Variable)</Form.Label>
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
                            <Form.Label className="fw-bold text-muted small">Tipo de Dato</Form.Label>
                            <Form.Select name="tipo_dato" value={form.tipo_dato} onChange={handleChange}>
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
                    <Form.Label className="fw-bold text-muted small">Descripción Detallada</Form.Label>
                    <Form.Control
                        as="textarea"
                        rows={2}
                        name="descripcion"
                        value={form.descripcion}
                        onChange={handleChange}
                    />
                </Form.Group>

                {/* SECCIÓN OPCIONES (Solo ENUM) */}
                {form.tipo_dato === 'ENUM' && (
                    <div className="border border-secondary border-opacity-25 rounded p-3 bg-dark bg-opacity-10 mb-3">
                        <label className="mb-2 text-info small fw-bold"><ListCheck /> OPCIONES DE SELECCIÓN</label>
                        <InputGroup className="mb-3">
                            <Form.Control
                                placeholder="Nueva opción..."
                                value={newOptionText}
                                onChange={e => setNewOptionText(e.target.value)}
                                onKeyDown={e => e.key === 'Enter' && addOption()}
                                className="bg-transparent text-white border-secondary"
                            />
                            <Button variant="outline-primary" onClick={addOption}>Agregar</Button>
                        </InputGroup>
                        <div style={{ maxHeight: '150px', overflowY: 'auto' }}>
                            <Table size="sm" borderless className="mb-0" style={{ backgroundColor: 'transparent' }}>
                                <tbody style={{ backgroundColor: 'transparent' }}>
                                {form.opciones.map((opt, idx) => (
                                    <tr key={idx}>
                                        <td className="text-white">{opt}</td>
                                        <td className="text-end">
                                            <Trash className="text-danger cursor-pointer" onClick={() => removeOption(idx)} />
                                        </td>
                                    </tr>
                                ))}
                                </tbody>
                            </Table>
                        </div>
                        <Form.Check
                            type="switch"
                            name="generarEstadistica"
                            label="Generar Estadística Automática"
                            checked={form.generarEstadistica}
                            onChange={handleChange}
                            className="mt-2 text-muted"
                        />
                    </div>
                )}

                <div className="d-flex gap-4 mt-3 p-2 border rounded border-secondary border-opacity-25 bg-secondary bg-opacity-10">
                    <Form.Check type="switch" name="dato_sensible" label="Dato Sensible" checked={form.dato_sensible} onChange={handleChange} />
                </div>

                {/* SECCIÓN DICOTOMIZACIÓN */}
                <Accordion className="mt-3 border-0">
                    <Accordion.Item eventKey="0" className="bg-transparent border-0">
                        <Accordion.Header><span className="small text-muted fw-bold"><Scissors className="me-2" /> Dicotomización (Cortes)</span></Accordion.Header>
                        <Accordion.Body className="bg-dark bg-opacity-10 border border-secondary border-opacity-25 rounded">
                            <Row className="align-items-end mb-3">
                                <Col>
                                    <Form.Label className="small">Valor de Corte</Form.Label>
                                    <Form.Control type="number" placeholder="Ej: 4.5" value={newDicValue} onChange={e => setNewDicValue(e.target.value)} size="sm" />
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
                                <Table size="sm" borderless hover className="mb-0 text-white small">
                                    <thead>
                                    <tr><th className="text-muted font-monospace">Condición</th><th className="text-muted font-monospace">Valor</th><th></th></tr>
                                    </thead>
                                    <tbody>
                                    {form.dicotomizaciones.map((dic, idx) => (
                                        <tr key={idx}>
                                            <td className="text-info">{dic.sentido}</td>
                                            <td className="fw-bold">{dic.valor}</td>
                                            <td className="text-end"><Trash className="text-danger cursor-pointer" onClick={() => removeDicotomizacion(idx)} /></td>
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
                <Button variant="primary" onClick={handleSubmit}>Guardar Pregunta</Button>
            </Modal.Footer>
        </Modal>
    );
};

export default QuestionFormModal;