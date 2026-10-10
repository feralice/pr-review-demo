const { calcularFrete } = require('./frete');

function textoDoFrete(total) {
  return 'Frete: R$ ' + calcularFrete(total);
}

module.exports = { textoDoFrete };
