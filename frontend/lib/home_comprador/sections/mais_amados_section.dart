import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class MaisAmadosSection extends StatelessWidget {
  final List<Map<String, dynamic>> produtos;
  final VoidCallback? onVerMais;

  const MaisAmadosSection({super.key, required this.produtos, this.onVerMais});

  @override
  Widget build(BuildContext context) {
    if (produtos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // título + ver mais
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mais Amados do Campus",
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
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final item = produtos[index];

                final nomeProduto = (item['nomeProduto'] ?? '')
                    .toString()
                    .trim();
                final nomeAmbulante = (item['nomeAmbulante'] ?? '')
                    .toString()
                    .trim();
                final lojaAberta = item['lojaAberta'] == true;

                return _MaisAmadoCard(
                  nomeProduto: nomeProduto,
                  nomeAmbulante: nomeAmbulante,
                  lojaAberta: lojaAberta,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MaisAmadoCard extends StatelessWidget {
  final String nomeProduto;
  final String nomeAmbulante;
  final bool lojaAberta;

  const _MaisAmadoCard({
    required this.nomeProduto,
    required this.nomeAmbulante,
    required this.lojaAberta,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // imagem do produto (placeholder por enquanto)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: const Center(
                child: Icon(Icons.fastfood, size: 40, color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // nome do produto
          Text(
            nomeProduto.isEmpty ? 'Nome do Produto' : nomeProduto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
          const SizedBox(height: 6),

          // ambulante + avatar
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: TColor.primary.withOpacity(0.15),
                child: Text(
                  (nomeAmbulante.isNotEmpty
                          ? nomeAmbulante.characters.first
                          : '?')
                      .toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: TColor.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nomeAmbulante.isEmpty ? 'Nome do Ambulante' : nomeAmbulante,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: TColor.secondarytext,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // status da loja
          Text(
            lojaAberta ? 'Disponível Agora' : 'Fechado',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: lojaAberta ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
