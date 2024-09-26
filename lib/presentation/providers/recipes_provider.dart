// Importações necessárias para o provedor de receitas, incluindo o repositório de receitas
// e o modelo de receitas.
import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:flutter/material.dart';

/// [RecipesProvider] é um [ChangeNotifier] que gerencia o estado das receitas,
/// incluindo a obtenção das receitas do repositório, filtragem por categoria,
/// e a exibição de mensagens de erro. Ele notifica os ouvintes sobre mudanças
/// de estado, permitindo uma UI reativa.
class RecipesProvider extends ChangeNotifier {
  late RecipesRepository
      _recipeRepository; // Repositório de receitas usado para obter dados.
  List<Recipes> _recipes = []; // Lista de todas as receitas obtidas.

  List<Recipes> _filteredRecipes =
      []; // Lista de receitas filtradas por categoria.
  bool _isLoading = false; // Estado de carregamento para exibir na UI.
  String? _errorMessage; // Mensagem de erro exibida em caso de falha.

  String? selectedCategory; // Categoria selecionada para filtragem.

  /// Construtor que inicializa o [RecipesProvider] com um [RecipesRepository].
  RecipesProvider(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
  }

  /// Atualiza o repositório de receitas.
  /// Útil se o repositório precisar ser alterado dinamicamente.
  void updateRepository(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
    notifyListeners();
  }

  // Getters para expor dados ao UI
  /// Retorna a lista de receitas filtradas ou todas as receitas,
  /// dependendo da categoria selecionada.
  List<Recipes> get recipes =>
      selectedCategory == null || selectedCategory == 'Todos'
          ? _recipes
          : _filteredRecipes;

  /// Retorna o estado de carregamento, útil para mostrar um indicador de progresso.
  bool get isLoading => _isLoading;

  /// Retorna a mensagem de erro atual, se houver.
  String? get errorMessage => _errorMessage;

  /// [fetchRecipes] busca as receitas do repositório e atualiza o estado do provedor.
  /// Em caso de erro, define uma mensagem de erro apropriada.
  Future<void> fetchRecipes(String? query, String? category) async {
    _isLoading = true; // Indica que o carregamento está em andamento.
    notifyListeners(); // Notifica ouvintes para atualizações de UI.

    try {
      _recipes = await _recipeRepository
          .getRecipes(query); // Obtém receitas do repositório.

      // Filtra as receitas com base na categoria, se especificada.
      if (category != null && category != 'Todos') {
        _filteredRecipes = _recipes
            .where((recipe) => recipe.category.contains(category))
            .toList();
      } else {
        _filteredRecipes = [
          ..._recipes
        ]; // Mostra todas as receitas se a categoria for "Todos" ou nula.
      }

      if (_filteredRecipes.isEmpty) {
        _errorMessage = 'Sem receitas de $category neste momento.';
      } else {
        _errorMessage = null; // Reseta qualquer mensagem de erro.
      }
    } catch (error) {
      _errorMessage =
          'Falha ao carregar receitas: $error'; // Define a mensagem de erro.
    } finally {
      _isLoading = false; // Indica que o carregamento foi concluído.
      notifyListeners(); // Notifica ouvintes novamente para atualizar a UI.
    }
  }

  /// [filterRecipesByCategory] filtra as receitas com base na categoria selecionada.
  void filterRecipesByCategory(String? category) {
    selectedCategory = category;

    fetchRecipes(null, selectedCategory);

    notifyListeners();
  }

  Future<Recipes> uploadRecipe(Recipes recipe) async {
    notifyListeners();
    await _recipeRepository.saveRecipe(recipe);
    return recipe;
  }
}
