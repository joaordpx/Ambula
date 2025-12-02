import 'dart:convert';
import 'package:http/http.dart' as http;

class LojasPopularesService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Map<String, dynamic>>> fetchLojasPopulares() async {
    final url = Uri.parse('$_baseUrl/home/lojas-populares');

    final response = await http.get(
      url,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      throw Exception('Resposta inesperada em /home/lojas-populares.');
    } else {
      throw Exception(
        'Falha ao carregar lojas populares (${response.statusCode}).',
      );
    }
  }
}
