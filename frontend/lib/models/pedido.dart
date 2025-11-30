import 'package:flutter/material.dart';

enum PedidoStatus { emAndamento, entregue, cancelado }

class PedidoItem {
  final String nomeProduto;
  final int quantidade;

  PedidoItem({required this.nomeProduto, required this.quantidade});
}

class Pedido {
  final int id;
  final String lojaNome;
  final String? lojaImagemUrl;
  final List<PedidoItem> itens;
  final double total;
  final PedidoStatus status;
  final DateTime criadoEm;

  Pedido({
    required this.id,
    required this.lojaNome,
    this.lojaImagemUrl,
    required this.itens,
    required this.total,
    required this.status,
    required this.criadoEm,
  });

  /// helper pra exibir o status como texto
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

  /// helper pra cor do status
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
