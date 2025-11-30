// lib/view/pedidos_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/pedido.dart';
import 'package:frontend/services/pedido_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PedidosView extends StatelessWidget {
  const PedidosView({super.key});

  @override
  Widget build(BuildContext context) {
    final emAndamento = PedidoService.pedidosEmAndamento;
    final historico = PedidoService.historico;

    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Pedidos',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (emAndamento.isNotEmpty) ...[
              Text(
                'Pedidos em Andamento',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: TColor.primarytext,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: emAndamento
                    .map((p) => _PedidoCard(pedido: p))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              'Histórico de Pedidos',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TColor.primarytext,
              ),
            ),
            const SizedBox(height: 12),
            if (historico.isEmpty)
              Text(
                'Você ainda não possui pedidos anteriores.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TColor.secondarytext,
                ),
              )
            else
              Column(
                children: historico.map((p) => _PedidoCard(pedido: p)).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const _PedidoCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    final statusColor = pedido.statusColor(TColor.primary, TColor.accent);

    // monta string básica dos itens (exibe só o primeiro com quantidade)
    final itemPrincipal = pedido.itens.isNotEmpty ? pedido.itens.first : null;
    final textoItem = itemPrincipal != null
        ? '• ${itemPrincipal.nomeProduto} x${itemPrincipal.quantidade}'
        : 'Nenhum item.';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
          // loja
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    (pedido.lojaImagemUrl != null &&
                        pedido.lojaImagemUrl!.isNotEmpty)
                    ? NetworkImage(pedido.lojaImagemUrl!)
                    : null,
                child:
                    (pedido.lojaImagemUrl == null ||
                        pedido.lojaImagemUrl!.isEmpty)
                    ? const Icon(Icons.storefront, color: Colors.black54)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pedido.lojaNome,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: TColor.primarytext,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // item principal
          Text(
            textoItem,
            style: GoogleFonts.inter(fontSize: 14, color: TColor.primarytext),
          ),
          const SizedBox(height: 6),

          // total
          Text(
            'Total do Pedido: R\$ ${pedido.total.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
          const SizedBox(height: 4),

          // status
          Row(
            children: [
              Text(
                'Status: ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TColor.primarytext,
                ),
              ),
              Text(
                pedido.statusTexto,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
