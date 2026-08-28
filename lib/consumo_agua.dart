class ConsumoAgua {
  String data;
  double quantidadeEmMl;
  double pesoAtualKg;

  ConsumoAgua({
    required this.data,
    required this.quantidadeEmMl,
    required this.pesoAtualKg,
  });

  double get metaDiaria {
    return pesoAtualKg * 35;
  }

  double get porcentagemMeta {
    if (metaDiaria == 0) {
      return 0;
    }

    return (quantidadeEmMl / metaDiaria) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'quantidade_em_ml': quantidadeEmMl,
      'peso_atual_kg': pesoAtualKg,
    };
  }

  factory ConsumoAgua.fromMap(Map<String, dynamic> map) {
    return ConsumoAgua(
      data: map['data'],
      quantidadeEmMl: (map['quantidade_em_ml'] as num).toDouble(),
      pesoAtualKg: (map['peso_atual_kg'] as num).toDouble(),
    );
  }
}
