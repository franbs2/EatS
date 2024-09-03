import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String photoURL;
  final List<String> dietaryRestrictions;
  final List<String> foodNiches;
  final bool onboarding;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.photoURL,
    required this.dietaryRestrictions,
    required this.foodNiches,
    required this.onboarding,
  });

  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? photoURL,
    List<String>? dietaryRestrictions,
    List<String>? foodNiches,
    bool? onboarding,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      photoURL: photoURL ?? this.photoURL,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      foodNiches: foodNiches ?? this.foodNiches,
      onboarding: onboarding ?? this.onboarding,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "photoURL": photoURL,
        "username": username,
        "dietaryRestrictions": dietaryRestrictions,
        "foodNiches": foodNiches,
        "onboarding": onboarding,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      photoURL: snapshot['photoURL'] ?? '',
      dietaryRestrictions:
          List<String>.from(snapshot['dietaryRestrictions'] ?? []),
      foodNiches: List<String>.from(snapshot['foodNiches'] ?? []),
      onboarding: snapshot['onboarding'] ?? false,
    );
  }
}
