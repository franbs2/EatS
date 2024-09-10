import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../../core/style/images_app.dart';
import '../../core/style/strings_app.dart';
import '../providers/banners_provider.dart';
import '../providers/recipes_provider.dart';
import '../widget/carousel_widget.dart';
import '../widget/filter_categories_recipes_widget.dart';
import '../widget/grid_view_recipes_widget.dart';
import '../widget/img_perfil_widget.dart';
import '../widget/search_bar_widget.dart';

/// [HomePage] do aplicativo que exibe banners, uma barra de pesquisa, filtros de categorias e uma grade de receitas.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Após o layout ser construído, busca receitas e banners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipesProvider>(context, listen: false).fetchRecipes();
      Provider.of<BannersProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém a lista de categorias de filtro a partir de strings constantes.
    const categories = StringsApp.listFilterCategories;
    // Obtém a altura da tela para definir o layout.
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height, // Define a altura do container como a altura da tela.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xff539F33), // Cor inicial do gradiente.
              Color(0xff82A030), // Cor intermediária do gradiente.
              Color(0xffEFC136), // Cor final do gradiente.
              Color(
                  0xffEFC136), // Cor final do gradiente repetida para suavizar a transição.
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30), // Espaçamento superior.
            const Padding(
              padding: EdgeInsets.all(
                  30.0), // Adiciona padding em torno do conteúdo.
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringsApp.local, // Texto para localização.
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffB7B7B7), // Cor do texto.
                              fontWeight: FontWeight.normal, // Peso da fonte.
                            ),
                          ),
                          SizedBox(height: 4), // Espaçamento vertical.
                          Text(
                            'Santarém, Pará', // Localização do usuário (TODO: substituir pela localização real do usuário).
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.secondaryColor, // Cor do texto.
                              fontWeight: FontWeight.w600, // Peso da fonte.
                            ),
                          ),
                        ],
                      ),
                      Spacer(), // Espaça o conteúdo à direita.
                      ImgPerfilWidget(), // Widget para exibir a imagem de perfil.
                    ],
                  ),
                  SizedBox(height: 24), // Espaçamento vertical.
                  SearchBarWidget(), // Widget da barra de pesquisa.
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xffF9F9F9)
                  ], // Gradiente para o fundo do container.
                  stops: [0.5, 0.5], // Posições das cores no gradiente.
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffF9F9F9),
                    width: 2.0, // Largura da borda inferior.
                  ),
                ),
              ),
              child: Consumer<BannersProvider>(
                builder: (context, bannersProvider, child) {
                  return CarouselWidget(
                    banners: bannersProvider
                        .banners, // Passa os banners obtidos pelo provedor para o widget de carrossel.
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(
                        0xffF9F9F9)), // Define a cor de fundo do container.
                child: Consumer<RecipesProvider>(
                  builder: (context, recipesProvider, child) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 16, // Espaçamento superior.
                        ),
                        const FilterCategoriesRecipesWidget(
                            categories:
                                categories), // Widget para filtros de categorias.
                        if (recipesProvider.recipes.isEmpty &&
                            recipesProvider.errorMessage == null)
                          const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme
                                    .primaryColor), // Indicador de carregamento quando as receitas estão sendo carregadas.
                          ),
                        if (recipesProvider.errorMessage != null)
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                    height: 24), // Espaçamento vertical.
                                Text(
                                  recipesProvider.errorMessage!
                                      .toLowerCase(), // Exibe a mensagem de erro em caso de falha na busca de receitas.
                                  style: const TextStyle(
                                    color: AppTheme
                                        .primaryColor, // Cor do texto de erro.
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600, // Peso da fonte.
                                  ),
                                ),
                                const SizedBox(
                                    height: 24), // Espaçamento vertical.
                                Image.asset(
                                  ImageApp
                                      .hungryIllustration, // Imagem exibida quando há erro.
                                  height: MediaQuery.of(context).size.height *
                                      0.2, // Define a altura da imagem.
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24), // Adiciona padding horizontal.
                            child: GridViewRecipesWidget(
                                listRecipes: recipesProvider
                                    .recipes), // Widget para exibir as receitas em uma visualização em grade.
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
