import '../../data/model/recipes.dart';

class RecipeArguments {
  final Recipes recipe;
  final bool isRecipeGenerated;

  RecipeArguments({
    required this.recipe,
    required this.isRecipeGenerated,
  });
}
