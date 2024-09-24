import 'package:eats/core/routes/routes.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:eats/presentation/args/recipe_arguments.dart';
import 'package:flutter/material.dart';

import '../../core/style/color.dart';

class RecipeCardListWidget extends StatelessWidget {
  final String imageUrl;
  final Recipes recipe;

  const RecipeCardListWidget(
      {super.key, required this.imageUrl, required this.recipe});

  @override
  Widget build(BuildContext context) {
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
                            onTap: () {},
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
                            onTap: () {},
                            child: const Text('Publicar',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.normal)),
                          ),
                          // Opção para sair da conta.
                          PopupMenuItem(
                            onTap: () {},
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
}
