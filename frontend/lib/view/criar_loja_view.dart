import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/services/loja_service.dart';
import 'package:frontend/view/home_vendedor_view.dart';
import 'package:google_fonts/google_fonts.dart';

class CriarLojaView extends StatefulWidget {
  const CriarLojaView({super.key});

  @override
  State<CriarLojaView> createState() => _CriarLojaViewState();
}

class _CriarLojaViewState extends State<CriarLojaView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _onSalvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await LojaService.criarLojaMock(
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Loja criada com sucesso!')));

      // Vai direto pro painel do vendedor
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeVendedorView()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar loja: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
          'Criar minha loja',
          style: GoogleFonts.inter(
            color: TColor.primarytext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preencha os dados abaixo para cadastrar sua loja no Ambula. '
                'Depois, você poderá gerenciar pedidos pelo painel do vendedor.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: TColor.secondarytext,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Nome
              Text(
                'Nome da loja',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TColor.primarytext,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Delícia de Cookie',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe um nome para a loja.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              Text(
                'Descrição',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TColor.primarytext,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Conte rapidamente o que você vende.',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _onSalvar,
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
                  child: _isSaving
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('Salvar e ir para painel do vendedor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
