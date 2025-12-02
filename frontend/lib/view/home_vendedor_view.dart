import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/pedido.dart';
import 'package:frontend/services/pedido_service.dart';
import 'package:frontend/view/config_loja_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeVendedorView extends StatefulWidget {
  final int? lojaId;
  final String? lojaNome;

  const HomeVendedorView({super.key, this.lojaId, this.lojaNome});

  @override
  State<HomeVendedorView> createState() => _HomeVendedorViewState();
}

class _HomeVendedorViewState extends State<HomeVendedorView> {
  int get _lojaIdExibicao => widget.lojaId ?? 1;

  String get _lojaNomeExibicao {
    if (widget.lojaNome != null && widget.lojaNome!.trim().isNotEmpty) {
      return widget.lojaNome!;
    }
    final todos = PedidoService.todos;
    final daLoja = todos.where((p) => p.lojaId == _lojaIdExibicao).toList();
    if (daLoja.isNotEmpty) return daLoja.first.lojaNome;
    return 'Minha loja';
  }

  @override
  Widget build(BuildContext context) {
    final novos = PedidoService.pedidosNovosDaLoja(_lojaIdExibicao);
    final emPreparo = PedidoService.pedidosEmPreparoDaLoja(_lojaIdExibicao);
    final prontos = PedidoService.pedidosProntosDaLoja(_lojaIdExibicao);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: TColor.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: TColor.primarytext,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Painel do vendedor',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TColor.secondarytext,
                ),
              ),
              Text(
                _lojaNomeExibicao,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TColor.primarytext,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.storefront_outlined),
              color: TColor.primarytext,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ConfigLojaView(lojaId: _lojaIdExibicao),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              color: TColor.primarytext,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Histórico de pedidos do vendedor ainda não implementado.',
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              color: TColor.primarytext,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // header verde
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo de hoje',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildHeaderStat('Novos', novos.length),
                      const SizedBox(width: 8),
                      _buildHeaderStat('Em preparo', emPreparo.length),
                      const SizedBox(width: 8),
                      _buildHeaderStat('Prontos', prontos.length),
                    ],
                  ),
                ],
              ),
            ),

            // tabs
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TabBar(
                labelColor: TColor.primarytext,
                unselectedLabelColor: TColor.secondarytext,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: TColor.primary,
                indicatorWeight: 3,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  _buildTabWithBadge('Novos', novos.length, Colors.blue),
                  _buildTabWithBadge(
                    'Em preparo',
                    emPreparo.length,
                    Colors.orange,
                  ),
                  _buildTabWithBadge('Prontos', prontos.length, Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: TabBarView(
                children: [
                  _buildListaPedidos(
                    context,
                    novos,
                    emptyText: 'Nenhum pedido novo.',
                  ),
                  _buildListaPedidos(
                    context,
                    emPreparo,
                    emptyText: 'Nada em preparo.',
                  ),
                  _buildListaPedidos(
                    context,
                    prontos,
                    emptyText: 'Nenhum pedido pronto.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$value',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab _buildTabWithBadge(String label, int count, Color color) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaPedidos(
    BuildContext context,
    List<Pedido> pedidos, {
    required String emptyText,
  }) {
    if (pedidos.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: GoogleFonts.inter(fontSize: 14, color: TColor.secondarytext),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        return _buildPedidoCard(pedido);
      },
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    final itensResumo = pedido.itens
        .map((i) => '${i.quantidade}x ${i.nomeProduto}')
        .join(', ');

    final hora =
        '${pedido.criadoEm.hour.toString().padLeft(2, '0')}:${pedido.criadoEm.minute.toString().padLeft(2, '0')}';

    List<Widget> actions;
    switch (pedido.status) {
      case PedidoStatus.novo:
        actions = [
          ElevatedButton(
            onPressed: () {
              setState(() {
                PedidoService.moverParaEmPreparo(pedido.id);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Iniciar preparo'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                PedidoService.cancelarPedido(pedido.id);
              });
            },
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(fontSize: 13, color: TColor.accent),
            ),
          ),
        ];
        break;

      case PedidoStatus.emPreparo:
        actions = [
          ElevatedButton(
            onPressed: () {
              setState(() {
                PedidoService.moverParaPronto(pedido.id);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Marcar como pronto'),
          ),
        ];
        break;

      case PedidoStatus.pronto:
        actions = [
          ElevatedButton(
            onPressed: () {
              setState(() {
                PedidoService.moverParaEntregue(pedido.id);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Marcar como entregue'),
          ),
        ];
        break;

      default:
        actions = [];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pedido.clienteNome ?? 'Cliente',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                ),
              ),
              Text(
                hora,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: TColor.secondarytext,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (pedido.localEntregaDescricao != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pedido.localEntregaDescricao!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: TColor.secondarytext,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Text(
            itensResumo,
            style: GoogleFonts.inter(fontSize: 13, color: TColor.primarytext),
          ),
          const SizedBox(height: 6),
          Text(
            'Total: R\$ ${pedido.total.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
          const SizedBox(height: 10),
          if (actions.isNotEmpty) Row(children: actions),
        ],
      ),
    );
  }
}
