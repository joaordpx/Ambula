import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const String _baseUrl = 'http://localhost/Ambula/backend/public/api';
  // se usando php embutido (php -S 127.0.0.1:9000 -t public),
  // trocar linha acima por:
  // static const String _baseUrl = 'http://127.0.0.1:9000/api';

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? get token => _token;

  // ========= REGISTRO =========
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String telefone,
    required String cpf,
    required int nivel,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'telefone': telefone,
        'cpf': cpf,
        'nivel': nivel,
      }),
    );

    // logs pra debug
    print('REGISTER STATUS: ${response.statusCode}');
    print('REGISTER BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception(
        'Falha ao registrar. Verifique os dados e tente novamente.',
      );
    }
  }

  // ========= LOGIN =========
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('LOGIN STATUS: ${response.statusCode}');
    print('LOGIN BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // tenta pegar o token da resposta e guardar em memória
      final dynamic rawToken = data['token'];
      if (rawToken is String && rawToken.isNotEmpty) {
        _token = rawToken;
      }

      return data;
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception('Falha ao fazer login. Verifique suas credenciais.');
    }
  }

  // ========= LOGOUT =========
  static Future<void> logout() async {
    // se não tiver token, só garante que está nulo e sai
    if (_token == null) {
      _token = null;
      return;
    }

    try {
      final url = Uri.parse('$_baseUrl/logout');

      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      // mesmo que o back não tenha o /logout ainda, essa chamada vai só falhar silenciosamente.
    } catch (e) {
      // por enquanto, ignoramos erro de rede no logout.
      print('Erro ao chamar /logout: $e');
    } finally {
      // de qualquer forma, limpamos o token em memória
      _token = null;
    }
  }

  // ========= /me =========
  static Future<Map<String, dynamic>> getMe() async {
    if (_token == null) {
      throw Exception('Usuário não autenticado (token ausente).');
    }

    final url = Uri.parse('$_baseUrl/me');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    print('ME STATUS: ${response.statusCode}');
    print('ME BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // se vier { "user": { ... } }
      if (data is Map<String, dynamic> && data['user'] is Map) {
        return data['user'] as Map<String, dynamic>;
      }

      // se vier só o objeto do usuário direto
      if (data is Map<String, dynamic>) {
        return data;
      }

      throw Exception('Resposta inesperada da API /me.');
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception(
        'Erro ao carregar dados do usuário (${response.statusCode}).',
      );
    }
  }
}
