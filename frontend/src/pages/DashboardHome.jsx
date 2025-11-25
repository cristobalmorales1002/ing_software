import { useState, useEffect } from 'react';
import { Container, Row, Col, Card, Spinner, Alert, Button, Offcanvas, Form, Badge, InputGroup, ProgressBar } from 'react-bootstrap';
import { People, GraphUp, PieChart as IconPieChart, GenderAmbiguous, FunnelFill, BarChartFill, PieChartFill, GearFill, ListUl, Search } from 'react-bootstrap-icons';
import api from '../api/axios';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

const DashboardHome = () => {
    const [allStats, setAllStats] = useState([]);
    const [kpis, setKpis] = useState({ total: 0, casos: 0, controles: 0 });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const [showFilter, setShowFilter] = useState(false);
    const [visibleIds, setVisibleIds] = useState(new Set());
    const [chartTypes, setChartTypes] = useState({});
    const [filterSearch, setFilterSearch] = useState('');

    const PIE_COLORS = ['#0d6efd', '#0dcaf0', '#20c997', '#ffc107', '#dc3545', '#6610f2'];

    useEffect(() => {
        const fetchData = async () => {
            setLoading(true);
            try {
                const resPacientes = await api.get('/api/pacientes');
                const total = resPacientes.data.length;
                const casos = resPacientes.data.filter(p => p.esCaso).length;
                setKpis({ total, casos, controles: total - casos });

                const resStats = await api.get('/api/estadisticas/dashboard');
                const data = resStats.data || [];
                setAllStats(data);

                if (visibleIds.size === 0 && data.length > 0) {
                    const initialSet = new Set();
                    const initialTypes = {};
                    const statSexo = data.find(s => s.tituloPregunta.toLowerCase().includes('sexo'));
                    const statCasos = data.find(s => s.tituloPregunta.toLowerCase().includes('casos'));

                    if (statCasos) {
                        initialSet.add(statCasos.preguntaId);
                        initialTypes[statCasos.preguntaId] = 'progress';
                    }
                    if (statSexo) {
                        initialSet.add(statSexo.preguntaId);
                        initialTypes[statSexo.preguntaId] = 'pie';
                    }
                    if (initialSet.size === 0) {
                        data.slice(0, 2).forEach(s => {
                            initialSet.add(s.preguntaId);
                            initialTypes[s.preguntaId] = 'bar';
                        });
                    }
                    setVisibleIds(initialSet);
                    setChartTypes(prev => ({ ...prev, ...initialTypes }));
                }
            } catch (err) {
                console.error(err);
                setError('No se pudieron cargar los datos.');
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    const toggleVisibility = (id) => {
        const newSet = new Set(visibleIds);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setVisibleIds(newSet);
    };

    const handleTypeChange = (id, type) => {
        setChartTypes(prev => ({ ...prev, [id]: type }));
    };

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

    if (loading && allStats.length === 0) return <div className="text-center py-5"><Spinner animation="border" variant="primary"/></div>;

    const visibleStats = allStats.filter(s => visibleIds.has(s.preguntaId));
    const filteredStatsForSettings = allStats.filter(stat =>
        stat.tituloPregunta.toLowerCase().includes(filterSearch.toLowerCase())
    );

    return (
        <Container fluid className="p-0">
            <div className="d-flex justify-content-between align-items-center mb-4">
                <h2 className="mb-0">DASHBOARD GENERAL</h2>
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
                        <span className="fw-bold">Gráficos Activos: {visibleStats.length}</span>
                    </div>
                    <Button variant="primary" size="sm" onClick={() => setShowFilter(true)}>
                        <FunnelFill className="me-2"/> Filtrar y Personalizar
                    </Button>
                </Card.Body>
            </Card>

            <Row>
                {visibleStats.length === 0 && (
                    <Col><Alert variant="info" className="text-center">No hay gráficos seleccionados.</Alert></Col>
                )}

                {visibleStats.map((stat) => {
                    const type = chartTypes[stat.preguntaId] || 'progress';

                    return (
                        <Col lg={6} key={stat.preguntaId} className="mb-4">
                            <Card className="h-100 border-0 shadow-sm" style={{minHeight:'400px'}}>
                                <Card.Header className="bg-transparent border-0 pt-4 px-4 d-flex justify-content-between">
                                    <h5 className="mb-0 text-primary d-flex align-items-center gap-2">
                                        <GenderAmbiguous /> {stat.tituloPregunta}
                                    </h5>

                                    {/* BOTONES DE TIPO DE GRÁFICO CORREGIDOS */}
                                    <div className="d-flex gap-1 bg-secondary bg-opacity-10 p-1 rounded">
                                        <Button
                                            variant={type === 'bar' ? 'white' : 'transparent'}
                                            size="sm"
                                            className="border-0"
                                            // CAMBIO: Si no está activo, usa var(--text-main) que es blanco en modo oscuro
                                            style={{ color: type === 'bar' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'bar' ? 1 : 0.5 }}
                                            onClick={() => handleTypeChange(stat.preguntaId, 'bar')}
                                            title="Barras"
                                        >
                                            <BarChartFill />
                                        </Button>
                                        <Button
                                            variant={type === 'pie' ? 'white' : 'transparent'}
                                            size="sm"
                                            className="border-0"
                                            style={{ color: type === 'pie' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'pie' ? 1 : 0.5 }}
                                            onClick={() => handleTypeChange(stat.preguntaId, 'pie')}
                                            title="Circular"
                                        >
                                            <PieChartFill />
                                        </Button>
                                        <Button
                                            variant={type === 'progress' ? 'white' : 'transparent'}
                                            size="sm"
                                            className="border-0"
                                            style={{ color: type === 'progress' ? 'var(--accent-color)' : 'var(--text-main)', opacity: type === 'progress' ? 1 : 0.5 }}
                                            onClick={() => handleTypeChange(stat.preguntaId, 'progress')}
                                            title="Lineal"
                                        >
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
                                                {/* CAMBIO: Tooltip igual al de Barras */}
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

            {/* PANEL LATERAL */}
            <Offcanvas show={showFilter} onHide={() => setShowFilter(false)} placement="end" style={{backgroundColor: 'var(--bg-card)', color: 'var(--text-main)'}}>
                <Offcanvas.Header closeButton>
                    <Offcanvas.Title><GearFill className="me-2"/> Configurar Vistas</Offcanvas.Title>
                </Offcanvas.Header>
                <Offcanvas.Body>
                    <p className="small mb-3" style={{color: 'var(--text-muted)'}}>Selecciona los gráficos que deseas visualizar.</p>

                    <InputGroup className="mb-4">
                        <InputGroup.Text className="bg-transparent border-secondary border-opacity-25" style={{color: 'var(--text-muted)'}}>
                            <Search />
                        </InputGroup.Text>
                        <Form.Control
                            placeholder="Buscar estadística..."
                            value={filterSearch}
                            onChange={(e) => setFilterSearch(e.target.value)}
                            className="bg-transparent border-secondary border-opacity-25 shadow-none"
                            style={{ color: 'var(--text-main)', borderLeft: 'none' }}
                        />
                    </InputGroup>

                    {filteredStatsForSettings.length === 0 ? (
                        <div className="text-center opacity-50 py-3" style={{color: 'var(--text-muted)'}}>No se encontraron resultados.</div>
                    ) : (
                        <Form>
                            {filteredStatsForSettings.map(stat => (
                                <Card key={stat.preguntaId} className="mb-3 border-secondary border-opacity-25 shadow-none bg-transparent">
                                    <Card.Body className="py-3">
                                        <div className="d-flex justify-content-between align-items-center mb-3">
                                            <Form.Check
                                                type="switch"
                                                id={`sw-${stat.preguntaId}`}
                                                label={<span className="fw-bold" style={{color: 'var(--text-main)'}}>{stat.tituloPregunta}</span>}
                                                checked={visibleIds.has(stat.preguntaId)}
                                                onChange={() => toggleVisibility(stat.preguntaId)}
                                            />
                                        </div>
                                        {visibleIds.has(stat.preguntaId) && (
                                            <InputGroup size="sm">
                                                <InputGroup.Text className="bg-transparent border-secondary border-opacity-50" style={{color: 'var(--text-muted)'}}>Tipo</InputGroup.Text>
                                                <Form.Select
                                                    size="sm"
                                                    value={chartTypes[stat.preguntaId] || 'progress'}
                                                    onChange={(e) => handleTypeChange(stat.preguntaId, e.target.value)}
                                                    className="bg-transparent border-secondary border-opacity-50 shadow-none"
                                                    style={{color: 'var(--text-main)'}}
                                                >
                                                    <option value="progress" style={{color:'black'}}>≣ Lineal (Progreso)</option>
                                                    <option value="bar" style={{color:'black'}}>📊 Barras</option>
                                                    <option value="pie" style={{color:'black'}}>🥧 Circular</option>
                                                </Form.Select>
                                            </InputGroup>
                                        )}
                                    </Card.Body>
                                </Card>
                            ))}
                        </Form>
                    )}
                </Offcanvas.Body>
            </Offcanvas>
        </Container>
    );
};

export default DashboardHome;