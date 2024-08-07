import 'package:eats/model/recipes.dart';
import 'package:eats/presentation/widget/card_recipe_widget.dart';
import 'package:flutter/material.dart';

class GridViewRecipesWidget extends StatelessWidget {
  final List<Recipes> listRecipes;
  const GridViewRecipesWidget({super.key, required this.listRecipes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: listRecipes.length,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          childAspectRatio: 0.6),
      itemBuilder: (context, index) {
        var recipe = listRecipes[index];
        return CardRecipeWidget(recipe: recipe);
      },
    );
  }
}
