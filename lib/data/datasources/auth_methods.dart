import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/exceptions/auth_exceptions.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Persistência de estado
  Stream<User?> get authState => _auth.authStateChanges();

  // Obter detalhes do usuário
  Future<model.User> getUserDetails() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception("Usuário não autenticado");
      }

      final snap = await _firestore.collection('users').doc(currentUser.uid).get();

      if (!snap.exists) {
        throw Exception("Documento não encontrado");
      }

      return model.User.fromSnap(snap);
    } catch (e) {
      throw Exception("Erro ao obter detalhes do usuário: $e");
    }
  }

  // Cadastro de usuário
  Future<void> signUpUser({
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
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

    } on FirebaseAuthException catch (err) {
      _handleFirebaseSignUpError(err);
    } catch (err) {
      throw GenericAuthException(err.toString());
    }
  }

  // Atualizar perfil de usuário
  Future<String> updateUserProfile({
    required String uid,
    String? username,
    Uint8List? file,
  }) async {
    try {
      final updateData = await _prepareUpdateData(username, file);

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
        return "success";
      }
      return "Nenhuma alteração detectada.";
    } catch (err) {
      return "Erro ao atualizar perfil: $err";
    }
  }

  // Login com Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _signInWithGoogle();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );

      await _checkAndCreateUserInFirestore(userCredential.user);
      
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(e.message!, context);
      }
    }
  }

  // Login do usuário com email e senha
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw GenericAuthException(e.message!);
    } catch (err) {
      throw EmailPassException();
    }
  }

  // Logout do usuário
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw LogOutException();
    }
  }

  // Métodos auxiliares privados

  // Validação dos campos de cadastro
  void _validateSignUpFields(String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw GenericAuthException('Por favor, preencha todos os campos.');
    }
    if (password != confirmPassword) {
      throw PasswordsDoNotMatchException();
    }
  }

  // Preparar dados de atualização do perfil
  Future<Map<String, dynamic>> _prepareUpdateData(String? username, Uint8List? file) async {
    final updateData = <String, dynamic>{};

    if (username != null && username.isNotEmpty) {
      updateData['username'] = username;
    }

    if (file != null) {
      final photoURL = await StorageMethods().uploadImageToStorage('profilePics', file, false);
      updateData['photoURL'] = photoURL;
    }

    return updateData;
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

  // Verificar e criar usuário no Firestore se necessário
  Future<void> _checkAndCreateUserInFirestore(User? user) async {
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      final newUser = model.User(
        uid: user.uid,
        username: user.displayName ?? '',
        photoURL: user.photoURL ?? 'profilePics/default.jpg',
        email: user.email ?? '',
        foodNiches: [],
        dietaryRestrictions: [],
      );
      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
    }
  }

  // Fazer login com Google
  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    return await GoogleSignIn().signIn();
  }
}
