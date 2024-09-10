import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../../core/style/color.dart';
import '../../data/datasources/ia_repository.dart';
import '../../data/model/recipes.dart';
import '../widget/button_default_widget.dart';

/// Página para gerar receitas com base em ingredientes fornecidos pelo usuário.
///
/// A [GenerateRecipesPage] permite ao usuário inserir uma lista de ingredientes e gera uma receita com base nesses ingredientes.
class GenerateRecipesPage extends StatefulWidget {
  const GenerateRecipesPage({super.key});

  @override
  State<GenerateRecipesPage> createState() => _GenerateRecipesPageState();
}

class _GenerateRecipesPageState extends State<GenerateRecipesPage> {
  late AIRepository
      _aiRepository; // Repositório de IA para comunicação com o backend de geração de receitas.
  final List<TextEditingController> _controllers =
      []; // Lista de controladores de texto para os campos de ingredientes.

  @override
  void initState() {
    super.initState();
    _addIngrediente(); // Adiciona um campo de ingrediente ao inicializar o widget.
    _aiRepository = context.read<
        AIRepository>(); // Obtém a instância do repositório de IA usando o Provider.
  }

  /// Adiciona um novo campo de ingrediente à lista de controladores.
  ///
  /// Este método é chamado quando o usuário deseja adicionar um novo ingrediente à lista.
  void _addIngrediente() {
    setState(() {
      _controllers.add(
          TextEditingController()); // Adiciona um novo controlador de texto para um ingrediente.
    });
  }

  /// Remove um campo de ingrediente da lista de controladores.
  ///
  /// [index] - O índice do campo de ingrediente a ser removido.
  /// Este método garante que pelo menos um campo de ingrediente permaneça na lista.
  void _removeIngrediente(int index) {
    if (_controllers.length > 1) {
      // Verifica se há mais de um campo de ingrediente.
      setState(() {
        _controllers.removeAt(
            index); // Remove o controlador do campo de ingrediente na posição especificada.
      });
    }
  }

  /// Gera uma receita com base nos ingredientes fornecidos.
  ///
  /// @return - Uma instância de [Recipes] representando a receita gerada.
  Future<Recipes?> _generateRecipe() async {
    final ingredients = _controllers
        .map((e) => e.text)
        .toList(); // Obtém a lista de ingredientes dos controladores de texto.
    print(ingredients); // Imprime a lista de ingredientes para depuração.
    final recipe = await _aiRepository.generateRecipe(
        ingredients); // Solicita ao repositório de IA a geração de uma receita com os ingredientes fornecidos.

    return recipe; // Retorna a receita gerada.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie sua receita'), // Título da barra de aplicativo.
        centerTitle: true, // Centraliza o título da barra de aplicativo.
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Adiciona padding em torno do conteúdo da página.
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers
                    .length, // Define o número de itens na lista como o número de controladores de texto.
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical:
                            8.0), // Adiciona padding vertical ao redor do item da lista.
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controllers[
                                index], // Associa o controlador de texto ao campo de ingrediente.
                            decoration: InputDecoration(
                              labelText:
                                  'Ingrediente ${index + 1}', // Rótulo do campo de texto com número do ingrediente.
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme
                                      .primaryColor, // Cor da borda quando o campo está desativado.
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme
                                      .primaryColor, // Cor da borda quando o campo está focado.
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index == _controllers.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.green,
                                size:
                                    28), // Ícone para adicionar novo ingrediente.
                            onPressed:
                                _addIngrediente, // Adiciona um novo campo de ingrediente ao ser pressionado.
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red,
                                size: 28), // Ícone para remover ingrediente.
                            onPressed: () => _removeIngrediente(
                                index), // Remove o campo de ingrediente ao ser pressionado.
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: ButtonDefaultlWidget(
                    text: 'Gerar receita', // Texto exibido no botão.
                    color: AppTheme.loginYellow, // Cor do botão.
                    width: 0.1 / 2, // Largura do botão.
                    height: 14, // Altura do botão.
                    onPressed: () async {
                      Recipes? recipe =
                          await _generateRecipe(); // Gera a receita e aguarda o resultado.
                      Navigator.of(context).pushNamed(
                          RoutesApp
                              .detailRecipePage, // Navega para a página de detalhes da receita.
                          arguments:
                              recipe); // Passa a receita gerada como argumento para a próxima página.
                    })),
          ],
        ),
      ),
    );
  }
}
