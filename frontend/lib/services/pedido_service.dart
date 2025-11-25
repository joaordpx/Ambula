import 'package:frontend/models/pedido.dart';

class PedidoService {
  static final List<Pedido> _pedidos = [
    Pedido(
      id: 1,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.emAndamento,
      criadoEm: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Pedido(
      id: 2,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.entregue,
      criadoEm: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Pedido(
      id: 3,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.cancelado,
      criadoEm: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<Pedido> get todos => List.unmodifiable(_pedidos);

  static List<Pedido> get pedidosEmAndamento =>
      _pedidos.where((p) => p.status == PedidoStatus.emAndamento).toList();

  static List<Pedido> get historico => _pedidos
      .where(
        (p) =>
            p.status == PedidoStatus.entregue ||
            p.status == PedidoStatus.cancelado,
      )
      .toList();

  static void adicionarPedido(Pedido pedido) {
    _pedidos.insert(0, pedido);
  }
}
