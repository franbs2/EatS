import 'dart:convert';

import 'package:eats/core/style/color.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/widget/rating_bar_widget.dart';
import 'package:flutter/material.dart';

class DetailRecipesPage extends StatelessWidget {
  DetailRecipesPage({super.key});

  Recipes recipe = Recipes(
      name: "Bolinho de Arroz",
      category: ["Bolos", "Salgados"],
      ingredients: ["Cenoura", "farinha", "açúcar", "ovos", "fermento"],
      image: "assets/food_img.jpg",
      description: "Bolinho Salgado",
      steps: [
        "Bata no liquidificador a cenoura, os ovos e o óleo, até obter uma mistura homogênea.",
        "Em uma tigela, misture a farinha, o açúcar e o fermento.",
        "Adicione a mistura do liquidificador à tigela e misture bem.",
        "Despeje a massa em uma forma untada e leve ao forno por 40 minutos.",
        "Para a cobertura, derreta o chocolate em banho-maria e misture o creme de leite.",
        "Despeje a cobertura sobre o bolo e sirva."
      ],
      rating: 4.5,
      value: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
              color: Colors.black,
              child: const Text(
                "Receita",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Cor da sombra
                      offset: const Offset(0, 4), // Deslocamento da sombra
                      blurRadius: 16, // Raio de desfoque da sombra
                      spreadRadius: 0, // Espalhamento da sombra
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(recipe.image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(recipe.category.join(", "),
                          style: const TextStyle(
                              fontSize: 16, color: AppTheme.primaryColor)),
                      StarRating(rating: recipe.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
