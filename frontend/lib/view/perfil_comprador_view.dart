import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/loja.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/loja_service.dart';
import 'package:frontend/view/home_vendedor_view.dart';
import 'package:frontend/view/criar_loja_view.dart';
import 'package:frontend/view/editar_conta_view.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilCompradorView extends StatefulWidget {
  const PerfilCompradorView({super.key});

  @override
  State<PerfilCompradorView> createState() => _PerfilCompradorViewState();
}

class _PerfilCompradorViewState extends State<PerfilCompradorView> {
  late Future<Map<String, dynamic>> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = AuthService.getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          'Meu perfil',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TColor.primarytext,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Não foi possível carregar seus dados.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TColor.secondarytext,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Nenhum dado para exibir.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: TColor.secondarytext,
                ),
              ),
            );
          }

          final user = snapshot.data!;
          final nome = (user['name'] ?? '').toString();
          final email = (user['email'] ?? '').toString();
          final telefone = (user['telefone'] ?? 'Não informado').toString();
          final cpf = (user['cpf'] ?? 'Não informado').toString();

          // backend futuro: user['loja']
          final dynamic lojaFromUser = user['loja'];

          // mock local, se já criou loja pelo app
          final mockLoja = LojaService.lojaAtual;

          // se mock existir, tem prioridade
          final dynamic loja = mockLoja ?? lojaFromUser;
          final bool hasLoja = (mockLoja != null) || (lojaFromUser != null);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: TColor.primary.withOpacity(0.15),
                    child: Text(
                      nome.isNotEmpty ? nome[0].toUpperCase() : '?',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: TColor.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome.isNotEmpty ? nome : 'Usuário',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: TColor.primarytext,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: TColor.secondarytext,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // DADOS DA CONTA
              _SectionCard(
                title: 'Dados da conta',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('Nome', nome),
                    const SizedBox(height: 6),
                    _infoRow('E-mail', email),
                    const SizedBox(height: 6),
                    _infoRow('Telefone', telefone),
                    const SizedBox(height: 6),
                    _infoRow('CPF', cpf),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EditarContaView(
                                nomeInicial: nome,
                                email: email,
                                telefoneInicial: telefone,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Editar dados',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: TColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // MINHA LOJA
              _SectionCard(
                title: 'Minha loja',
                child: hasLoja
                    ? _buildComLoja(context, loja)
                    : _buildSemLoja(context),
              ),

              const SizedBox(height: 24),

              // LOGOUT
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    AuthService.setToken('');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: TColor.accent),
                    foregroundColor: TColor.accent,
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Sair da conta'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 13, color: TColor.primarytext),
          ),
        ),
      ],
    );
  }

  Widget _buildSemLoja(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Você ainda não possui uma loja no Ambula.',
          style: GoogleFonts.inter(fontSize: 13, color: TColor.primarytext),
        ),
        const SizedBox(height: 4),
        Text(
          'Crie sua loja para começar a receber pedidos dos estudantes no campus.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: TColor.secondarytext,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CriarLojaView()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Criar minha loja'),
          ),
        ),
      ],
    );
  }

  Widget _buildComLoja(BuildContext context, dynamic loja) {
    String nomeLoja;
    String? descricao;

    if (loja is Loja) {
      nomeLoja = loja.nome;
      descricao = loja.descricao;
    } else {
      final map = loja as Map<String, dynamic>;
      nomeLoja = (map['nome'] ?? 'Minha loja').toString();
      descricao = map['descricao']?.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nomeLoja,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TColor.primarytext,
          ),
        ),
        if (descricao != null && descricao.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: TColor.secondarytext,
              height: 1.3,
            ),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HomeVendedorView()),
              );
            },
            icon: const Icon(Icons.storefront_outlined, size: 18),
            label: const Text('Ir para painel do vendedor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TColor.primarytext,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
