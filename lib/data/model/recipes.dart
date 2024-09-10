import 'package:cloud_firestore/cloud_firestore.dart';

/// [Recipes] - Model para armazenar os dados das receitas no Firestore.
class Recipes {
  final String name;
  final List<String> category;
  final String image;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  final double value;

  Recipes({
    required this.image,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.name,
    required this.category,
    required this.rating,
    required this.value,
  });

  /// [fromFirestore] - Cria uma instância de [Recipes] a partir de um documento do Firestore.
  factory Recipes.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Recipes(
      name: data['name'] ?? '',
      category: List<String>.from(data['category']),
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients']),
      steps: List<String>.from(data['steps']),
      rating: (data['rating'] ?? 0.0).toDouble(),
      value: (data['value'] ?? 0.0).toDouble(),
    );
  }
}
