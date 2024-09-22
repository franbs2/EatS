import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../../core/utils/utils.dart';
import '../../core/style/color.dart';
import '../../data/datasources/ia_repository.dart';
import '../../data/model/recipes.dart';
import '../args/recipe_arguments.dart';
import '../widget/button_default_widget.dart';
import '../widget/filter_generate_widget.dart';
import '../widget/custom_allergies_list_widget.dart';
import '../providers/user_provider.dart';

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
  final List<TextEditingController> _controllersIngredients = [];
  final List<TextEditingController> _controllersInstruments = [];

  List<String> _selectedRestrictions = [];
  String _selectedMealType = '';
  String _selectedPreparationTime = '';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _selectedRestrictions = userProvider.user!.dietaryRestrictions;
    _addField(_controllersInstruments);
    _addField(
        _controllersIngredients); // Adiciona um campo de ingrediente ao inicializar o widget.
    _addField(_controllersIngredients);
    _aiRepository = context.read<
        AIRepository>(); // Obtém a instância do repositório de IA usando o Provider.
  }

  /// Adiciona um novo campo de ingrediente ou instrumento à lista de controladores.
  void _addField(List<TextEditingController> controllers) {
    setState(() {
      controllers.add(
          TextEditingController()); // Adiciona um novo controlador de texto.
    });
  }

  /// Remove um campo de ingrediente ou instrumento da lista de controladores.
  /// Este método garante que pelo menos um campo permaneça na lista.
  void _removeField(int index, List<TextEditingController> controllers) {
    if (controllers.length > 1) {
      setState(() {
        controllers.removeAt(
            index); // Remove o controlador do campo na posição especificada.
      });
    }
  }

  /// Gera uma receita com base nos ingredientes fornecidos.
  Future<Recipes?> _generateRecipe() async {
    final ingredients = _controllersIngredients.map((e) => e.text).toList();
    final instruments = _controllersInstruments.map((e) => e.text).toList();

    if (ingredients.length < 2) {
      showSnackBar('Insira pelo menos 2 ingredientes', context);
      return null;
    }
    final hasEmptyIngredient = ingredients.any((element) => element.isEmpty);
    if (hasEmptyIngredient) {
      showSnackBar('Insira todos os ingredientes', context);
      return null;
    }

    final recipe = await _aiRepository.generateRecipe(
      ingredients,
      instruments,
      _selectedMealType,
      _selectedRestrictions,
      _selectedPreparationTime,
    );
    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
        title: const Text('Crie sua receita'), // Título da barra de aplicativo.
        centerTitle: true, // Centraliza o título da barra de aplicativo.
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterGenerateWidget(
                        listFilter: const [
                          'indefinido',
                          'Lanche',
                          'Jantar',
                          'Almoço',
                          'Sobremesa',
                          'Café da manhã',
                        ],
                        title: 'Tipo de Refeição',
                        onSelected: (value) {
                          setState(() {
                            _selectedMealType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      FilterGenerateWidget(
                        listFilter: const [
                          'Minhas',
                          'Customizadas',
                          'Nenhuma',
                        ],
                        title: 'Restrições',
                        onSelected: (value) {
                          if (value == 'Customizadas') {
                            _showRestrictionsModal(context);
                          } else {
                            setState(() {
                              if (value == 'Minhas') {
                                _selectedRestrictions =
                                    userProvider.user!.dietaryRestrictions;
                              } else {
                                _selectedRestrictions = [];
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      FilterGenerateWidget(
                        listFilter: const [
                          'indefinido',
                          '10 min',
                          '15 min',
                          '30 min',
                          '45 min',
                          '+ 1 hora',
                        ],
                        title: 'Tempo de Preparo',
                        onSelected: (value) {
                          setState(() {
                            _selectedPreparationTime = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      const Text(
                        'Ingredientes Principais',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600), // Estilo do título da seção.
                      ),
                      ..._buildFieldList(
                          _controllersIngredients, 'Ingrediente'),
                      const SizedBox(height: 24),
                      const Text(
                        'Instrumentos Principais',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600), // Estilo do título da seção.
                      ),
                      ..._buildFieldList(
                          _controllersInstruments, 'Instrumento'),
                      const SizedBox(height: 24),
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
                              print(recipe);
                              if (recipe == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Não foi possível criar sua receita! Tente novamente. Verifique se os ingredientes estão corretos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (context.mounted) {
                                Navigator.of(context).pushNamed(
                                  RoutesApp.detailRecipePage,
                                  arguments: RecipeArguments(
                                      recipe: recipe, isRecipeGenerated: true),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a lista de campos de texto para ingredientes ou instrumentos.
  List<Widget> _buildFieldList(
      List<TextEditingController> controllers, String label) {
    return List.generate(
      controllers.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllers[index],
                decoration: InputDecoration(
                  labelText:
                      '$label ${index + 1}', // Rótulo do campo de texto com número do ingrediente ou instrumento.
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
            if (index == controllers.length - 1)
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: Colors.green,
                    size:
                        28), // Ícone para adicionar novo ingrediente ou instrumento.
                onPressed: () => _addField(
                    controllers), // Adiciona um novo campo ao ser pressionado.
              )
            else
              IconButton(
                icon: const Icon(Icons.close,
                    color: Colors.red,
                    size: 28), // Ícone para remover ingrediente ou instrumento.
                onPressed: () => _removeField(
                    index, controllers), // Remove o campo ao ser pressionado.
              ),
          ],
        ),
      ),
    );
  }

  void _showRestrictionsModal(BuildContext context) async {
    final selectedRestrictions = await showModalBottomSheet<List<String>>(
      context: context,
      elevation: 50,
      backgroundColor: AppTheme.secondaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.0)),
      ),
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SingleChildScrollView(child: CustomAllergiesListWidget()),
        );
      },
    );

    if (selectedRestrictions != null) {
      setState(() {
        _selectedRestrictions = selectedRestrictions;
      });
    }
  }
}
