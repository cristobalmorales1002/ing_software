// participantes.js - Lógica de gestión de participantes

let participantes = [];
let preguntas = [];
let participanteActual = null;

document.addEventListener('DOMContentLoaded', async () => {
    if (!checkAuth()) return;

    const user = getCurrentUser();

    // Ocultar opción de CASO si no es médico
    if (user.rol !== 'MEDICO') {
        const opcionCaso = document.getElementById('opcionCaso');
        if (opcionCaso) opcionCaso.style.display = 'none';
    }

    // Inicializar eventos
    document.getElementById('nuevoParticipanteBtn').addEventListener('click', abrirModalNuevo);
    document.getElementById('participanteForm').addEventListener('submit', guardarParticipante);
    document.getElementById('cancelarBtn').addEventListener('click', cerrarModal);
    document.getElementById('filtroTipo').addEventListener('change', filtrarParticipantes);
    document.getElementById('buscarParticipante').addEventListener('input', buscarParticipante);
    document.getElementById('respuestasForm').addEventListener('submit', guardarRespuestas);
    document.getElementById('cerrarRespuestasBtn').addEventListener('click', cerrarModalRespuestas);

    // Cerrar modales al hacer click en la X
    document.querySelectorAll('.close').forEach(closeBtn => {
        closeBtn.addEventListener('click', function() {
            this.closest('.modal').classList.remove('active');
        });
    });

    // Cargar datos iniciales
    await cargarParticipantes();
    await cargarPreguntas();
});

async function cargarParticipantes() {
    try {
        participantes = await ParticipanteAPI.getAll();
        mostrarParticipantes(participantes);
    } catch (error) {
        console.error('Error cargando participantes:', error);
        showAlert('Error al cargar participantes', 'error');
    }
}

async function cargarPreguntas() {
    try {
        preguntas = await PreguntaAPI.getActivas();
    } catch (error) {
        console.error('Error cargando preguntas:', error);
    }
}

function mostrarParticipantes(lista) {
    const tbody = document.getElementById('participantesTableBody');

    if (lista.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center">No hay participantes registrados</td></tr>';
        return;
    }

    tbody.innerHTML = lista.map(p => `
        <tr>
            <td><strong>${p.participanteCod}</strong></td>
            <td><span class="badge badge-${p.tipo.toLowerCase()}">${p.tipo}</span></td>
            <td>${formatDate(p.fechaIncl)}</td>
            <td>${p.creadoPor ? p.creadoPor.nombreCompleto || 'N/A' : 'N/A'}</td>
            <td class="table-actions">
                <button class="btn btn-sm btn-primary" onclick="abrirFormularioCRF(${p.participanteId})">
                    📋 CRF
                </button>
                <button class="btn btn-sm btn-secondary" onclick="editarParticipante(${p.participanteId})">
                    ✏️
                </button>
                <button class="btn btn-sm btn-danger" onclick="eliminarParticipante(${p.participanteId})">
                    🗑️
                </button>
            </td>
        </tr>
    `).join('');
}

function filtrarParticipantes() {
    const tipo = document.getElementById('filtroTipo').value;

    if (!tipo) {
        mostrarParticipantes(participantes);
        return;
    }

    const filtrados = participantes.filter(p => p.tipo === tipo);
    mostrarParticipantes(filtrados);
}

function buscarParticipante() {
    const busqueda = document.getElementById('buscarParticipante').value.toLowerCase();

    const filtrados = participantes.filter(p =>
        p.participanteCod.toLowerCase().includes(busqueda)
    );

    mostrarParticipantes(filtrados);
}

function abrirModalNuevo() {
    document.getElementById('modalTitle').textContent = 'Nuevo Participante';
    document.getElementById('participanteForm').reset();
    document.getElementById('participanteId').value = '';
    document.getElementById('fechaIncl').valueAsDate = new Date();
    document.getElementById('participanteModal').classList.add('active');
}

