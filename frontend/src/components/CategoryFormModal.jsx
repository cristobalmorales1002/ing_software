import { useState, useEffect } from 'react';
import { Modal, Button, Form } from 'react-bootstrap';

const CategoryFormModal = ({ show, onHide, category, onSave, isEditing }) => {
    const [nombre, setNombre] = useState('');

    // Cargar datos al abrir
    useEffect(() => {
        if (show) {
            setNombre(category ? category.nombre : '');
        }
    }, [show, category]);

    const handleSubmit = () => {
        if (!nombre.trim()) return;
        // Enviamos el objeto al padre
        onSave({ nombre });
    };

    return (
        <Modal show={show} onHide={onHide} backdrop="static" centered>
            <Modal.Header closeButton>
                <Modal.Title>{isEditing ? 'Editar Categoría' : 'Nueva Categoría'}</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <Form.Group className="mb-3">
                    <Form.Label>Nombre de la Categoría</Form.Label>
                    <Form.Control
                        type="text"
                        value={nombre}
                        onChange={e => setNombre(e.target.value)}
                        placeholder="Ej: Antecedentes Generales"
                        autoFocus
                        onKeyDown={e => e.key === 'Enter' && handleSubmit()}
                    />
                </Form.Group>
            </Modal.Body>
            <Modal.Footer>
                <Button variant="secondary" onClick={onHide}>Cancelar</Button>
                <Button variant="primary" onClick={handleSubmit}>Guardar</Button>
            </Modal.Footer>
        </Modal>
    );
};

export default CategoryFormModal;