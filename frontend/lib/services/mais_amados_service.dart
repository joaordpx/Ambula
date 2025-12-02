import 'dart:convert';
import 'package:http/http.dart' as http;

class MaisAmadosService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Map<String, dynamic>>> fetchMaisAmados() async {
    final url = Uri.parse('$_baseUrl/home/mais-amados');

    final response = await http.get(
      url,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      throw Exception('Resposta inesperada em /home/mais-amados.');
    } else {
      throw Exception(
        'Falha ao carregar mais amados (${response.statusCode}).',
      );
    }
  }
}
