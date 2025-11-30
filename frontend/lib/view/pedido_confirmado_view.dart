import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/view/main_tab_view.dart';
import 'package:google_fonts/google_fonts.dart';

class PedidoConfirmadoView extends StatefulWidget {
  const PedidoConfirmadoView({super.key});

  @override
  State<PedidoConfirmadoView> createState() => _PedidoConfirmadoViewState();
}

class _PedidoConfirmadoViewState extends State<PedidoConfirmadoView> {
  @override
  void initState() {
    super.initState();

    // Depois de um curto tempo, envia o usuário para a aba "Pedidos" (índice 2)
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainTabView(initialIndex: 2)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: TColor.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 50,
                  color: TColor.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pedido confirmado!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: TColor.primarytext,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você poderá acompanhar o status na aba de Pedidos.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TColor.secondarytext,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
