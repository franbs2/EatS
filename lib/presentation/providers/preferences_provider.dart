import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';

class PreferencesProvider with ChangeNotifier {
  UserProvider _userProvider;

  PreferencesProvider(this._userProvider) {
    loadPreferences();
  }

  List<String> _selectedAllergies = [];
  List<String> _selectedDiets = [];
  List<String> _selectedPreferences = [];
  List<String> _allergies = [];
  List<String> _diets = [];
  final List<String> _preferences = [];

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    loadPreferences();
  }

  List<String> get selectedAllergies => _selectedAllergies;
  List<String> get selectedDiets => _selectedDiets;
  List<String> get selectedPreferences => _selectedPreferences;

  Future<void> loadPreferences() async {
    _allergies = _userProvider.user?.dietaryRestrictions ?? [];
    _diets = _userProvider.user?.foodNiches ?? [];
    notifyListeners();
    resetSelectedAllergies();
    resetSelectedDiets();
    revokePreferences();
  }

  Future<void> resetSelectedAllergies() async {
    _selectedAllergies = [..._allergies];
    notifyListeners();
  }

  Future<void> resetSelectedDiets() async {
    _selectedDiets = [..._diets];
    notifyListeners();
  }

  Future<void> revokePreferences() async {
    _selectedPreferences = _preferences;
    notifyListeners();
  }

  void toggleAllergy(String allergy) {
    if (_selectedAllergies.contains(allergy)) {
      _selectedAllergies.remove(allergy);
    } else {
      _selectedAllergies.add(allergy);
    }
    notifyListeners();
  }

  void toggleDiet(String diet) {
    if (_selectedDiets.contains(diet)) {
      _selectedDiets.remove(diet);
    } else {
      _selectedDiets.add(diet);
    }
    notifyListeners();
  }

  void togglePreference(String preference) {
    if (_selectedPreferences.contains(preference)) {
      _selectedPreferences.remove(preference);
    } else {
      _selectedPreferences.add(preference);
    }
    notifyListeners();
  }

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

  Future<void> saveDiets() async {
    await AuthMethods().updateUserProfile(
      foodNiches: [..._selectedDiets],
    );
    _diets = [..._selectedDiets];
    await _userProvider.refreshUser();
    notifyListeners();
  }

  Future<void> saveAllergies() async {
    await AuthMethods().updateUserProfile(
      dietaryRestrictions: [..._selectedAllergies],
    );
    _allergies = [..._selectedAllergies];
    await _userProvider.refreshUser();
    notifyListeners();
  }
}
