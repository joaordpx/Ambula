import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/categoria_produto.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriasSection extends StatelessWidget {
  final List<CategoriaProduto> categorias;
  final VoidCallback? onVerMais;
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
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categorias[index];
                return _CategoriaChip(
                  label: cat.descricao,
                  onTap: () => onCategoriaTap?.call(cat),
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
          'Categorias',
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
              'Ver todas',
              style: GoogleFonts.inter(fontSize: 13, color: TColor.primary),
            ),
          ),
      ],
    );
  }
}

class _CategoriaChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _CategoriaChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: TColor.primarytext,
          ),
        ),
      ),
    );
  }
}
