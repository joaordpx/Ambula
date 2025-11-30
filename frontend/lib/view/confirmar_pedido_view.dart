import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/local_entrega.dart';
import 'package:frontend/services/pedido_service.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/view/local_entrega_view.dart';
import 'package:frontend/view/pedido_confirmado_view.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderConfirmView extends StatefulWidget {
  final LocalEntrega localEntrega;

  const OrderConfirmView({super.key, required this.localEntrega});

  @override
  State<OrderConfirmView> createState() => _OrderConfirmViewState();
}

class _OrderConfirmViewState extends State<OrderConfirmView> {
  late LocalEntrega _localEntrega;
  late Future<Map<String, dynamic>> _futureUser;

  @override
  void initState() {
    super.initState();
    _localEntrega = widget.localEntrega;
    _futureUser = AuthService.getMe();
  }

  @override
  Widget build(BuildContext context) {
    final state = CarrinhoService.state;

    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Finalização de Pedido',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// resumo pedido
                _SectionCard(
                  title: 'Resumo do Pedido',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // nome da loja
                      if (state.lojaNome != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black12,
                                child: Icon(
                                  Icons.storefront,
                                  color: Colors.black54,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.lojaNome!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: TColor.primarytext,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Lista de itens
                      ...state.itens.map((item) {
                        final totalItem = item.preco * item.quantidade;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '• ${item.nome} x${item.quantidade}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: TColor.primarytext,
                                  ),
                                ),
                              ),
                              Text(
                                'R\$ ${totalItem.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.primarytext,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 8),

                      // Total Geral
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Geral',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: TColor.primarytext,
                            ),
                          ),
                          Text(
                            'R\$ ${state.subtotal.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: TColor.primarytext,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                /// dados do cliente
                FutureBuilder<Map<String, dynamic>>(
                  future: _futureUser,
                  builder: (context, snapshot) {
                    String nome = 'Carregando...';
                    String telefone = 'Carregando...';

                    if (snapshot.hasError) {
                      nome = 'Não foi possível carregar';
                      telefone = '-';
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      nome = (user['name'] ?? 'Nome não informado').toString();
                      telefone = (user['telefone'] ?? 'Telefone não informado')
                          .toString();
                    }

                    return _SectionCard(
                      title: 'Dados do Cliente',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome: $nome',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: TColor.primarytext,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Telefone: $telefone',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: TColor.primarytext,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // endereço entrega + botão editar
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Endereço de Entrega:',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: TColor.primarytext,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _localEntrega.nome,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: TColor.primarytext,
                                      ),
                                    ),
                                    if (_localEntrega.descricao != null &&
                                        _localEntrega.descricao!
                                            .trim()
                                            .isNotEmpty)
                                      Text(
                                        _localEntrega.descricao!,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: TColor.secondarytext,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final LocalEntrega? novoLocal =
                                      await Navigator.push<LocalEntrega?>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const DeliveryLocationView(),
                                        ),
                                      );
                                  if (novoLocal != null && mounted) {
                                    setState(() {
                                      _localEntrega = novoLocal;
                                    });
                                  }
                                },
                                child: Text(
                                  'Editar',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                /// forma de pagamento
                _SectionCard(
                  title: 'Forma de Pagamento',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Dinheiro',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: TColor.primarytext,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pagamento direto ao vendedor na entrega.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: TColor.secondarytext,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// rodapé valor total e botao confirmar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: TColor.primarytext,
                      ),
                    ),
                    Text(
                      'R\$ ${state.subtotal.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: TColor.primarytext,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // cria o pedido a partir do carrinho
                        await PedidoService.criarPedidoFromCart(
                          localEntrega: _localEntrega,
                        );

                        // limpa o carrinho
                        CarrinhoService.clear();

                        // vai para a tela de "Pedido Confirmado" (splash)
                        if (!mounted) return;

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const PedidoConfirmadoView(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao confirmar pedido: $e'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Confirmar Pedido'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
