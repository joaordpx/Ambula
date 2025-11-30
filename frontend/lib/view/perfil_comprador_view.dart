import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/view/editar_conta_view.dart';
import 'package:frontend/view/login_view.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes do Perfil',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: TColor.primarytext,
                ),
              ),
              const SizedBox(height: 20),

              // conteúdo rolagem
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _futureUser,
                  builder: (context, snapshot) {
                    String nome = 'Carregando...';
                    String email = '-';
                    String telefone = '-';

                    if (snapshot.hasError) {
                      nome = 'Não foi possível carregar';
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      nome = (user['name'] ?? 'Nome não informado').toString();
                      email = (user['email'] ?? 'E-mail não informado')
                          .toString();
                      telefone = (user['telefone'] ?? '-').toString();
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // card conta
                          _SectionCard(
                            title: 'Conta',
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: snapshot.hasData
                                      ? () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => EditarContaView(
                                                nomeInicial: nome,
                                                email: email,
                                                telefoneInicial: telefone,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                nome,
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right_rounded,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // card sessao
                          _SectionCard(
                            title: 'Sessão',
                            child: InkWell(
                              onTap: () async {
                                await AuthService.logout();

                                if (!mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginView(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.logout_rounded,
                                      size: 22,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Sair da conta',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        ),
      ),
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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
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
