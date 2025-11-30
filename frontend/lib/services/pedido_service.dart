import 'package:frontend/models/pedido.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/models/local_entrega.dart';

class PedidoService {
  /// Lista mock de pedidos (vai ser substituída pelo backend depois).
  ///
  /// Repara que agora **todo pedido tem um `lojaId`**.
  /// Isso é o que permite filtrar corretamente os pedidos
  /// por loja no painel do vendedor.
  static final List<Pedido> _pedidos = [
    Pedido(
      id: 1,
      lojaId: 1,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      clienteNome: 'João Silva',
      clienteTelefone: '(38) 99999-0000',
      localEntregaDescricao: 'Prédio 3 - CCET',
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.novo,
      criadoEm: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Pedido(
      id: 2,
      lojaId: 2,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      clienteNome: 'João Silva',
      clienteTelefone: '(38) 99999-0000',
      localEntregaDescricao: 'Prédio 3 - CCET',
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.entregue,
      criadoEm: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Pedido(
      id: 3,
      lojaId: 3,
      lojaNome: 'Delícia de Cookie',
      lojaImagemUrl: null,
      clienteNome: 'João Silva',
      clienteTelefone: '(38) 99999-0000',
      localEntregaDescricao: 'Prédio 3 - CCET',
      itens: [
        PedidoItem(nomeProduto: 'Cookie de chocolate com gotas', quantidade: 2),
      ],
      total: 11.80,
      status: PedidoStatus.cancelado,
      criadoEm: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ================== GETTERS COMUNS (COMPRADOR) ==================

  /// Todos os pedidos (visão geral; em geral você NÃO usa isso direto em tela).
  static List<Pedido> get todos => List.unmodifiable(_pedidos);

  /// Para tela do **comprador** – “Pedidos em andamento”
  /// (tudo que ainda não foi entregue nem cancelado).
  static List<Pedido> get pedidosEmAndamento =>
      _pedidos.where((p) => p.isEmAndamentoComprador).toList();

  /// Para tela do **comprador** – “Histórico”
  /// (apenas pedidos entregues ou cancelados).
  static List<Pedido> get historico => _pedidos
      .where(
        (p) =>
            p.status == PedidoStatus.entregue ||
            p.status == PedidoStatus.cancelado,
      )
      .toList();

  // ================== GETTERS PARA VENDEDOR (FILTRADOS POR LOJA) ==================

  /// Pedidos **novos** de uma loja específica – coluna "Novos" do kanban.
  static List<Pedido> pedidosNovosDaLoja(int lojaId) => _pedidos
      .where((p) => p.lojaId == lojaId && p.status == PedidoStatus.novo)
      .toList();

  /// Pedidos **em preparo** de uma loja específica – coluna "Em preparo".
  static List<Pedido> pedidosEmPreparoDaLoja(int lojaId) => _pedidos
      .where((p) => p.lojaId == lojaId && p.status == PedidoStatus.emPreparo)
      .toList();

  /// Pedidos **prontos** de uma loja específica – coluna "Prontos para retirada".
  static List<Pedido> pedidosProntosDaLoja(int lojaId) => _pedidos
      .where((p) => p.lojaId == lojaId && p.status == PedidoStatus.pronto)
      .toList();

  /// Pedidos **entregues** de uma loja específica – pode alimentar
  /// uma coluna/aba "Entregues" no painel do vendedor.
  static List<Pedido> pedidosEntreguesDaLoja(int lojaId) => _pedidos
      .where((p) => p.lojaId == lojaId && p.status == PedidoStatus.entregue)
      .toList();

  // ================== MUTADORES ==================

  /// Adicionar um pedido manualmente (se precisar em algum teste).
  static void adicionarPedido(Pedido pedido) {
    _pedidos.insert(0, pedido);
  }

  /// Cria um novo pedido a partir do carrinho atual.
  ///
  /// Hoje: grava em memória (mock).
  /// Futuro: isso aqui vira um POST pro backend, passando:
  /// - loja_id,
  /// - itens,
  /// - valor total,
  /// - local_entrega_id,
  /// - dados do cliente, etc.
  static Future<Pedido> criarPedidoFromCart({
    required LocalEntrega localEntrega,
    String? clienteNome,
    String? clienteTelefone,
  }) async {
    final carrinho = CarrinhoService.state;

    // segurança extra: não criar pedido sem loja ou sem itens
    if (carrinho.isEmpty || carrinho.lojaId == null) {
      throw Exception('Carrinho vazio ou loja não definida.');
    }

    final novoPedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch, // id mock por enquanto
      lojaId: carrinho.lojaId!, // 🔹 vínculo com a loja dona
      lojaNome: carrinho.lojaNome ?? 'Loja',
      lojaImagemUrl: null, // depois vem da API
      clienteNome: clienteNome,
      clienteTelefone: clienteTelefone,
      localEntregaDescricao:
          localEntrega.nome, // (poderá virar local_entrega_id)
      itens: carrinho.itens
          .map(
            (item) =>
                PedidoItem(nomeProduto: item.nome, quantidade: item.quantidade),
          )
          .toList(),
      total: carrinho.subtotal,
      status: PedidoStatus.novo, // entra como "Novo" pro kanban
      criadoEm: DateTime.now(),
    );

    _pedidos.insert(0, novoPedido);
    return novoPedido;
  }

  // ================== ATUALIZAÇÃO DE STATUS (PAINEL VENDEDOR) ==================

  /// Helper interno pra achar pedido pelo id.
  static Pedido _findById(int id) {
    final index = _pedidos.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Pedido $id não encontrado.');
    }
    return _pedidos[index];
  }

  /// Atualiza o status de um pedido em memória.
  ///
  /// ⚠️ IMPORTANTE:
  /// - Certifica que o `status` em `Pedido` **não seja `final`**,
  ///   senão essa atribuição não compila.
  /// - No backend real, isso aqui vira um PATCH/PUT tipo:
  ///   `PATCH /api/pedidos/{id} { "status": "pronto" }`.
  static void atualizarStatus(int pedidoId, PedidoStatus novoStatus) {
    final pedido = _findById(pedidoId);
    pedido.status = novoStatus;
  }

  /// Exemplo: botão "Iniciar preparo" na coluna "Novos".
  static void moverParaEmPreparo(int pedidoId) {
    atualizarStatus(pedidoId, PedidoStatus.emPreparo);
  }

  /// Exemplo: botão "Marcar como pronto" na coluna "Em preparo".
  static void moverParaPronto(int pedidoId) {
    atualizarStatus(pedidoId, PedidoStatus.pronto);
  }

  /// Exemplo: botão "Marcar como entregue" na coluna "Prontos".
  static void moverParaEntregue(int pedidoId) {
    atualizarStatus(pedidoId, PedidoStatus.entregue);
  }

  /// Exemplo: botão "Cancelar" (pode existir em "Novos" ou "Em preparo").
  static void cancelarPedido(int pedidoId) {
    atualizarStatus(pedidoId, PedidoStatus.cancelado);
  }
}
