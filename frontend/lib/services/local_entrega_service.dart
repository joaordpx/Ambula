import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:frontend/models/local_entrega.dart';

class LocalEntregaService {
  // Ajuste essa URL de acordo com o que você está usando no projeto
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  // static const String _baseUrl = 'http://localhost/Ambula/backend/public/api';

  /// Cache simples em memória para permitir getById()
  static final Map<int, LocalEntrega> _cacheById = {};

  /// Busca todos os locais de entrega da API (/api/localizacoes)
  static Future<List<LocalEntrega>> listarLocais() async {
    final uri = Uri.parse('$_baseUrl/localizacoes');

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar locais de entrega (HTTP ${response.statusCode})',
      );
    }

    final dynamic body = jsonDecode(response.body);

    // A API pode retornar diretamente um array ou algo do tipo { data: [...] }
    List<dynamic> rawList;
    if (body is List) {
      rawList = body;
    } else if (body is Map<String, dynamic> && body['data'] is List) {
      rawList = body['data'] as List;
    } else if (body is Map<String, dynamic> && body['localizacoes'] is List) {
      rawList = body['localizacoes'] as List;
    } else {
      throw Exception('Formato inesperado ao listar locais de entrega.');
    }

    final locais = <LocalEntrega>[];

    for (final item in rawList) {
      if (item is! Map) continue;
      final map = item as Map<String, dynamic>;

      final id = (map['id'] as num).toInt();
      final descricao = (map['descricao'] ?? '').toString();

      // Como a tabela só tem "descricao", usamos:
      // - nome: descricao
      // - descricao: descricao
      // - latitude/longitude: 0.0 (não usados atualmente)
      final local = LocalEntrega(
        id: id,
        nome: descricao,
        descricao: descricao,
        latitude: 0.0,
        longitude: 0.0,
      );

      locais.add(local);
    }

    // atualiza cache para getById()
    _cacheById
      ..clear()
      ..addEntries(locais.map((l) => MapEntry(l.id, l)));

    return locais;
  }

  /// Busca um local no cache pelo ID.
  /// Depende de `listarLocais()` ter sido chamado antes.
  static LocalEntrega? getById(int id) {
    return _cacheById[id];
  }
}
