import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class DisponiveisAgoraSection extends StatelessWidget {
  final List<Map<String, dynamic>> lojas;
  final VoidCallback? onVerMais;
  final void Function(int lojaId)? onLojaTap;

  const DisponiveisAgoraSection({
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
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: lojas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final loja = lojas[index];
                final int id = (loja['id'] as num).toInt();
                final nome = (loja['nome'] ?? '').toString();

                return GestureDetector(
                  onTap: () => onLojaTap?.call(id),
                  child: Container(
                    width: 180,
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
                          nome,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TColor.primarytext,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Aberto agora',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
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
          'Disponíveis agora',
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
