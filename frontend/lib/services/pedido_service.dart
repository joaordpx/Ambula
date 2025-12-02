import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:frontend/models/pedido.dart';
import 'package:frontend/models/local_entrega.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/services/auth_service.dart';

class PedidoService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  /// Cache local para exibir na tela sem precisar bater toda hora na API.
  static List<Pedido> _cache = [];

  static String? get _token => AuthService.token;

  static Map<String, String> _headers() {
    if (_token == null) {
      throw Exception('Usuário não autenticado.');
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  /// Mapeia o JSON de status do back para o enum PedidoStatus
  static PedidoStatus _mapStatusFromJson(dynamic statusJson) {
    if (statusJson is Map && statusJson['descricao'] != null) {
      final desc = statusJson['descricao'].toString().toUpperCase();

      if (desc.contains('ENTREG')) {
        return PedidoStatus.entregue;
      }
      if (desc.contains('CANCEL')) {
        return PedidoStatus.cancelado;
      }
    }

    return PedidoStatus.emAndamento;
  }

  /// Converte o JSON completo do back para o modelo Pedido usado na UI.
  static Pedido _fromApiJson(Map<String, dynamic> json) {
    final loja = json['loja'] as Map?;
    final lojaNome = (loja?['nome'] ?? 'Loja').toString();

    final itensJson = json['itens'] as List? ?? [];
    final itens = itensJson.map((i) {
      final item = i as Map<String, dynamic>;
      final produto = item['produto'] as Map?;
      final nomeProduto = (produto?['nome'] ?? 'Produto').toString();
      final quantidade = (item['quantidade'] ?? 0) as int;

      return PedidoItem(nomeProduto: nomeProduto, quantidade: quantidade);
    }).toList();

    // total pode vir como valor_total ou total
    double total = 0;
    if (json['valor_total'] != null) {
      total = (json['valor_total'] as num).toDouble();
    } else if (json['total'] != null) {
      total = (json['total'] as num).toDouble();
    }

    DateTime criadoEm;
    try {
      criadoEm = DateTime.parse(json['created_at'] as String);
    } catch (_) {
      criadoEm = DateTime.now();
    }

    final status = _mapStatusFromJson(json['status']);

    return Pedido(
      id: (json['id'] as num).toInt(),
      lojaNome: lojaNome,
      lojaImagemUrl: loja?['imagem'],
      itens: itens,
      total: total,
      status: status,
      criadoEm: criadoEm,
      // se quiser usar localEntrega depois, basta mapear json['localizacao']
      localEntrega: null,
    );
  }

  // ---------- Leitura (lista, detalhes) ----------

  static List<Pedido> get pedidosEmAndamento =>
      _cache.where((p) => p.status == PedidoStatus.emAndamento).toList();

  static List<Pedido> get historico => _cache
      .where(
        (p) =>
            p.status == PedidoStatus.entregue ||
            p.status == PedidoStatus.cancelado,
      )
      .toList();

  /// Carrega pedidos do back e atualiza o cache.
  static Future<List<Pedido>> carregarPedidos() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/pedidos'),
      headers: _headers(),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        _cache =
            data.whereType<Map<String, dynamic>>().map(_fromApiJson).toList()
              ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));

        return _cache;
      } else {
        throw Exception('Resposta inesperada ao listar pedidos.');
      }
    } else {
      try {
        final body = jsonDecode(resp.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception('Erro ao carregar pedidos (${resp.statusCode}).');
    }
  }

  /// Busca um pedido específico pelo ID.
  static Future<Pedido> buscarPorId(int id) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/pedidos/$id'),
      headers: _headers(),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is Map<String, dynamic>) {
        final pedido = _fromApiJson(data);

        _cache.removeWhere((p) => p.id == pedido.id);
        _cache.insert(0, pedido);

        return pedido;
      } else {
        throw Exception('Resposta inesperada ao buscar pedido.');
      }
    } else {
      try {
        final body = jsonDecode(resp.body);
        if (body is Map && body['message'] != null) {
          throw Exception(body['message'].toString());
        }
      } catch (_) {}
      throw Exception('Erro ao buscar pedido (${resp.statusCode}).');
    }
  }

  // ---------- Criação (a partir do carrinho) ----------

  /// Cria um pedido no backend a partir do carrinho atual.
  ///
  /// - Usa CarrinhoService para pegar lojaId + itens.
  /// - Envia localizacao_id escolhido na LocalEntregaView.
  /// - Atualiza o cache e retorna o Pedido já mapeado.
  static Future<Pedido> criarPedidoFromCart({
    required LocalEntrega localEntrega,
  }) async {
    final carrinho = CarrinhoService.state;

    if (carrinho.isEmpty || carrinho.lojaId == null) {
      throw Exception('Carrinho vazio ou loja não definida.');
    }

    final itensPayload = carrinho.itens
        .map(
          (item) => {
            'produto_id': item.produtoId,
            'quantidade': item.quantidade,
          },
        )
        .toList();

    final body = {
      'loja_id': carrinho.lojaId,
      'localizacao_id': localEntrega.id,
      'itens': itensPayload,
    };

    final resp = await http.post(
      Uri.parse('$_baseUrl/pedidos'),
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (resp.statusCode == 201) {
      final data = jsonDecode(resp.body);

      if (data is Map<String, dynamic>) {
        final rawPedido = data['pedido'] ?? data;
        if (rawPedido is Map<String, dynamic>) {
          // injeta total no json do pedido, se veio fora
          if (data['total'] != null && rawPedido['total'] == null) {
            rawPedido['total'] = data['total'];
          }

          final pedido = _fromApiJson(rawPedido);

          _cache.insert(0, pedido);

          // limpar carrinho aqui faz sentido:
          CarrinhoService.limpar();

          return pedido;
        }
      }

      throw Exception('Resposta inesperada ao criar pedido.');
    } else {
      try {
        final body = jsonDecode(resp.body);
        if (body is Map) {
          if (body['errors'] != null) {
            throw Exception(body['errors'].toString());
          }
          if (body['message'] != null) {
            throw Exception(body['message'].toString());
          }
        }
      } catch (_) {}
      throw Exception('Erro ao criar pedido (${resp.statusCode}).');
    }
  }
}
