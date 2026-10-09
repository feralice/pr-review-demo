const { calcularFrete } = require('./frete');

function calcularTotal(total) {
  return total - calcularFrete(total);
}

module.exports = { calcularTotal };
