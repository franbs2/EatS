import 'package:eats/presentation/providers/banners_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../../core/style/color.dart';
import '../../core/style/images_app.dart';
import '../../core/style/strings_app.dart';
import '../providers/recipes_provider.dart';
import '../widget/carousel_widget.dart';
import '../widget/filter_categories_recipes_widget.dart';
import '../widget/grid_view_recipes_widget.dart';
import '../widget/img_perfil_widget.dart';
import '../widget/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipesProvider>(context, listen: false).fetchRecipes();
      Provider.of<BannersProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    final bannersProvider = Provider.of<BannersProvider>(context);
    

    const categories = StringsApp.listFilterCategories;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffEFC136), Color(0xff539F33)],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: AppTheme.backgroundColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 24, right: 24, top: height * 0.2),
                    child: GridViewRecipesWidget(
                      listRecipes: recipesProvider.recipes,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: height * 0.1 - 30,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringsApp.local,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.homeColorText,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Santarém, Pará', // TODO: pegar localização do usuário
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesApp.perfilPage);
                          },
                          child: const ImgPerfilWidget(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: SearchBarWidget(),
                  ),
                  const SizedBox(height: 24),
                  CarouselWidget(
                    banners: bannersProvider.banners,
                  ),
                  const SizedBox(height: 24),
                  const FilterCategoriesRecipesWidget(categories: categories),
                  if (recipesProvider.recipes.isEmpty)
                    const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryColor),
                    ),
                  if (recipesProvider.errorMessage != null)
                    Center(
                      child: Text(
                        recipesProvider.errorMessage!,
                        style: const TextStyle(
                          color: AppTheme.secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
