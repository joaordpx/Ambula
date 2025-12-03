import 'dart:convert';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/models/produto.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static String? get _token => AuthService.token;

  static Map<String, String> _headers() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token!}',
    };
  }

  static Future<Produto> criar(Produto p) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/produtos'),
      headers: _headers(),
      body: jsonEncode(p.toJson()),
    );

    if (resp.statusCode == 201) {
      final json = jsonDecode(resp.body);
      return Produto.fromJson(json);
    }

    throw Exception('Erro ao criar produto: ${resp.body}');
  }

  static Future<Produto> atualizar(int id, Produto p) async {
    final resp = await http.put(
      Uri.parse('$_baseUrl/produtos/$id'),
      headers: _headers(),
      body: jsonEncode(p.toJson()),
    );

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      return Produto.fromJson(json);
    }

    throw Exception('Erro ao atualizar produto: ${resp.body}');
  }

  static Future<void> remover(int id) async {
    final resp = await http.delete(
      Uri.parse('$_baseUrl/produtos/$id'),
      headers: _headers(),
    );

    if (resp.statusCode == 200) return;

    throw Exception('Erro ao deletar produto: ${resp.body}');
  }
}
