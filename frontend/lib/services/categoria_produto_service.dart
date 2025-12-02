import 'dart:convert';
import 'package:frontend/models/categoria_produto.dart';
import 'package:http/http.dart' as http;

class CategoriaProdutoService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<CategoriaProduto>> fetchCategorias() async {
    final url = Uri.parse('$_baseUrl/categorias-produto');

    final response = await http.get(
      url,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body
            .map((e) => CategoriaProduto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Resposta inesperada ao carregar categorias.');
    } else {
      throw Exception('Falha ao carregar categorias (${response.statusCode}).');
    }
  }
}
