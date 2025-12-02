import 'dart:convert';

import 'package:frontend/models/loja.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/models/loja_detalhe.dart';
import 'package:http/http.dart' as http;

class LojaService {
  LojaService();

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<LojaDetalhe> getDetalhesLoja(int lojaId) async {
    final uri = Uri.parse('$_baseUrl/lojas/$lojaId');

    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is! Map<String, dynamic>) {
        throw Exception('Resposta inesperada ao carregar detalhes da loja.');
      }

      final lojaJson = Map<String, dynamic>.from(
        (body['loja'] ?? const <String, dynamic>{}) as Map,
      );
      final produtosJson = body['produtos'];

      final loja = Loja.fromJson(lojaJson);

      final produtos = (produtosJson is List)
          ? produtosJson
                .map((e) => Produto.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <Produto>[];

      return LojaDetalhe(loja: loja, produtos: produtos);
    } else if (response.statusCode == 404) {
      throw Exception('Loja não encontrada.');
    } else {
      throw Exception(
        'Falha ao carregar detalhes da loja (${response.statusCode}).',
      );
    }
  }
}
