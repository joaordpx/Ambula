import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class LojasPopularesSection extends StatelessWidget {
  final List<Map<String, dynamic>> lojas;
  final VoidCallback? onVerMais;

  // 👇 novo callback
  final void Function(int lojaId)? onLojaTap;

  const LojasPopularesSection({
    super.key,
    required this.lojas,
    this.onVerMais,
    this.onLojaTap,
  });

  @override
  Widget build(BuildContext context) {
    if (lojas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + "Ver mais"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lojas Mais Populares",
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
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: lojas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final loja = lojas[index];
                final nome = (loja['nome'] ?? '').toString().trim();
                final inicial = (nome.isNotEmpty ? nome.characters.first : '?')
                    .toUpperCase();

                // 👇 pegamos o id da loja (ajusta a chave se for diferente)
                final int? lojaId = loja['id'] is int
                    ? loja['id'] as int
                    : int.tryParse(loja['id']?.toString() ?? '');

                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: lojaId != null ? () => onLojaTap?.call(lojaId) : null,
                  child: Column(
                    children: [
                      // avatar circular da loja (placeholder, depois vira imagem)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: TColor.primary.withOpacity(0.15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          inicial,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: TColor.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 80,
                        child: Text(
                          nome.isEmpty ? 'Nome da Loja' : nome,
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
