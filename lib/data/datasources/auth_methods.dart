import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/exceptions/auth_exceptions.dart'; // corrected import statement

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
  
    return model.User.fromSnap(snap);
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
          photoURL: 'profilePics/default.png',
          email: email,
          foodNiches: [],
          dietaryRestrictions: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
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

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);

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
