import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/widget/card_recipe_widget.dart';
import 'package:flutter/material.dart';

/// [GridViewRecipesWidget] é um widget que exibe uma lista de receitas em um layout de grade.
/// Este widget utiliza o [GridView.builder] para organizar os itens em colunas e linhas.
///
/// - Parâmetros:
///   - [listRecipes] ([List<Recipes>]): A lista de receitas que será exibida no grid. Cada item deve ser um objeto da classe [Recipes].
///
/// - Funcionamento:
///   - Cada receita da lista é exibida usando o widget [CardRecipeWidget].
///   - O layout é configurado para mostrar duas colunas, com espaçamento personalizado entre os itens.
///   - O scroll é vertical, permitindo que o usuário visualize todas as receitas conforme rola a tela.
///
/// Referências:
/// - [Recipes]: Modelo de dados que define a estrutura de uma receita.
/// - [CardRecipeWidget]: Widget que exibe os detalhes individuais de uma receita em um cartão.

class GridViewRecipesWidget extends StatelessWidget {
  /// A lista de receitas que será exibida no grid.
  final List<Recipes> listRecipes;

  /// Construtor do widget que exige uma lista de receitas.
  const GridViewRecipesWidget({super.key, required this.listRecipes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Define que o grid deve se ajustar ao conteúdo, permitindo ser incorporado em outros widgets.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Define o número de itens no grid com base no tamanho da lista de receitas.
      itemCount: listRecipes.length,
      // Configura o scroll do grid para ser vertical.
      scrollDirection: Axis.vertical,
      // Define a estrutura do grid com duas colunas e espaçamento personalizado.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Define o número de colunas.
        crossAxisSpacing: 8, // Define o espaçamento horizontal entre os itens.
        mainAxisSpacing: 16, // Define o espaçamento vertical entre os itens.
        childAspectRatio: 0.6, // Define a proporção largura/altura dos itens.
      ),
      // Constrói cada item do grid com base na lista de receitas.
      itemBuilder: (context, index) {
        // Obtém a receita atual da lista.
        var recipe = listRecipes[index];
        // Retorna o widget [CardRecipeWidget] para exibir a receita.
        return CardRecipeWidget(recipe: recipe);
      },
    );
  }
}
