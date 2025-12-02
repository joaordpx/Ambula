import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/local_entrega.dart';
import 'package:frontend/services/local_entrega_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalEntregaView extends StatefulWidget {
  const LocalEntregaView({super.key});

  @override
  State<LocalEntregaView> createState() => _LocalEntregaViewState();
}

class _LocalEntregaViewState extends State<LocalEntregaView> {
  int? _selectedLocalId;
  late Future<List<LocalEntrega>> _futureLocais;

  // cache local da lista carregada
  List<LocalEntrega> _locais = [];

  @override
  void initState() {
    super.initState();
    _futureLocais = LocalEntregaService.listarLocais();
  }

  void _confirmar() {
    if (_selectedLocalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione um local de entrega")),
      );
      return;
    }

    try {
      final local = _locais.firstWhere((l) => l.id == _selectedLocalId);

      Navigator.of(context).pop(local);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao recuperar o local selecionado.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Local de Entrega",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: FutureBuilder<List<LocalEntrega>>(
        future: _futureLocais,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar locais:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum local disponível."));
          }

          _locais = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _locais.length,
                  itemBuilder: (context, index) {
                    final local = _locais[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: RadioListTile<int>(
                        value: local.id,
                        groupValue: _selectedLocalId,
                        activeColor: TColor.primary,
                        onChanged: (value) {
                          setState(() {
                            _selectedLocalId = value;
                          });
                        },
                        title: Text(
                          local.nome,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: local.descricao != null
                            ? Text(
                                local.descricao!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: TColor.secondarytext,
                                  height: 1.3,
                                ),
                              )
                            : null,
                        secondary: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // botão confirmar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _confirmar,
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
                    child: const Text("Prosseguir"),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
