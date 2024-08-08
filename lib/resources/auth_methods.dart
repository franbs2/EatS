import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/model/user.dart' as model;
import 'package:eats/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
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

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'O endereço de email possui um formato inválido.';
      } else if (err.code == 'weak-password') {
        res = 'A senha deve ter pelo menos 6 caracteres.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
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
