import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  Uint8List? _profileImage;

  final AuthMethods _authMethods = AuthMethods();

  model.User? get user => _user;
  Uint8List? get profileImage => _profileImage;
  bool get isUserLoaded => _user != null;

  Future<void> refreshUser() async {
  try {
    debugPrint('Iniciando refreshUser...');
    
    const maxAttempts = 20;
    int attempts = 0;
    
    while (_authMethods.currentUser == null && attempts < maxAttempts) {
      debugPrint('Aguardando autenticação do usuário...');
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }
    
    if (_authMethods.currentUser == null) {
      debugPrint('Autenticação falhou após várias tentativas.');
      throw Exception("Autenticação do usuário falhou");
    }

    debugPrint('Usuário autenticado: ${_authMethods.currentUser!.uid}');

    var newUser = await _authMethods.getUserDetails();
    if (newUser == null) {
      debugPrint('Usuário não encontrado, criando no Firestore...');
      newUser = await _authMethods.createUserInFirestoreIfNotExists();

      if (newUser == null) {
        throw Exception("Erro ao criar e carregar o usuário no Firestore");
      }
    }

    debugPrint('Usuário carregado: ${newUser.uid}');
    
    _user = newUser; // Atualize diretamente o usuário
    await _updateUserProfileImage(newUser);

    debugPrint('Refresh do usuário completo. Usuário: ${_user?.uid}');
    notifyListeners();

  } catch (e) {
    debugPrint('Erro em refreshUser: $e');
    _user = null;
    _profileImage = null;
  }
}

Future<void> _updateUserProfileImage(model.User newUser) async {
  debugPrint('Atualizando imagem de perfil...');
  Uint8List? newProfileImage;

  if (newUser.photoURL != null &&
      newUser.photoURL.startsWith('profilePics')) {
    newProfileImage = await StorageMethods().loadImageInMemory(
      newUser.photoURL,
      true,
    );
  } else if (newUser.photoURL != null) {
    newProfileImage = await StorageMethods().loadImageInMemory(
      newUser.photoURL,
      false,
    );
  } else {
    newProfileImage = null;
  }

  if (_profileImage == null && newProfileImage != null ||
      _profileImage != null && newProfileImage == null ||
      _profileImage != null && newProfileImage != null &&
      !listEquals(_profileImage, newProfileImage)) {
    debugPrint('Imagem de perfil atualizada.');
    _profileImage = newProfileImage;
    notifyListeners();
  } else {
    debugPrint('Nenhuma mudança na imagem de perfil.');
  }
}

void _updateUserData(model.User newUser) {
  debugPrint('Atualizando dados do usuário...');
  bool hasUserChanged = false;

  if (_user == null) {
    hasUserChanged = true;
  } else {
    if (_user!.uid != newUser.uid) {
      hasUserChanged = true;
    }
    if (_user!.email != newUser.email) {
      hasUserChanged = true;
    }
    if (_user!.username != newUser.username) {
      hasUserChanged = true;
    }
    if (!listEquals(_user!.foodNiches, newUser.foodNiches)) {
      hasUserChanged = true;
    }
    if (!listEquals(_user!.dietaryRestrictions, newUser.dietaryRestrictions)) {
      hasUserChanged = true;
    }
  }

  if (hasUserChanged) {
    debugPrint('Dados do usuário foram atualizados.');
    _user = newUser;
    notifyListeners();
  } else {
    debugPrint('Nenhuma mudança nos dados do usuário.');
  }
}
}