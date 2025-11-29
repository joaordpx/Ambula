import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/categoria_produto.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriasSection extends StatelessWidget {
  final List<CategoriaProduto> categorias;
  final VoidCallback? onVerMais; // callback pro "Ver mais" (null por enquanto)
  final void Function(CategoriaProduto categoria)? onCategoriaTap;
  const CategoriasSection({
    super.key,
    required this.categorias,
    this.onVerMais,
    this.onCategoriaTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categorias de Produtos",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: TColor.primarytext,
                ),
              ),
              InkWell(
                onTap: onVerMais,
                child: Text(
                  "Ver mais",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TColor.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final cat = categorias[i];
                final desc = cat.descricao.trim();
                final letra = desc.isNotEmpty ? desc.characters.first : '?';

                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => onCategoriaTap?.call(cat),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: TColor.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          letra.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: TColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 73,
                        child: Text(
                          desc.isEmpty ? 'Categoria' : desc,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TColor.primarytext,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
