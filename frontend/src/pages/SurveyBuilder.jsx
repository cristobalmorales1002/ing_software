import { useState, useEffect } from 'react';
import { Container, Accordion, Button, Card, Badge, Spinner } from 'react-bootstrap';
import { PlusLg, PencilSquare, Trash, GripVertical, Scissors } from 'react-bootstrap-icons';
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd';

// Importamos Axios configurado (Esto arregla la conexión)
import api from '../api/axios';

import QuestionFormModal from '../components/QuestionFormModal';
import CategoryFormModal from '../components/CategoryFormModal';

const SurveyBuilder = () => {
    // --- ESTADOS ---
    const [categories, setCategories] = useState([]);
    const [loading, setLoading] = useState(false);

    // Modales de Categoría
    const [showCatModal, setShowCatModal] = useState(false);
    const [editingCat, setEditingCat] = useState(null);

    // Modales de Pregunta
    const [showQModal, setShowQModal] = useState(false);
    const [editingQuestion, setEditingQuestion] = useState(null);
    const [targetCatId, setTargetCatId] = useState(null);

    // --- CARGA INICIAL ---
    const fetchEncuesta = async () => {
        setLoading(true);
        try {
            const response = await api.get('/api/encuesta/completa');
            const data = response.data;

            const processedData = data.map(cat => ({
                ...cat,
                preguntas: cat.preguntas ? cat.preguntas.map(q => ({
                    ...q,
                    dicotomizaciones: q.dicotomizaciones || []
                })) : []
            }));

            setCategories(processedData);
        } catch (error) {
            console.error("Error cargando encuesta:", error);
        } finally {
            setLoading(false);
        }
    };

    // Eliminamos diagnosticarConexion() porque ya no es necesaria

    useEffect(() => {
        fetchEncuesta();
    }, []);

    // --- DRAG AND DROP (CORREGIDO A AXIOS) ---
    const handleDragEnd = async (result) => {
        const { source, destination, type } = result;
        if (!destination) return;
        if (source.droppableId === destination.droppableId && source.index === destination.index) return;

        const newCategories = [...categories];

        if (type === 'CATEGORY') {
            const [movedCat] = newCategories.splice(source.index, 1);
            newCategories.splice(destination.index, 0, movedCat);

            // Actualización visual optimista
            const updatedVisual = newCategories.map((cat, idx) => ({ ...cat, orden: idx + 1 }));
            setCategories(updatedVisual);

            const idsOrdenados = updatedVisual.map(c => c.id_cat);
            try {
                // CAMBIO: fetch -> api.put (Axios envía JSON automáticamente)
                await api.put('/api/categorias/reordenar', idsOrdenados);
            } catch (err) {
                console.error(err);
                fetchEncuesta(); // Revertir si falla
            }
        }
        else if (type === 'QUESTION') {
            const sourceCatId = source.droppableId.replace('questions-', '');
            const destCatId = destination.droppableId.replace('questions-', '');
            const sourceCat = newCategories.find(c => c.id_cat.toString() === sourceCatId);
            const destCat = newCategories.find(c => c.id_cat.toString() === destCatId);
            const [movedQuestion] = sourceCat.preguntas.splice(source.index, 1);

            if (sourceCatId !== destCatId) movedQuestion.categoriaId = parseInt(destCatId);

            destCat.preguntas.splice(destination.index, 0, movedQuestion);
            setCategories(newCategories);

            try {
                if (sourceCatId === destCatId) {
                    // Reordenar en la misma categoría
                    const idsOrdenados = destCat.preguntas.map(q => q.pregunta_id);
                    await api.put(`/api/variables/reordenar`, idsOrdenados);
                } else {
                    // Mover a otra categoría
                    const payload = {
                        ...movedQuestion,
                        categoriaId: destCatId,
                        opciones: movedQuestion.opciones,
                        dicotomizaciones: movedQuestion.dicotomizaciones
                    };
                    // 1. Actualizar la pregunta con la nueva categoría
                    await api.put(`/api/variables/${movedQuestion.pregunta_id}`, payload);

                    // 2. Reordenar la categoría de destino
                    const idsDestino = destCat.preguntas.map(q => q.pregunta_id);
                    await api.put(`/api/variables/reordenar`, idsDestino);
                }
            } catch (err) {
                console.error(err);
                fetchEncuesta();
            }
        }
    };

    // --- GESTIÓN CATEGORÍAS (CORREGIDO A AXIOS) ---
    const openCatModal = (cat = null) => {
        setEditingCat(cat);
        setShowCatModal(true);
    };

    const handleSaveCategory = async (formData) => {
        try {
            const payload = editingCat ? formData : { ...formData, orden: categories.length + 1 };

            if (editingCat) {
                // PUT
                await api.put(`/api/categorias/${editingCat.id_cat}`, payload);
            } else {
                // POST
                await api.post('/api/categorias', payload);
            }

            fetchEncuesta();
            setShowCatModal(false);
        } catch (err) {
            console.error(err);
            alert("Error al guardar categoría");
        }
    };

    const handleDeleteCategory = async (catId) => {
        if(!window.confirm("¿Eliminar categoría y sus preguntas?")) return;
        try {
            // CAMBIO: fetch -> api.delete
            await api.delete(`/api/categorias/${catId}`);
            fetchEncuesta();
        } catch (err) {
            console.error(err);
            alert("Error al eliminar categoría");
        }
    };

    // --- GESTIÓN PREGUNTAS (CORREGIDO A AXIOS) ---
    const openQuestionModal = (catId, question = null) => {
        setTargetCatId(catId);
        setEditingQuestion(question);
        setShowQModal(true);
    };

    const handleSaveQuestion = async (formData) => {
        try {
            // Preservar dicotomizaciones existentes si el form no las envía
            const existingDicos = editingQuestion && editingQuestion.dicotomizaciones
                ? editingQuestion.dicotomizaciones
                : [];

            const payload = {
                ...formData,
                dicotomizaciones: formData.dicotomizaciones || existingDicos
            };

            if (editingQuestion) {
                // PUT
                await api.put(`/api/variables/${editingQuestion.pregunta_id}`, payload);
            } else {
                // POST
                // Asegurar orden y categoría
                payload.categoriaId = targetCatId;
                const catActual = categories.find(c => c.id_cat === targetCatId);
                payload.orden = catActual ? (catActual.preguntas ? catActual.preguntas.length + 1 : 1) : 1;

                await api.post('/api/variables', payload);
            }

            fetchEncuesta();
            setShowQModal(false);

        } catch (err) {
            console.error(err);
            const msg = err.response?.data?.message || err.message;
            alert("Error: " + msg);
        }
    };

    const handleDeleteQuestion = async (catId, qId) => {
        if(!window.confirm("¿Eliminar esta pregunta?")) return;
        try {
            // CAMBIO: fetch -> api.delete
            await api.delete(`/api/variables/${qId}`);
            fetchEncuesta();
        } catch (err) { console.error(err); }
    };

    if (loading && categories.length === 0) return <div className="text-center mt-5"><Spinner animation="border" variant="primary" /> <p>Cargando datos...</p></div>;

    return (
        <Container fluid className="p-0">
            <div className="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 className="mb-0">FORMULARIO</h2>
                </div>
                <Button variant="primary" onClick={() => openCatModal()} className="d-flex align-items-center gap-2">
                    <PlusLg /> Nueva categoría
                </Button>
            </div>

            <DragDropContext onDragEnd={handleDragEnd}>
                <Droppable droppableId="all-categories" type="CATEGORY">
                    {(provided) => (
                        <div {...provided.droppableProps} ref={provided.innerRef}>
                            <Accordion defaultActiveKey={['0']} alwaysOpen>
                                {categories.map((cat, index) => (
                                    <Draggable key={`cat-${cat.id_cat}`} draggableId={`cat-${cat.id_cat}`} index={index}>
                                        {(provided) => (
                                            <div ref={provided.innerRef} {...provided.draggableProps} className="mb-3">
                                                <Accordion.Item eventKey={cat.id_cat.toString()} className="border-secondary border-opacity-25 bg-transparent">
                                                    <Accordion.Header>
                                                        <div className="d-flex align-items-center w-100">
                                                            <div {...provided.dragHandleProps} className="me-3 text-muted p-2" onClick={(e) => e.stopPropagation()}><GripVertical size={20} /></div>
                                                            <div className="d-flex justify-content-between w-100 me-3 align-items-center">
                                                                <span className="fw-bold text-info"><span className="me-2">#{index + 1}</span> {cat.nombre}</span>
                                                                <Badge bg="secondary" pill>{cat.preguntas ? cat.preguntas.length : 0}</Badge>
                                                            </div>
                                                        </div>
                                                    </Accordion.Header>
                                                    <Accordion.Body className="bg-dark bg-opacity-10">
                                                        <div className="d-flex justify-content-between mb-3 pb-2 border-bottom border-secondary border-opacity-25">
                                                            <div className="d-flex gap-2">
                                                                <Button variant="outline-secondary" size="sm" onClick={() => openCatModal(cat)}><PencilSquare /> Editar</Button>
                                                                <Button variant="outline-danger" size="sm" onClick={() => handleDeleteCategory(cat.id_cat)}><Trash /></Button>
                                                            </div>
                                                            <Button variant="outline-info" size="sm" onClick={() => openQuestionModal(cat.id_cat)}><PlusLg /> Pregunta</Button>
                                                        </div>

                                                        <Droppable droppableId={`questions-${cat.id_cat}`} type="QUESTION">
                                                            {(provided) => (
                                                                <div ref={provided.innerRef} {...provided.droppableProps} className="d-flex flex-column gap-2" style={{ minHeight: '50px' }}>
                                                                    {cat.preguntas && cat.preguntas.map((q, qIndex) => (
                                                                        <Draggable key={`q-${q.pregunta_id}`} draggableId={`q-${q.pregunta_id}`} index={qIndex}>
                                                                            {(provided) => (
                                                                                <Card ref={provided.innerRef} {...provided.draggableProps} className="border-secondary border-opacity-25 bg-dark-subtle">
                                                                                    <Card.Body className="p-2 px-3 d-flex justify-content-between align-items-center">
                                                                                        <div className="d-flex gap-3 align-items-center">
                                                                                            <div {...provided.dragHandleProps} className="text-muted"><GripVertical /></div>
                                                                                            <div className="d-flex flex-column">
                                                                                                <div className="d-flex gap-2 align-items-center">
                                                                                                    <span className="fw-bold" style={{ color: 'var(--text-main)' }}>{q.etiqueta}</span>
                                                                                                    <span className="text-muted small ms-2 font-monospace">[{q.codigoStata}]</span>
                                                                                                </div>
                                                                                                <span className="text-muted small fst-italic">{q.descripcion || 'Sin descripción'}</span>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div className="d-flex align-items-center gap-2">
                                                                                            {q.dicotomizaciones && q.dicotomizaciones.length > 0 &&
                                                                                                <Badge bg="warning" text="dark"><Scissors/></Badge>
                                                                                            }
                                                                                            <Badge bg="dark" className="border border-secondary">{q.tipo_dato}</Badge>
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

            <CategoryFormModal
                show={showCatModal}
                onHide={() => setShowCatModal(false)}
                category={editingCat}
                onSave={handleSaveCategory}
                isEditing={!!editingCat}
            />

            <QuestionFormModal
                show={showQModal}
                onHide={() => setShowQModal(false)}
                question={editingQuestion}
                onSave={handleSaveQuestion}
                isEditing={!!editingQuestion}
                allQuestions={categories.flatMap(cat => cat.preguntas || [])}
            />
        </Container>
    );
};

export default SurveyBuilder;