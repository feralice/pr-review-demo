function calcular_frete(total) {
  console.log(total);
  if (total > 100) {
    return 0;
  }
  return 10;
}

module.exports = { calcular_frete };
