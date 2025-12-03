import 'dart:convert';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/loja.dart';
import 'package:frontend/models/produto.dart';
import 'package:frontend/models/loja_detalhe.dart';
import 'package:http/http.dart' as http;

class LojaService {
  LojaService();

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  // ========================================================
  //   CRIAR LOJA  (AJUSTADO PARA USAR O TOKEN CORRETAMENTE)
  // ========================================================
  static Future<Map<String, dynamic>> criarLoja({
    required String nome,
    required String descricao,
  }) async {
    final token = AuthService.token;
    if (token == null) {
      throw Exception("Usuário não autenticado (token ausente).");
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/lojas'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'nome': nome, 'descricao': descricao},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao criar loja: ${response.body}');
    }
  }

  // ========================================================
  //   DETALHES DA LOJA  (MANTIDO)
  // ========================================================
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

extension LojaServiceUpdate on LojaService {
  Future<void> atualizarLoja({
    required int lojaId,
    required String nome,
    required String descricao,
    required bool status,
  }) async {
    final token = AuthService.token;
    if (token == null) throw Exception('Token ausente.');

    final resp = await http.put(
      Uri.parse('${LojaService._baseUrl}/lojas/$lojaId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nome': nome,
        'descricao': descricao,
        'status': status,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('Erro ao atualizar loja: ${resp.body}');
    }
  }
}
