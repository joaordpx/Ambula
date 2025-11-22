import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/categoria_produto_service.dart';
import 'package:frontend/services/mais_amados_service.dart';
import 'package:frontend/services/lojas_populares_service.dart';
import 'package:frontend/services/disponiveis_agora_service.dart';
import 'package:frontend/models/categoria_produto.dart';
import 'package:frontend/models/home_data.dart';
import 'package:frontend/home_comprador/sections/categorias_section.dart';
import 'package:frontend/home_comprador/sections/mais_amados_section.dart';
import 'package:frontend/home_comprador/sections/lojas_populares_section.dart';
import 'package:frontend/home_comprador/sections/disponiveis_agora_section.dart';
import 'package:frontend/view/store_detail_view.dart';
import 'package:frontend/view/main_tab_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCompradorView extends StatefulWidget {
  const HomeCompradorView({super.key});

  @override
  State<HomeCompradorView> createState() => _HomeCompradorViewState();
}

class _HomeCompradorViewState extends State<HomeCompradorView> {
  late Future<HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadAll();
  }

  Future<HomeData> _loadAll() async {
    final responses = await Future.wait([
      AuthService.getMe(),
      CategoriaProdutoService.fetchCategorias(),
      MaisAmadosService.fetchMaisAmados(),
      LojasPopularesService.fetchLojasPopulares(),
      DisponiveisAgoraService.fetchDisponiveisAgora(),
    ]);

    final user = responses[0] as Map<String, dynamic>;
    final categorias = responses[1] as List<CategoriaProduto>;
    final maisAmados = responses[2] as List<Map<String, dynamic>>;
    final lojasPopulares = responses[3] as List<Map<String, dynamic>>;
    final disponiveisAgora = responses[4] as List<Map<String, dynamic>>;

    return HomeData(
      user: user,
      categorias: categorias,
      maisAmados: maisAmados,
      lojasPopulares: lojasPopulares,
      disponiveisAgora: disponiveisAgora,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: FutureBuilder<HomeData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Não foi possível carregar a página.\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Nenhum dado para exibir.'));
            }

            final data = snapshot.data!;
            final user = data.user;
            final categorias = data.categorias;
            final maisAmados = data.maisAmados;
            final lojasPopulares = data.lojasPopulares;
            final disponiveisAgora = data.disponiveisAgora;

            final nomeCompleto = (user['name'] ?? '').toString();
            final primeiroNome = nomeCompleto.split(' ').first;

            return _buildBody(
              context,
              primeiroNome,
              categorias,
              maisAmados,
              lojasPopulares,
              disponiveisAgora,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    String firstName,
    List<CategoriaProduto> categorias,
    List<Map<String, dynamic>> maisAmados,
    List<Map<String, dynamic>> lojasPopulares,
    List<Map<String, dynamic>> disponiveisAgora,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // topo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Olá, $firstName",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: TColor.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 28,
                      color: TColor.primary,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // localização - alterar quando backend pronto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Localização Atual",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: TColor.secondarytext,
                        ),
                      ),
                      Text(
                        "Prédio 3 - CCET",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: TColor.primarytext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // body scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                // categorias
                CategoriasSection(
                  categorias: categorias,
                  onVerMais: () {
                    // navegação pra tela de "todas as categorias" (futuro)
                  },
                  onCategoriaTap: (categoria) {
                    MainTabView.of(
                      context,
                    )?.openSearchWithTerm(categoria.descricao);
                  },
                ),

                const SizedBox(height: 20),

                // mais amados do campus
                MaisAmadosSection(
                  produtos: maisAmados,
                  onVerMais: () {
                    // navegar pra listagem completa dos produtos em destaque
                  },
                ),

                const SizedBox(height: 20),

                // lojas mais populares
                LojasPopularesSection(
                  lojas: lojasPopulares,
                  onVerMais: () {
                    // navegar pra listagem de lojas
                  },
                  onLojaTap: (lojaId) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StoreDetailView(lojaId: lojaId),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // disp agora
                DisponiveisAgoraSection(
                  produtos: disponiveisAgora,
                  onVerMais: () {
                    // navegar pra listagem de lojas disponíveis
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
