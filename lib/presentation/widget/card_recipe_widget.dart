import 'package:eats/core/routes/routes.dart';
import 'package:eats/core/style/color.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/args/recipe_arguments.dart';
import 'package:eats/services/storage_service.dart';
import 'package:flutter/material.dart';

/// [CardRecipeWidget] é um widget que exibe uma receita em um cartão.
/// Este widget mostra a imagem da receita, o nome, a descrição e o valor.
///
/// - Parâmetros:
///   - [recipe] ([Recipes]): A receita que será exibida pelo widget. Deve ser um objeto da classe [Recipes].
///
/// - Funcionamento:
///   - Quando o cartão é clicado, o widget navega para a página de detalhes da receita, passando a receita como argumento.
///   - A imagem da receita é carregada a partir de uma URL, e o estado de carregamento é gerenciado com [FutureBuilder].
///   - O widget exibe o nome, a descrição e o valor da receita com estilos específicos.
///
/// Referências:
/// - [Recipes]: Modelo de dados que define a estrutura de uma receita.
/// - [StorageService]: Classe que contém métodos para manipulação de armazenamento e carregamento de imagens.
/// - [RoutesApp]: Classe que define as rotas usadas no aplicativo.

class CardRecipeWidget extends StatelessWidget {
  /// A receita que será exibida no cartão.
  final Recipes recipe;

  /// Construtor do widget que exige uma receita.
  const CardRecipeWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Instancia o método de armazenamento para carregar a imagem da receita.
    final StorageService storageService = StorageService();

    return InkWell(
      // Define o comportamento ao clicar no cartão.
      onTap: () {
        Navigator.of(context).pushNamed(
          RoutesApp.detailRecipePage,
          arguments: RecipeArguments(recipe: recipe, isRecipeGenerated: false),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 0, // Define a elevação do cartão.
        color: AppTheme.secondaryColor, // Define a cor do cartão.
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Define o formato do cartão.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
              child: ClipRRect(
                // Recorta a imagem com bordas arredondadas.
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<String>(
                  // Constrói o widget com base no estado do futuro.
                  future: storageService.loadImageInURL(
                    recipe.image, // URL da imagem da receita.
                    true, // Indica que a imagem deve ser carregada.
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Exibe um indicador de carregamento enquanto a imagem está sendo carregada.
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        color: AppTheme.secondaryColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      // Exibe uma mensagem de erro se ocorrer um problema ao carregar a imagem.
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        color: AppTheme.secondaryColor,
                        child: const Center(
                            child: Text('Erro ao carregar imagem')),
                      );
                    } else {
                      // Exibe a imagem da receita quando estiver carregada.
                      return Image.network(
                        snapshot.data ?? '', // URL da imagem.
                        fit: BoxFit
                            .fill, // Ajusta a imagem para preencher o espaço disponível.
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              // Adiciona espaçamento ao redor do conteúdo do cartão.
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff2F2D2C),
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffB7B7B7),
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'R\$ ${recipe.value.toStringAsFixed(2)}', // Exibe o valor da receita formatado em reais.
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff2F2D2C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
