// usuarios.js - Lógica de gestión de usuarios

let usuarios = [];

document.addEventListener('DOMContentLoaded', async () => {
    if (!checkAuth()) return;

    // Verificar que sea admin
    const user = getCurrentUser();
    if (user.rol !== 'ADMIN') {
        showAlert('No tienes permisos para acceder a esta página', 'error');
        window.location.href = 'dashboard.html';
        return;
    }

    // Inicializar eventos
    document.getElementById('nuevoUsuarioBtn').addEventListener('click', abrirModalNuevo);
    document.getElementById('usuarioForm').addEventListener('submit', guardarUsuario);
    document.getElementById('cancelarBtn').addEventListener('click', cerrarModal);

    // Cerrar modal con X
    document.querySelector('.close').addEventListener('click', cerrarModal);

    // Cargar usuarios
    await cargarUsuarios();
});

async function cargarUsuarios() {
    try {
        usuarios = await UsuarioAPI.getAll();
        mostrarUsuarios(usuarios);
    } catch (error) {
        console.error('Error cargando usuarios:', error);
        showAlert('Error al cargar usuarios', 'error');
    }
}

function mostrarUsuarios(lista) {
    const tbody = document.getElementById('usuariosTableBody');

    if (lista.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">No hay usuarios registrados</td></tr>';
        return;
    }

    tbody.innerHTML = lista.map(u => {
        const estadoBadge = u.estadoU === 'ACTIVO'
            ? '<span class="badge" style="background: #d1fae5; color: #065f46;">Activo</span>'
            : '<span class="badge" style="background: #fee2e2; color: #991b1b;">Inactivo</span>';

        return `
            <tr>
                <td><strong>${u.rut}</strong></td>
                <td>${u.nombres} ${u.apellidos}</td>
                <td>${u.email}</td>
                <td><span class="badge" style="background: #dbeafe; color: #1e40af;">${u.rol}</span></td>
                <td>${estadoBadge}</td>
                <td class="table-actions">
                    <button class="btn btn-sm btn-secondary" onclick="editarUsuario(${u.usuarioId})">
                        ✏️ Editar
                    </button>
                    ${u.estadoU === 'ACTIVO'
            ? `<button class="btn btn-sm btn-danger" onclick="desactivarUsuario(${u.usuarioId})">🚫 Desactivar</button>`
            : `<button class="btn btn-sm btn-success" onclick="activarUsuario(${u.usuarioId})">✅ Activar</button>`
        }
                </td>
            </tr>
        `;
    }).join('');
}

function abrirModalNuevo() {
    document.getElementById('modalTitle').textContent = 'Nuevo Usuario';
    document.getElementById('usuarioForm').reset();
    document.getElementById('usuarioId').value = '';
    document.getElementById('passwordGroup').style.display = 'block';
    document.getElementById('password').required = true;
    document.getElementById('usuarioModal').classList.add('active');
}

function cerrarModal() {
    document.getElementById('usuarioModal').classList.remove('active');
}

async function guardarUsuario(e) {
    e.preventDefault();

    const id = document.getElementById('usuarioId').value;
    const rut = document.getElementById('rut').value;
    const nombres = document.getElementById('nombres').value;
    const apellidos = document.getElementById('apellidos').value;
    const email = document.getElementById('email').value;
    const telefono = document.getElementById('telefono').value;
    const rol = document.getElementById('rol').value;
    const password = document.getElementById('password').value;

    const usuario = {
        rut,
        nombres,
        apellidos,
        email,
        telefono,
        rol,
        estadoU: 'ACTIVO'
    };

    if (password) {
        usuario.passwordHash = password;
    }

    try {
        if (id) {
            await UsuarioAPI.update(id, usuario);
            showAlert('Usuario actualizado correctamente', 'success');
        } else {
            if (!password) {
                showAlert('La contraseña es obligatoria para nuevos usuarios', 'error');
                return;
            }
            await UsuarioAPI.create(usuario);
            showAlert('Usuario creado correctamente', 'success');
        }

        cerrarModal();
        await cargarUsuarios();

    } catch (error) {
        console.error('Error guardando usuario:', error);
        showAlert(error.message || 'Error al guardar usuario', 'error');
    }
}

async function editarUsuario(id) {
    try {
        const usuario = await UsuarioAPI.getById(id);

        document.getElementById('modalTitle').textContent = 'Editar Usuario';
        document.getElementById('usuarioId').value = usuario.usuarioId;
        document.getElementById('rut').value = usuario.rut;
        document.getElementById('nombres').value = usuario.nombres;
        document.getElementById('apellidos').value = usuario.apellidos;
        document.getElementById('email').value = usuario.email;
        document.getElementById('telefono').value = usuario.telefono || '';
        document.getElementById('rol').value = usuario.rol;

        // Ocultar campo de contraseña en edición
        document.getElementById('passwordGroup').style.display = 'none';
        document.getElementById('password').required = false;

        document.getElementById('usuarioModal').classList.add('active');

    } catch (error) {
        console.error('Error cargando usuario:', error);
        showAlert('Error al cargar usuario', 'error');
    }
}

async function desactivarUsuario(id) {
    if (!confirm('¿Estás seguro de desactivar este usuario?')) return;

    try {
        await UsuarioAPI.delete(id);
        showAlert('Usuario desactivado correctamente', 'success');
        await cargarUsuarios();
    } catch (error) {
        console.error('Error desactivando usuario:', error);
        showAlert('Error al desactivar usuario', 'error');
    }
}

async function activarUsuario(id) {
    try {
        const usuario = await UsuarioAPI.getById(id);
        usuario.estadoU = 'ACTIVO';
        await UsuarioAPI.update(id, usuario);
        showAlert('Usuario activado correctamente', 'success');
        await cargarUsuarios();
    } catch (error) {
        console.error('Error activando usuario:', error);
        showAlert('Error al activar usuario', 'error');
    }
}

