import { useState, useEffect, useMemo } from 'react';
import { Container, Row, Col, Card, Spinner, Alert, Button, Offcanvas, Form, InputGroup, ProgressBar } from 'react-bootstrap';
import { People, GraphUp, PieChart as IconPieChart, GenderAmbiguous, FunnelFill, BarChartFill, PieChartFill, GearFill, ListUl, Search, Floppy, Calculator, Filter } from 'react-bootstrap-icons';
import api from '../api/axios';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

const DashboardHome = () => {

    const [dashboardStats, setDashboardStats] = useState([]);
    const [allPatients, setAllPatients] = useState([]);
    const [availableOptions, setAvailableOptions] = useState([]);

    const [kpis, setKpis] = useState({ total: 0, casos: 0, controles: 0 });
    const [loading, setLoading] = useState(true);
    const [updating, setUpdating] = useState(false);
    const [savingManual, setSavingManual] = useState(false);
    const [error, setError] = useState(null);

    const [showFilter, setShowFilter] = useState(false);
    const [chartTypes, setChartTypes] = useState({});
    const [grouping, setGrouping] = useState({});
    const [filterSearch, setFilterSearch] = useState('');

    const [patientFilter, setPatientFilter] = useState({
        showCasos: true,
        showControles: true
    });

    const PIE_COLORS = ['#0d6efd', '#0dcaf0', '#20c997', '#ffc107', '#dc3545', '#6610f2'];

    useEffect(() => {
        fetchInitialData();
    }, []);

    const fetchInitialData = async () => {
        setLoading(true);
        try {
            // 1. Obtener Pacientes (Datos Crudos)
            const resPacientes = await api.get('/api/pacientes');
            const pacientes = resPacientes.data || [];
            setAllPatients(pacientes);

            // KPIs
            const total = pacientes.length;
            const casos = pacientes.filter(p => p.esCaso).length;
            setKpis({ total, casos, controles: total - casos });

            // 2. Opciones Disponibles
            const resOptions = await api.get('/api/estadisticas/opciones');
            setAvailableOptions(resOptions.data || []);

            // 3. Configuración del Dashboard
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
                const newGrouping = { ...grouping };

                data.forEach(stat => {
                    if (!newTypes[stat.preguntaId]) {
                        const titulo = stat.tituloPregunta.toLowerCase();
                        // Asignar tipo de gráfico por defecto según el título
                        if (stat.preguntaId === 0 || titulo.includes('caso')) newTypes[stat.preguntaId] = 'pie';
                        else if (titulo.includes('sexo')) newTypes[stat.preguntaId] = 'pie';
                        else newTypes[stat.preguntaId] = 'bar';
                    }
                    if (isNumericStat(stat) && !newGrouping[stat.preguntaId]) {
                        newGrouping[stat.preguntaId] = 10;
                    }
                });

                setGrouping(newGrouping);
                return newTypes;
            });
        } catch (err) {
            console.error("Error recargando stats", err);
        }
    };

    // --- PROCESAMIENTO DE DATOS (CORREGIDO) ---
    const processedStats = useMemo(() => {
        return dashboardStats.map(stat => {
            // 1. Filtrar pacientes según checkboxes (Casos / Controles)
            const filteredPatients = allPatients.filter(p => {
                if (p.esCaso && !patientFilter.showCasos) return false;
                if (!p.esCaso && !patientFilter.showControles) return false;
                return true;
            });

            // --- INICIO CORRECCIÓN ---
            // Manejo especial para el gráfico de "Casos vs Controles" (ID 0)
            // Este gráfico NO depende de 'respuestas', sino del campo booleano 'esCaso'.
            if (stat.preguntaId === 0) {
                const countCasos = filteredPatients.filter(p => p.esCaso).length;
                const countControles = filteredPatients.filter(p => !p.esCaso).length;

                return {
                    ...stat,
                    datos: [
                        { etiqueta: 'Casos', valor: countCasos },
                        { etiqueta: 'Controles', valor: countControles }
                    ]
                };
            }
            // --- FIN CORRECCIÓN ---

            // 2. Calcular frecuencias para preguntas normales (Encuestas)
            const counts = {};
            filteredPatients.forEach(p => {
                // Validación robusta de respuestas
                if (!p.respuestas || !Array.isArray(p.respuestas)) return;

                const respuesta = p.respuestas.find(r =>
                    (r.preguntaId === stat.preguntaId) ||
                    (r.pregunta_id === stat.preguntaId)
                );

                if (respuesta && respuesta.valor !== null && respuesta.valor !== undefined && respuesta.valor !== '') {
                    const val = respuesta.valor;
                    counts[val] = (counts[val] || 0) + 1;
                }
            });

            // 3. Formatear como espera Recharts [{etiqueta: "X", valor: 10}]
            const dynamicData = Object.entries(counts).map(([k, v]) => ({
                etiqueta: k,
                valor: v
            }));

            // Retornar copia del stat con los datos recalculados
            return { ...stat, datos: dynamicData };
        });
    }, [dashboardStats, allPatients, patientFilter]);


    const isNumericStat = (stat) => {
        // El gráfico de Casos vs Controles (ID 0) no es numérico continuo
        if (stat.preguntaId === 0) return false;

        if (stat.tipoDato === 'NUMERO' || stat.tipoDato === 'DECIMAL') return true;
        // Revisar si los datos dinámicos parecen números
        if (!stat.datos || stat.datos.length === 0) return false;
        return !isNaN(parseFloat(stat.datos[0].etiqueta));
    };

    const calculateGroupedData = (rawData, bins) => {
        if (!bins || bins < 2 || !rawData || rawData.length === 0) return rawData;

        let numericValues = [];
        rawData.forEach(item => {
            const val = parseFloat(item.etiqueta);
            if (!isNaN(val)) numericValues.push({ val, count: item.valor });
        });

        if (numericValues.length === 0) return rawData;

        const min = Math.min(...numericValues.map(v => v.val));
        const max = Math.max(...numericValues.map(v => v.val));

        if (min === max) return rawData;

        const step = (max - min) / bins;
        const groups = [];

        for (let i = 0; i < bins; i++) {
            const start = min + (i * step);
            const end = min + ((i + 1) * step);
            // Formateo para evitar decimales infinitos
            const labelStart = Number.isInteger(start) ? start : start.toFixed(1);
            const labelEnd = Number.isInteger(end) ? end : end.toFixed(1);
            const label = `${labelStart} - ${labelEnd}`;

            groups.push({ etiqueta: label, valor: 0 });
        }

        numericValues.forEach(item => {
            let binIndex = Math.floor((item.val - min) / step);
            if (binIndex >= bins) binIndex = bins - 1;
            groups[binIndex].valor += item.count;
        });

        return groups;
    };

    // --- HANDLERS ---
    const handleFilterChange = (e) => {
        setPatientFilter({ ...patientFilter, [e.target.name]: e.target.checked });
    };

    const handleForceSave = async () => {
        setSavingManual(true);
        try {
            const currentIds = dashboardStats.map(s => s.preguntaId).filter(id => id !== 0);
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
            let newIds = isCurrentlyVisible ? currentIds.filter(id => id !== preguntaId) : [...currentIds, preguntaId];

            await api.post('/api/estadisticas/preferencias', { preguntasIds: newIds });
            await refreshDashboardStats();
        } catch (err) {
            console.error(err);
        } finally {
            setUpdating(false);
        }
    };

    const handleTypeChange = (id, type) => setChartTypes(prev => ({ ...prev, [id]: type }));
    const handleGroupingChange = (id, groups) => setGrouping(prev => ({ ...prev, [id]: groups }));

    const renderCustomizedLabel = ({ cx, cy, midAngle, innerRadius, outerRadius, percent }) => {
        const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
        const x = cx + radius * Math.cos(-midAngle * Math.PI / 180);
        const y = cy + radius * Math.sin(-midAngle * Math.PI / 180);
        // Solo mostramos etiqueta si el porcentaje es mayor a 0
        if (percent === 0) return null;
        return <text x={x} y={y} fill="white" textAnchor={x > cx ? 'start' : 'end'} dominantBaseline="central" fontSize="12px" fontWeight="bold">{`${(percent * 100).toFixed(0)}%`}</text>;
    };

    const filteredOptions = availableOptions.filter(opt =>
        opt.tituloPregunta.toLowerCase().includes(filterSearch.toLowerCase())
    );

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

            {/* BARRA DE HERRAMIENTAS (Filtros y Configuración) */}
            <Card className="mb-4 border-0 shadow-sm bg-light">
                <Card.Body className="d-flex flex-wrap justify-content-between align-items-center py-2 gap-3">

                    {/* ZONA 1: Filtros de Datos (Casos vs Controles) */}
                    <div className="d-flex align-items-center gap-3 border-end pe-3">
                        <div className="d-flex align-items-center text-secondary fw-bold small">
                            <Filter className="me-2"/> Datos:
                        </div>
                        <Form.Check
                            type="checkbox"
                            id="chk-casos"
                            name="showCasos"
                            label="Casos"
                            checked={patientFilter.showCasos}
                            onChange={handleFilterChange}
                            className="mb-0 fw-medium"
                        />
                        <Form.Check
                            type="checkbox"
                            id="chk-controles"
                            name="showControles"
                            label="Controles"
                            checked={patientFilter.showControles}
                            onChange={handleFilterChange}
                            className="mb-0 fw-medium"
                        />
                    </div>

                    {/* ZONA 2: Información y Botones de Acción */}
                    <div className="d-flex align-items-center gap-3">
                        <div className="d-flex align-items-center gap-2 text-primary me-2 d-none d-md-flex">
                            <BarChartFill />
                            <span className="fw-bold small">Activos: {processedStats.length}</span>
                        </div>

                        <Button variant="success" size="sm" onClick={handleForceSave} disabled={savingManual}>
                            {savingManual ? <Spinner as="span" animation="border" size="sm" role="status" aria-hidden="true" /> : <><Floppy className="me-2"/> Guardar gráficos seleccionados</>}
                        </Button>
                        <Button variant="primary" size="sm" onClick={() => setShowFilter(true)}>
                            <FunnelFill className="me-2"/> Configurar
                        </Button>
                    </div>
                </Card.Body>
            </Card>

            <Row>
                {processedStats.length === 0 && (
                    <Col><Alert variant="info" className="text-center">No hay gráficos configurados.</Alert></Col>
                )}

                {/* Usamos processedStats que tiene los datos filtrados en tiempo real */}
                {processedStats.map((stat) => {
                    const type = chartTypes[stat.preguntaId] || 'bar';
                    const isNum = isNumericStat(stat);
                    const currentGroups = grouping[stat.preguntaId];
                    const chartData = isNum ? calculateGroupedData(stat.datos, currentGroups) : stat.datos;

                    return (
                        <Col lg={6} key={stat.preguntaId} className="mb-4">
                            <Card className="h-100 border-0 shadow-sm" style={{minHeight:'400px'}}>
                                <Card.Header className="bg-transparent border-0 pt-4 px-4 d-flex justify-content-between align-items-start">
                                    <h5 className="mb-0 text-primary d-flex align-items-center gap-2 text-truncate" style={{maxWidth: '50%'}}>
                                        <GenderAmbiguous /> {stat.tituloPregunta}
                                    </h5>

                                    <div className="d-flex align-items-center gap-2">

                                        {/* Botones de Agrupación Dinámica */}
                                        {isNum && (
                                            <div className="d-flex gap-1 bg-warning bg-opacity-10 p-1 rounded me-2">
                                                <span className="d-flex align-items-center px-2 text-muted small" title="Agrupar intervalos"><Calculator size={14}/></span>
                                                {[5, 10, 15, 20].map(num => (
                                                    <Button
                                                        key={num}
                                                        variant={currentGroups === num ? 'warning' : 'transparent'}
                                                        size="sm"
                                                        className="border-0 px-2 py-0"
                                                        style={{
                                                            fontSize: '0.8rem',
                                                            fontWeight: 'bold',
                                                            color: currentGroups === num ? '#fff' : 'var(--text-muted)'
                                                        }}
                                                        onClick={() => handleGroupingChange(stat.preguntaId, num)}
                                                        title={`Dividir en ${num} grupos`}
                                                    >
                                                        {num}
                                                    </Button>
                                                ))}
                                            </div>
                                        )}

                                        {/* Selector de Tipo de Gráfico */}
                                        <div className="d-flex gap-1 bg-secondary bg-opacity-10 p-1 rounded">
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
                                    </div>
                                </Card.Header>
                                <Card.Body className="d-flex align-items-center justify-content-center p-4">
                                    {(!chartData || chartData.length === 0) ? (
                                        <div className="text-muted fst-italic">Sin datos para mostrar con los filtros actuales.</div>
                                    ) : (
                                        <>
                                            {type === 'bar' && (
                                                <ResponsiveContainer width="100%" height={300}>
                                                    <BarChart data={chartData} margin={{top:20, right:30, left:0, bottom:5}}>
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
                                                        <Pie data={chartData} cx="50%" cy="50%" labelLine={false} label={renderCustomizedLabel} outerRadius={100} fill="#8884d8" dataKey="valor" nameKey="etiqueta">
                                                            {chartData.map((entry, index) => <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />)}
                                                        </Pie>
                                                        <Tooltip contentStyle={{backgroundColor:'var(--bg-card)', borderColor:'var(--border-color)', color:'var(--text-main)'}} itemStyle={{color: 'var(--text-main)'}} />
                                                        <Legend wrapperStyle={{color: 'var(--text-main)'}} />
                                                    </PieChart>
                                                </ResponsiveContainer>
                                            )}

                                            {type === 'progress' && (
                                                <div className="w-100 px-2" style={{maxHeight: '300px', overflowY: 'auto'}}>
                                                    {chartData.map((dato, dIdx) => {
                                                        const totalVal = chartData.reduce((acc, curr) => acc + curr.valor, 0);
                                                        const porcentaje = totalVal > 0 ? Math.round((dato.valor / totalVal) * 100) : 0;

                                                        return (
                                                            <div key={dIdx} className="mb-4">
                                                                <div className="d-flex justify-content-between mb-2">
                                                                    <span className="fw-bold" style={{color: 'var(--text-main)'}}>{dato.etiqueta}</span>
                                                                    <span className="fw-bold" style={{color: 'var(--text-main)'}}>
                                                                        {dato.valor}
                                                                        <span className="fw-normal ms-2" style={{color: 'var(--text-muted)'}}>({porcentaje}%)</span>
                                                                    </span>
                                                                </div>
                                                                <ProgressBar now={porcentaje} variant={dIdx % 2 === 0 ? "info" : "primary"} style={{height: '10px', borderRadius: '5px', backgroundColor: 'var(--border-color)'}} />
                                                            </div>
                                                        )
                                                    })}
                                                </div>
                                            )}
                                        </>
                                    )}
                                </Card.Body>
                            </Card>
                        </Col>
                    );
                })}
            </Row>

            <Offcanvas show={showFilter} onHide={() => setShowFilter(false)} placement="end" style={{backgroundColor: 'var(--bg-card)', color: 'var(--text-main)'}}>
                <Offcanvas.Header closeButton>
                    <Offcanvas.Title><GearFill className="me-2"/> Mis gráficos</Offcanvas.Title>
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