// Frete grátis a partir de R$ 100
function calcularFrete(total, pesoKg) {
  if (total >= 100) {
    return 0;
  }
  return pesoKg * 5;
}

module.exports = { calcularFrete };
