import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/data/model/recipes.dart';
import 'package:flutter/material.dart';

class RecipesProvider extends ChangeNotifier {
  late RecipesRepository _recipeRepository;
  List<Recipes> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  RecipesProvider(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
  }

//metodo para atualizar o repositório
  void updateRepository(RecipesRepository recipeRepository) {
    _recipeRepository = recipeRepository;
    notifyListeners();
  }

//getters
  List<Recipes> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

//método para buscar as receitas
  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _recipeRepository.getRecipes();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Falha ao carregar receitas: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
