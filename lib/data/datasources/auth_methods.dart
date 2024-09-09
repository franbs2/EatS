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

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Persistência de estado
  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  bool isUserLoggedIn() {
    return currentUser != null;
  }

  // Obter detalhes do usuário
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

  Future<Object?> getUserAtribute(String atribute) async {
    final userDoc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    if (userDoc.exists) {
      return userDoc.data()![atribute];
    }
    return null;
  }

  // Cadastro de usuário
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

  // Login com Google
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

  // Atualizar perfil de usuário
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

  // Login do usuário com email e senha
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

  // Logout do usuário
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

  // Métodos auxiliares privados

  // Validação dos campos de cadastro
  void _validateSignUpFields(
      String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw GenericAuthException('Por favor, preencha todos os campos.');
    }
    if (password != confirmPassword) {
      throw PasswordsDoNotMatchException();
    }
  }

  // Preparar dados de atualização do perfil
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

  // Verificar e criar usuário no Firestore se necessário
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

  // verificar se um username já existe
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

  // Lidar com erros de cadastro do Firebase
  void _handleFirebaseSignUpError(FirebaseAuthException err) {
    if (err.code == 'invalid-email') {
      throw InvalidEmailException();
    } else if (err.code == 'weak-password') {
      throw WeakPasswordException();
    } else {
      throw GenericAuthException(err.message ?? 'Erro desconhecido.');
    }
  }

  // Fazer login com Google
  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    return await _googleSignIn.signIn();
  }
}
