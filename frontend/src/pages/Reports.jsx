import { useState } from 'react';
import { Container, Row, Col, Card, Button, Spinner, Alert } from 'react-bootstrap';
import { FileEarmarkExcel, FileEarmarkPdf, Download, ShieldLock, Table } from 'react-bootstrap-icons';
import api from '../api/axios';

const Reports = () => {
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    const handleDownload = async (url, filename, params = {}) => {
        setLoading(true);
        setError(null);
        try {
            const response = await api.get(url, {
                params: params,
                responseType: 'blob'
            });
            const urlBlob = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = urlBlob;
            link.setAttribute('download', filename);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
            window.URL.revokeObjectURL(urlBlob);
        } catch (err) {
            console.error("Error descarga:", err);
            setError('Error al descargar el archivo. Intente nuevamente.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Container fluid className="p-0">

            {/* 1. AGREGADO: text-center para centrar el título */}
            <h2 className="mb-4 text-center">CENTRO DE DOCUMENTOS</h2>

            {error && <Alert variant="danger" onClose={() => setError(null)} dismissible>{error}</Alert>}

            {/* 2. AGREGADO: justify-content-center para centrar las tarjetas horizontalmente */}
            <Row className="g-4 justify-content-center">

                {/* TARJETA 1: EXCEL */}
                <Col md={10} lg={6}> {/* Ajusté xl={4} para que no sean tan anchas en pantallas gigantes */}
                    <Card className="h-100 shadow-sm border-0">
                        <Card.Header className="bg-success bg-opacity-10 text-success fw-bold d-flex align-items-center gap-2 justify-content-center">
                            <FileEarmarkExcel size={20}/> Base de Datos (Excel)
                        </Card.Header>
                        <Card.Body>
                            <p className="text-muted small mb-4 text-center">
                                Descarga la base de datos completa de los pacientes y sus respuestas para análisis estadístico.
                            </p>

                            <div className="d-grid gap-3">
                                <Button
                                    variant="outline-success"
                                    className="d-flex justify-content-between align-items-center"
                                    onClick={() => handleDownload('/api/exportar/excel', 'Base_Completa.xlsx', { anonimo: false, dicotomizar: false })}
                                    disabled={loading}
                                >
                                    <span><Table className="me-2"/> Base Completa</span>
                                    <Download />
                                </Button>

                                <Button
                                    variant="outline-primary"
                                    className="d-flex justify-content-between align-items-center"
                                    onClick={() => handleDownload('/api/exportar/excel', 'Base_Anonima.xlsx', { anonimo: true, dicotomizar: false })}
                                    disabled={loading}
                                >
                                    <span><ShieldLock className="me-2"/> Base Anonimizada</span>
                                    <Download />
                                </Button>

                                <Button
                                    variant="outline-dark"
                                    className="d-flex justify-content-between align-items-center"
                                    onClick={() => handleDownload('/api/exportar/excel', 'Base_Dicotomizada.xlsx', { anonimo: true, dicotomizar: true })}
                                    disabled={loading}
                                >
                                    <span><Table className="me-2"/> Base Dicotomizada</span>
                                    <Download />
                                </Button>
                            </div>
                        </Card.Body>
                    </Card>
                </Col>

                {/* TARJETA 2: PDF */}
                <Col md={10} lg={6}>
                    <Card className="h-100 shadow-sm border-0">
                        <Card.Header className="bg-danger bg-opacity-10 text-danger fw-bold d-flex align-items-center gap-2 justify-content-center">
                            <FileEarmarkPdf size={20}/> Documentación Clínica
                        </Card.Header>
                        <Card.Body>
                            <p className="text-muted small mb-4 text-center">
                                Descarga plantillas vacías del Formulario de Reporte de Caso (CRF) para impresión.
                            </p>

                            <div className="d-grid gap-2">
                                <Button
                                    variant="outline-danger"
                                    className="d-flex justify-content-between align-items-center p-3"
                                    onClick={() => handleDownload('/api/pdf/crf/vacio', 'CRF_Plantilla_Vacia.pdf')}
                                    disabled={loading}
                                >
                                    <div className="text-start">
                                        <div className="fw-bold">CRF Plantilla Vacía</div>
                                        <div className="small text-muted" style={{fontSize:'0.75rem'}}>Formulario completo sin datos</div>
                                    </div>
                                    <Download />
                                </Button>
                            </div>

                            <Alert variant="info" className="mt-4 mb-0 small text-center">
                                <i className="bi bi-info-circle me-2"></i>
                                Para descargar el CRF lleno, dirígete a <strong>Casos y Controles</strong>.
                            </Alert>
                        </Card.Body>
                    </Card>
                </Col>
            </Row>

            {loading && (
                <div className="position-fixed top-50 start-50 translate-middle p-4 bg-white rounded shadow text-center" style={{zIndex: 2000}}>
                    <Spinner animation="border" variant="primary" className="mb-2"/>
                    <div>Generando archivo...</div>
                </div>
            )}
        </Container>
    );
};

export default Reports;