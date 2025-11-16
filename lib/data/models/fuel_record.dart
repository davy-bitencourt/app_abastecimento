class FuelRecord {
  final String id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final String veiculoId;
  final double? consumo;
  final String? observacao;

  FuelRecord({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    this.consumo,
    this.observacao,
  });

  Map<String, dynamic> toMap() => {
        'data': data.toIso8601String(),
        'quantidadeLitros': quantidadeLitros,
        'valorPago': valorPago,
        'quilometragem': quilometragem,
        'tipoCombustivel': tipoCombustivel,
        'veiculoId': veiculoId,
        'consumo': consumo,
        'observacao': observacao,
      };

  factory FuelRecord.fromMap(String id, Map<String, dynamic> map) => FuelRecord(
        id: id,
        data: DateTime.parse(map['data'] as String),
        quantidadeLitros: (map['quantidadeLitros'] ?? 0).toDouble(),
        valorPago: (map['valorPago'] ?? 0).toDouble(),
        quilometragem: (map['quilometragem'] ?? 0) as int,
        tipoCombustivel: map['tipoCombustivel'] ?? '',
        veiculoId: map['veiculoId'] ?? '',
        consumo: map['consumo'] != null ? (map['consumo'] as num).toDouble() : null,
        observacao: map['observacao'],
      );
}
