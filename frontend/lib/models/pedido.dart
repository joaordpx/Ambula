import 'package:flutter/material.dart';
import 'package:frontend/models/local_entrega.dart';

/// Status possíveis de um pedido na visão do app.
enum PedidoStatus { emAndamento, entregue, cancelado }

/// Item individual dentro de um pedido (nome + quantidade).
class PedidoItem {
  final String nomeProduto;
  final int quantidade;

  const PedidoItem({required this.nomeProduto, required this.quantidade});
}

/// Modelo de Pedido usado no front (mock por enquanto).
class Pedido {
  final int id;
  final String lojaNome;
  final String? lojaImagemUrl;
  final List<PedidoItem> itens;
  final double total;
  final PedidoStatus status;
  final DateTime criadoEm;
  final LocalEntrega? localEntrega;

  const Pedido({
    required this.id,
    required this.lojaNome,
    required this.lojaImagemUrl,
    required this.itens,
    required this.total,
    required this.status,
    required this.criadoEm,
    this.localEntrega,
  });

  /// Texto amigável para exibir o status na UI.
  String get statusTexto {
    switch (status) {
      case PedidoStatus.emAndamento:
        return 'Em andamento';
      case PedidoStatus.entregue:
        return 'Entregue';
      case PedidoStatus.cancelado:
        return 'Cancelado';
    }
  }

  /// Helper pra cor do status, mantendo o padrão que você já estava usando.
  Color statusColor(Color primary, Color accent) {
    switch (status) {
      case PedidoStatus.emAndamento:
        return Colors.orange;
      case PedidoStatus.entregue:
        return primary;
      case PedidoStatus.cancelado:
        return accent;
    }
  }
}
