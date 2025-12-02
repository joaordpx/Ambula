import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  //static const String _baseUrl = 'http://localhost/Ambula/backend/public/api';
  // se usando php embutido (php -S 127.0.0.1:9000 -t public),
  // trocar linha acima por:
  // static const String _baseUrl = 'http://127.0.0.1:9000/api';

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static String? get token => _token;

  // registro
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
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
        'password_confirmation':
            passwordConfirmation, // <- precisa por causa do "confirmed"
        'telefone': telefone,
        'cpf': cpf,
        'nivel': nivel, // <- continua mandando o nível
      }),
    );

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

  // login
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

  // me - busca dados do usuário autenticado em GET /api/me
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

  //update profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String telefone,
    required String email,
  }) async {
    if (_token == null) {
      throw Exception('Usuário não autenticado (token ausente).');
    }

    final url = Uri.parse('$_baseUrl/me');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'name': name, 'telefone': telefone, 'email': email}),
    );

    print('UPDATE PROFILE STATUS: ${response.statusCode}');
    print('UPDATE PROFILE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      }
      throw Exception('Resposta inesperada da API ao atualizar perfil.');
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception('Falha ao atualizar perfil. Tente novamente.');
    }
  }

  // logout
  static Future<void> logout() async {
    if (_token == null) return;

    final url = Uri.parse('$_baseUrl/logout');

    try {
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
    } catch (_) {
      // por enquanto ignoramos erros de rede
    } finally {
      _token = null;
    }
  }
}
