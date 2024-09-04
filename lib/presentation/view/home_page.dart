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
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);

    const categories = StringsApp.listFilterCategories;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
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
        child: Column(children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Column(
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
                          'Santarém, Pará', //TODO: pegar localização do usuário
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
                const SizedBox(height: 24),
                const SearchBarWidget(),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0xffF9F9F9)],
                stops: [0.5, 0.5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              //remover sombra
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
              //adicionar borda branca so em baixo
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffF9F9F9),
                  width: 2.0,
                ),
              ),
            ),
            child: const CarouselWidget(),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(color: Color(0xffF9F9F9)),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                const FilterCategoriesRecipesWidget(categories: categories),
                if (recipesProvider.recipes.isEmpty &&
                    recipesProvider.errorMessage == null)
                  const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.primaryColor),
                  ),
                if (recipesProvider.errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          recipesProvider.errorMessage!.toLowerCase(),
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Image.asset(
                          ImageApp.hungryIllustration,
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridViewRecipesWidget(
                          listRecipes: recipesProvider.recipes)),
                ),
              ],
            ),
          ))
        ]),
      ),
    );
  }
}
