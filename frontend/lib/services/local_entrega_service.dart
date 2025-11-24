import 'package:frontend/models/local_entrega.dart';

class LocalEntregaService {
  // Mock fixo de locais de entrega dentro da universidade
  // (coordenadas são exemplos; depois vocês podem ajustar com valores reais)
  static final List<LocalEntrega> _locais = [
    LocalEntrega(
      id: 1,
      nome: "Entrada do Prédio 3 - CCET",
      descricao: "Entrada principal do CCET, próxima ao estacionamento.",
      latitude: -16.7280000,
      longitude: -43.8610000,
    ),
    LocalEntrega(
      id: 2,
      nome: "Entrada do Prédio 2 - CCH",
      descricao: "Ao lado da cantina do CCH.",
      latitude: -16.7275000,
      longitude: -43.8605000,
    ),
    LocalEntrega(
      id: 3,
      nome: "Praça de Alimentação",
      descricao: "Ponto central da universidade, próximo aos quiosques.",
      latitude: -16.7278000,
      longitude: -43.8613000,
    ),
  ];

  /// Simula requisição à API que retornaria todos os locais de entrega.
  static Future<List<LocalEntrega>> listarLocais() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _locais;
  }

  /// Busca um local específico pelo ID (útil na tela de resumo do pedido).
  static LocalEntrega? getById(int id) {
    try {
      return _locais.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
