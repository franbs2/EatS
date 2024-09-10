import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/core/utils/utils.dart';
import 'package:eats/presentation/main_screen.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/edit_perfil_page.dart';
import 'package:eats/presentation/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../core/exceptions/auth_exceptions.dart';

/// [AuthMethods] - Classe que define os métodos de autenticação do aplicativo.

class AuthMethods {
  // Autenticação

  // Instâncias de autenticação, banco de dados e login do Google
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Persistência de estado
  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  ///[isUserLoggedIn] - Verifica se o usuário está autenticado.
  //
  /// Este método verifica se o [currentUser] não é nulo e retorna um valor booleano
  /// indicando se o usuário está autenticado ou não.
  bool isUserLoggedIn() {
    return currentUser != null;
  }

  /// [getUserDetails] - Obtém os detalhes do usuário atual, incluindo o nome de usuário e a imagem de perfil.
  ///
  /// Este método verifica se o [currentUser] não é nulo e, se sim, carrega os detalhes
  /// do usuário a partir do Firestore, criando um objeto [model.User] com os dados
  /// obtidos. Se o usuário não estiver autenticado, uma exceção é lançada.
  ///
  /// - Retorna: Um objeto [model.User] com os detalhes do usuário, ou nulo se o
  ///   usuário não estiver autenticado.
  ///
  /// - Exceção: Uma exceção se houver um erro ao carregar os detalhes do usuário.

