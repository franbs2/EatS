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
      debugPrint('UserProvider: Iniciando refreshUser...');

      const maxAttempts = 20;
      int attempts = 0;

      while (_authMethods.currentUser == null && attempts < maxAttempts) {
        debugPrint('UserProvider: Aguardando autenticação do usuário...');
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }

      if (_authMethods.currentUser == null) {
        debugPrint('UserProvider: Autenticação falhou após várias tentativas.');
        throw Exception("Autenticação do usuário falhou");
      }

      debugPrint(
          'UserProvider: Usuário autenticado: ${_authMethods.currentUser!.uid}');

      var newUser = await _authMethods.getUserDetails();
      if (newUser == null) {
        debugPrint(
            'UserProvider: Usuário não encontrado, criando no Firestore...');
        newUser = await _authMethods.createUserInFirestoreIfNotExists();

        if (newUser == null) {
          throw Exception("Erro ao criar e carregar o usuário no Firestore");
        }
      }

      debugPrint('UserProvider: Usuário carregado: ${newUser.uid}');

      _user = newUser; // Atualize diretamente o usuário
      await _updateUserProfileImage(newUser);

      debugPrint(
          'UserProvider: Refresh do usuário completo. Usuário: ${_user?.uid}');
      notifyListeners();
    } catch (e) {
      debugPrint('UserProvider: Erro em refreshUser: $e');
      _user = null;
      _profileImage = null;
    }
  }

  Future<void> _updateUserProfileImage(model.User newUser) async {
    debugPrint('UserProvider: Atualizando imagem de perfil...');
    Uint8List? newProfileImage;

    if (newUser.photoURL.startsWith('profilePics')) {
      newProfileImage = await StorageMethods().loadImageInMemory(
        newUser.photoURL,
        true,
      );
    } else {
      newProfileImage = await StorageMethods().loadImageInMemory(
        newUser.photoURL,
        false,
      );
    }

    if (_profileImage == null && newProfileImage != null ||
        _profileImage != null && newProfileImage == null ||
        _profileImage != null &&
            newProfileImage != null &&
            !listEquals(_profileImage, newProfileImage)) {
      debugPrint('UserProvider: Imagem de perfil atualizada.');
      _profileImage = newProfileImage;
      notifyListeners();
    } else {
      debugPrint('Nenhuma mudança na imagem de perfil.');
    }
  }
}
