import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/services/carrinho_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
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
          'Meu Carrinho',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: state.isEmpty
          ? Center(
              child: Text(
                'Seu carrinho está vazio.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: TColor.secondarytext,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.itens.length,
                    itemBuilder: (context, index) {
                      final item = state.itens[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child:
                                    (item.imageUrl != null &&
                                        item.imageUrl!.isNotEmpty)
                                    ? Image.network(
                                        item.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.fastfood_rounded,
                                        ),
                                      ),
                              ),
                            ),
                            title: Text(
                              item.nome,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: TColor.primarytext,
                              ),
                            ),
                            subtitle: Text(
                              'R\$ ${item.preco.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: TColor.secondarytext,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      CarrinhoService.updateQuantity(
                                        item.produtoId,
                                        item.quantidade - 1,
                                      );
                                    });
                                  },
                                ),
                                Text(
                                  '${item.quantidade}',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      CarrinhoService.updateQuantity(
                                        item.produtoId,
                                        item.quantidade + 1,
                                      );
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      CarrinhoService.removeItem(
                                        item.produtoId,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // resumo + botão
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
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
                      _linhaResumo('Quantidade', '${state.totalItens}'),
                      const SizedBox(height: 6),
                      _linhaResumo(
                        'Subtotal',
                        'R\$ ${state.subtotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 44,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // futuro: chamar endpoint de criar pedido
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fluxo de finalizar pedido ainda não implementado.',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Finalizar Pedido'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _linhaResumo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: TColor.primarytext),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: TColor.primarytext,
          ),
        ),
      ],
    );
  }
}
