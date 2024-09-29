// Importações necessárias para o provedor de preferências,
// incluindo métodos de autenticação e o provedor de usuário.
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/services/user_service.dart';
import 'package:flutter/material.dart';

/// [PreferencesProvider] gerencia as preferências alimentares,
/// incluindo alergias, dietas e outras preferências do usuário.
/// Ele interage com o [UserProvider] para carregar e atualizar as preferências do usuário.
class PreferencesProvider with ChangeNotifier {
  UserProvider
      _userProvider; // Provedor de usuário para carregar e atualizar preferências.

  /// Construtor que inicializa o [PreferencesProvider] com um [UserProvider] e
  /// carrega as preferências do usuário.
  PreferencesProvider(this._userProvider) {
    loadPreferences();
  }

  // Propriedades para manter o estado das preferências alimentares do usuário.
  List<String> _selectedAllergies =
      []; // Lista de alergias selecionadas pelo usuário.
  List<String> _selectedDiets =
      []; // Lista de dietas selecionadas pelo usuário.
  List<String> _allergies = 
      []; // Lista completa de alergias do usuário.
  List<String> _diets = []; // Lista completa de dietas do usuário.

  /// Atualiza o [UserProvider] e recarrega as preferências do usuário.
  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    loadPreferences();
  }

  // Getters para expor as listas selecionadas à interface de usuário.
  List<String> get selectedAllergies => _selectedAllergies;
  List<String> get selectedDiets => _selectedDiets;

  /// Carrega as preferências do usuário a partir do [UserProvider].
  /// Chama métodos para resetar as listas de alergias, dietas e preferências selecionadas.
  Future<void> loadPreferences() async {
    _allergies = _userProvider.user?.dietaryRestrictions ?? [];
    _diets = _userProvider.user?.foodNiches ?? [];
    notifyListeners();
    resetSelectedAllergies();
    resetSelectedDiets();
  }

  /// Reseta as alergias selecionadas para refletir as alergias atuais do usuário.
  Future<void> resetSelectedAllergies() async {
    _selectedAllergies = [..._allergies];
    notifyListeners();
  }

  /// Reseta as dietas selecionadas para refletir as dietas atuais do usuário.
  Future<void> resetSelectedDiets() async {
    _selectedDiets = [..._diets];
    notifyListeners();
  }

  /// Adiciona ou remove uma alergia da lista de alergias selecionadas.
  void toggleAllergy(String allergy) {
    if (_selectedAllergies.contains(allergy)) {
      _selectedAllergies.remove(allergy);
    } else {
      _selectedAllergies.add(allergy);
    }
    notifyListeners();
  }

  /// Adiciona ou remove uma dieta da lista de dietas selecionadas.
  void toggleDiet(String diet) {
    if (_selectedDiets.contains(diet)) {
      _selectedDiets.remove(diet);
    } else {
      _selectedDiets.add(diet);
    }
    notifyListeners();
  }

  /// Limpa todas as alergias selecionadas.
  void clearAllergies() {
    _selectedAllergies.clear();
    notifyListeners();
  }

  /// Limpa todas as dietas selecionadas.
  void clearDiets() {
    _selectedDiets.clear();
    notifyListeners();
  }

  /// Salva as dietas selecionadas no perfil do usuário e recarrega o estado do usuário.
  Future<void> saveDiets(BuildContext context) async {
    await UserService().updateUserProfile(
      foodNiches: [..._selectedDiets],
    );
    _diets = [..._selectedDiets];
    await _userProvider.refreshUser();
    notifyListeners();
  }

  /// Salva as alergias selecionadas no perfil do usuário e recarrega o estado do usuário.
  Future<void> saveAllergies(BuildContext context) async {
    await UserService().updateUserProfile(
      dietaryRestrictions: [..._selectedAllergies],
    );
    _allergies = [..._selectedAllergies];
    await _userProvider.refreshUser();
    notifyListeners();
  }
}
