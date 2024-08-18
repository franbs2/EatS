import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String photoURL;
  final List<String> dietaryRestrictions;
  final List<String> foodNiches;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.photoURL,
    required this.dietaryRestrictions,
    required this.foodNiches,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "photoURL": photoURL,
        "username": username,
        "dietaryRestrictions": dietaryRestrictions,
        "foodNiches": foodNiches,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      photoURL: snapshot['photoURL'] ?? '',
      dietaryRestrictions: List<String>.from(snapshot['dietaryRestrictions'] ?? []),
      foodNiches: List<String>.from(snapshot['foodNiches'] ?? []),
    );
  }
}
