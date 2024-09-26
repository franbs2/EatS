import 'package:eats/core/routes/routes.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/args/recipe_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../providers/user_provider.dart';

class RecipeCardListWidget extends StatelessWidget {
  final String imageUrl;
  final Recipes recipe;
  final Function() updatePage;

  const RecipeCardListWidget(
      {super.key,
      required this.imageUrl,
      required this.recipe,
      required this.updatePage});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.of(context).pushNamed(
            RoutesApp.detailRecipePage,
            arguments:
                RecipeArguments(recipe: recipe, isRecipeGenerated: false),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Seção da imagem
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.0,
                      height: 80.0,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              // Seção de texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da receita
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    // Subtítulo ou descrição
                    Text(
                      recipe.description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    // Informações adicionais (exemplo: rating, tempo)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          recipe.rating.toString(), // Exemplo de rating
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(width: 16.0),
                        Icon(
                          recipe.public == true ? Icons.public : Icons.lock,
                          color: Colors.grey[600],
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          recipe.public == true
                              ? 'Público'
                              : 'Privado', // Exemplo de tempo
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Ícone de menu
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Menu de opções no canto superior direito.
                  PopupMenuButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16))),
                      icon: const Icon(
                        Icons.more_vert,
                        size: 28,
                        color: Colors.black,
                      ),
                      itemBuilder: (context) {
                        return [
                          // Opção para editar o perfil.
                          PopupMenuItem(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesApp.addRecipePage,
                                arguments: RecipeArguments(
                                    recipe: recipe, isRecipeGenerated: false),
                              ).then((_) {
                                updatePage();
                              });
                            },
                            child: const SizedBox(
                              child: Text(
                                'Editar',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          // Opção para visualizar dados pessoais (não implementada).
                          PopupMenuItem(
                            onTap: () {
                              _showConfirmationDialog(context,
                                  title: recipe.public == true
                                      ? 'Confirmar a Privação da Receita'
                                      : 'Confirmar a Publicação',
                                  content: recipe.public == true
                                      ? 'Você tem certeza que deseja privar essa receita?'
                                      : 'Você tem certeza que deseja publicar essa receita?',
                                  textButton: recipe.public == true
                                      ? 'Privar'
                                      : 'Publicar', onConfirm: () async {
                                final result =
                                    await userProvider.toggleRecipeVisibility(
                                        recipe.id, recipe.public!);
                                updatePage();
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)));
                              },
                                  colorButton: AppTheme.primaryColor,
                                  colorButtonCancel: Colors.grey);
                            },
                            child: Text(
                                recipe.public == true ? 'Privar' : 'Publicar',
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.normal)),
                          ),
                          // Opção para sair da conta.
                          PopupMenuItem(
                            onTap: () {
                              _showConfirmationDialog(
                                context,
                                title: 'Confirmação de exclusão',
                                content:
                                    'Deseja realmente excluir esta receita?',
                                onConfirm: () async {
                                  final result =
                                      await userProvider.deletMyRecipe(
                                          recipe.id); // Captura o resultado
                                  //Atualiza a pagina
                                  updatePage();
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              result))); // Exibe a mensagem
                                },
                                textButton: 'Deletar',
                              );
                            },
                            child: const Text('Deletar',
                                style: TextStyle(
                                    color: AppTheme.atencionRed,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ];
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context,
      {required String title,
      required String content,
      required String textButton,
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text(textButtonCancel,
                  style: TextStyle(color: colorButtonCancel)),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop(); // Fecha o diálogo
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
