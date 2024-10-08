import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/images_app.dart';
import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/widget/rating_bar_widget.dart';
import 'package:eats/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../../core/style/strings_app.dart';
import '../args/recipe_arguments.dart';
import '../widget/button_default_widget.dart';

/// [DetailRecipesPage] é uma página que exibe os detalhes de uma receita específica.
///
/// Esta página inclui a imagem da receita, o nome, a categoria, os ingredientes, o modo de preparo e a avaliação da receita.
///
/// A classe utiliza o [StorageService] para carregar a imagem da receita e o [Recipes] para representar as informações da receita.
class DetailRecipesPage extends StatelessWidget {
  const DetailRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia o objeto StorageMethods para carregar imagens.
    final StorageService storageService = StorageService();
    // Obtém a receita passada como argumento na navegação.
    final RecipeArguments? args =
        ModalRoute.of(context)?.settings.arguments as RecipeArguments?;

    if (args != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final Recipes recipe = args.recipe;
      final bool isRecipeGenerated = args.isRecipeGenerated;
      final recipesRepository =
          Provider.of<RecipesRepository>(context, listen: false);

      return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppTheme.secondaryColor,
            surfaceTintColor: AppTheme.secondaryColor,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Title(
              color: Colors.black,
              child: const Text(
                "Receita",
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton(
                  color: AppTheme.secondaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  offset: const Offset(0, 50),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          _showConfirmationDialog(context,
                              title: 'Denunciar Receita',
                              content:
                                  'Tem certeza que deseja denunciar esta receita?',
                              textButton: 'Denunciar', onConfirm: () async {
                            try {
                              await recipesRepository.reportRecipe(
                                  recipe.id, userProvider.user!.uid);

                              _showConfirmationDialog(context,
                                  desativeCancel: true,
                                  title: 'Denúncia Enviada',
                                  content:
                                      'Sua denúncia foi enviada com sucesso.',
                                  textButton: 'OK',
                                  colorButton: AppTheme.primaryColor,
                                  onConfirm: () {
                                Navigator.pop(context);
                              });

                            } catch (e) {
                              _showConfirmationDialog(context,
                                  desativeCancel: true,
                                  title: 'Denúncia duplicada',
                                  content:
                                      'Você já denunciou esta receita.',
                                  textButton: 'OK',
                                  colorButton: AppTheme.primaryColor,
                                  onConfirm: () {
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        child: const SizedBox(
                          child: Text(
                            'Denunciar',
                            style: TextStyle(
                                color: AppTheme.atencionRed,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ];
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildRecipeDetails(
                    context, recipe, storageService, isRecipeGenerated),
              ],
            ),
          ));
    } else {
      return _buildErrorContent(context);
    }
  }

  /// Renderiza o conteúdo de erro quando não há receita.
  ///
  /// Exibe uma mensagem de erro, uma ilustração e um botão para tentar novamente.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  Widget _buildErrorContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Não foi possível criar sua receita! Desculpe.',
                style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.atencionRed,
                    fontWeight: FontWeight.bold),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                        color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                child: const Text(
                  'Tentar novamente',
                  style: TextStyle(fontSize: 18, color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Renderiza os detalhes da receita, incluindo a imagem, nome, categoria,
  /// ingredientes, modo de preparo e avaliação.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  /// [recipe] - O objeto Recipes que contém as informações da receita.
  /// [StorageService] - O objeto StorageMethods utilizado para carregar a imagem.
  Widget _buildRecipeDetails(BuildContext context, Recipes recipe,
      StorageService storageService, bool isRecipeGenerated) {
    return Column(
      children: [
        if (recipe.blocked == true)

          /// adicionar tarja de bloqueio
          Container(
              width: double.infinity,
              color: AppTheme.atencionRed,
              child: const Text(
                'Receita Bloqueada',
                style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.backgroundColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
        if (recipe.image != '')
          _buildRecipeImage(context, recipe, storageService),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
              const SizedBox(height: 8),
              Text(
                recipe.category
                    .join(', ')
                    .replaceAll('Almoco', 'Almoço')
                    .replaceAll('Cafe da Manha', 'Café da Manhã'),
                style:
                    const TextStyle(fontSize: 16, color: AppTheme.primaryColor),
              ),
              if (recipe.rating != 0) _buildRating(recipe),
              const SizedBox(height: 16),
              const Text(
                'Ingredientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildIngredients(recipe),
              const SizedBox(height: 16),
              const Text(
                'Modo de Preparo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPreparationSteps(recipe),
              const SizedBox(height: 16),
              if (isRecipeGenerated)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Deletar',
                          style: TextStyle(
                            color: AppTheme.atencionRed,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Row(
                      children: [
                        ButtonDefaultlWidget(
                          text: 'Publicar',
                          color: AppTheme.loginYellow,
                          width: 0.1 / 2,
                          height: 14,
                          onPressed: () {
                            recipe.changeVisibility(true);
                            Navigator.of(context).pushNamed(
                                RoutesApp.addRecipePage,
                                arguments: RecipeArguments(
                                    recipe: recipe, isRecipeGenerated: true));
                          },
                        ),
                        const SizedBox(width: 8),
                        ButtonDefaultlWidget(
                          text: StringsApp.save,
                          color: AppTheme.loginYellow,
                          width: 0.1 / 2,
                          height: 14,
                          onPressed: () {
                            recipe.changeVisibility(false);
                            Navigator.of(context).pushNamed(
                                RoutesApp.addRecipePage,
                                arguments: RecipeArguments(
                                    recipe: recipe, isRecipeGenerated: true));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Renderiza a imagem da receita com um efeito de sombra e carregamento dinâmico.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  /// [recipe] - O objeto Recipes que contém a URL da imagem.
  /// [StorageService] - O objeto StorageService utilizado para carregar a imagem.
  Widget _buildRecipeImage(
      BuildContext context, Recipes recipe, StorageService storageService) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FutureBuilder<String>(
          future: storageService.loadImageInURL(recipe.image, true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingImage(context);
            } else if (snapshot.hasError) {
              return _buildErrorImage(context);
            } else {
              return Image.network(
                snapshot.data ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
              );
            }
          },
        ),
      ),
    );
  }

  /// Renderiza um indicador de carregamento para a imagem da receita.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  Widget _buildLoadingImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
          child: CircularProgressIndicator(
        color: AppTheme.primaryColor,
      )),
    );
  }

  /// Renderiza uma mensagem de erro caso ocorra falha ao carregar a imagem.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  Widget _buildErrorImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(child: Text('Erro ao carregar imagem')),
    );
  }

  /// Renderiza a avaliação da receita com estrelas.
  ///
  /// [recipe] - O objeto Recipes que contém a avaliação da receita.
  Widget _buildRating(Recipes recipe) {
    return Row(
      children: [
        StarRating(
            rating:
                recipe.rating), // Widget para exibir a avaliação em estrelas
        Text(
          ' ${recipe.rating}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Renderiza a lista de ingredientes da receita.
  ///
  /// [recipe] - O objeto Recipes que contém a lista de ingredientes.
  Widget _buildIngredients(Recipes recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.ingredients
          .map((ingredient) => Column(
                children: [
                  Text(
                    ingredient,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    softWrap: true,
                  ),
                  const SizedBox(height: 8),
                ],
              ))
          .toList(),
    );
  }

  /// Renderiza as etapas do modo de preparo da receita.
  ///
  /// [recipe] - O objeto Recipes que contém as etapas do preparo.
  Widget _buildPreparationSteps(Recipes recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.steps
          .asMap()
          .map((index, step) => MapEntry(
                index,
                Column(
                  children: [
                    Text(
                      '${index + 1}. $step',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ))
          .values
          .toList(),
    );
  }

  void _showConfirmationDialog(BuildContext context,
      {required String title,
      required String content,
      required String textButton,
      bool desativeCancel = false,
      String textButtonCancel = 'Cancelar',
      Color colorButton = AppTheme.atencionRed,
      Color colorButtonCancel = AppTheme.primaryColor,
      required Function() onConfirm}) {
    debugPrint('Chamando o modal de confirmação');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (!desativeCancel)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: Text(textButtonCancel,
                    style: TextStyle(color: colorButtonCancel)),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(
                textButton,
                style: TextStyle(color: colorButton),
              ),
            ),
          ],
        );
      },
    );
  }
}
