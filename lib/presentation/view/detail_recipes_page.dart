import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/images_app.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/widget/rating_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/storage_methods.dart';

class DetailRecipesPage extends StatelessWidget {
  const DetailRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageMethods storageMethods = StorageMethods();
    final Recipes? recipe =
        ModalRoute.of(context)?.settings.arguments as Recipes?;

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
          child: recipe == null
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Não foi criar sua receita! Desculpe.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        ImageApp.hungryIllustration,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                        child: const Text('Tentar novamente',
                            style: TextStyle(
                                fontSize: 18, color: AppTheme.primaryColor)),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (recipe.image != '')
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
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              recipe.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(recipe.category.join(", "),
                              style: const TextStyle(
                                  fontSize: 16, color: AppTheme.primaryColor)),
                          if (recipe.rating != 0)
                            Row(
                              children: [
                                StarRating(rating: recipe.rating),
                                Text(
                                  ' ${recipe.rating}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingredientes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.ingredients
                                .map((ingredient) => Column(
                                      children: [
                                        Text(
                                          ingredient,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          softWrap: true,
                                        ),
                                        const SizedBox(height: 8),
                                      ],
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
                                .map(
                                  (step) => Column(
                                    children: [
                                      Text(
                                        step,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        softWrap: true,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
