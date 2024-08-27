import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      model.User user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners(); 
    } catch (e) {
      print("Erro ao atualizar o usuário: $e");
      _user = null;
      notifyListeners(); 
    }
  }

  bool get isUserLoaded => _user != null;
}
