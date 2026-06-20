const { sumar, healthCheck } = require('../src/index');

describe('Pruebas unitarias de la aplicación', () => {
  test('Debería sumar 2 + 3 correctamente', () => {
    expect(sumar(2, 3)).toBe(5);
  });

  test('Debería retornar un estado de salud UP', () => {
    const health = healthCheck();
    expect(health.status).toBe('UP');
    expect(health.timestamp).toBeInstanceOf(Date);
  });
});