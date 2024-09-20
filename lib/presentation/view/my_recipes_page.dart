import 'package:eats/presentation/widget/recipe_card_list_widget.dart';
import 'package:eats/presentation/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../data/model/recipes.dart';

class MyRecipesPage extends StatelessWidget {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Recipes>? listRecipes =
        ModalRoute.of(context)?.settings.arguments as List<Recipes>?;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.21,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                colors: [Color(0xffEFC136), Color(0xff539F33)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Minhas Receitas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SearchBarWidget(controller: TextEditingController()),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listRecipes?.length ?? 0,
              itemBuilder: (context, index) {
                Recipes recipe = listRecipes![index];
                return RecipeCardListWidget(
                    title: recipe.name,
                    subtitle: recipe.description,
                    imageUrl: recipe.image,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
