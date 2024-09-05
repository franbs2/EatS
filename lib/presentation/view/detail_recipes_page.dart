import 'package:eats/core/style/color.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/widget/rating_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/storage_methods.dart';

class DetailRecipesPage extends StatelessWidget {
  const DetailRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageMethods storageMethods = StorageMethods();
    final Recipes recipe =
        ModalRoute.of(context)?.settings.arguments as Recipes;

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FutureBuilder<String>(
                      future: storageMethods.loadImageInURL(
                          recipe.image, true), // Use a função loadImage
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: Text('Erro ao carregar imagem')),
                          );
                        } else {
                          return Image.network(
                            snapshot.data ?? '',
                            fit: BoxFit.fill,
                            width: double.infinity,
                          );
                        }
                      },
                    ),
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
                        Row(
                          children: [
                            StarRating(rating: recipe.rating),
                            Text(
                              ' ${recipe.rating}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ingredientes',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.ingredients
                              .map((ingredient) => Text(
                                    ingredient,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    softWrap: true,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Modo de Preparo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recipe.steps
                              .map((step) => SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.1 /
                                        2,
                                    child: Text(
                                      step,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      softWrap: true,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
