import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/pedido.dart';
import 'package:frontend/services/pedido_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/view/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeVendedorView extends StatefulWidget {
  final int? lojaId;
  final String? lojaNome;

  const HomeVendedorView({super.key, this.lojaId, this.lojaNome});

  @override
  State<HomeVendedorView> createState() => _HomeVendedorViewState();
}

class _HomeVendedorViewState extends State<HomeVendedorView> {
  @override
  Widget build(BuildContext context) {
    // se veio do login com nome/ID de loja, usamos isso; senão caímos no mock
    final todos = PedidoService.todos;
    final fallbackNome = todos.isNotEmpty ? todos.first.lojaNome : 'Minha loja';

    final lojaNome = widget.lojaNome ?? fallbackNome;

    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Painel do vendedor',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TColor.secondarytext,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              lojaNome,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TColor.primarytext,
              ),
            ),
          ],
        ),
        actions: [
          // futuro: tela de perfil/edição da loja
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            color: TColor.primarytext,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Tela de perfil da loja ainda não implementada.',
                  ),
                ),
              );
            },
          ),
          // histórico de pedidos entregues (do vendedor)
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
          // logout
          IconButton(
            icon: const Icon(Icons.logout),
            color: TColor.primarytext,
            onPressed: () async {
              await AuthService.logout();

              if (!mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // por enquanto, usamos as listas globais do service.
    // no futuro, podemos filtrar por widget.lojaId.
    final novos = PedidoService.pedidosNovos;
    final emPreparo = PedidoService.pedidosEmPreparo;
    final prontos = PedidoService.pedidosProntos;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(
              title: 'Novos',
              badgeColor: Colors.blue.shade100,
              pedidos: novos,
              emptyText: 'Nenhum pedido novo.',
              buildActions: (pedido) => [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      PedidoService.moverParaEmPreparo(pedido.id);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: TColor.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            _buildColumn(
              title: 'Em preparo',
              badgeColor: Colors.orange.shade100,
              pedidos: emPreparo,
              emptyText: 'Nada em preparo.',
              buildActions: (pedido) => [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      PedidoService.moverParaPronto(pedido.id);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Marcar como pronto'),
                ),
              ],
            ),
            const SizedBox(width: 12),
            _buildColumn(
              title: 'Prontos',
              badgeColor: Colors.green.shade100,
              pedidos: prontos,
              emptyText: 'Nenhum pedido pronto.',
              buildActions: (pedido) => [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      PedidoService.moverParaEntregue(pedido.id);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Marcar como entregue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required Color badgeColor,
    required List<Pedido> pedidos,
    required String emptyText,
    required List<Widget> Function(Pedido pedido) buildActions,
  }) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // título da coluna
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${pedidos.length}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (pedidos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                emptyText,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TColor.secondarytext,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return _buildPedidoCard(pedido, buildActions(pedido));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPedidoCard(Pedido pedido, List<Widget> actions) {
    final itensResumo = pedido.itens
        .map((i) => '${i.quantidade}x ${i.nomeProduto}')
        .join(', ');

    final hora =
        '${pedido.criadoEm.hour.toString().padLeft(2, '0')}:${pedido.criadoEm.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header: cliente + horário
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

            // local de entrega
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

            // itens
            Text(
              itensResumo,
              style: GoogleFonts.inter(fontSize: 13, color: TColor.primarytext),
            ),
            const SizedBox(height: 6),

            // total
            Text(
              'Total: R\$ ${pedido.total.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TColor.primarytext,
              ),
            ),
            const SizedBox(height: 8),

            // ações
            Row(children: [...actions]),
          ],
        ),
      ),
    );
  }
}
