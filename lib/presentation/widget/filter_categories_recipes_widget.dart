import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../providers/recipes_provider.dart';

/// [FilterCategoriesRecipesWidget] é um widget que exibe uma lista de categorias
/// em forma de chips, permitindo ao usuário selecionar uma categoria para filtrar receitas.
///
/// - Parâmetros:
///   - [categories] ([List<String>]): Lista de categorias disponíveis para a filtragem.
///     Cada categoria será exibida como um chip.
///
/// - Funcionamento:
///   - Quando o usuário seleciona um chip de categoria, o estado do chip é alterado para "selecionado",
///     e o widget atualiza o estado interno para refletir a categoria selecionada.
///   - O widget usa o [RecipesProvider] para filtrar as receitas com base na categoria selecionada.
///   - A seleção de uma categoria aplica a cor definida como [selectedColor] e altera o estilo do texto.
///
/// Referências:
/// - [RecipesProvider]: Provedor de estado que gerencia a lista de receitas e a filtragem baseada na categoria.
/// - [AppTheme]: Classe que contém definições de tema, incluindo cores primárias para o aplicativo.

class FilterCategoriesRecipesWidget extends StatefulWidget {
  /// Lista de categorias que serão exibidas como chips.
  final List<String> categories;

  /// Construtor do widget que recebe uma lista de categorias.
  const FilterCategoriesRecipesWidget({super.key, required this.categories});

  @override
  State<FilterCategoriesRecipesWidget> createState() =>
      _FilterCategoriesRecipesWidgetState();
}

class _FilterCategoriesRecipesWidgetState
    extends State<FilterCategoriesRecipesWidget> {
  /// Armazena a categoria atualmente selecionada.
  String? _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    // Obtém a instância de RecipesProvider do contexto atual para gerenciar o estado das receitas.
    final recipesProvider = Provider.of<RecipesProvider>(context);

    return SingleChildScrollView(
      // Permite rolar horizontalmente para exibir todas as categorias quando necessário.
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children:
              widget.categories // Itera sobre a lista de categorias fornecida.
                  .map((category) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FilterChip(
                          // Exibe cada categoria como um chip.
                          selectedColor: AppTheme.primaryColor,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          backgroundColor: Colors.white,
                          showCheckmark:
                              false, // Oculta o checkmark que indica a seleção do chip.
                          label: Text(
                            (category == 'Almoco')
                                ? 'Almoço'
                                : (category == 'Cafe da Manha')
                                    ? 'Café da Manhã'
                                    : category,
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : const Color(0xff2F4B4E),
                            ),
                          ),
                          selected: _selectedCategory == category,
                          onSelected: (bool selected) {
                            // Atualiza o estado da seleção ao clicar no chip.
                            setState(() {
                              _selectedCategory = selected ? category : 'Todos';
                            });
                            // Filtra as receitas com base na categoria selecionada.
                            recipesProvider
                                .filterRecipesByCategory(_selectedCategory);
                          },
                        ),
                      ))
                  .toList(), // Converte as categorias em uma lista de chips.
        ),
      ),
    );
  }
}