function cerrarModal() {
    document.getElementById('participanteModal').classList.remove('active');
}

async function guardarParticipante(e) {
    e.preventDefault();

    const id = document.getElementById('participanteId').value;
    const tipo = document.getElementById('tipo').value;
    const fechaIncl = document.getElementById('fechaIncl').value;

    const participante = {
        tipo,
        fechaIncl
    };

    try {
        if (id) {
            await ParticipanteAPI.update(id, participante);
            showAlert('Participante actualizado correctamente', 'success');
        } else {
            await ParticipanteAPI.create(participante);
            showAlert('Participante creado correctamente', 'success');
        }

        cerrarModal();
        await cargarParticipantes();

    } catch (error) {
        console.error('Error guardando participante:', error);
        showAlert(error.message || 'Error al guardar participante', 'error');
    }
}

async function editarParticipante(id) {
    try {
        const participante = await ParticipanteAPI.getById(id);

        document.getElementById('modalTitle').textContent = 'Editar Participante';
        document.getElementById('participanteId').value = participante.participanteId;
        document.getElementById('tipo').value = participante.tipo;
        document.getElementById('fechaIncl').value = participante.fechaIncl;

        document.getElementById('participanteModal').classList.add('active');

    } catch (error) {
        console.error('Error cargando participante:', error);
        showAlert('Error al cargar participante', 'error');
    }
}

async function eliminarParticipante(id) {
    if (!confirm('¿Estás seguro de eliminar este participante?')) return;

    try {
        await ParticipanteAPI.delete(id);
        showAlert('Participante eliminado correctamente', 'success');
        await cargarParticipantes();
    } catch (error) {
        console.error('Error eliminando participante:', error);
        showAlert(error.message || 'Error al eliminar participante', 'error');
    }
}

