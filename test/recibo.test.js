const test = require('node:test');
const assert = require('node:assert');
const { textoDoFrete } = require('../src/recibo');

test('recibo mostra o frete', () => {
  assert.strictEqual(textoDoFrete(50), 'Frete: R$ 10');
});
