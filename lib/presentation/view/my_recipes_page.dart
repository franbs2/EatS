import 'package:eats/core/style/color.dart';
import 'package:eats/presentation/widget/recipe_card_list_widget.dart';
import 'package:eats/presentation/widget/search_bar_widget.dart';
import 'package:eats/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/recipes.dart';
import '../providers/user_provider.dart';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  List<Recipes>? listRecipes;

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }

  Future<void> _loadUserRecipes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    listRecipes = await userProvider.getMyRecipes();
    setState(() {}); // Atualiza o estado após carregar as receitas
  }

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = StorageService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                colors: [Color(0xffEFC136), Color(0xff539F33)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
                ],
              ),
            ),
          ),
          Expanded(
            child: listRecipes!.isEmpty
                ? const Center(child: Text('Nenhuma receita encontrada.'))
                : ListView.builder(
                    itemCount: listRecipes!.length,
                    itemBuilder: (context, index) {
                      Recipes recipe = listRecipes![index];
                      return FutureBuilder<String>(
                        future:
                            storageService.loadImageInURL(recipe.image, true),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: LinearProgressIndicator(
                              color: AppTheme.homeColorOne,
                              backgroundColor: AppTheme.secondaryColor,
                            ));
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Erro ao carregar imagem'));
                          } else {
                            return RecipeCardListWidget(
                              recipe: recipe,
                              imageUrl: snapshot.data ?? '',
                              updatePage: () {
                                setState(() {
                                  _loadUserRecipes();
                                });
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
