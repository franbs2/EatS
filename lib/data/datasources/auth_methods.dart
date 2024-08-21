import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/core/utils/utils.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../core/exceptions/auth_exceptions.dart'; // corrected import statement
import 'package:eats/presentation/view/home_page.dart';
import 'package:eats/presentation/view/register_page.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //State Persistence
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // get user details
  Future<model.User> getUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot snap =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (snap.exists) {
          return model.User.fromSnap(snap);
        } else {
          throw Exception("Documento não encontrado");
        }
      } else {
        throw Exception("Usuário não autenticado");
      }

    } catch (e) {
      print("Erro ao buscar detalhes do usuário: $e");
      rethrow;
    }
  }

  // sign up user
  Future<void> signUpUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw GenericAuthException('Por favor, preencha todos os campos.');
      }

      if (password != confirmPassword) {
        throw PasswordsDoNotMatchException();
      }

      // Register user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user == null) {
        throw GenericAuthException('Erro ao criar o usuário.');
      }

      // Add user to our database with minimal initial data

      model.User user = model.User(
        uid: cred.user!.uid,
        username: '',
        photoURL: 'profilePics/default.jpg',
        email: email,
        foodNiches: [],
        dietaryRestrictions: [],
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.toJson(),
          );
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        throw InvalidEmailException();
      } else if (err.code == 'weak-password') {
        throw WeakPasswordException();
      } else {
        throw GenericAuthException(err.message ?? 'Erro desconhecido.');
      }
    } catch (err) {
      throw GenericAuthException(err.toString());
    }
  }

  // update user profile
  Future<String> updateUserProfile({
    required String uid,
    String? username,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";
    try {
      Map<String, dynamic> updateData = {};

      if (username != null && username.isNotEmpty) {
        updateData['username'] = username;
      }

      if (file != null) {
        String photoURL = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        updateData['photoURL'] = photoURL;
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Google sign in
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Criar credencial do Google
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        
        // Autenticar com Firebase
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Verificar se o usuário já existe no Firestore
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

          if (!userDoc.exists) {
            // Se o usuário não existir no Firestore, cria um novo registro
            model.User newUser = model.User(
              uid: user.uid,
              username: user.displayName ?? '',
              photoURL: user.photoURL ?? 'profilePics/default.jpg',
              email: user.email ?? '',
              foodNiches: [],
              dietaryRestrictions: [],
            );

            await _firestore.collection('users').doc(user.uid).set(
                  newUser.toJson(),
                );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message!, context);
    }
  }


  // logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Por favor, preencha todos os campos";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'Usuário não encontrado.';
      } else if (e.code == 'wrong-password') {
        res = 'Senha incorreta.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.refreshUser();

    if (firebaseUser != null) {
      return const HomePage();
    }
    return RegisterPage();
  }
}
