import 'dart:convert';

import 'package:frontend/models/produto.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  /// Lista produtos com filtros opcionais:
  /// - categoriaId
  /// - termo de busca
  static Future<List<Produto>> listar({int? categoriaId, String? termo}) async {
    final queryParams = <String, String>{};

    if (categoriaId != null) {
      queryParams['categoria_id'] = categoriaId.toString();
    }
    if (termo != null && termo.trim().isNotEmpty) {
      queryParams['q'] = termo.trim();
    }

    final uri = Uri.parse(
      '$_baseUrl/produtos',
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is List) {
        return body
            .map((e) => Produto.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      throw Exception('Resposta inesperada ao listar produtos.');
    } else {
      throw Exception('Falha ao listar produtos (${response.statusCode}).');
    }
  }

  /// Busca detalhes de um produto, opcionalmente com loja_id.
  static Future<Produto> obterPorId({
    required int produtoId,
    int? lojaId,
  }) async {
    final uri = Uri.parse('$_baseUrl/produtos/$produtoId').replace(
      queryParameters: lojaId != null ? {'loja_id': lojaId.toString()} : null,
    );

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        // o JSON vem no formato alinhado com Produto.fromJson
        final map = <String, dynamic>{
          'id': body['id'],
          'loja_id': (body['lojaInfo']?['loja_id']) ?? 0,
          'nome': body['nome'],
          'descricao': body['descricao'],
          'valor': body['valor'],
          'imagem': body['imagem'],
        };

        return Produto.fromJson(map);
      }

      throw Exception('Resposta inesperada ao obter produto.');
    } else if (response.statusCode == 404) {
      throw Exception('Produto não encontrado.');
    } else {
      throw Exception('Falha ao carregar produto (${response.statusCode}).');
    }
  }
}
