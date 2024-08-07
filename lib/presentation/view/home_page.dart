import 'package:eats/model/Recipes.dart';
import 'package:eats/presentation/style/strings_app.dart';
import 'package:eats/presentation/widget/filter_categories_recipes_widget.dart';
import 'package:eats/presentation/widget/grid_view_recipes_widget.dart';
import 'package:eats/presentation/widget/img_perfil_widget.dart';
import 'package:eats/presentation/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import '../style/color.dart';
import '../widget/carousel_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipes> listRecipes = Recipes.recipes; //TODO: pegar receitas do banco de dados (firebase)
  List<String> categories = StringsApp.listFilterCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xff93B884),
                        Color(0xff529536),
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
                            Spacer(),
                            ImgPerfilWidget(),
                          ],
                        ),
                        SizedBox(height: 24),
                        SearchBarWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                FilterCategoriesRecipesWidget(categories: categories),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridViewRecipesWidget(listRecipes: listRecipes)),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: const CarouselWidget(),
          ),
        ],
      ),
    );
  }
}