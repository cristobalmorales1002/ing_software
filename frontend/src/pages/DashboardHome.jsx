import { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Spinner, Alert, Button, Offcanvas, Form, InputGroup, ProgressBar } from 'react-bootstrap';

import { People, GraphUp, PieChart as IconPieChart, GenderAmbiguous, FunnelFill, BarChartFill, PieChartFill, GearFill, ListUl, Search, Floppy } from 'react-bootstrap-icons';
import api from '../api/axios';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

const DashboardHome = () => {

    const [dashboardStats, setDashboardStats] = useState([]);

    const [availableOptions, setAvailableOptions] = useState([]);

    const [kpis, setKpis] = useState({ total: 0, casos: 0, controles: 0 });
    const [loading, setLoading] = useState(true);
    const [updating, setUpdating] = useState(false);
    const [savingManual, setSavingManual] = useState(false);
    const [error, setError] = useState(null);

    const [showFilter, setShowFilter] = useState(false);
    const [chartTypes, setChartTypes] = useState({});
    const [filterSearch, setFilterSearch] = useState('');

    const PIE_COLORS = ['#0d6efd', '#0dcaf0', '#20c997', '#ffc107', '#dc3545', '#6610f2'];


    useEffect(() => {
        fetchInitialData();
    }, []);

    const fetchInitialData = async () => {
        setLoading(true);
        try {

            const resPacientes = await api.get('/api/pacientes');
            const total = resPacientes.data.length;
            const casos = resPacientes.data.filter(p => p.esCaso).length;
            setKpis({ total, casos, controles: total - casos });

            const resOptions = await api.get('/api/estadisticas/opciones');
            setAvailableOptions(resOptions.data || []);

            await refreshDashboardStats();

        } catch (err) {
            console.error(err);
            setError('No se pudieron cargar los datos.');
        } finally {
            setLoading(false);
        }
    };

    const refreshDashboardStats = async () => {
        try {
            const resStats = await api.get('/api/estadisticas/dashboard');
            const data = resStats.data || [];
            setDashboardStats(data);

            setChartTypes(prev => {
                const newTypes = { ...prev };
                data.forEach(stat => {
                    if (!newTypes[stat.preguntaId]) {
                        const titulo = stat.tituloPregunta.toLowerCase();
                        if (titulo.includes('sexo')) newTypes[stat.preguntaId] = 'pie';
                        else if (titulo.includes('casos')) newTypes[stat.preguntaId] = 'progress';
                        else newTypes[stat.preguntaId] = 'bar';
                    }
                });
                return newTypes;
            });
        } catch (err) {
            console.error("Error recargando stats", err);
        }
    };

    const handleForceSave = async () => {
        setSavingManual(true);
        try {
            const currentIds = dashboardStats
                .map(s => s.preguntaId)
                .filter(id => id !== 0);

            console.log("Forzando guardado de IDs:", currentIds);

            await api.post('/api/estadisticas/preferencias', { preguntasIds: currentIds });

            alert("¡Preferencias guardadas exitosamente!");
        } catch (err) {
            console.error(err);
            alert("Error al guardar las preferencias.");
        } finally {
            setSavingManual(false);
        }
    };

    const handleToggleStat = async (preguntaId) => {
        setUpdating(true);
        try {
            const currentIds = dashboardStats.map(s => s.preguntaId).filter(id => id !== 0);
            const isCurrentlyVisible = currentIds.includes(preguntaId);

            let newIds;
            if (isCurrentlyVisible) {
                newIds = currentIds.filter(id => id !== preguntaId);
            } else {
                newIds = [...currentIds, preguntaId];
            }

            await api.post('/api/estadisticas/preferencias', { preguntasIds: newIds });

            await refreshDashboardStats();

        } catch (err) {
            console.error(err);
        } finally {
            setUpdating(false);
        }
    };

    const handleTypeChange = (id, type) => {
        setChartTypes(prev => ({ ...prev, [id]: type }));
    };

    const filteredOptions = availableOptions.filter(opt =>
        opt.tituloPregunta.toLowerCase().includes(filterSearch.toLowerCase())
    );

    const renderCustomizedLabel = ({ cx, cy, midAngle, innerRadius, outerRadius, percent }) => {
        const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
        const x = cx + radius * Math.cos(-midAngle * Math.PI / 180);
        const y = cy + radius * Math.sin(-midAngle * Math.PI / 180);
        return <text x={x} y={y} fill="white" textAnchor={x > cx ? 'start' : 'end'} dominantBaseline="central" fontSize="12px" fontWeight="bold">{`${(percent * 100).toFixed(0)}%`}</text>;
    };

    const StatCard = ({ title, value, icon, color }) => (
        <Card className="h-100 shadow-sm border-0">
            <Card.Body className="d-flex align-items-center">
                <div className={`rounded-circle p-3 bg-${color} bg-opacity-10 text-${color} me-3`}>{icon}</div>
                <div>
                    <h6 className="mb-0 small text-uppercase fw-bold opacity-75">{title}</h6>
                    <h2 className="mb-0 fw-bold">{value}</h2>
                </div>
            </Card.Body>
        </Card>
    );

    if (loading) return <div className="text-center py-5"><Spinner animation="border" variant="primary"/></div>;

    return (
        <Container fluid className="p-0">
            <div className="d-flex justify-content-between align-items-center mb-4">
                <h2 className="mb-0">DASHBOARD GENERAL</h2>
                {updating && <Spinner animation="border" size="sm" className="text-primary" />}
            </div>

            {error && <Alert variant="warning">{error}</Alert>}

            <Row className="mb-4 g-3">
                <Col md={4}><StatCard title="Total Participantes" value={kpis.total} icon={<People size={24}/>} color="primary" /></Col>
                <Col md={4}><StatCard title="Casos (Cáncer)" value={kpis.casos} icon={<GraphUp size={24}/>} color="danger" /></Col>
                <Col md={4}><StatCard title="Controles (Sanos)" value={kpis.controles} icon={<IconPieChart size={24}/>} color="success" /></Col>
            </Row>

            <Card className="mb-4 border-0 shadow-sm bg-primary bg-opacity-10">
                <Card.Body className="d-flex justify-content-between align-items-center py-2">
                    <div className="d-flex align-items-center gap-2 text-primary">
                        <BarChartFill />
                        <span className="fw-bold">Gráficos Activos: {dashboardStats.length}</span>
                    </div>

                    {}
                    <div className="d-flex gap-2">
                        {}
                        <Button
                            variant="success"
                            size="sm"
                            onClick={handleForceSave}
                            disabled={savingManual}
                        >
                            {savingManual ? (
                                <Spinner as="span" animation="border" size="sm" role="status" aria-hidden="true" />
                            ) : (
                                <>
                                    <Floppy className="me-2"/> Guardar preferencias de gráficos
                                </>
                            )}
                        </Button>

                        {}
                        <Button variant="primary" size="sm" onClick={() => setShowFilter(true)}>
                            <FunnelFill className="me-2"/> Filtrar y personalizar
                        </Button>
                    </div>
                </Card.Body>
            </Card>

            <Row>
                {dashboardStats.length === 0 && (
                    <Col><Alert variant="info" className="text-center">No hay gráficos configurados.</Alert></Col>
                )}

                {dashboardStats.map((stat) => {
                    const type = chartTypes[stat.preguntaId] || 'bar';

                    return (
                        <Col lg={6} key={stat.preguntaId} className="mb-4">
                            <Card className="h-100 border-0 shadow-sm" style={{minHeight:'400px'}}>
                                <Card.Header className="bg-transparent border-0 pt-4 px-4 d-flex justify-content-between">
                                    <h5 className="mb-0 text-primary d-flex align-items-center gap-2 text-truncate">
                                        <GenderAmbiguous /> {stat.tituloPregunta}
                                    </h5>

                                    <div className="d-flex gap-1 bg-secondary bg-opacity-10 p-1 rounded ms-2">
                                        <Button variant={type === 'bar' ? 'white' : 'transparent'} size="sm" className="border-0"
                                                style={{ color: type === 'bar' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'bar' ? 1 : 0.5 }}
                                                onClick={() => handleTypeChange(stat.preguntaId, 'bar')} title="Barras">
                                            <BarChartFill />
                                        </Button>
                                        <Button variant={type === 'pie' ? 'white' : 'transparent'} size="sm" className="border-0"
                                                style={{ color: type === 'pie' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'pie' ? 1 : 0.5 }}
                                                onClick={() => handleTypeChange(stat.preguntaId, 'pie')} title="Circular">
                                            <PieChartFill />
                                        </Button>
                                        <Button variant={type === 'progress' ? 'white' : 'transparent'} size="sm" className="border-0"
                                                style={{ color: type === 'progress' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'progress' ? 1 : 0.5 }}
                                                onClick={() => handleTypeChange(stat.preguntaId, 'progress')} title="Lista">
                                            <ListUl />
                                        </Button>
                                    </div>
                                </Card.Header>
                                <Card.Body className="d-flex align-items-center justify-content-center p-4">
                                    {type === 'bar' && (
                                        <ResponsiveContainer width="100%" height={300}>
                                            <BarChart data={stat.datos || []} margin={{top:20, right:30, left:0, bottom:5}}>
                                                <CartesianGrid strokeDasharray="3 3" opacity={0.2} />
                                                <XAxis dataKey="etiqueta" tick={{fill:'var(--text-muted)', fontSize:12}} axisLine={false} tickLine={false}/>
                                                <YAxis tick={{fill:'var(--text-muted)', fontSize:12}} axisLine={false} tickLine={false}/>
                                                <Tooltip contentStyle={{backgroundColor:'var(--bg-card)', borderColor:'var(--border-color)', color:'var(--text-main)'}} cursor={{fill: 'var(--hover-bg)'}} />
                                                <Bar dataKey="valor" fill="var(--accent-color)" radius={[4,4,0,0]} name="Cantidad" />
                                            </BarChart>
                                        </ResponsiveContainer>
                                    )}

                                    {type === 'pie' && (
                                        <ResponsiveContainer width="100%" height={300}>
                                            <PieChart>
                                                <Pie data={stat.datos || []} cx="50%" cy="50%" labelLine={false} label={renderCustomizedLabel} outerRadius={100} fill="#8884d8" dataKey="valor" nameKey="etiqueta">
                                                    {(stat.datos || []).map((entry, index) => <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />)}
                                                </Pie>
                                                <Tooltip contentStyle={{backgroundColor:'var(--bg-card)', borderColor:'var(--border-color)', color:'var(--text-main)'}} itemStyle={{color: 'var(--text-main)'}} />
                                                <Legend wrapperStyle={{color: 'var(--text-main)'}} />
                                            </PieChart>
                                        </ResponsiveContainer>
                                    )}

                                    {type === 'progress' && (
                                        <div className="w-100 px-2">
                                            {(stat.datos || []).map((dato, dIdx) => (
                                                <div key={dIdx} className="mb-4">
                                                    <div className="d-flex justify-content-between mb-2">
                                                        <span className="fw-bold" style={{color: 'var(--text-main)'}}>{dato.etiqueta}</span>
                                                        <span className="fw-bold" style={{color: 'var(--text-main)'}}>
                                                            {dato.valor}
                                                            <span className="fw-normal ms-2" style={{color: 'var(--text-muted)'}}>({dato.porcentaje}%)</span>
                                                        </span>
                                                    </div>
                                                    <ProgressBar now={dato.porcentaje} variant={dIdx % 2 === 0 ? "info" : "primary"} style={{height: '10px', borderRadius: '5px', backgroundColor: 'var(--border-color)'}} />
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </Card.Body>
                            </Card>
                        </Col>
                    );
                })}
            </Row>

            <Offcanvas show={showFilter} onHide={() => setShowFilter(false)} placement="end" style={{backgroundColor: 'var(--bg-card)', color: 'var(--text-main)'}}>
                <Offcanvas.Header closeButton>
                    <Offcanvas.Title><GearFill className="me-2"/> Mis Gráficos</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    <p className="small mb-3" style={{color: 'var(--text-muted)'}}>
                        Activa las estadísticas que deseas ver y luego presiona <strong>"Guardar preferencias"</strong> en el dashboard.
                    </p>

                    <InputGroup className="mb-4">
                        <InputGroup.Text className="bg-transparent border-secondary border-opacity-25" style={{color: 'var(--text-muted)'}}>
                            <Search />
                        </InputGroup.Text>
                        <Form.Control
                            placeholder="Buscar variable..."
                            value={filterSearch}
                            onChange={(e) => setFilterSearch(e.target.value)}
                            className="bg-transparent border-secondary border-opacity-25 shadow-none"
                            style={{ color: 'var(--text-main)', borderLeft: 'none' }}
                        />
                    </InputGroup>

                    {filteredOptions.length === 0 ? (
                        <div className="text-center opacity-50 py-3" style={{color: 'var(--text-muted)'}}>No se encontraron variables.</div>
                    ) : (
                        <div className="d-flex flex-column gap-2">
                            {filteredOptions.map(opt => {
                                const isChecked = dashboardStats.some(s => s.preguntaId === opt.preguntaId);

                                return (
                                    <Card key={opt.preguntaId} className={`border-secondary border-opacity-25 shadow-none ${isChecked ? 'bg-primary bg-opacity-10' : 'bg-transparent'}`}>
                                        <Card.Body className="py-2 d-flex align-items-center justify-content-between">
                                            <span className="fw-bold small" style={{color: 'var(--text-main)'}}>{opt.tituloPregunta}</span>
                                            <Form.Check
                                                type="switch"
                                                id={`sw-${opt.preguntaId}`}
                                                checked={isChecked}
                                                disabled={updating}
                                                onChange={() => handleToggleStat(opt.preguntaId)}
                                                style={{transform: 'scale(1.2)'}}
                                            />
                                        </Card.Body>
                                    </Card>
                                );
                            })}
                        </div>
                    )}
                </Offcanvas.Body>
            </Offcanvas>
        </Container>
    );
};

export default DashboardHome;