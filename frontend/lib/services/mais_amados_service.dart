import 'dart:async';

class MaisAmadosService {
  /// No futuro isso vira GET /api/home/mais-amados (ou algo assim).
  /// Por enquanto, é só um mock em memória.
  static Future<List<Map<String, dynamic>>> fetchMaisAmados() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      {
        'id': 1,
        'nomeProduto': 'Cookie de Chocolate',
        'nomeAmbulante': 'Nena Snacks',
        'lojaAberta': true,
      },
      {
        'id': 2,
        'nomeProduto': 'Brownie da Casa',
        'nomeAmbulante': 'Doces do João',
        'lojaAberta': false,
      },
      {
        'id': 3,
        'nomeProduto': 'Suco Natural',
        'nomeAmbulante': 'Ambulante da Bio',
        'lojaAberta': true,
      },
    ];
  }
}
