import 'dart:async';

class LojasPopularesService {
  /// No futuro: GET /api/home/lojas-populares (ordenadas por avaliação).
  /// Por enquanto, um mock fixo só pra interface.
  static Future<List<Map<String, dynamic>>> fetchLojasPopulares() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      {'id': 1, 'nome': 'Nena Snacks'},
      {'id': 2, 'nome': 'Doces do João'},
      {'id': 3, 'nome': 'Lanches do CCET'},
      {'id': 4, 'nome': 'Cantina Central'},
      {'id': 5, 'nome': 'Cantina Central'},
      {'id': 6, 'nome': 'Cantina Central'},
      {'id': 7, 'nome': 'Cantina Central'},
    ];
  }
}
