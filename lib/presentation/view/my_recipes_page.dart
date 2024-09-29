import 'package:eats/core/style/color.dart';
import 'package:eats/presentation/widget/recipe_card_list_widget.dart';
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
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      List<Recipes>? recipes = await userProvider.getMyRecipes();
      setState(() {
        listRecipes = recipes;
      });
    } catch (e) {
      // Exibir ou logar erro se necessário
      print('Erro ao carregar receitas: $e');
    }
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
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: _loadUserRecipes,
              child: listRecipes == null
                  ? const Center(child: CircularProgressIndicator())
                  : listRecipes!.isEmpty
                      ? const Center(child: Text('Nenhuma receita encontrada.'))
                      : ListView.builder(
                          itemCount: listRecipes!.length,
                          itemBuilder: (context, index) {
                            Recipes recipe = listRecipes![index];
                            return FutureBuilder<String>(
                              future: storageService.loadImageInURL(
                                  recipe.image, true),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: LinearProgressIndicator(
                                      color: AppTheme.homeColorOne,
                                      backgroundColor: AppTheme.secondaryColor,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Erro ao carregar imagem'));
                                } else {
                                  return RecipeCardListWidget(
                                    recipe: recipe,
                                    imageUrl: snapshot.data ?? '',
                                    updatePage: _loadUserRecipes,
                                  );
                                }
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
