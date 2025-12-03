import 'package:flutter/material.dart';
import 'package:frontend/models/local_entrega.dart';
import 'package:frontend/common/color_extension.dart'; // ← NECESSÁRIO para TColor

/// Status possíveis de um pedido na visão do app.
enum PedidoStatus { emAndamento, entregue, cancelado, novo, emPreparo, pronto }

/// Item individual dentro de um pedido (nome + quantidade).
class PedidoItem {
  final String nomeProduto;
  final int quantidade;

  const PedidoItem({required this.nomeProduto, required this.quantidade});
}

/// Modelo de Pedido usado no front.
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

  /// Texto visível do status
  String get statusTexto {
    switch (status) {
      case PedidoStatus.novo:
        return 'Novo';
      case PedidoStatus.emPreparo:
        return 'Em preparo';
      case PedidoStatus.pronto:
        return 'Pronto para retirada';
      case PedidoStatus.entregue:
        return 'Entregue';
      case PedidoStatus.cancelado:
        return 'Cancelado';
      case PedidoStatus.emAndamento:
        return 'Em andamento';
    }
  }

  /// Cor exibida para o status
  Color statusColor(Color primary, Color accent) {
    switch (status) {
      case PedidoStatus.novo:
        return primary;
      case PedidoStatus.emPreparo:
        return Colors.orange;
      case PedidoStatus.pronto:
        return primary;
      case PedidoStatus.entregue:
        return TColor.primary;
      case PedidoStatus.cancelado:
        return accent;
      case PedidoStatus.emAndamento:
        return Colors.blue; // fallback – você pode trocar se quiser
    }
  }

  /// Do ponto de vista do COMPRADOR, “em andamento”
  bool get isEmAndamentoComprador =>
      status == PedidoStatus.novo ||
      status == PedidoStatus.emPreparo ||
      status == PedidoStatus.pronto;
}
