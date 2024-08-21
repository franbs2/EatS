import 'package:eats/data/model/recipes.dart';
import 'package:flutter/material.dart';

class DetailRecipePage extends StatelessWidget {
  const DetailRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Recipes recipe =
        ModalRoute.of(context)?.settings.arguments as Recipes;

    return Scaffold(
      body: Column(
        children: [Text('Detalhes da receita ${recipe.name}')],
      ),
    );
  }
}
