import 'package:firebase_auth/firebase_auth.dart';
import 'package:eats/core/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retorna um stream que indica se o usu rio est  logado ou n o.
  Stream<User?> get authState => _auth.authStateChanges();

  /// Retorna o usu rio atual se ele estiver logado, ou null se n o estiver.
  User? get currentUser => _auth.currentUser;

  /// Verifica se o usu rio est  logado.
  bool isUserLoggedIn() {
    return currentUser != null;
  }

  /// Cria um novo usu rio no Firebase com o email e senha informados.
  /// Se o email j  estiver em uso, lan a uma exce o [EmailAlreadyInUseException].
  Future<void> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user == null) {
        throw GenericAuthException('Erro ao criar o usu rio.');
      }
    } on FirebaseAuthException catch (err) {
      _handleFirebaseSignUpError(err);
    } catch (err) {
      throw GenericAuthException(err.toString());
    }
  }

  /// Realiza o login do usu rio no Firebase com o email e senha informados.
  /// Se o email ou senha forem inv lidos, lan a uma exce o [EmailPassException].
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw GenericAuthException(e.message!);
    } catch (_) {
      throw EmailPassException();
    }
  }

  /// Realiza o logout do usu rio no Firebase.
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw LogOutException('Falha ao fazer logout. Tente novamente.');
    }
  }

  /// Manipula as exce es do Firebase na hora de criar um novo usu rio.
  void _handleFirebaseSignUpError(FirebaseAuthException err) {
    if (err.code == 'invalid-email') {
      throw InvalidEmailException();
    } else if (err.code == 'weak-password') {
      throw WeakPasswordException();
    } else {
      throw GenericAuthException(err.message ?? 'Erro desconhecido.');
    }
  }
}

