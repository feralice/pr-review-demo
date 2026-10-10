const { calcular_frete } = require('./frete');

function calcularTotal(total) {
  return total - calcular_frete(total);
}

module.exports = { calcularTotal };