async function abrirFormularioCRF(participanteId) {
    try {
        participanteActual = await ParticipanteAPI.getById(participanteId);

        // Actualizar título del modal
        document.getElementById('participanteCodigo').textContent = participanteActual.participanteCod;

        // Cargar respuestas existentes
        const respuestasExistentes = await RespuestaAPI.getByParticipante(participanteId);
        const respuestasMap = {};
        respuestasExistentes.forEach(r => {
            respuestasMap[r.pregunta.preguntaId] = r.valor;
        });

        // Generar formulario dinámico con las preguntas
        const container = document.getElementById('preguntasContainer');
        container.innerHTML = '';

        // Agrupar preguntas por grupo
        const grupos = {};
        preguntas.forEach(p => {
            const grupo = p.grupo || 'General';
            if (!grupos[grupo]) grupos[grupo] = [];
            grupos[grupo].push(p);
        });

        // Renderizar por grupos
        Object.keys(grupos).forEach(nombreGrupo => {
            const grupoDiv = document.createElement('div');
            grupoDiv.className = 'pregunta-grupo';
            grupoDiv.innerHTML = `<h3>${nombreGrupo}</h3>`;

            grupos[nombreGrupo].forEach(pregunta => {
                const preguntaDiv = document.createElement('div');
                preguntaDiv.className = 'form-group';

                const label = document.createElement('label');
                label.textContent = pregunta.etiquetaVisible;
                label.htmlFor = `pregunta_${pregunta.preguntaId}`;

                let input;
                const valorExistente = respuestasMap[pregunta.preguntaId] || '';

                switch (pregunta.tipoDato) {
                    case 'NUMERICO':
                        input = document.createElement('input');
                        input.type = 'number';
                        input.value = valorExistente;
                        break;

                    case 'TEXTO':
                        input = document.createElement('input');
                        input.type = 'text';
                        input.value = valorExistente;
                        break;

                    case 'FECHA':
                        input = document.createElement('input');
                        input.type = 'date';
                        input.value = valorExistente;
                        break;

                    case 'BOOLEANO':
                        input = document.createElement('select');
                        input.innerHTML = `
                            <option value="">Seleccionar...</option>
                            <option value="true" ${valorExistente === 'true' ? 'selected' : ''}>Sí</option>
                            <option value="false" ${valorExistente === 'false' ? 'selected' : ''}>No</option>
                        `;
                        break;

                    case 'SELECCION_UNICA':
                        input = document.createElement('select');
                        input.innerHTML = '<option value="">Seleccionar...</option>';
                        if (pregunta.opciones) {
                            pregunta.opciones.forEach(opcion => {
                                const option = document.createElement('option');
                                option.value = opcion.valorAlmacenado;
                                option.textContent = opcion.etiquetaVisible;
                                if (opcion.valorAlmacenado === valorExistente) {
                                    option.selected = true;
                                }
                                input.appendChild(option);
                            });
                        }
                        break;

                    case 'SELECCION_MULTIPLE':
                        input = document.createElement('div');
                        input.className = 'checkbox-group';
                        const valoresSeleccionados = valorExistente ? valorExistente.split(',') : [];

                        if (pregunta.opciones) {
                            pregunta.opciones.forEach(opcion => {
                                const checkDiv = document.createElement('div');
                                checkDiv.className = 'checkbox-item';

                                const checkbox = document.createElement('input');
                                checkbox.type = 'checkbox';
                                checkbox.value = opcion.valorAlmacenado;
                                checkbox.id = `opcion_${opcion.opcionId}`;
                                checkbox.checked = valoresSeleccionados.includes(opcion.valorAlmacenado);

                                const checkLabel = document.createElement('label');
                                checkLabel.htmlFor = `opcion_${opcion.opcionId}`;
                                checkLabel.textContent = opcion.etiquetaVisible;

                                checkDiv.appendChild(checkbox);
                                checkDiv.appendChild(checkLabel);
                                input.appendChild(checkDiv);
                            });
                        }
                        break;

                    default:
                        input = document.createElement('input');
                        input.type = 'text';
                        input.value = valorExistente;
                }

                input.id = `pregunta_${pregunta.preguntaId}`;
                input.name = `pregunta_${pregunta.preguntaId}`;
                input.dataset.preguntaId = pregunta.preguntaId;
                input.dataset.tipoDato = pregunta.tipoDato;

                preguntaDiv.appendChild(label);
                preguntaDiv.appendChild(input);
                grupoDiv.appendChild(preguntaDiv);
            });

            container.appendChild(grupoDiv);
        });

        // Mostrar modal
        document.getElementById('respuestasModal').classList.add('active');

    } catch (error) {
        console.error('Error cargando formulario CRF:', error);
        showAlert('Error al cargar el formulario', 'error');
    }
}

function cerrarModalRespuestas() {
    document.getElementById('respuestasModal').classList.remove('active');
    participanteActual = null;
}

async function guardarRespuestas(e) {
    e.preventDefault();

    if (!participanteActual) return;

    try {
        // Recopilar todas las respuestas
        const respuestas = {};
        const inputs = document.querySelectorAll('[data-pregunta-id]');

        inputs.forEach(input => {
            const preguntaId = input.dataset.preguntaId;
            const tipoDato = input.dataset.tipoDato;
            let valor = '';

            if (tipoDato === 'SELECCION_MULTIPLE') {
                // Recopilar valores de checkboxes
                const checkboxes = input.querySelectorAll('input[type="checkbox"]:checked');
                valor = Array.from(checkboxes).map(cb => cb.value).join(',');
            } else {
                valor = input.value;
            }

            if (valor) {
                respuestas[preguntaId] = valor;
            }
        });

        // Guardar respuestas
        await RespuestaAPI.guardarMultiples(participanteActual.participanteId, respuestas);

        showAlert('Respuestas guardadas correctamente', 'success');
        cerrarModalRespuestas();

    } catch (error) {
        console.error('Error guardando respuestas:', error);
        showAlert('Error al guardar las respuestas', 'error');
    }
}