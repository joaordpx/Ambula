import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class DisponiveisAgoraSection extends StatelessWidget {
  final List<Map<String, dynamic>> produtos;
  final VoidCallback onVerMais;

  const DisponiveisAgoraSection({
    super.key,
    required this.produtos,
    required this.onVerMais,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Disponíveis Agora",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
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
          const SizedBox(height: 14),

          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final item = produtos[i];

                return SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item["imagem"],
                          height: 110,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        item["nome"],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              item["ambulante"]["foto"],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item["ambulante"]["nome"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "Disponível Agora",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
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
