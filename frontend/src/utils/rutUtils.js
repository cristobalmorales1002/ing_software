// src/utils/rutUtils.js

// 1. Función para VALIDAR el RUT (algoritmo Módulo 11)
export const validateRut = (rut) => {
  if (typeof rut !== 'string') return false;
  
  // Limpia el RUT de puntos y guion
  const cleanRut = rut.replace(/[^0-9kK]/g, '').toUpperCase();
  
  if (cleanRut.length < 2) return false;

  const body = cleanRut.slice(0, -1);
  const dv = cleanRut.slice(-1);

  let sum = 0;
  let multiplier = 2;

  // Recorre el cuerpo de derecha a izquierda
  for (let i = body.length - 1; i >= 0; i--) {
    sum += parseInt(body[i], 10) * multiplier;
    multiplier = multiplier === 7 ? 2 : multiplier + 1;
  }

  const calculatedDv = 11 - (sum % 11);
  let expectedDv;

  if (calculatedDv === 11) {
    expectedDv = '0';
  } else if (calculatedDv === 10) {
    expectedDv = 'K';
  } else {
    expectedDv = calculatedDv.toString();
  }

  return dv === expectedDv;
};

// 2. Función para FORMATEAR el RUT mientras se escribe
export const formatRut = (rut) => {
  // Limpia el RUT de todo excepto números y 'k'
  const cleanRut = rut.replace(/[^0-9kK]/g, '').toUpperCase();
  const len = cleanRut.length;

  // Si no hay nada, retorna vacío
  if (len === 0) return '';

  // Separa el cuerpo del dígito verificador
  let body = cleanRut.slice(0, -1);
  let dv = cleanRut.slice(-1);

  // Si solo hay cuerpo (aún no se escribe el DV)
  if (len <= 8) {
    body = cleanRut;
    dv = '';
  }

  // Agrega los puntos al cuerpo (usando Expresión Regular)
  const formattedBody = body.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

  // Si hay DV, lo une con un guion. Si no, solo retorna el cuerpo.
  return dv ? `${formattedBody}-${dv}` : formattedBody;
};