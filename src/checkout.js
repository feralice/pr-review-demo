const { calcularFrete } = require('./frete');

// Total do pedido: itens + frete
function calcularTotal(itens, pesoKg) {
  if (!Array.isArray(itens)) {
    throw new TypeError('itens deve ser uma lista');
  }
  const subtotal = itens.reduce((soma, item) => soma + item.preco * item.qtd, 0);
  const frete = calcularFrete(subtotal, pesoKg);
  return subtotal + frete;
}

module.exports = { calcularTotal };
