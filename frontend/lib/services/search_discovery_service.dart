import 'dart:convert';
import 'package:frontend/models/search_models.dart';
import 'package:http/http.dart' as http;

/// Service responsável pelos dados do modo "descoberta"
/// (categorias + lojas mais bem avaliadas).
class SearchDiscoveryService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<DadosDescoberta> loadDiscoveryData() async {
    final categoriasUri = Uri.parse('$_baseUrl/categorias-produto');
    final lojasUri = Uri.parse('$_baseUrl/home/lojas-populares');

    final responses = await Future.wait([
      http.get(categoriasUri, headers: const {'Accept': 'application/json'}),
      http.get(lojasUri, headers: const {'Accept': 'application/json'}),
    ]);

    final categoriasResponse = responses[0];
    final lojasResponse = responses[1];

    if (categoriasResponse.statusCode != 200) {
      throw Exception(
        'Falha ao carregar categorias (${categoriasResponse.statusCode}).',
      );
    }

    if (lojasResponse.statusCode != 200) {
      throw Exception('Falha ao carregar lojas (${lojasResponse.statusCode}).');
    }

    final categoriasBody = jsonDecode(categoriasResponse.body);
    final lojasBody = jsonDecode(lojasResponse.body);

    final categorias = (categoriasBody is List)
        ? categoriasBody.map((e) {
            final map = Map<String, dynamic>.from(e as Map);
            return CategoriaProduto(
              id: (map['id'] as num?)?.toInt(),
              descricao: (map['descricao'] ?? '') as String,
              imagem: map['imagem'] as String?,
            );
          }).toList()
        : <CategoriaProduto>[];

    final lojas = (lojasBody is List)
        ? lojasBody
              .map((e) => Loja.fromJson(Map<String, dynamic>.from(e)))
              .toList()
        : <Loja>[];

    return DadosDescoberta(
      categorias: categorias,
      lojasMaisBemAvaliadas: lojas,
    );
  }
}
