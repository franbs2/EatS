import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/providers/recipes_provider.dart';
import 'package:eats/presentation/widget/filter_categories_recipes_widget.dart';
import 'package:eats/presentation/widget/grid_view_recipes_widget.dart';
import 'package:eats/presentation/widget/img_perfil_widget.dart';
import 'package:eats/presentation/widget/search_bar_widget.dart';
import 'package:eats/core/style/color.dart';
import '../widget/carousel_widget.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(context, height),
              SizedBox(height: height * 0.12),
              const FilterCategoriesRecipesWidget(categories: categories),
              if (recipesProvider.recipes.isEmpty)
                const Center(
                  child:
                      CircularProgressIndicator(color: AppTheme.primaryColor),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridViewRecipesWidget(
                      listRecipes: recipesProvider.recipes),
                ),
              ),
            ],
          ),
          Positioned(
            top: height * 0.35 - 80,
            left: 0,
            right: 0,
            child: const CarouselWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height * 0.35,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppTheme.homeColorOne,
            AppTheme.homeColorTwo,
          ],
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Column(
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
                Spacer(),
                ImgPerfilWidget(),
              ],
            ),
            SizedBox(height: 24),
            SearchBarWidget(),
          ],
        ),
      ),
    );
  }
}
