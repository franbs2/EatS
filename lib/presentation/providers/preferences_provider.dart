import 'package:flutter/material.dart';

class PreferencesProvider extends ChangeNotifier {
  // Listas para armazenar as preferências
  final List<String> _selectedAllergies = [];
  final List<String> _selectedDiets = [];
  final List<String> _selectedPreferences = [];

  // Getters para acessar os dados
  List<String> get selectedAllergies => _selectedAllergies;
  List<String> get selectedDiets => _selectedDiets;
  List<String> get selectedPreferences => _selectedPreferences;

  // Métodos para gerenciar alergias
  void toggleAllergy(String allergy) {
    if (_selectedAllergies.contains(allergy)) {
      _selectedAllergies.remove(allergy);
    } else {
      _selectedAllergies.add(allergy);
    }
    notifyListeners();
  }

  // Métodos para gerenciar dietas
  void toggleDiet(String diet) {
    if (_selectedDiets.contains(diet)) {
      _selectedDiets.remove(diet);
    } else {
      _selectedDiets.add(diet);
    }
    notifyListeners();
  }

  // Métodos para gerenciar preferências gerais
  void togglePreference(String preference) {
    if (_selectedPreferences.contains(preference)) {
      _selectedPreferences.remove(preference);
    } else {
      _selectedPreferences.add(preference);
    }
    notifyListeners();
  }

  // Métodos para limpar as listas
  void clearAllergies() {
    _selectedAllergies.clear();
    notifyListeners();
  }

  void clearDiets() {
    _selectedDiets.clear();
    notifyListeners();
  }

  void clearPreferences() {
    _selectedPreferences.clear();
    notifyListeners();
  }
}
