import { useState, useEffect } from 'react';
import { Container, Row, Col, Card, ProgressBar, Spinner, Alert } from 'react-bootstrap';
import { People, GraphUp, PieChart, GenderAmbiguous } from 'react-bootstrap-icons';
import api from '../api/axios';

const DashboardHome = () => {
    const [stats, setStats] = useState([]);
    const [kpis, setKpis] = useState({ total: 0, casos: 0, controles: 0 });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            setLoading(true);
            try {
                // 1. KPIs: Usamos el endpoint de pacientes
                const resPacientes = await api.get('/api/pacientes');
                const total = resPacientes.data.length;
                const casos = resPacientes.data.filter(p => p.esCaso).length;

                setKpis({ total, casos, controles: total - casos });

                // 2. Gráficos: Usamos el endpoint de estadísticas
                const resStats = await api.get('/api/estadisticas/dashboard');
                setStats(resStats.data || []);

            } catch (err) {
                console.error(err);
                setError('No hay datos suficientes o el servicio no responde.');
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    const StatCard = ({ title, value, icon, color }) => (
        <Card className="h-100 shadow-sm border-0"> {/* Quitamos bg-dark-subtle para que use el del tema */}
            <Card.Body className="d-flex align-items-center">
                <div className={`rounded-circle p-3 bg-${color} bg-opacity-10 text-${color} me-3`}>
                    {icon}
                </div>
                <div>
                    {/* CORRECCIONES:
                        1. Quitamos 'text-muted'. Usamos 'opacity-75' para que sea el mismo color del tema pero más suave.
                        2. Quitamos 'text-white'. Ahora heredará el color correcto (Negro en Claro, Blanco en Oscuro).
                    */}
                    <h6 className="mb-0 small text-uppercase fw-bold opacity-75">{title}</h6>
                    <h2 className="mb-0 fw-bold">{value}</h2>
                </div>
            </Card.Body>
        </Card>
    );

    if (loading) return <div className="text-center py-5"><Spinner animation="border" variant="primary"/></div>;

    return (
        <Container fluid className="p-0">
            <h2 className="mb-4">DASHBOARD GENERAL</h2>
            {error && <Alert variant="info">{error}</Alert>}

            <Row className="mb-4 g-3">
                <Col md={4}><StatCard title="Total Participantes" value={kpis.total} icon={<People size={24}/>} color="primary" /></Col>
                <Col md={4}><StatCard title="Casos (Cáncer)" value={kpis.casos} icon={<GraphUp size={24}/>} color="danger" /></Col>
                <Col md={4}><StatCard title="Controles (Sanos)" value={kpis.controles} icon={<PieChart size={24}/>} color="success" /></Col>
            </Row>

            <Row>
                {stats.length === 0 && !error && <Col><Alert variant="secondary">No hay variables configuradas para estadísticas aún.</Alert></Col>}

                {stats.map((stat, idx) => (
                    <Col lg={6} key={idx} className="mb-4">
                        <Card className="h-100 border-secondary border-opacity-25 bg-transparent">
                            <Card.Header className="bg-dark bg-opacity-25 border-secondary border-opacity-25">
                                <h5 className="mb-0 text-info d-flex align-items-center gap-2"><GenderAmbiguous /> {stat.tituloPregunta}</h5>
                            </Card.Header>
                            <Card.Body>
                                {stat.datos.map((dato, dIdx) => (
                                    <div key={dIdx} className="mb-3">
                                        <div className="d-flex justify-content-between mb-1 small"> {/* Quitamos text-white */}
                                            <span className="fw-bold">{dato.etiqueta}</span>
                                            <span className="fw-bold">{dato.valor} ({dato.porcentaje}%)</span>
                                        </div>
                                        <ProgressBar now={dato.porcentaje} variant={dIdx % 2 === 0 ? "info" : "primary"} style={{height: '8px', backgroundColor: 'rgba(255,255,255,0.1)'}} />
                                    </div>
                                ))}
                            </Card.Body>
                        </Card>
                    </Col>
                ))}
            </Row>
        </Container>
    );
};
export default DashboardHome;