import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/images_app.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/widget/rating_bar_widget.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/storage_methods.dart';

/// [DetailRecipesPage] é uma página que exibe os detalhes de uma receita específica.
///
/// Esta página inclui a imagem da receita, o nome, a categoria, os ingredientes, o modo de preparo e a avaliação da receita.
///
/// A classe utiliza o [StorageMethods] para carregar a imagem da receita e o [Recipes] para representar as informações da receita.
class DetailRecipesPage extends StatelessWidget {
  const DetailRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia o objeto StorageMethods para carregar imagens.
    final StorageMethods storageMethods = StorageMethods();
    // Obtém a receita passada como argumento na navegação.
    final Recipes? recipe =
        ModalRoute.of(context)?.settings.arguments as Recipes?;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        surfaceTintColor: AppTheme.secondaryColor,
        title: Title(
          color: Colors.black,
          child: const Text(
            "Receita",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: recipe == null
            ? _buildErrorContent(
                context) // Renderiza uma mensagem de erro se a receita não for encontrada
            : _buildRecipeDetails(context, recipe,
                storageMethods), // Renderiza os detalhes da receita
      ),
    );
  }

  /// Renderiza o conteúdo de erro quando não há receita.
  ///
  /// Exibe uma mensagem de erro, uma ilustração e um botão para tentar novamente.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  Widget _buildErrorContent(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Não foi possível criar sua receita! Desculpe.',
            style: TextStyle(fontSize: 18, color: AppTheme.atencionRed),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
            ),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(fontSize: 18, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Renderiza os detalhes da receita, incluindo a imagem, nome, categoria,
  /// ingredientes, modo de preparo e avaliação.
  ///
  /// [context] - O contexto BuildContext utilizado para exibir a UI.
  /// [recipe] - O objeto Recipes que contém as informações da receita.
  /// [storageMethods] - O objeto StorageMethods utilizado para carregar a imagem.
  Widget _buildRecipeDetails(
      BuildContext context, Recipes recipe, StorageMethods storageMethods) {
    return Column(
      children: [
        if (recipe.image != '')
          _buildRecipeImage(context, recipe, storageMethods),
        Padding(
          padding: const EdgeInsets.all(20.0),
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
                recipe.category.join(", "),
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
  /// [storageMethods] - O objeto StorageMethods utilizado para carregar a imagem.
  Widget _buildRecipeImage(
      BuildContext context, Recipes recipe, StorageMethods storageMethods) {
    return Padding(
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
            future: storageMethods.loadImageInURL(recipe.image, true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingImage(context);
              } else if (snapshot.hasError) {
                return _buildErrorImage(context);
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
      child: const Center(child: CircularProgressIndicator()),
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
          .map(
            (step) => Column(
              children: [
                Text(
                  step,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  softWrap: true,
                ),
                const SizedBox(height: 8),
              ],
            ),
          )
          .toList(),
    );
  }
}
