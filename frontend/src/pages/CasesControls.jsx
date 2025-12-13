import { useState, useEffect, useMemo } from 'react';
import {
    Container, Row, Col, Form, InputGroup, Button, Card, ListGroup,
    Badge, Spinner, Modal, ProgressBar, Table, OverlayTrigger, Tooltip,
    Tabs, Tab, Accordion, Toast, ToastContainer
} from 'react-bootstrap';
import { Link } from 'react-router-dom';
import {
    Search, PlusLg, PersonVcard, ClipboardPulse, ArrowRight, ArrowLeft,
    Save, FileEarmarkPdf, Download,
    ExclamationTriangle, QuestionCircle, Pencil, Trash, ExclamationCircle, Activity, Gear
} from 'react-bootstrap-icons';
import api from '../api/axios';
import { formatRut } from '../utils/rutUtils';
import { getPhoneConfig, COUNTRY_PHONE_DATA } from '../utils/phoneUtils';

const CasesControls = () => {
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [isLoading, setIsLoading] = useState(false);
    const [isSaving, setIsSaving] = useState(false);

    const [filters, setFilters] = useState({ showCasos: true, showControles: true });
    const [selectedIds, setSelectedIds] = useState(new Set());
    const [isDownloading, setIsDownloading] = useState(false);

    const [showModal, setShowModal] = useState(false);
    const [isCase, setIsCase] = useState(true);
    const [surveyStructure, setSurveyStructure] = useState([]);
    const [currentStep, setCurrentStep] = useState(0);
    const [formData, setFormData] = useState({});

    // Estado para errores de validación
    const [validationErrors, setValidationErrors] = useState({});

    const [countryCodes, setCountryCodes] = useState({});
    const [loadingSurvey, setLoadingSurvey] = useState(false);

    const [editingId, setEditingId] = useState(null);
    const [currentUser, setCurrentUser] = useState(null);
    const [usersMap, setUsersMap] = useState({});

    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [itemToDelete, setItemToDelete] = useState(null);

    // --- ESTADOS CONFIGURACIÓN ADMIN ---
    const [showConfigModal, setShowConfigModal] = useState(false);
    const [savingConfigId, setSavingConfigId] = useState(null);

    // Helper para deducir letras (Ej: de "CC", "CT", "TT" saca "C" y "T")
    const getAlelosPosibles = (conf) => {
        const raw = (conf.opcion1 + conf.opcion2 + conf.opcion3).split('');
        return [...new Set(raw)].sort();
    };

    // Función para guardar el alelo de riesgo
    const handleSaveConfig = async (id, nuevoAlelo) => {
        setSavingConfigId(id);
        try {
            await api.put(`/api/genetica/configuracion/${id}`, nuevoAlelo, {
                headers: { 'Content-Type': 'application/json' }
            });

            // Actualizamos la lista localmente
            setMuestraGenesConfig(prev => prev.map(c =>
                c.id_snp === id ? { ...c, aleloRiesgo: nuevoAlelo } : c
            ));

            // Si hay un paciente seleccionado, recargamos su análisis para ver el impacto inmediato
            if (selectedItem) fetchAnalisisGenetico(selectedItem.dbId);

        } catch (err) {
            console.error(err);
            alert("Error al guardar configuración.");
        } finally {
            setSavingConfigId(null);
        }
    };

    // --- ESTADOS PARA GENÉTICA (MUESTRAS) ---
    const [muestraGenesConfig, setMuestraGenesConfig] = useState([]);
    const [analisisGenetico, setAnalisisGenetico] = useState([]);
    const [loadingAnalisis, setLoadingAnalisis] = useState(false);
    const [showMuestraModal, setShowMuestraModal] = useState(false);
    const [formMuestraData, setFormMuestraData] = useState({});
    const [showToast, setShowToast] = useState(false);
    const [toastMessage, setToastMessage] = useState("");
    const [toastVariant, setToastVariant] = useState("success");

    const currentUserId = currentUser ? (currentUser.idUsuario || currentUser.id || currentUser.usuarioId) : null;

    // --- FUNCIONES GENÉTICA ---
    const fetchGenesConfig = async () => {
        try {
            const res = await api.get('/api/genetica/configuraciones');
            setMuestraGenesConfig(res.data || []);
        } catch (err) { console.error("Error config genética:", err); }
    };

    const fetchAnalisisGenetico = async (pacienteId) => {
        if (!pacienteId) return;
        setLoadingAnalisis(true);
        try {
            const res = await api.get(`/api/genetica/analisis/${pacienteId}`);
            setAnalisisGenetico(res.data || []);
        } catch (err) {
            console.error(err);
            setAnalisisGenetico([]);
        } finally { setLoadingAnalisis(false); }
    };

    const handleOpenMuestraModal = () => {
        const dataPrevia = {};

        // Recorremos la configuración de los genes (que tiene los IDs necesarios para el input)
        muestraGenesConfig.forEach(config => {
            // Buscamos si ya existe un análisis para este gen comparando el nombre
            const resultadoExistente = analisisGenetico.find(a => a.nombreGen === config.nombreGen);

            // Si hay resultado, lo asignamos al estado del formulario usando el ID del SNP
            if (resultadoExistente && resultadoExistente.resultadoPaciente) {
                dataPrevia[config.id_snp] = resultadoExistente.resultadoPaciente;
            }
        });

        setFormMuestraData(dataPrevia);
        setShowMuestraModal(true);
    };

    const handleMuestraChange = (snpId, valor) => {
        setFormMuestraData(prev => ({ ...prev, [snpId]: valor }));
    };

    const handleSaveMuestra = async () => {
        if (!selectedItem) return;
        setIsSaving(true);
        try {
            const promesas = Object.entries(formMuestraData).map(async ([snpId, resultado]) => {
                if(!resultado) return;
                return api.post('/api/genetica/muestra', {
                    participanteId: selectedItem.dbId,
                    snpConfigId: parseInt(snpId),
                    resultado: resultado
                });
            });
            await Promise.all(promesas);

            setShowMuestraModal(false);
            fetchAnalisisGenetico(selectedItem.dbId);

            setToastMessage("¡Muestras guardadas correctamente!");
            setToastVariant("success"); // Color verde
            setShowToast(true);         // Mostrar notificación

        } catch (err) {
            // Manejo de error con Toast rojo
            setToastMessage("Error al guardar muestras.");
            setToastVariant("danger");
            setShowToast(true);
        } finally { setIsSaving(false); }
    };


    const fetchUserRole = async () => {
        try {
            const res = await api.get('/api/usuarios/me');
            setCurrentUser(res.data);
        } catch (error) { console.error(error); }
    };

    const fetchUsers = async () => {
        try {
            const res = await api.get('/api/usuarios');
            if (Array.isArray(res.data)) {
                const map = {};
                res.data.forEach(u => {
                    const uid = u.usuarioId || u.id || u.idUsuario;
                    const nombre = u.nombre || (u.nombres + ' ' + u.apellidos);
                    if (uid) map[uid] = nombre;
                });
                setUsersMap(map);
            }
        } catch (err) { console.error(err); }
    };

    const fetchPacientes = async () => {
        setIsLoading(true);
        try {
            const res = await api.get('/api/pacientes');
            if (!Array.isArray(res.data)) { setItems([]); return; }

            const dataMapeada = res.data.map(p => ({
                dbId: p.participante_id,
                id: p.participanteCod || `P-${p.participante_id}`,
                tipo: p.esCaso ? 'CASO' : 'CONTROL',
                fechaIngreso: p.fechaIncl,
                estado: 'Activo',
                creadorId: p.usuarioCreadorId,
                respuestas: p.respuestas || []
            }));
            setItems(dataMapeada);
            if (dataMapeada.length > 0) {
                if (selectedItem) {
                    const updatedItem = dataMapeada.find(i => i.dbId === selectedItem.dbId);
                    setSelectedItem(updatedItem || dataMapeada[0]);
                } else {
                    setSelectedItem(dataMapeada[0]);
                }
            } else { setSelectedItem(null); }
        } catch (err) { console.error(err); } finally { setIsLoading(false); }
    };

    const fetchSurveyStructure = async () => {
        setLoadingSurvey(true);
        try {
            const res = await api.get('/api/encuesta/completa');
            const structure = Array.isArray(res.data) ? res.data : [];
            const structureClean = structure.map(cat => ({
                ...cat,
                preguntas: (cat.preguntas || []).sort((a, b) => a.orden - b.orden)
            })).sort((a, b) => a.orden - b.orden);
            setSurveyStructure(structureClean);
        } catch (err) { console.error(err); setSurveyStructure([]); } finally { setLoadingSurvey(false); }
    };

    const getMissingCount = (patient) => {
        if (!patient || !surveyStructure || surveyStructure.length === 0) return 0;
        const allQuestions = surveyStructure.flatMap(cat => cat.preguntas || []);
        const missing = allQuestions.filter(q => {
            const hasAnswer = patient.respuestas && patient.respuestas.some(r =>
                (r.preguntaId === q.pregunta_id) || (r.pregunta_id === q.pregunta_id)
            );
            return !hasAnswer;
        });
        return missing.length;
    };

    useEffect(() => {
        fetchPacientes();
        fetchSurveyStructure();
        fetchUserRole();
        fetchUsers();
        fetchGenesConfig();
    }, []);

    useEffect(() => {
        if (selectedItem) {
            fetchAnalisisGenetico(selectedItem.dbId);
        } else {
            setAnalisisGenetico([]);
        }
    }, [selectedItem]);

    const userRole = currentUser?.rol;
    const hasRole = (allowedRoles) => userRole && allowedRoles.includes(userRole);

    const canEdit = (item) => {
        if (!currentUser || !item) return false;
        const itemCreatorId = item.creadorId;
        const isCreator = itemCreatorId == currentUserId;
        if (item.tipo === 'CASO') return userRole === 'ROLE_MEDICO' && isCreator;
        if (item.tipo === 'CONTROL') {
            if (userRole === 'ROLE_ESTUDIANTE' || userRole === 'ROLE_MEDICO') return isCreator;
            if (['ROLE_ADMIN', 'ROLE_INVESTIGADOR'].includes(userRole)) return true;
        }
        return false;
    };

    const canDelete = () => userRole === 'ROLE_ADMIN';
    const canDownload = hasRole(['ROLE_ADMIN', 'ROLE_INVESTIGADOR']);

    const filteredItems = useMemo(() => {
        const normalize = (text) => text ? text.toString().toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim() : "";
        const term = normalize(searchTerm);
        let result = items.filter(item => (item.tipo === 'CASO' && filters.showCasos) || (item.tipo === 'CONTROL' && filters.showControles));

        if (!term) return result;
        if (term.includes(':')) {
            const rawTerm = searchTerm.toLowerCase();
            const regex = /([a-z0-9_ñáéíóú\s]+):\s*([^:]+?)(?=\s+[a-z0-9_ñáéíóú\s]+:|$)/gi;
            let match;
            const criteria = [];
            while ((match = regex.exec(rawTerm)) !== null) criteria.push({ key: normalize(match[1]), value: normalize(match[2]) });
            if (criteria.length === 0) return [];
            const allQuestions = surveyStructure.flatMap(cat => cat.preguntas || []);
            return result.filter(patient => {
                return criteria.every(criterion => {
                    const matchingQuestions = allQuestions.filter(q => {
                        const label = normalize(q.etiqueta);
                        const code = normalize(q.codigoStata);
                        return label.includes(criterion.key) || (code && code.includes(criterion.key));
                    });
                    if (matchingQuestions.length === 0) return false;
                    return matchingQuestions.some(q => {
                        const answer = patient.respuestas?.find(r => (r.preguntaId == q.pregunta_id) || (r.pregunta_id == q.pregunta_id));
                        if (!answer || !answer.valor) return false;
                        return normalize(answer.valor).includes(criterion.value);
                    });
                });
            });
        } else {
            return result.filter(item => {
                const matchesId = normalize(item.id).includes(term);
                const creatorName = usersMap[item.creadorId];
                const matchesCreator = creatorName ? normalize(creatorName).includes(term) : false;
                return matchesId || matchesCreator;
            });
        }
    }, [items, searchTerm, filters, surveyStructure, usersMap]);

    const handleFilterChange = (e) => setFilters({ ...filters, [e.target.name]: e.target.checked });
    const handleToggleSelect = (id) => { const newSet = new Set(selectedIds); if (newSet.has(id)) newSet.delete(id); else newSet.add(id); setSelectedIds(newSet); };
    const handleSelectAll = (e) => { if (e.target.checked) { setSelectedIds(new Set(filteredItems.map(i => i.dbId))); } else { setSelectedIds(new Set()); } };

    const handleBulkDownload = async () => {
        if (selectedIds.size === 0) return;
        setIsDownloading(true);
        try {
            const idsArray = Array.from(selectedIds);
            const response = await api.post('/api/pdf/crf/zip', idsArray, { responseType: 'blob' });
            const urlBlob = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = urlBlob;
            link.setAttribute('download', `CRFs_Lote_${new Date().toISOString().slice(0,10)}.zip`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) { console.error(err); alert("Error al generar ZIP."); } finally { setIsDownloading(false); }
    };

    const handleDownloadPdf = async (pacienteId, codigo) => {
        try {
            const response = await api.get(`/api/pdf/crf/paciente/${pacienteId}`, { responseType: 'blob' });
            const urlBlob = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = urlBlob;
            link.setAttribute('download', `CRF_${codigo}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.parentNode.removeChild(link);
        } catch (err) { console.error(err); alert("Error al generar PDF."); }
    };

    const handleOpenModal = (esCaso, itemAEditar = null) => {
        setValidationErrors({});
        if (itemAEditar) {
            setEditingId(itemAEditar.dbId);
            setIsCase(itemAEditar.tipo === 'CASO');
            const initialData = {};
            if (itemAEditar.respuestas) {
                itemAEditar.respuestas.forEach(r => {
                    const pid = r.preguntaId || r.pregunta_id;
                    initialData[pid] = r.valor;
                });
            }
            setFormData(initialData);
        } else {
            setEditingId(null);
            setIsCase(esCaso);
            setFormData({});
            setCountryCodes({});
        }
        setCurrentStep(0);
        setShowModal(true);
    };

    const handleInputChange = (preguntaId, value, tipo) => {
        let val = value;
        if (tipo === 'RUT') val = formatRut(value);

        setFormData(prev => {
            // 1. Creamos una copia del formulario con el nuevo valor
            const newFormData = { ...prev, [preguntaId]: val };

            // 2. Definimos la función recursiva para limpiar datos "huerfanos"
            const cleanDependencies = (parentId, parentValue, dataState) => {
                // Buscamos en la categoría actual qué preguntas dependen de este 'parentId'
                // Nota: Si 'currentCat' no está disponible aquí, asegúrate de tener acceso a la lista de preguntas
                const dependentQuestions = currentCat?.preguntas?.filter(q => q.preguntaControladoraId === parentId) || [];

                dependentQuestions.forEach(child => {
                    // Verificamos: ¿El valor nuevo del padre cumple la condición del hijo?
                    // Si NO la cumple (child.valorEsperadoControladora !== parentValue)...
                    if (child.valorEsperadoControladora !== parentValue) {

                        // ... y si el hijo tenía una respuesta guardada ...
                        if (dataState[child.pregunta_id]) {
                            // ¡La borramos!
                            delete dataState[child.pregunta_id];

                            // Recursividad: Como borramos al hijo, revisamos si este tenía "nietos"
                            // Pasamos '' (vacío) como valor actual del hijo porque lo acabamos de borrar
                            cleanDependencies(child.pregunta_id, '', dataState);
                        }
                    }
                });
            };

            // 3. Ejecutamos la limpieza iniciando desde la pregunta que se acaba de modificar
            cleanDependencies(preguntaId, val, newFormData);

            return newFormData;
        });

        // Limpiar error al escribir (tu lógica original)
        if (validationErrors[preguntaId]) {
            setValidationErrors(prev => {
                const newErrs = { ...prev };
                delete newErrs[preguntaId];
                return newErrs;
            });
        }
    };

    // --- MANEJO PAÍS (CELULAR) ---
    const handleCountryChange = (preguntaId, code) => {
        setCountryCodes(prev => ({...prev, [preguntaId]: code}));
        const config = getPhoneConfig(code);
        const currentVal = formData[preguntaId] || '';
        if (currentVal.length > config.maxLength) {
            const truncated = currentVal.slice(0, config.maxLength);
            setFormData(prev => ({ ...prev, [preguntaId]: truncated }));
        }
    };

    // --- NUEVO HANDLE NEXT CON VALIDACIÓN ---
    const handleNext = () => {
        const currentCat = surveyStructure[currentStep];
        const currentQuestions = currentCat?.preguntas || [];
        const nextErrors = {};
        let hasError = false;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        currentQuestions.forEach(q => {
            if (q.tipo_dato === 'EMAIL') {
                const val = formData[q.pregunta_id];
                // Regla: Si NO está vacío Y no cumple el regex, es error.
                if (val && val.trim() !== '' && !emailRegex.test(val)) {
                    nextErrors[q.pregunta_id] = "Formato de correo inválido.";
                    hasError = true;
                }
            }
        });

        if (hasError) {
            setValidationErrors(prev => ({ ...prev, ...nextErrors }));
            return; // Detiene el avance
        }

        // Si no hay errores, avanza
        if (currentStep < surveyStructure.length - 1) {
            setCurrentStep(p => p + 1);
        }
    };

    const handlePrev = () => { if (currentStep > 0) setCurrentStep(p => p - 1); };

    const handleSave = async () => {
        // Validación final antes de guardar (por si acaso editan el último paso y guardan directo)
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const finalErrors = {};
        let hasError = false;

        // Revisamos TODAS las preguntas por seguridad
        surveyStructure.forEach(cat => {
            cat.preguntas?.forEach(q => {
                if (q.tipo_dato === 'EMAIL') {
                    const val = formData[q.pregunta_id];
                    if (val && val.trim() !== '' && !emailRegex.test(val)) {
                        finalErrors[q.pregunta_id] = "Formato inválido.";
                        hasError = true;
                    }
                }
            });
        });

        if (hasError) {
            setValidationErrors(finalErrors);
            alert("Corrija los errores antes de guardar.");
            return;
        }

        setIsSaving(true);
        try {
            const respuestasDTO = Object.entries(formData).map(([key, value]) => ({ pregunta_id: parseInt(key), valor: value }));
            if (editingId) { await api.put(`/api/pacientes/${editingId}/respuestas`, respuestasDTO); }
            else { await api.post('/api/pacientes', { esCaso: isCase, respuestas: respuestasDTO }); }
            setShowModal(false);
            setFormData({});
            setEditingId(null);
            fetchPacientes();
        } catch (err) { alert(err.response?.data?.message || "Error al guardar"); } finally { setIsSaving(false); }
    };

    const requestDelete = (id) => { setItemToDelete(id); setShowDeleteModal(true); };
    const confirmDelete = async () => {
        if (!itemToDelete) return;
        try {
            await api.delete(`/api/pacientes/${itemToDelete}`);
            if (selectedItem && selectedItem.dbId === itemToDelete) setSelectedItem(null);
            fetchPacientes();
            setShowDeleteModal(false);
        } catch (err) { alert("Error al eliminar."); }
    };

    const currentCat = surveyStructure[currentStep];
    const progress = Math.round(((currentStep + 1) / surveyStructure.length) * 100);

    return (
        /* Altura fija y overflow hidden al contenedor padre */
        <Container
            fluid
            className="p-0 page-container-fixed d-flex flex-column"
            style={{ height: 'calc(100vh - 60px)', overflow: 'hidden' }}
        >
            <style type="text/css">{`
                .btn-delete-custom { color: #6c757d; border-color: #6c757d; transition: all 0.2s ease; }
                .btn-delete-custom:hover { color: #fff; background-color: #dc3545; border-color: #dc3545; }
            `}</style>

            <div className="d-flex justify-content-between align-items-center mb-3 flex-shrink-0 p-1">
                <h2 className="mb-0">CASOS Y CONTROLES</h2>
                <div className="d-flex gap-2">
                    {hasRole(['ROLE_ESTUDIANTE', 'ROLE_MEDICO', 'ROLE_INVESTIGADOR', 'ROLE_ADMIN']) && (
                        <Button variant="outline-primary" onClick={() => handleOpenModal(false)}><PlusLg /> Nuevo control</Button>
                    )}
                    {hasRole(['ROLE_MEDICO']) && (
                        <Button variant="primary" onClick={() => handleOpenModal(true)}><PlusLg /> Nuevo caso</Button>
                    )}
                </div>
            </div>

            <Row className="flex-grow-1 overflow-hidden g-3 h-100">
                <Col md={4} lg={3} className="d-flex flex-column h-100">
                    <Card className="h-100 shadow-sm border-0 overflow-hidden">
                        <div className="p-3 border-bottom border-secondary border-opacity-25">
                            <InputGroup className="mb-3">
                                <InputGroup.Text className="bg-transparent border-secondary border-opacity-50" style={{ color: 'var(--text-muted)' }}><Search /></InputGroup.Text>
                                <Form.Control placeholder="Buscar..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="border-secondary border-opacity-50 bg-transparent shadow-none" style={{ borderLeft: 'none', color: 'var(--text-main)' }} />
                            </InputGroup>
                            <div className="d-flex justify-content-around mb-3">
                                <Form.Check type="checkbox" label={<span className="small fw-bold text-muted">Casos</span>} name="showCasos" checked={filters.showCasos} onChange={handleFilterChange} className="user-select-none"/>
                                <Form.Check type="checkbox" label={<span className="small fw-bold text-muted">Controles</span>} name="showControles" checked={filters.showControles} onChange={handleFilterChange} className="user-select-none"/>
                            </div>
                            {canDownload && (
                                <div className="d-flex align-items-center justify-content-between bg-primary bg-opacity-10 p-2 rounded border border-primary border-opacity-25">
                                    <Form.Check type="checkbox" label={<span className="small fw-bold ms-1">Seleccionar todos</span>} checked={filteredItems.length > 0 && selectedIds.size === filteredItems.length} onChange={handleSelectAll} className="m-0 user-select-none"/>
                                    {selectedIds.size > 0 && (
                                        <Button size="sm" variant="primary" onClick={handleBulkDownload} disabled={isDownloading} className="py-0 px-2" style={{fontSize: '0.8rem'}}>
                                            {isDownloading ? <Spinner size="sm" animation="border"/> : <><Download className="me-1"/> Descargar ({selectedIds.size})</>}
                                        </Button>
                                    )}
                                </div>
                            )}
                        </div>
                        <div className="flex-grow-1 overflow-auto">
                            <ListGroup variant="flush">
                                {filteredItems.length === 0 ? <div className="text-center p-5 text-muted">No se encontraron registros.</div> : filteredItems.map(item => (
                                    <ListGroup.Item key={item.dbId} action active={selectedItem && selectedItem.dbId === item.dbId} className="d-flex align-items-center py-3 border-bottom border-secondary border-opacity-10 px-2"
                                                    style={{
                                                        backgroundColor: selectedItem?.dbId === item.dbId ? 'var(--hover-bg)' : 'transparent',
                                                        /* CAMBIO: Usamos var(--text-main) para que sea Blanco(Oscuro) y Negro(Claro) */
                                                        color: 'var(--text-main)',
                                                        /* CAMBIO: Borde del mismo color del texto para consistencia */
                                                        borderLeft: selectedItem?.dbId === item.dbId ? '4px solid var(--text-main)' : '4px solid transparent',
                                                        transition: 'all 0.2s',
                                                        cursor: 'pointer'
                                                    }}
                                                    onClick={() => setSelectedItem(item)}
                                    >
                                        {canDownload && <div className="me-3" onClick={(e) => e.stopPropagation()}><Form.Check type="checkbox" checked={selectedIds.has(item.dbId)} onChange={() => handleToggleSelect(item.dbId)}/></div>}
                                        <div className="d-flex justify-content-between align-items-center flex-grow-1">
                                            <div className="d-flex flex-column justify-content-center">
                                                <div className="d-flex align-items-center gap-2">
                                                    {getMissingCount(item) > 0 && <Badge bg="warning" text="dark" pill className="d-flex align-items-center px-2 py-1" style={{fontSize: '0.7rem'}}><ExclamationTriangle className="me-1"/> {getMissingCount(item)}</Badge>}
                                                    <span className="fw-bold">{item.id}</span>
                                                </div>
                                            </div>
                                            <Badge bg={item.tipo === 'CASO' ? 'danger' : 'success'} pill className="opacity-75" style={{fontSize: '0.7em'}}>{item.tipo}</Badge>
                                        </div>
                                    </ListGroup.Item>
                                ))}
                            </ListGroup>
                        </div>
                    </Card>
                </Col>

                <Col md={8} lg={9} className="h-100">
                    {selectedItem ? (
                        <Card className="h-100 shadow-sm border-0 overflow-hidden">
                            <Card.Header className="d-flex justify-content-between align-items-center py-3 border-bottom border-secondary border-opacity-25 bg-transparent">
                                {/* --- HEADER --- */}
                                <div>
                                    {/* CAMBIO: var(--text-main) */}
                                    <h4 className="mb-0 d-flex align-items-center gap-2" style={{ color: 'var(--text-main)' }}><PersonVcard /> {selectedItem.id}</h4>
                                    <div className="text-muted small">
                                        <span>Ingreso: {selectedItem.fechaIngreso ? new Date(selectedItem.fechaIngreso + 'T00:00:00').toLocaleDateString() : '-'}</span>
                                        <span className="mx-2">•</span>
                                        <span>Reclutado por: </span>
                                        {selectedItem.creadorId && usersMap[selectedItem.creadorId] ? (
                                            <Link to={currentUserId == selectedItem.creadorId ? '/dashboard/perfil' : `/dashboard/usuarios/${selectedItem.creadorId}`} className="profile-link">
                                                {usersMap[selectedItem.creadorId]}
                                            </Link>
                                        ) : <strong>{usersMap[selectedItem.creadorId] || 'Cargando...'}</strong>}
                                    </div>
                                </div>
                                <div className="d-flex gap-2 align-items-center">
                                    {userRole === 'ROLE_ADMIN' && <Button variant="outline-danger" size="sm" onClick={() => handleDownloadPdf(selectedItem.dbId, selectedItem.id)}><FileEarmarkPdf className="me-2"/> PDF</Button>}
                                    {canEdit(selectedItem) && <Button variant="outline-primary" size="sm" onClick={() => handleOpenModal(selectedItem.tipo === 'CASO', selectedItem)}><Pencil className="me-2"/> Editar</Button>}
                                    {canDelete() && <Button variant="outline-secondary" className="btn-delete-custom" size="sm" onClick={() => requestDelete(selectedItem.dbId)}><Trash /></Button>}
                                    <Badge bg={selectedItem.tipo === 'CASO' ? 'danger' : 'success'} className="fs-6 px-3 py-2 ms-2">{selectedItem.tipo}</Badge>
                                </div>
                            </Card.Header>

                            {/* --- BODY --- */}
                            {/* CORRECCIÓN: Quitamos bg-light bg-opacity-10, dejamos transparente */}
                            <Card.Body className="p-0 overflow-hidden d-flex flex-column bg-transparent">
                                <Tabs
                                    defaultActiveKey="ficha"
                                    id="patient-details-tabs"
                                    className="px-3 pt-3 border-bottom"
                                    key={selectedItem.dbId}
                                >
                                    {/* TAB 1: Dinámico (Caso o Control) */}
                                    <Tab
                                        eventKey="ficha"
                                        title={selectedItem.tipo === 'CASO' ? 'Caso' : 'Control'}
                                        className="h-100 overflow-hidden"
                                    >
                                        {/* CORRECCIÓN: Quitamos bg-card que no existe, dejamos transparente */}
                                        <div
                                            className="overflow-auto p-3 position-relative accordion-scroll-container border rounded shadow-sm"
                                            style={{
                                                maxHeight: 'calc(100vh - 250px)',
                                                overflowY: 'auto',
                                                scrollBehavior: 'smooth',
                                                backgroundColor: 'transparent'
                                            }}
                                        >
                                            {surveyStructure.length === 0 ? (
                                                <div className="text-center p-5 text-muted">No se ha cargado la estructura.</div>
                                            ) : (
                                                <Accordion alwaysOpen flush className="bg-transparent">
                                                    {surveyStructure.map((cat, index) => (
                                                        <div id={`cat-${cat.id_cat}`} key={cat.id_cat} className="accordion-wrapper">
                                                            <Accordion.Item eventKey={index.toString()}>
                                                                <Accordion.Header>
                                                                    {/* CAMBIO: var(--text-main) */}
                                                                    <ClipboardPulse className="me-2 opacity-75" style={{ color: 'var(--text-main)' }}/>
                                                                    <span className="fw-bold text-uppercase small">{cat.nombre}</span>
                                                                </Accordion.Header>
                                                                <Accordion.Body className="p-0">
                                                                    <Table hover className="mb-0 align-middle">
                                                                        <tbody>
                                                                        {cat.preguntas?.map((pregunta) => {
                                                                            const respuesta = selectedItem.respuestas?.find(r => r.preguntaId === pregunta.pregunta_id || r.pregunta_id === pregunta.pregunta_id);
                                                                            let cellContent = respuesta && respuesta.valor ?
                                                                                /* CAMBIO: var(--text-main) */
                                                                                <span className="fw-medium" style={{ color: 'var(--text-main)' }}>{respuesta.valor}</span> :
                                                                                <span className="text-danger d-flex align-items-center gap-2 small bg-danger bg-opacity-10 px-2 py-1 rounded fit-content"><ExclamationTriangle /><span className="fst-italic">No registrado</span></span>;

                                                                            return (
                                                                                <tr key={pregunta.pregunta_id}>
                                                                                    <td className="ps-4 py-3" style={{width: '60%'}}>
                                                                                        <div className="fw-bold d-flex align-items-center">
                                                                                            {pregunta.etiqueta}
                                                                                            {pregunta.descripcion && <OverlayTrigger placement="top" overlay={<Tooltip id={`t-${pregunta.pregunta_id}`}>{pregunta.codigoStata}: {pregunta.descripcion}</Tooltip>}><QuestionCircle className="ms-2 text-info" style={{ cursor: 'help', fontSize: '0.9em' }} /></OverlayTrigger>}
                                                                                        </div>
                                                                                        {pregunta.dato_sensible && <Badge bg="warning" text="dark" style={{fontSize:'0.6em'}}>SENSIBLE</Badge>}
                                                                                    </td>
                                                                                    <td className="py-3">{cellContent}</td>
                                                                                </tr>
                                                                            );
                                                                        })}
                                                                        </tbody>
                                                                    </Table>
                                                                </Accordion.Body>
                                                            </Accordion.Item>
                                                        </div>
                                                    ))}
                                                </Accordion>
                                            )}
                                        </div>
                                    </Tab>

                                    {/* TAB 2: Muestra (Sin cambios) */}
                                    <Tab eventKey="muestra" title="Muestras biológicas" className="h-100 overflow-hidden">
                                        <div className="h-100 overflow-auto p-4">
                                            {loadingAnalisis ? <div className="text-center py-5"><Spinner animation="border" /></div> : (
                                                <>
                                                    {analisisGenetico.length > 0 ? (
                                                        <>
                                                            <div className="d-flex justify-content-between align-items-center mb-4">
                                                                {/* Izquierda: Título */}
                                                                {/* CAMBIO: var(--text-main) */}
                                                                <h5 className="mb-0" style={{ color: 'var(--text-main)' }}>
                                                                    <Activity className="me-2"/>Análisis genético
                                                                </h5>

                                                                {/* Derecha: Grupo de Botones */}
                                                                <div>
                                                                    <Button size="sm" variant="outline-primary" onClick={handleOpenMuestraModal}>
                                                                        <Pencil className="me-1"/> Editar
                                                                    </Button>

                                                                    {hasRole(['ROLE_ADMIN']) && (
                                                                        <Button
                                                                            size="sm"
                                                                            variant="secondary"
                                                                            onClick={() => setShowConfigModal(true)}
                                                                            title="Configurar Genes"
                                                                            className="ms-2"
                                                                        >
                                                                            <Gear />
                                                                        </Button>
                                                                    )}
                                                                </div>
                                                            </div>
                                                            <Card className="border-0 shadow-sm">
                                                                <Table responsive hover className="mb-0 align-middle">
                                                                    {/* CORRECCIÓN: Quitamos bg-light, usamos border-bottom */}
                                                                    <thead className="text-muted small text-uppercase border-bottom">
                                                                    <tr>
                                                                        <th className="ps-4 py-3 border-0">Gen</th>
                                                                        <th className="py-3 border-0 text-center">Genotipo</th>
                                                                        <th className="py-3 border-0">Modelo Dominante</th>
                                                                        <th className="py-3 border-0">Modelo Recesivo</th>
                                                                    </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                    {analisisGenetico.map((row, idx) => (
                                                                        <tr key={idx}>
                                                                            <td className="ps-4 fw-bold text-secondary">{row.nombreGen}</td>
                                                                            <td className="text-center">
                                                                                <Badge className="badge-genotipo border px-3 py-2">
                                                                                    {row.resultadoPaciente}
                                                                                </Badge>
                                                                            </td>

                                                                            {/* MODELO DOMINANTE */}
                                                                            <td>
                                                                                {row.interpretacionDominante && row.interpretacionDominante.startsWith("Grupo Riesgo") ?
                                                                                    <Badge bg="warning" text="dark">RIESGO</Badge> :
                                                                                    <Badge bg="success">SIN RIESGO</Badge>}
                                                                            </td>

                                                                            {/* MODELO RECESIVO */}
                                                                            <td>
                                                                                {row.interpretacionRecesivo && row.interpretacionRecesivo.startsWith("Grupo Riesgo") ?
                                                                                    <Badge bg="danger">ALTO RIESGO</Badge> :
                                                                                    <span className="text-success fw-bold small">BAJO RIESGO</span>}
                                                                            </td>
                                                                        </tr>
                                                                    ))}
                                                                    </tbody>
                                                                </Table>
                                                            </Card>
                                                        </>
                                                    ) : (
                                                        <div className="d-flex flex-column align-items-center justify-content-center h-100 py-5 text-muted opacity-75">
                                                            <Activity size={48} className="mb-3 text-secondary"/>
                                                            <h5>No hay muestras registradas</h5>
                                                            <Button variant="primary" className="mt-3" onClick={handleOpenMuestraModal}><PlusLg className="me-2"/> Registrar Muestra</Button>
                                                        </div>
                                                    )}
                                                </>
                                            )}
                                        </div>
                                    </Tab>
                                </Tabs>
                            </Card.Body>
                        </Card>
                    ) : (
                        <Card className="h-100 border-0 shadow-sm d-flex align-items-center justify-content-center bg-light" style={{ color: 'var(--text-muted)' }}>
                            <div className="text-center opacity-50"><ClipboardPulse style={{ fontSize: '4rem' }} className="mb-3" /><h5>Selecciona un participante para ver su ficha</h5></div>
                        </Card>
                    )}
                </Col>
            </Row>

            <Modal show={showModal} onHide={() => setShowModal(false)} backdrop="static" keyboard={false} size="lg" centered>
                <Modal.Header closeButton>
                    <div className="w-100 me-3">
                        <Modal.Title className="mb-2 fs-5">{editingId ? "Editar " : "Ingresar nuevo "} {isCase ? <span className="text-danger">CASO</span> : <span className="text-success">CONTROL</span>}</Modal.Title>
                        {surveyStructure.length > 0 && <div className="d-flex align-items-center gap-2 small"><ProgressBar now={progress} variant={isCase ? "danger" : "success"} style={{height: '6px', flexGrow: 1}} /><span className="text-muted text-nowrap">Paso {currentStep + 1}/{surveyStructure.length}</span></div>}
                    </div>
                </Modal.Header>
                <Modal.Body className="p-4" style={{ minHeight: '300px' }}>
                    {loadingSurvey ? <div className="text-center py-5"><Spinner animation="border" /></div> : (
                        <div>
                            {/* CAMBIO: var(--text-main) */}
                            <h5 className="mb-4 border-bottom pb-2" style={{ color: 'var(--text-main)' }}>{currentCat?.nombre}</h5>
                            <Row>
                                {currentCat?.preguntas.map(q => {
                                    if (q.preguntaControladoraId) {
                                        const valorPadre = formData[q.preguntaControladoraId];
                                        if (valorPadre == q.valorEsperadoControladora) {
                                            return null;
                                        }
                                    }

                                    return (
                                        <Col md={12} key={q.pregunta_id} className="mb-3">
                                            <Form.Group>
                                                <Form.Label className="d-flex justify-content-between w-100">
                                                    <div>{q.etiqueta}</div>
                                                    {q.dato_sensible && <Badge bg="warning" text="dark">SENSIBLE</Badge>}
                                                </Form.Label>
                                                {(() => {
                                                    const val = formData[q.pregunta_id] || '';

                                                    if(q.tipo_dato === 'EMAIL') {
                                                        return (
                                                            <>
                                                                <Form.Control
                                                                    type="email"
                                                                    value={val}
                                                                    onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'EMAIL')}
                                                                    isInvalid={!!validationErrors[q.pregunta_id]}
                                                                    placeholder="nombre@ejemplo.com"
                                                                />
                                                                <Form.Control.Feedback type="invalid">{validationErrors[q.pregunta_id]}</Form.Control.Feedback>
                                                            </>
                                                        );
                                                    }

                                                    if(q.tipo_dato === 'ENUM') return <Form.Select value={val} onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'ENUM')}><option value="">Seleccione...</option>{q.opciones && q.opciones.map((opt, idx) => <option key={idx} value={opt}>{opt}</option>)}</Form.Select>;

                                                    if(q.tipo_dato === 'RUT') return <Form.Control value={val} onChange={e => handleInputChange(q.pregunta_id, e.target.value, 'RUT')} maxLength={12} />;

                                                    if(q.tipo_dato === 'CELULAR') {
                                                        const currentCode = countryCodes[q.pregunta_id] || '+56';
                                                        const phoneConfig = getPhoneConfig(currentCode);

                                                        return (
                                                            <InputGroup>
                                                                <Form.Select
                                                                    style={{maxWidth:'90px'}}
                                                                    value={currentCode}
                                                                    onChange={(e) => handleCountryChange(q.pregunta_id, e.target.value)}
                                                                >
                                                                    {COUNTRY_PHONE_DATA.map(c => (
                                                                        <option key={c.code} value={c.code}>{c.code}</option>
                                                                    ))}
                                                                </Form.Select>
                                                                <Form.Control
                                                                    type="text"
                                                                    value={val}
                                                                    placeholder={phoneConfig.placeholder}
                                                                    maxLength={phoneConfig.maxLength}
                                                                    onChange={e => handleInputChange(q.pregunta_id, e.target.value.replace(/\D/g, ''), 'CELULAR')}
                                                                />
                                                            </InputGroup>
                                                        );
                                                    }

                                                    return <Form.Control type={q.tipo_dato === 'NUMERO' ? 'number' : 'text'} value={val} onChange={e => handleInputChange(q.pregunta_id, e.target.value, q.tipo_dato === 'RUT' ? 'RUT' : 'TEXTO')} maxLength={q.tipo_dato === 'RUT' ? 12 : undefined} />;
                                                })()}
                                            </Form.Group>
                                        </Col>
                                    );
                                })}
                            </Row>
                        </div>
                    )}
                </Modal.Body>
                <Modal.Footer className="justify-content-between">
                    <Button variant="secondary" onClick={handlePrev} disabled={currentStep === 0 || isSaving}><ArrowLeft className="me-2" /> Anterior</Button>
                    {currentStep === surveyStructure.length - 1 ? <Button variant="success" onClick={handleSave} disabled={isSaving}>{isSaving ? <Spinner size="sm" animation="border" className="me-2"/> : <Save className="me-2" />} {editingId ? "Actualizar" : "Guardar"}</Button> : <Button variant="primary" onClick={handleNext} disabled={isSaving}>Siguiente <ArrowRight className="ms-2" /></Button>}
                </Modal.Footer>
            </Modal>

            <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)} centered>
                <Modal.Header closeButton className="border-0 pb-0"><Modal.Title className="text-danger d-flex align-items-center gap-2"><ExclamationCircle /> Confirmar eliminación</Modal.Title></Modal.Header>
                <Modal.Body className="text-center pt-4 pb-4 px-5"><p className="mb-1 fw-bold fs-5">¿Estás seguro de que deseas eliminar este registro?</p><p className="text-muted small">Esta acción no se puede deshacer y eliminará todos los datos asociados al paciente.</p></Modal.Body>
                <Modal.Footer className="border-0 justify-content-center pb-4 gap-3"><Button variant="light" onClick={() => setShowDeleteModal(false)}>Cancelar</Button><Button variant="danger" onClick={confirmDelete}>Eliminar</Button></Modal.Footer>
            </Modal>

            {/* --- MODAL DE MUESTRAS --- */}
            <Modal show={showMuestraModal} onHide={() => setShowMuestraModal(false)} centered backdrop="static">
                <Modal.Header closeButton>
                    <Modal.Title><Activity className="me-2"/> Registro de muestras</Modal.Title>
                </Modal.Header>
                <Modal.Body className="p-4">
                    <Form>
                        {muestraGenesConfig.map(gen => (
                            <Form.Group key={gen.id_snp} className="mb-1 pb-2">
                                <Form.Label className="fw-bold text-secondary">{gen.nombreGen}</Form.Label>

                                {/* Cambio: Uso de Form.Select en lugar de Radio Buttons */}
                                <Form.Select
                                    value={formMuestraData[gen.id_snp] || ""}
                                    onChange={(e) => handleMuestraChange(gen.id_snp, e.target.value)}
                                    aria-label={`Selección para ${gen.nombreGen}`}
                                >
                                    <option value="">-- Seleccionar --</option>
                                    {[gen.opcion1, gen.opcion2, gen.opcion3].filter(Boolean).map(op => (
                                        <option key={op} value={op}>
                                            {op}
                                        </option>
                                    ))}
                                </Form.Select>

                            </Form.Group>
                        ))}
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="light" onClick={() => setShowMuestraModal(false)}>Cancelar</Button>
                    <Button variant="primary" onClick={handleSaveMuestra} disabled={isSaving}>
                        {isSaving ? <Spinner size="sm" animation="border"/> : "Guardar"}
                    </Button>
                </Modal.Footer>
            </Modal>

            {/* --- MODAL DE CONFIGURACIÓN (ADMIN) --- */}
            {/* CORRECCIÓN: Header bg-transparent en lugar de bg-light */}
            <Modal show={showConfigModal} onHide={() => setShowConfigModal(false)} size="lg" centered>
                <Modal.Header closeButton className="bg-transparent">
                    <Modal.Title className="d-flex align-items-center gap-2">
                        <Gear /> Configuración de riesgo genético
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body className="p-0">
                    <div className="p-3">
                        <div className="alert alert-info border-0 d-flex align-items-center small m-0">
                            <ExclamationCircle className="me-2 fs-5"/>
                            <div>
                                Defina el <strong>alelo de riesgo</strong>. El sistema usará esto para calcular automáticamente los grupos dominante y recesivo.
                            </div>
                        </div>
                    </div>
                    <Table hover responsive className="mb-0 align-middle">
                        {/* CORRECCIÓN: Header sin bg-light, solo border-bottom */}
                        <thead className="text-secondary small text-uppercase border-bottom">
                        <tr>
                            <th className="ps-4 py-3 border-0">Gen / SNP</th>
                            <th className="py-3 border-0">Genotipos</th>
                            <th className="py-3 border-0" style={{width:'30%'}}>Alelo de Riesgo</th>
                        </tr>
                        </thead>
                        <tbody>
                        {muestraGenesConfig.length === 0 ? (
                            <tr><td colSpan="4" className="text-center py-4 text-muted">No hay genes cargados.</td></tr>
                        ) : (
                            muestraGenesConfig.map(conf => {
                                const posibles = [...new Set((conf.opcion1 + conf.opcion2 + conf.opcion3).split(''))].sort();
                                const seleccionado = conf.aleloRiesgo || "";
                                return (
                                    <tr key={conf.id_snp}>
                                        <td className="ps-4 fw-bold text-secondary">{conf.nombreGen}</td>
                                        <td>
                                            <div className="d-flex gap-1 align-items-center flex-wrap">
                                                {[conf.opcion1, conf.opcion2, conf.opcion3]
                                                    .filter(Boolean)
                                                    .sort() /* <--- Esto los ordena alfabéticamente (AA, AG, GG) */
                                                    .map(op => (
                                                        <Badge
                                                            key={op}
                                                            /* Usamos tu clase personalizada para el modo oscuro */
                                                            className="badge-genotipo border px-3 py-2"
                                                        >
                                                            {op}
                                                        </Badge>
                                                    ))}
                                            </div>
                                        </td>
                                        <td>
                                            <Form.Select
                                                size="sm"
                                                value={seleccionado}
                                                onChange={(e) => handleSaveConfig(conf.id_snp, e.target.value)}
                                                disabled={savingConfigId === conf.id_snp}
                                                className={seleccionado ? "border-success text-success fw-bold" : "border-warning"}
                                            >
                                                <option value="">-- Seleccionar --</option>
                                                {posibles.map(letra => (
                                                    <option key={letra} value={letra}>Alelo "{letra}"</option>
                                                ))}
                                            </Form.Select>
                                        </td>
                                    </tr>
                                );
                            })
                        )}
                        </tbody>
                    </Table>
                </Modal.Body>
                {/* CORRECCIÓN: Footer bg-transparent */}
                <Modal.Footer className="bg-transparent border-top-0">
                    <Button variant="primary" onClick={() => setShowConfigModal(false)}>Cerrar</Button>
                </Modal.Footer>
            </Modal>
            {/* --- NOTIFICACIÓN FLOTANTE (TOAST) --- */}
            <ToastContainer position="bottom-end" className="p-3" style={{ zIndex: 9999, position: 'fixed' }}>
                <Toast
                    onClose={() => setShowToast(false)}
                    show={showToast}
                    delay={3000}
                    autohide
                    bg={toastVariant} // Se pinta verde o rojo según el caso
                >
                    <Toast.Header>
                        <strong className="me-auto">Sistema</strong>
                        <small>Justo ahora</small>
                    </Toast.Header>
                    {/* Texto blanco para que resalte sobre el fondo verde/rojo */}
                    <Toast.Body className="text-white">
                        {toastMessage}
                    </Toast.Body>
                </Toast>
            </ToastContainer>
        </Container>
    );
};
export default CasesControls;