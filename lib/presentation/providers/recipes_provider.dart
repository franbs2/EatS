import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:flutter/material.dart';

class RecipesProvider extends ChangeNotifier {
  late RecipesRepository _recipeRepository;
  List<Recipes> _recipes = [];
  List<Recipes> _filteredRecipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;

  RecipesProvider(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
  }

  // Método para atualizar o repositório
  void updateRepository(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
    notifyListeners();
  }

  // Getters
  List<Recipes> get recipes =>
      _selectedCategory == null || _selectedCategory == 'Todos'
          ? _recipes
          : _filteredRecipes;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para buscar as receitas
  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _recipeRepository.getRecipes();
      _filteredRecipes = [..._recipes]; // Inicializa com todas as receitas
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Falha ao carregar receitas: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para filtrar as receitas por categoria
  void filterRecipesByCategory(String? category) {
    _selectedCategory = category;

    if (_selectedCategory == null || _selectedCategory == 'Todos') {
      _filteredRecipes = [..._recipes]; 
      _errorMessage = null;
    } else {
      _filteredRecipes = _recipes
          .where((recipe) => recipe.category.contains(_selectedCategory))
          .toList();

      
      if (_filteredRecipes.isEmpty) {
        _errorMessage = 'Sem receitas de $_selectedCategory neste momento.';
      } else {
        _errorMessage = null;
      }
    }

    notifyListeners();
  }
}
