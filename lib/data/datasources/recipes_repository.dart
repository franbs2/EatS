import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/recipes.dart';

/// [RecipesRepository] - Repositorio responsável por buscar receitas no Firestore.
class RecipesRepository {
  final FirebaseFirestore _firestore;

  RecipesRepository(this._firestore);

  /// [getRecipes] - Retorna uma lista de receitas obtidas do Firestore.
  ///
  /// A lista de receitas [recipesCollection] é retornada como um futuro,
  /// pois a leitura do Firestore é um processo assincrono.
  ///
  /// - Retorna: Uma lista de receitas.

  Future<List<Recipes>> getRecipes() async {
    var recipesCollection = _firestore.collection('recipes');
    var querySnapshot = await recipesCollection.get();
    return querySnapshot.docs.map((doc) => Recipes.fromFirestore(doc)).toList();
  }
}
