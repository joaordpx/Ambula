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
import 'package:frontend/view/carrinho_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCompradorView extends StatefulWidget {
  const HomeCompradorView({super.key});

  @override
  State<HomeCompradorView> createState() => _HomeCompradorViewState();
}

class _HomeCompradorViewState extends State<HomeCompradorView> {
  late Future<HomeData> _futureHome;

  @override
  void initState() {
    super.initState();
    _futureHome = _carregarHome();
  }

  Future<HomeData> _carregarHome() async {
    final user = await AuthService.getMe();
    final List<CategoriaProduto> categorias =
        await CategoriaProdutoService.fetchCategorias();
    final maisAmados = await MaisAmadosService.fetchMaisAmados();
    final lojasPopulares = await LojasPopularesService.fetchLojasPopulares();
    final disponiveisAgora =
        await DisponiveisAgoraService.fetchDisponiveisAgora();

    return HomeData(
      user: user,
      categorias: categorias,
      maisAmados: maisAmados,
      lojasPopulares: lojasPopulares,
      disponiveisAgora: disponiveisAgora,
    );
  }

  void _abrirLoja(int lojaId) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => StoreDetailView(lojaId: lojaId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: FutureBuilder<HomeData>(
          future: _futureHome,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Não foi possível carregar a página.\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(),
                  ),
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
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Column(
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
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartView()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // body
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
                  onVerMais: null,
                  onCategoriaTap: (categoria) {
                    // 👉 Troca para a aba de busca mantendo a bottom nav
                    MainTabView.of(
                      context,
                    )?.openSearchWithTerm(categoria.descricao);
                  },
                ),

                const SizedBox(height: 20),

                // mais amados do campus
                MaisAmadosSection(
                  produtos: maisAmados,
                  onVerMais: null,
                  onProdutoTap: (produto) {
                    final lojaId = produto['lojaId'] as int?;
                    if (lojaId != null) {
                      _abrirLoja(lojaId);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // lojas mais populares
                LojasPopularesSection(
                  lojas: lojasPopulares,
                  onVerMais: null,
                  onLojaTap: _abrirLoja,
                ),

                const SizedBox(height: 20),

                // disponíveis agora (lojas abertas)
                DisponiveisAgoraSection(
                  lojas: disponiveisAgora,
                  onVerMais: null,
                  onLojaTap: _abrirLoja,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
