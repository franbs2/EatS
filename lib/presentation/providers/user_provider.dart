import 'package:eats/data/model/user.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user; // Permite que o usuário seja nulo enquanto carrega

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners(); // Notifica os widgets que os dados do usuário foram atualizados
  }
}