  Future<model.User?> getUserDetails() async {
    try {
      // Esperar até que o currentUser esteja disponível
      while (_auth.currentUser == null) {
        debugPrint("AuthMethods: esperando currentUser");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Usuário não autenticado");
      }

      final snap =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!snap.exists) {
        return null;
      }

      return model.User.fromSnap(snap);
    } catch (e) {
      throw Exception("Erro ao obter detalhes do usuário: $e");
    }
  }

  /// [getUserAtribute] - Retorna o valor de um atributo do usuário.
  ///
  /// Este método busca o documento do usuário autenticado no Firestore e
  /// retorna o valor do atributo especificado.
  ///
  /// - Parâmetros:
  ///   - [atribute] (String): Nome do atributo a ser lido.
  ///
  /// - Retorna: O valor do atributo especificado, ou nulo se o atributo não existir.
  ///
  Future<Object?> getUserAtribute(String atribute) async {
    final userDoc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    if (userDoc.exists) {
      return userDoc.data()![atribute];
    }
    return null;
  }

  /// [signUpUser] - Registra um novo usuário no Firebase Auth e no Firestore.
  ///
  /// Este método valida os campos de e-mail e senha, e cria um novo usuário no
  /// Firebase Auth e no Firestore. Se o registro for bem-sucedido, o usuário é
  /// autenticado e a página de login é exibida.
  ///
  /// - Parâmetros:
  ///   - [context] (BuildContext): Contexto da build atual, usado para exibir
  ///     mensagens e navegar entre páginas.
  ///   - [email] (String): E-mail do usuário a ser registrado.
  ///   - [password] (String): Senha do usuário a ser registrado.
  ///   - [confirmPassword] (String): Confirma o do usuário a ser registrado.
  ///
  /// - Exceções:
  ///   - [GenericAuthException]: Se o registro falhar por algum motivo.
  ///
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      _validateSignUpFields(email, password, confirmPassword);

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user == null) {
        throw GenericAuthException('Erro ao criar o usuário.');
      }

      final user = model.User(
        uid: cred.user!.uid,
        username: '',
        photoURL: 'profilePics/default.jpg',
        email: email,
        foodNiches: [],
        dietaryRestrictions: [],
        onboarding: false,
      );

      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      if (context.mounted) {
        await loginUser(context: context, email: email, password: password);
      }
    } on FirebaseAuthException catch (err) {
      _handleFirebaseSignUpError(err);
    } catch (err) {
      throw GenericAuthException(err.toString());
    }
  }

  /// [signInWithGoogle] - Tenta autenticar o usuário com o Google Sign-In.
  ///
  /// Este método tenta autenticar o usuário com o Google Sign-In, utilizando o
  /// [GoogleSignIn] para obter as credenciais do usuário. Se a autenticação for
  /// bem-sucedida, ele atualiza o estado do [UserProvider] e redireciona o
  /// usuário para a tela principal.
  ///
  /// - Parâmetros:
  ///   - [context] (BuildContext): Contexto da build atual, usado para exibir
  ///     mensagens e navegar entre páginas.
  ///
  /// - Exceções:
  ///   - [FirebaseAuthException]: Se a autenticação falhar por algum motivo.
  ///   - [Exception]: Se ocorrer um erro inesperado durante a autenticação.

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _signInWithGoogle();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Atualize o estado do UserProvider
      if (context.mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.refreshUser();

        // Verifique se o usuário foi atualizado no UserProvider
        debugPrint(
            "AuthMethods: Usuário autenticado e atualizado: ${userProvider.user?.uid}");
      }

      // Redirecione para a tela adequada
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(e.message!, context);
      }
    }
  }

  ///[updateUserProfile] - Atualiza o perfil do usuário no Firebase Firestore.
  ///
  /// - Parâmetros:
  ///   - [username] ([String]): Novo nome de usuário.
  ///   - [file] ([Uint8List]): Novo arquivo de imagem de perfil.
  ///   - [foodNiches] ([List<String>]): Novas dietas preferidas do usuário.
  ///   - [dietaryRestrictions] ([List<String>]): Novas restrições alimentares do usuário.
  ///   - [onboarding] ([bool]): Se o usuário concluiu o onboarding.
  ///   - [context] ([BuildContext]): Contexto da tela atual.
  //
  /// - Retorna:
  ///   - [String]: "success" se o perfil foi atualizado com sucesso, ou uma mensagem de erro caso contrário.
  //
  /// - Exceções:
  ///   - [Exception]: Se ocorrer um erro inesperado durante a atualização do perfil.
  Future<String> updateUserProfile({
    String? username,
    Uint8List? file,
    List<String>? foodNiches,
    List<String>? dietaryRestrictions,
    bool? onboarding,
    required BuildContext context,
  }) async {
    final uid = _auth.currentUser!.uid;
    try {
      final updateData = await _prepareUpdateData(
          username, file, foodNiches, dietaryRestrictions, onboarding, context);

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
        return "success";
      }
      return "Nenhuma alteração detectada.";
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// [loginUser] - Tenta fazer login do usuário com email e senha.
  //
  /// - Parâmetros:
  ///   - [context] ([BuildContext]): Contexto da tela atual.
  ///   - [email] ([String]): Email do usuário.
  ///   - [password] ([String]): Senha do usuário.
  //
  /// - Retorna:
  ///   - [Future<void>]: Uma promise de que o login foi concluído com sucesso.
  //
  /// - Exceções:
  ///   - [GenericAuthException]: Se o login falhar por algum motivo.
  ///   - [EmailPassException]: Se a autenticação falhar devido a email ou senha inválidos.
  //
  /// - Caso o login seja bem-sucedido, navega para a tela principal se o usuário
  ///   tiver concluído o onboarding, ou para a tela de edição de perfil se ele
  ///   não tiver concluído o onboarding.

  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await userProvider.refreshUser();
      debugPrint("${userProvider.user!.onboarding}");
      if (!userProvider.user!.onboarding) {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => EditPerfilPage()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      throw GenericAuthException(e.message!);
    } catch (err) {
      throw EmailPassException();
    }
  }

  /// [logOut] - Desconecta o usuário logado, seja por email e senha ou por Google.
  ///
  /// - Caso o usuário esteja logado pelo Google, o método [GoogleSignIn.signOut] é chamado.
  /// - Se o usuário estiver logado por email e senha, o método [FirebaseAuth.signOut] é chamado.
  /// - Após o logout, o método navega para a [LoginPage].
  ///
  /// - Exceções:
  ///   - Caso o logout falhe, o método lança uma [LogOutException].
  ///

  Future<void> logOut(context) async {
    try {
      // se for logado pelo google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _auth.signOut();
      // Redirecione para a tela adequada
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Aqui você pode adicionar detalhes do erro
      throw LogOutException('Falha ao fazer logout. Tente novamente.');
    }
  }

  /// [_validateSignUpFields] Valida os campos de cadastro.
  //
  // Verifica se os campos de email, senha e confirmação de senha estão preenchidos.
  //
  // - Parâmetros:
  ///   - [email] (String): Email do usuário.
  ///   - [password] (String): Senha do usuário.
  ///   - [confirmPassword] (String): Confirmação da senha do usuário.
  //
  // - Exceções:
  //   - [GenericAuthException]: Se pelo menos um dos campos estiver vazio.
  //   - [PasswordsDoNotMatchException]: Se as senhas não forem iguais.

  void _validateSignUpFields(
      String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw GenericAuthException('Por favor, preencha todos os campos.');
    }
    if (password != confirmPassword) {
      throw PasswordsDoNotMatchException();
    }
  }

  /// [_prepareUpdateData] - Prepara os dados para atualizar o perfil do usuário.
  ///
  /// Verifica se os campos de username, imagem, nichos de alimentos e restrições
  /// alimentares estão preenchidos e se as senhas são iguais. Se alguma
  /// validação falhar, lança uma exceção [GenericAuthException] com uma mensagem
  /// de erro apropriada.
  ///
  /// - Parâmetros:
  ///   - [username] (String?): Novo nome de usuário.
  ///   - [file] (Uint8List?): Nova imagem de perfil.
  ///   - [foodNiches] (List<String>?): Novos nichos de alimentos.
  ///   - [dietaryRestrictions] (List<String>?): Novas restrições alimentares.
  ///   - [onboarding] (bool?): Novo status de onboarding.
  ///   - [context] (BuildContext): Contexto da build atual, usado para obter o
  ///     provedor de usuário.
  ///
  /// - Retorna:
  ///   Um mapa de chave-valor com os dados atualizados.
  ///
  /// - Exceções:
  ///   - [GenericAuthException]: Se houver um erro ao preparar os dados para
  ///     atualizar o perfil do usuário.
  ///
  Future<Map<String, dynamic>> _prepareUpdateData(
    String? username,
    Uint8List? file,
    List<String>? foodNiches,
    List<String>? dietaryRestrictions,
    bool? onboarding,
    BuildContext context,
  ) async {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9\- ]*$');
    final updateData = <String, dynamic>{};
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (username != null && username.isNotEmpty) {
      debugPrint("AuthMethods: Validando username");
      debugPrint("username: $username");
      if (!regex.hasMatch(username)) {
        debugPrint("AuthMethods: username inválido");
        throw InvalidUsernameException();
      } else if (username.length <= 5) {
        debugPrint("AuthMethods: username muito curto");
        throw InvalidTooShortException();
      } else if (username.length > 20) {
        debugPrint("AuthMethods: username muito longo");
        throw UsernameTooLongException();
      } else if (await _usernameExists(username)) {
        debugPrint("AuthMethods: username em uso");
        throw UsernameAlreadyInUseException();
      } else {
        debugPrint("AuthMethods: Atualizando username");
        updateData['username'] = username;
      }
    }

    if (file != null) {
      final user = await getUserDetails();
      final photoURL = user!.photoURL;

      if (photoURL != 'profilePics/default.jpg' &&
          !photoURL.startsWith("http")) {
        debugPrint("AuthMethods: trocando imagem do perfil no Storage");
        await StorageMethods().replaceImageAtStorage(photoURL, file);
      } else {
        debugPrint("AuthMethods: Adicionando imagem do perfil no Storage");
        await StorageMethods()
            .uploadImageToStorage('profilePics', _auth.currentUser!.uid, file);
        updateData['photoURL'] = 'profilePics/${_auth.currentUser!.uid}';
      }
    }

    if (foodNiches != null) {
      updateData['foodNiches'] = foodNiches;
    }

    if (dietaryRestrictions != null) {
      updateData['dietaryRestrictions'] = dietaryRestrictions;
    }

    if (onboarding != null) {
      updateData['onboarding'] = onboarding;
    }

    userProvider.refreshUser();
    return updateData;
  }

  /// [createUserInFirestoreIfNotExists] - Cria um usuário no Firestore se não existir.
  ///
  /// Verifica se o usuário autenticado existe no Firestore.
  /// Caso ele não exista, cria um novo usuário com os dados do Firebase Auth.
  /// Caso ele já exista, retorna o usuário existente.
  ///
  /// Retorna um [model.User] se o usuário for criado ou encontrado, ou [null] se o
  /// usuário autenticado for nulo.
  ///
  Future<model.User?> createUserInFirestoreIfNotExists() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return null;

    final snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (!snap.exists) {
      final newUser = model.User(
        uid: currentUser.uid,
        username: currentUser.displayName ?? '',
        photoURL: currentUser.photoURL ?? 'profilePics/default.jpg',
        email: currentUser.email ?? '',
        foodNiches: [],
        dietaryRestrictions: [],
        onboarding: true,
      );
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(newUser.toJson());
      return newUser;
    }

    return model.User.fromSnap(snap);
  }

  /// [_usernameExists] - Verifica se o username existe no Firestore.
  ///
  /// Realiza uma consulta ao Firestore para verificar se o username especificado existe.
  ///
  /// - Parâmetros:
  ///   - [username] (String): O username a ser verificado.
  ///
  /// - Retorna: [Future] que completa com [true] se o username existir, ou [false] caso contrário.
  Future<bool> _usernameExists(String username) async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return snap.docs.isNotEmpty;
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }

  /// [_handleFirebaseSignUpError] - Trata erros de autenticação ocorridos durante o registro.
  ///
  /// Verifica o erro e trata o erro de acordo com a necessidade.
  ///
  /// Exceções tratadas:
  ///   - [InvalidEmailException]		: Erro de email inválido.
  ///   - [WeakPasswordException]		: Senha fraca.
  ///   - [GenericAuthException]		: Erro genérico.
  ///
  /// - Parâmetros:
  ///   - [err] (FirebaseAuthException): O erro de autenticação ocorrido.
  ///
  /// - Retorna: [Future] que completa com [true] se o username existir, ou [false] caso contrário.
  ///
  void _handleFirebaseSignUpError(FirebaseAuthException err) {
    if (err.code == 'invalid-email') {
      throw InvalidEmailException();
    } else if (err.code == 'weak-password') {
      throw WeakPasswordException();
    } else {
      throw GenericAuthException(err.message ?? 'Erro desconhecido.');
    }
  }

  /// [_signInWithGoogle] - Realiza o login com Google.
  ///
  /// Chama o método [signIn] do [GoogleSignIn] para iniciar o processo de login.
  ///
  /// - Retorna: [Future] que completa com o [GoogleSignInAccount] do usuário
  ///   logado, ou nulo se o usuário cancelar o login.
  ///
  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    return await _googleSignIn.signIn();
  }
}
