const test = require('node:test');
const assert = require('node:assert');
const { calcularTotal } = require('../src/checkout');

test('frete grátis a partir de R$ 100', () => {
  assert.strictEqual(calcularTotal([{ preco: 100, qtd: 1 }], 2), 100);
});

test('abaixo de R$ 100 paga R$ 5 por kg', () => {
  assert.strictEqual(calcularTotal([{ preco: 40, qtd: 1 }], 2), 50);
});

test('itens deve ser uma lista', () => {
  assert.throws(() => calcularTotal('x', 1), TypeError);
});
