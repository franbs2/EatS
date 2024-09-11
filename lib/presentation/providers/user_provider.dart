// Importações das dependências necessárias, incluindo métodos de armazenamento,
// autenticação e o modelo de usuário.
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:flutter/foundation.dart';

/// [UserProvider] é uma classe que gerencia o estado do usuário autenticado no aplicativo.
/// Ele utiliza o [ChangeNotifier] para permitir a atualização reativa do estado do usuário
/// e notificar os ouvintes quando há mudanças.
class UserProvider with ChangeNotifier {
  model.User? _user; // Armazena o usuário autenticado.
  Uint8List?
      _profileImage; // Armazena a imagem de perfil do usuário em memória.
  Uint8List?
      image; // Reservado para armazenamento de outras imagens relacionadas ao usuário.

  final AuthMethods _authMethods =
      AuthMethods(); // Instância de métodos de autenticação.

  // Getter para obter o usuário autenticado.
  model.User? get user => _user;

  // Getter para obter a imagem de perfil do usuário.
  Uint8List? get profileImage => _profileImage;

  // Verifica se o usuário está carregado.
  bool get isUserLoaded => _user != null;

  /// [refreshUser] tenta carregar ou atualizar os detalhes do usuário a partir da autenticação.
  /// Faz múltiplas tentativas para verificar se o usuário está autenticado, carrega ou cria o
  /// usuário no Firestore se necessário, e atualiza os dados de perfil.
  Future<void> refreshUser() async {
    try {
      debugPrint('UserProvider: Iniciando refreshUser...');

      const maxAttempts = 20;
      int attempts = 0;

      // Loop para aguardar até que o usuário esteja autenticado, com um limite de tentativas.
      while (_authMethods.currentUser == null && attempts < maxAttempts) {
        debugPrint('UserProvider: Aguardando autenticação do usuário...');
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }

      // Verifica se o usuário não foi autenticado após as tentativas.
      if (_authMethods.currentUser == null) {
        debugPrint('UserProvider: Autenticação falhou após várias tentativas.');
        throw Exception("Autenticação do usuário falhou");
      }

      debugPrint(
          'UserProvider: Usuário autenticado: ${_authMethods.currentUser!.uid}');

      // Carrega os detalhes do usuário a partir do Firestore.
      var newUser = await _authMethods.getUserDetails();
      if (newUser == null) {
        debugPrint(
            'UserProvider: Usuário não encontrado, criando no Firestore...');
        newUser = await _authMethods.createUserInFirestoreIfNotExists();

        // Se a criação do usuário falhar, lança uma exceção.
        if (newUser == null) {
          throw Exception("Erro ao criar e carregar o usuário no Firestore");
        }
      }

      debugPrint('UserProvider: Usuário carregado: ${newUser.uid}');

      // Atualiza o estado do usuário.
      _user = newUser;
      await _updateUserProfileImage(newUser);
      await _updateUsername(newUser);

      debugPrint(
          'UserProvider: Refresh do usuário completo. Usuário: ${_user?.uid}');
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado.
    } catch (e) {
      debugPrint('UserProvider: Erro em refreshUser: $e');
      _user = null;
      _profileImage = null;
    }
  }

  /// Atualiza a imagem de perfil do usuário carregando-a a partir do [StorageMethods].
  /// Verifica se há mudanças na imagem e notifica ouvintes caso ocorra uma atualização.
  Future<void> _updateUserProfileImage(model.User newUser) async {
    debugPrint('UserProvider: Atualizando imagem de perfil...');
    Uint8List? newProfileImage;

    // Carrega a imagem com base no caminho especificado.
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

    // Verifica se há mudanças na imagem de perfil e atualiza o estado.
    if (_profileImage == null ||
        // ignore: unnecessary_null_comparison
        _profileImage != null && newProfileImage == null ||
        _profileImage != null && !listEquals(_profileImage, newProfileImage)) {
      debugPrint('UserProvider: Imagem de perfil atualizada.');
      _profileImage = newProfileImage;
      notifyListeners();
    } else {
      debugPrint('UserProvider: Nenhuma mudança na imagem de perfil.');
    }
  }

  /// Atualiza o username do usuário se houver uma mudança no valor atual.
  Future<void> _updateUsername(model.User newUser) async {
    if (_user?.username != newUser.username) {
      debugPrint('UserProvider: Username atualizado.');
      _user = _user!.copyWith(username: newUser.username);
      notifyListeners();
    } else {
      debugPrint('UserProvider: Nenhuma mudança no username.');
    }
  }

  /// Limpa os dados do usuário atual, incluindo o perfil e as imagens.
  /// Notifica os ouvintes para redefinir o estado.
  void clearUser() {
    debugPrint('UserProvider: Limpando dados do usuário...');
    _user = null;
    _profileImage = null;
    notifyListeners();
  }
}
