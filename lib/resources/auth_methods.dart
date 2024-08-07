import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {

        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoURL = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);

        // add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'dietaryRestrictions': [],
          'foodNiches': [],
          'photoURL': photoURL,
        });

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'O endereço de email possui um formato inválido.';
      } else if (err.code == 'weak-password') {
        res = 'A senha deve ter pelo menos 6 caracteres.';
      }
    }
    catch (err) {
      res = err.toString();
    }
    return res;
  }
}