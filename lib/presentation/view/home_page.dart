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
    // Busca receitas e banners após o layout ser construído.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipesProvider>(context, listen: false).fetchRecipes();
      Provider.of<BannersProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtém a lista de categorias de filtro a partir de strings constantes.
    const categories = StringsApp.listFilterCategories;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xff539F33),
                Color(0xff82A030),
                Color(0xffEFC136),
                Color(0xffEFC136),
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringsApp.local,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffB7B7B7),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Santarém, Pará',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ImgPerfilWidget(),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.transparent,
                collapsedHeight: MediaQuery.of(context).size.height * 0.1,
                pinned: true,
                flexibleSpace: const Center(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: SearchBarWidget(),
                )),
              ),

              // Renderiza o banner e o slider de banners.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xffF9F9F9)],
                        stops: [0.5, 0.5],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffF9F9F9),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Consumer<BannersProvider>(
                      builder: (context, bannersProvider, child) {
                        return CarouselWidget(banners: bannersProvider.banners);
                      },
                    ),
                  ),
                ),
              ),
              // Renderiza as categorias de filtro.
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffF9F9F9),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const FilterCategoriesRecipesWidget(
                            categories: categories),
                        Consumer<RecipesProvider>(
                          builder: (context, recipesProvider, child) {
                            if (recipesProvider.recipes.isEmpty &&
                                recipesProvider.errorMessage == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                ),
                              );
                            }

                            if (recipesProvider.errorMessage != null) {
                              return Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 24),
                                    Text(
                                      recipesProvider.errorMessage!
                                          .toLowerCase(),
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Image.asset(
                                      ImageApp.hungryIllustration,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              child: GridViewRecipesWidget(
                                listRecipes: recipesProvider.recipes,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
