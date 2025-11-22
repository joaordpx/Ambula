import 'package:flutter/material.dart';
import 'package:frontend/common/color_extension.dart';
import 'package:frontend/models/search_models.dart';
import 'package:frontend/services/search_discovery_service.dart';
import 'package:frontend/services/search_service.dart';
import 'package:frontend/view/store_detail_view.dart';

class SearchView extends StatefulWidget {
  final String? termoInicial;

  const SearchView({super.key, this.termoInicial});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  bool _estaBuscando = false;
  String _ultimoTermo = '';

  late Future<DadosDescoberta> _futureDescoberta;
  Future<ResultadoBusca>? _futureResultado;

  @override
  void initState() {
    super.initState();

    _futureDescoberta = SearchDiscoveryService.loadDiscoveryData();

    // tratar termos iniciais (clicou na categoria em home -> vai p busca)
    if (widget.termoInicial != null && widget.termoInicial!.trim().isNotEmpty) {
      final termo = widget.termoInicial!.trim();
      _searchController.text = termo;
      _aoSubmeterBusca(termo);
    }
  }

  // atualizar busca quando vem outro termo da home
  @override
  void didUpdateWidget(covariant SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.termoInicial != oldWidget.termoInicial) {
      final novo = widget.termoInicial?.trim() ?? '';

      if (novo.isEmpty) {
        // limpar busca
        _searchController.clear();
        setState(() {
          _estaBuscando = false;
          _ultimoTermo = '';
          _futureResultado = null;
        });
      } else {
        _searchController.text = novo;
        _aoSubmeterBusca(novo);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // search
  void _aoSubmeterBusca(String valor) {
    final termo = valor.trim();

    if (termo.isEmpty) {
      setState(() {
        _estaBuscando = false;
        _ultimoTermo = '';
        _futureResultado = null;
      });
      return;
    }

    setState(() {
      _estaBuscando = true;
      _ultimoTermo = termo;
      _futureResultado = SearchService.search(termo);
    });
  }

  void _aoTocarCategoria(CategoriaProduto categoria) {
    _searchController.text = categoria.descricao;
    _aoSubmeterBusca(categoria.descricao);
  }

  void _limparBusca() {
    _searchController.clear();
    setState(() {
      _estaBuscando = false;
      _ultimoTermo = '';
      _futureResultado = null;
    });
  }

  // build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _construirBarraBusca(),
            const SizedBox(height: 8),
            Expanded(
              child: _estaBuscando
                  ? _construirResultados()
                  : _construirDescoberta(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirBarraBusca() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onSubmitted: _aoSubmeterBusca,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Buscar por produtos ou lojas',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _limparBusca,
              ),
          ],
        ),
      ),
    );
  }

  // modo explorar da pagina de busca
  Widget _construirDescoberta() {
    return FutureBuilder<DadosDescoberta>(
      future: _futureDescoberta,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Não foi possível carregar os dados.',
              style: TextStyle(color: TColor.primarytext),
            ),
          );
        }

        final dados = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categorias',
                style: TextStyle(
                  color: TColor.primarytext,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Grade de categorias
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dados.categorias.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final categoria = dados.categorias[index];
                  return _construirCardCategoria(categoria);
                },
              ),

              const SizedBox(height: 24),

              Text(
                'Lojas mais bem avaliadas',
                style: TextStyle(
                  color: TColor.primarytext,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: dados.lojasMaisBemAvaliadas
                    .map((loja) => _construirCardLoja(loja))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirCardCategoria(CategoriaProduto categoria) {
    IconData icone;
    switch (categoria.descricao.toLowerCase()) {
      case 'lanches':
        icone = Icons.fastfood;
        break;
      case 'doces':
        icone = Icons.cake;
        break;
      case 'bebidas':
        icone = Icons.local_drink;
        break;
      case 'salgados':
        icone = Icons.local_pizza;
        break;
      case 'saudáveis':
        icone = Icons.restaurant;
        break;
      default:
        icone = Icons.more_horiz;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _aoTocarCategoria(categoria),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icone),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                categoria.descricao,
                style: TextStyle(
                  color: TColor.primarytext,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirCardLoja(Loja loja) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => StoreDetailView(lojaId: loja.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 82,
                height: 82,
                color: Colors.grey.shade300,
                child: loja.imagem != null
                    ? Image.network(loja.imagem!, fit: BoxFit.cover)
                    : const Icon(Icons.store),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loja.nome,
                          style: TextStyle(
                            color: TColor.primarytext,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            loja.avaliacao.toStringAsFixed(1),
                            style: TextStyle(
                              color: TColor.primarytext,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    loja.status,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loja.descricao,
                    style: TextStyle(color: TColor.secondarytext, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // resultados da busca
  Widget _construirResultados() {
    if (_futureResultado == null) {
      return Center(
        child: Text(
          'Digite algo para buscar.',
          style: TextStyle(color: TColor.primarytext),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          if (_ultimoTermo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resultados para "$_ultimoTermo"',
                  style: TextStyle(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          TabBar(
            labelColor: TColor.primary,
            unselectedLabelColor: TColor.secondarytext,
            indicatorColor: TColor.primary,
            tabs: const [
              Tab(text: 'Produtos'),
              Tab(text: 'Lojas'),
            ],
          ),

          Expanded(
            child: FutureBuilder<ResultadoBusca>(
              future: _futureResultado,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao buscar. Tente novamente.',
                      style: TextStyle(color: TColor.primarytext),
                    ),
                  );
                }

                final resultado = snapshot.data!;
                final temProdutos = resultado.produtos.isNotEmpty;
                final temLojas = resultado.lojas.isNotEmpty;

                if (!temProdutos && !temLojas) {
                  return Center(
                    child: Text(
                      'Nenhum resultado encontrado.',
                      style: TextStyle(color: TColor.primarytext),
                    ),
                  );
                }

                return TabBarView(
                  children: [
                    temProdutos
                        ? ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: resultado.produtos.length,
                            itemBuilder: (context, index) {
                              final p = resultado.produtos[index];
                              return _construirCardProduto(p);
                            },
                          )
                        : Center(
                            child: Text(
                              'Nenhum produto encontrado.',
                              style: TextStyle(color: TColor.primarytext),
                            ),
                          ),

                    temLojas
                        ? ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: resultado.lojas.length,
                            itemBuilder: (context, index) {
                              final l = resultado.lojas[index];
                              return _construirCardLoja(l);
                            },
                          )
                        : Center(
                            child: Text(
                              'Nenhuma loja encontrada.',
                              style: TextStyle(color: TColor.primarytext),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCardProduto(Produto produto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TColor.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: TextStyle(
                    color: TColor.primarytext,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  produto.lojaNome,
                  style: TextStyle(color: TColor.secondarytext, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'R\$ ${produto.valor.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      produto.lojaAvaliacao.toStringAsFixed(1),
                      style: TextStyle(color: TColor.primarytext, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
