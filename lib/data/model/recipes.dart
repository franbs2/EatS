import 'package:cloud_firestore/cloud_firestore.dart';

/// [Recipes] - Model para armazenar os dados das receitas no Firestore.
class Recipes {
  final String id;
  final String name;
  final List<String> category;
  late final String image;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  final double value;
  final String? authorId;
  bool? blocked;
  bool? public;

  Recipes({
    required this.id,
    required this.image,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.name,
    required this.category,
    required this.rating,
    required this.value,
    this.public,
    this.blocked,
    this.authorId,
  });

  /// [fromFirestore] - Cria uma instância de [Recipes] a partir de um documento do Firestore.
  factory Recipes.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Recipes(
      id: doc.id,
      name: data['name'] ?? '',
      category: List<String>.from(data['category']),
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients']),
      steps: List<String>.from(data['steps']),
      rating: (data['rating'] ?? 0.0).toDouble(),
      value: (data['value'] ?? 0.0).toDouble(),
      authorId: data['authorId'] ?? '',
      public: data['public'] ?? true,
      blocked: data['blocked'] ?? false,
    );
  }

  /// [toMap] - Retorna um Map com todos os campos da receita, pronto para ser salvo no Firestore.
  ///
  /// - Retorna um Map<String, Object> com todos os campos da receita.
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'rating': rating,
      'value': value,
      'authorId': authorId ?? '',
      'public': public ?? true,
      'blocked': blocked ?? false,
    };
  }

  /// [changeVisibility] - Altera a visibilidade da receita para o valor especificado.
  ///
  /// - Parâmetros:
  ///   - [willPublic] ([bool]): Se verdadeiro, a receita será tornada pública.
  ///     Caso contrário, a receita será tornada privada.
  ///
  void changeVisibility(bool willPublic) {
    public = willPublic;
  }
}
