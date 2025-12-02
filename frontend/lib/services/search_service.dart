import 'dart:convert';
import 'package:frontend/models/search_models.dart';
import 'package:http/http.dart' as http;

/// Service responsável pela busca de produtos e lojas.
class SearchService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<ResultadoBusca> search(String query) async {
    final termo = query.trim();
    if (termo.isEmpty) {
      return const ResultadoBusca(produtos: [], lojas: []);
    }

    final uri = Uri.parse(
      '$_baseUrl/search',
    ).replace(queryParameters: {'q': termo});

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic>) {
        throw Exception('Resposta inesperada da API de busca.');
      }

      final produtosJson = body['produtos'];
      final lojasJson = body['lojas'];

      final produtos = (produtosJson is List)
          ? produtosJson
                .map((e) => Produto.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <Produto>[];

      final lojas = (lojasJson is List)
          ? lojasJson
                .map((e) => Loja.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <Loja>[];

      return ResultadoBusca(produtos: produtos, lojas: lojas);
    } else {
      throw Exception(
        'Falha ao buscar (${response.statusCode}). Tente novamente.',
      );
    }
  }
}
