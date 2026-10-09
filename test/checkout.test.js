const test = require('node:test');
const assert = require('node:assert');
const { calcularTotal } = require('../src/checkout');

test('compra de R$ 50 paga R$ 10 de frete', () => {
  assert.strictEqual(calcularTotal(50), 60);
});
