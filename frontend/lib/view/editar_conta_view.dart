import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/auth_service.dart';

class EditarContaView extends StatefulWidget {
  final String nomeInicial;
  final String email;
  final String telefoneInicial;

  const EditarContaView({
    super.key,
    required this.nomeInicial,
    required this.email,
    required this.telefoneInicial,
  });

  @override
  State<EditarContaView> createState() => _EditarContaViewState();
}

class _EditarContaViewState extends State<EditarContaView> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeInicial);
    _telefoneController = TextEditingController(text: widget.telefoneInicial);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final email = _emailController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o nome.')));
      return;
    }

    if (telefone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o telefone.')));
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o e-mail.')));
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um e-mail válido.')),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final result = await AuthService.updateProfile(
        name: nome,
        telefone: telefone,
        email: email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (result['message'] as String?) ?? 'Dados atualizados com sucesso.',
          ),
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Editar Conta',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: TColor.primarytext,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF6F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Telefone',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: TColor.primarytext,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF6F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'E-mail',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: TColor.primarytext,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF6F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _salvando ? null : _salvar,
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
                child: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
