import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:frontend/models/pedido.dart';
import 'package:frontend/models/local_entrega.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/services/auth_service.dart';

class PedidoService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

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

  // ------------------------------------------------------------
  // MAPEAMENTO DE STATUS PARA ENUM DO FRONT
  // ------------------------------------------------------------
  static PedidoStatus _mapStatusFromString(String? status) {
    if (status == null) return PedidoStatus.emAndamento;

    final s = status.toLowerCase();

    if (s.contains('novo')) return PedidoStatus.novo;
    if (s.contains('preparo')) return PedidoStatus.emPreparo;
    if (s.contains('pronto')) return PedidoStatus.pronto;
    if (s.contains('entreg')) return PedidoStatus.entregue;
    if (s.contains('cancel')) return PedidoStatus.cancelado;

    return PedidoStatus.emAndamento;
  }

  // ------------------------------------------------------------
  // PARSE DO JSON VINDO DO BACKEND
  // ------------------------------------------------------------
  static Pedido _fromApiJson(Map<String, dynamic> json) {
    final itensJson = json['itens'] as List? ?? [];
    final itens = itensJson.map((i) {
      return PedidoItem(
        nomeProduto: i['produto']?['nome'] ?? 'Produto',
        quantidade: i['quantidade'] ?? 1,
      );
    }).toList();

    return Pedido(
      id: json['id'],
      lojaNome: json['loja']?['nome'] ?? 'Loja',
      lojaImagemUrl: json['loja']?['imagem'],
      itens: itens,
      total: (json['valor_total'] ?? json['total'] ?? 0).toDouble(),
      status: _mapStatusFromString(
        json['status'] ?? json['status_pedido'] ?? json['status_pedido_id'],
      ),
      criadoEm: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      localEntrega: null,
    );
  }

  // ------------------------------------------------------------
  // COMPRADOR - LISTA TOTAL / HISTÓRICO
  // ------------------------------------------------------------
  static List<Pedido> get pedidosEmAndamento =>
      _cache.where((p) => p.isEmAndamentoComprador).toList();

  static List<Pedido> get historico => _cache
      .where(
        (p) =>
            p.status == PedidoStatus.entregue ||
            p.status == PedidoStatus.cancelado,
      )
      .toList();

  static Future<List<Pedido>> carregarPedidos() async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/pedidos'),
      headers: _headers(),
    );

    if (resp.statusCode != 200) {
      throw Exception('Erro ao carregar pedidos');
    }

    final data = jsonDecode(resp.body);
    if (data is! List) throw Exception('Resposta inesperada');

    _cache = data.map<Pedido>((j) => _fromApiJson(j)).toList();
    return _cache;
  }

  static Future<Pedido> buscarPorId(int id) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/pedidos/$id'),
      headers: _headers(),
    );

    if (resp.statusCode != 200) {
      throw Exception('Erro ao buscar pedido');
    }

    final data = jsonDecode(resp.body);
    final p = _fromApiJson(data);

    _cache.removeWhere((e) => e.id == p.id);
    _cache.insert(0, p);

    return p;
  }

  // ------------------------------------------------------------
  // VENDEDOR - LISTAGEM DA LOJA
  // ------------------------------------------------------------
  static Future<List<Pedido>> carregarPedidosDaLoja(int lojaId) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/lojas/$lojaId/pedidos'),
      headers: _headers(),
    );

    if (resp.statusCode != 200) {
      throw Exception('Erro ao carregar pedidos da loja');
    }

    final json = jsonDecode(resp.body);
    final pedidosJson = json['pedidos'] as List? ?? [];

    final pedidos = pedidosJson
        .whereType<Map<String, dynamic>>()
        .map(_fromApiJson)
        .toList();

    // ATUALIZA CACHE SEM QUEBRAR OUTRAS TELAS
    for (var p in pedidos) {
      _cache.removeWhere((x) => x.id == p.id);
      _cache.insert(0, p);
    }

    return pedidos;
  }

  static List<Pedido> pedidosNovosDaLoja(int lojaId) =>
      _cache.where((p) => p.status == PedidoStatus.novo).toList();

  static List<Pedido> pedidosEmPreparoDaLoja(int lojaId) =>
      _cache.where((p) => p.status == PedidoStatus.emPreparo).toList();

  static List<Pedido> pedidosProntosDaLoja(int lojaId) =>
      _cache.where((p) => p.status == PedidoStatus.pronto).toList();

  // ------------------------------------------------------------
  // VENDEDOR - ATUALIZAÇÃO DE STATUS
  // ------------------------------------------------------------
  static Future<void> _setStatus(int pedidoId, String status) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/pedidos/$pedidoId/status'),
      headers: _headers(),
      body: jsonEncode({"status": status}),
    );

    if (resp.statusCode != 200) {
      throw Exception("Erro ao atualizar status");
    }
  }

  static Pedido _copyWithStatus(Pedido p, PedidoStatus novoStatus) {
    return Pedido(
      id: p.id,
      lojaNome: p.lojaNome,
      lojaImagemUrl: p.lojaImagemUrl,
      itens: p.itens,
      total: p.total,
      status: novoStatus,
      criadoEm: p.criadoEm,
      localEntrega: p.localEntrega,
    );
  }

  static Future<void> moverParaEmPreparo(int id) async {
    await _setStatus(id, 'em_preparo');

    final index = _cache.indexWhere((e) => e.id == id);
    if (index != -1) {
      _cache[index] = _copyWithStatus(_cache[index], PedidoStatus.emPreparo);
    }
  }

  static Future<void> moverParaPronto(int id) async {
    await _setStatus(id, 'pronto');

    final index = _cache.indexWhere((e) => e.id == id);
    if (index != -1) {
      _cache[index] = _copyWithStatus(_cache[index], PedidoStatus.pronto);
    }
  }

  static Future<void> moverParaEntregue(int id) async {
    await _setStatus(id, 'entregue');

    final index = _cache.indexWhere((e) => e.id == id);
    if (index != -1) {
      _cache[index] = _copyWithStatus(_cache[index], PedidoStatus.entregue);
    }
  }

  static Future<void> cancelarPedido(int id) async {
    await _setStatus(id, 'cancelado');

    final index = _cache.indexWhere((e) => e.id == id);
    if (index != -1) {
      _cache[index] = _copyWithStatus(_cache[index], PedidoStatus.cancelado);
    }
  }

  // ------------------------------------------------------------
  // CRIAÇÃO DO PEDIDO (COMPRADOR)
  // ------------------------------------------------------------
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

    if (resp.statusCode != 201) {
      throw Exception("Erro ao criar pedido");
    }

    final data = jsonDecode(resp.body);
    final rawPedido = data['pedido'] ?? data;

    final pedido = _fromApiJson(rawPedido);

    _cache.insert(0, pedido);
    CarrinhoService.limpar();

    return pedido;
  }
}
