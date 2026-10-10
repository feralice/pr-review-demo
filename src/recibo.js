const { calcularFrete } = require('./frete');

function textoDoFrete(total) {
  if (calcularFrete(total) === 10) {
    return 'Frete: R$ 10';
  }
  return 'Erro no frete';
}

module.exports = { textoDoFrete };
