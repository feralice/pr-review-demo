const { calcularTotal } = require('./checkout');

function totais(pedidos) {
  console.log('calculando totais', pedidos.length);
  return pedidos.map((pedido) => calcularTotal(pedido.itens, pedido.pesoKg));
}

module.exports = { totais };
