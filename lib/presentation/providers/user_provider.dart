import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User? get getUser => _user;

  // Método para verificar se o usuário está carregado
  bool get isUserLoaded => _user != null;

  // Atualiza os dados do usuário e notifica listeners
  Future<void> refreshUser() async {
    try {
      final user = await _authMethods.getUserDetails();
      _user = user;
    } catch (e) {
      _user = null;
      debugPrint("Erro ao atualizar o usuário: $e");
    } finally {
      notifyListeners(); // Chama notifyListeners uma vez após a atualização
    }
  }
}
