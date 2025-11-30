import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';

/// Estados possíveis do pedido.
/// - novo: acabou de ser criado, ainda não aceito pelo vendedor
/// - emPreparo: vendedor iniciou o preparo
/// - pronto: pronto para retirada/entrega
/// - entregue: finalizado com sucesso
/// - cancelado: cancelado por alguma das partes
enum PedidoStatus { novo, emPreparo, pronto, entregue, cancelado }

class PedidoItem {
  final String nomeProduto;
  final int quantidade;

  PedidoItem({required this.nomeProduto, required this.quantidade});
}

class Pedido {
  final int id;
  final String lojaNome;
  final int lojaId;
  final String? lojaImagemUrl;
  final List<PedidoItem> itens;
  final double total;
  PedidoStatus status;
  final DateTime criadoEm;
  // dados extras úteis para comprador/vendedor
  final String? clienteNome;
  final String? clienteTelefone;
  final String? localEntregaDescricao;

  Pedido({
    required this.id,
    required this.lojaNome,
    required this.lojaId,
    this.lojaImagemUrl,
    required this.itens,
    required this.total,
    required this.status,
    required this.criadoEm,
    this.clienteNome,
    this.clienteTelefone,
    this.localEntregaDescricao,
  });

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
    }
  }

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
    }
  }

  /// Do ponto de vista do COMPRADOR, “em andamento” = tudo que ainda não foi entregue nem cancelado
  bool get isEmAndamentoComprador =>
      status == PedidoStatus.novo ||
      status == PedidoStatus.emPreparo ||
      status == PedidoStatus.pronto;
}
