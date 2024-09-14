import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/user.dart' as model;
import 'package:eats/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  /// Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Instância do Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtém detalhes do usuário autenticado no Firebase.
  ///
  /// Retorna null se o usuário não estiver autenticado.
  ///
  /// Lança uma exceção se houver um erro ao obter os detalhes do usuário.
  Future<model.User?> getUserDetails() async {
    try {
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

  /// Atualiza o perfil do usuário
  Future<String> updateUserProfile({
    String? username,
    Uint8List? file,
    List<String>? foodNiches,
    List<String>? dietaryRestrictions,
    bool? onboarding,
  }) async {
    final uid = _auth.currentUser!.uid;
    try {
      final updateData = await _prepareUpdateData(
        username,
        file,
        foodNiches,
        dietaryRestrictions,
        onboarding,
      );

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
        return "success";
      }
      return "Nenhuma alteração detectada.";
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Map<String, dynamic>> _prepareUpdateData(
    String? username,
    Uint8List? file,
    List<String>? foodNiches,
    List<String>? dietaryRestrictions,
    bool? onboarding,
  ) async {
    final Map<String, dynamic> updateData = {};
    final user = await getUserDetails();
    final photoURL = user!.photoURL;

    if (username != null && username.isNotEmpty && username != user.username) {
      if (!await _isUsernameValid(username)) {
        throw Exception('Username inválido ou já em uso');
      }
      updateData['username'] = username;
    }

    if (file != null) {
      

      if (photoURL != 'profilePics/default.jpg' &&
          !photoURL.startsWith("http")) {
        debugPrint("AuthMethods: trocando imagem do perfil no Storage");
        await StorageService().replaceImageAtStorage(photoURL, file);
      } else {
        debugPrint("AuthMethods: Adicionando imagem do perfil no Storage");
        await StorageService()
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

    return updateData;
  }

  Future<bool> _isUsernameValid(String username) async {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9\- ]{5,20}$');
    if (!regex.hasMatch(username)) {
      return false;
    }

    final snap = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return snap.docs.isEmpty;
  }

    /// Cria um usuário no Firestore se ele não existir
  Future<model.User?> createUserInFirestoreIfNotExists() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return null;

    final snap = await _firestore.collection('users').doc(currentUser.uid).get();

    if (!snap.exists) {
      final newUser = model.User(
        uid: currentUser.uid,
        username: currentUser.displayName ?? '',
        photoURL: currentUser.photoURL ?? 'profilePics/default.jpg',
        email: currentUser.email ?? '',
        foodNiches: [],
        dietaryRestrictions: [],
        onboarding: currentUser.displayName != null,
      );
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(newUser.toJson());
      return newUser;
    }

    return model.User.fromSnap(snap);
  }

}

