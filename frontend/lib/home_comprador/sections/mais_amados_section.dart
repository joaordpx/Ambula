import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class MaisAmadosSection extends StatelessWidget {
  final List<Map<String, dynamic>> produtos;
  final VoidCallback? onVerMais;
  final void Function(Map<String, dynamic> produto)? onProdutoTap;

  const MaisAmadosSection({
    super.key,
    required this.produtos,
    this.onVerMais,
    this.onProdutoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (produtos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final produto = produtos[index];
                final nomeProduto = (produto['nomeProduto'] ?? '').toString();
                final nomeAmbulante = (produto['nomeAmbulante'] ?? '')
                    .toString();
                final bool lojaAberta =
                    (produto['lojaAberta'] as bool?) ?? false;

                return GestureDetector(
                  onTap: () => onProdutoTap?.call(produto),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nomeProduto,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TColor.primarytext,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nomeAmbulante,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TColor.secondarytext,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          lojaAberta
                              ? 'Disponível agora'
                              : 'Fechado no momento',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: lojaAberta ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Text(
          'Mais amados do campus',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TColor.primarytext,
          ),
        ),
        const Spacer(),
        if (onVerMais != null)
          TextButton(
            onPressed: onVerMais,
            child: Text(
              'Ver todos',
              style: GoogleFonts.inter(fontSize: 13, color: TColor.primary),
            ),
          ),
      ],
    );
  }
}
