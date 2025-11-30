import 'package:frontend/models/pedido.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/models/local_entrega.dart';

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

  // getters leitura

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

  // adicionar manual (se precisar em algum teste)
  static void adicionarPedido(Pedido pedido) {
    _pedidos.insert(0, pedido);
  }

  /// cria um novo pedido a partir do carrinho atual

  static Future<Pedido> criarPedidoFromCart({
    required LocalEntrega localEntrega,
  }) async {
    final carrinho = CarrinhoService.state;

    if (carrinho.isEmpty || carrinho.lojaId == null) {
      throw Exception('Carrinho vazio ou loja não definida.');
    }

    final novoPedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch, // id mock por enquanto
      lojaNome: carrinho.lojaNome ?? 'Loja',
      lojaImagemUrl: null, // depois preencher com dado real da API
      itens: carrinho.itens
          .map(
            (item) =>
                PedidoItem(nomeProduto: item.nome, quantidade: item.quantidade),
          )
          .toList(),
      total: carrinho.subtotal,
      status: PedidoStatus.emAndamento,
      criadoEm: DateTime.now(),
    );

    _pedidos.insert(0, novoPedido);

    // trocar por um POST pro backend e retorna o pedido da resposta
    return novoPedido;
  }
}
