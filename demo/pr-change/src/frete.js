function calcularFrete(pesoKg, total) {
  if (total > 100) {
    return 0;
  }
  return pesoKg * 5;
}

module.exports = { calcularFrete };
