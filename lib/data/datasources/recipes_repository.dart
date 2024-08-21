import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/recipes.dart';

class RecipesRepository {
  final FirebaseFirestore _firestore;

  RecipesRepository(this._firestore);

// método para buscar as receitas no firebase
  Future<List<Recipes>> getRecipes() async {
    var recipesCollection = _firestore.collection('recipes');
    var querySnapshot = await recipesCollection.get();
    return querySnapshot.docs.map((doc) => Recipes.fromFirestore(doc)).toList();
  }
}