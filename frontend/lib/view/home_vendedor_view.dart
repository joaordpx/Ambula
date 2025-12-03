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

  @override
  void initState() {
    super.initState();

    PedidoService.carregarPedidosDaLoja(_lojaIdExibicao).then((_) {
      setState(() {});
    });
  }

  String get _lojaNomeExibicao =>
      widget.lojaNome?.isNotEmpty == true ? widget.lojaNome! : "Minha Loja";

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
            const SizedBox(height: 12),
            TabBar(
              labelColor: TColor.primarytext,
              unselectedLabelColor: TColor.secondarytext,
              indicatorColor: TColor.primary,
              tabs: [
                _tab('Novos', novos.length, Colors.blue),
                _tab('Em preparo', emPreparo.length, Colors.orange),
                _tab('Prontos', prontos.length, Colors.green),
              ],
            ),

            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _buildListaPedidos(novos, 'Nenhum pedido novo.'),
                  _buildListaPedidos(emPreparo, 'Nada em preparo.'),
                  _buildListaPedidos(prontos, 'Nenhum pedido pronto.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab _tab(String label, int count, Color color) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 10,
            backgroundColor: color.withOpacity(0.12),
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

  Widget _buildHeaderStat(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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

  Widget _buildListaPedidos(List<Pedido> list, String emptyText) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: GoogleFonts.inter(fontSize: 14, color: TColor.secondarytext),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: list.length,
      itemBuilder: (_, index) => _buildPedidoCard(list[index]),
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    final itensResumo = pedido.itens
        .map((e) => '${e.quantidade}x ${e.nomeProduto}')
        .join(', ');

    final hora =
        '${pedido.criadoEm.hour.toString().padLeft(2, '0')}:${pedido.criadoEm.minute.toString().padLeft(2, '0')}';

    List<Widget> actions;

    switch (pedido.status) {
      case PedidoStatus.novo:
        actions = [
          ElevatedButton(
            onPressed: () async {
              await PedidoService.moverParaEmPreparo(pedido.id);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: TColor.primary),
            child: const Text('Iniciar preparo'),
          ),
          TextButton(
            onPressed: () async {
              await PedidoService.cancelarPedido(pedido.id);
              setState(() {});
            },
            child: Text('Cancelar', style: TextStyle(color: TColor.accent)),
          ),
        ];
        break;

      case PedidoStatus.emPreparo:
        actions = [
          ElevatedButton(
            onPressed: () async {
              await PedidoService.moverParaPronto(pedido.id);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Marcar como pronto'),
          ),
        ];
        break;

      case PedidoStatus.pronto:
        actions = [
          ElevatedButton(
            onPressed: () async {
              await PedidoService.moverParaEntregue(pedido.id);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
              const CircleAvatar(radius: 18, child: Icon(Icons.person)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cliente',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(hora, style: GoogleFonts.inter(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(itensResumo),
          const SizedBox(height: 6),
          Text(
            'Total: R\$ ${pedido.total.toStringAsFixed(2)}',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          if (actions.isNotEmpty) Row(children: actions),
        ],
      ),
    );
  }
}
