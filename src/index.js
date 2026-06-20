/**
 * Función básica para sumar dos números.
 */
function sumar(a, b) {
  return a + b;
}

/**
 * Función de verificación de estado.
 */
function healthCheck() {
  return { status: "UP", timestamp: new Date() };
}

module.exports = { sumar, healthCheck };