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

  String? _selectedCategory; // Categoria selecionada para filtragem.

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
      _selectedCategory == null || _selectedCategory == 'Todos'
          ? _recipes
          : _filteredRecipes;

  /// Retorna o estado de carregamento, útil para mostrar um indicador de progresso.
  bool get isLoading => _isLoading;

  /// Retorna a mensagem de erro atual, se houver.
  String? get errorMessage => _errorMessage;

  /// `fetchRecipes` busca as receitas do repositório e atualiza o estado do provedor.
  /// Em caso de erro, define uma mensagem de erro apropriada.
  Future<void> fetchRecipes() async {
    _isLoading = true; // Indica que o carregamento está em andamento.
    notifyListeners(); // Notifica ouvintes para atualizações de UI.

    try {
      _recipes = await _recipeRepository
          .getRecipes(); // Obtém receitas do repositório.
      _filteredRecipes = [
        ..._recipes
      ]; // Inicializa as receitas filtradas com todas as receitas.
      _errorMessage = null; // Reseta qualquer mensagem de erro.
    } catch (error) {
      _errorMessage =
          'Falha ao carregar receitas: $error'; // Define a mensagem de erro.
    } finally {
      _isLoading = false; // Indica que o carregamento foi concluído.
      notifyListeners(); // Notifica ouvintes novamente para atualizar a UI.
    }
  }

  /// [filterRecipesByCategory] filtra as receitas com base na categoria selecionada.
  /// Atualiza a lista filtrada e define uma mensagem de erro se não houver receitas correspondentes.
  void filterRecipesByCategory(String? category) {
    _selectedCategory = category; // Define a categoria selecionada.

    // Se a categoria for "Todos" ou nula, mostra todas as receitas.
    if (_selectedCategory == null || _selectedCategory == 'Todos') {
      _filteredRecipes = [..._recipes];
      _errorMessage = null; // Sem erros ao mostrar todas as receitas.
    } else {
      // Filtra receitas que correspondem à categoria selecionada.
      _filteredRecipes = _recipes
          .where((recipe) => recipe.category.contains(_selectedCategory))
          .toList();

      // Se nenhuma receita corresponder, define uma mensagem de erro.
      if (_filteredRecipes.isEmpty) {
        _errorMessage = 'Sem receitas de $_selectedCategory neste momento.';
      } else {
        _errorMessage =
            null; // Reseta a mensagem de erro se receitas forem encontradas.
      }
    }

    notifyListeners(); // Notifica ouvintes sobre mudanças na filtragem.
  }
}
