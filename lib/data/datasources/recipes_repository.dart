import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/recipes.dart';

/// [RecipesRepository] - Repositorio responsável por buscar receitas no Firestore.
class RecipesRepository {
  final FirebaseFirestore _firestore;

  RecipesRepository(this._firestore);

  /// [getRecipes] - Retorna uma lista de receitas obtidas do Firestore.
  ///
  /// O parâmetro [searchValue] é opcional e serve para filtrar as receitas
  /// com base no nome. Se [searchValue] for nulo, todas as receitas do
  /// Firestore são retornadas. Caso contrário, apenas as receitas cujo nome
  /// contenha as palavras chave especificadas em [searchValue] são retornadas.
  ///
  /// A lista de receitas [recipesCollection] é retornada como um futuro,
  /// pois a leitura do Firestore é um processo assincrono.
  ///
  /// - Retorna: Uma lista de receitas.
  Future<List<Recipes>> getRecipes(String? query) async {
    // Recupera todas as receitas com public = true e que n tem a coluna blocked
    Query<Map<String, dynamic>> recipesCollection = _firestore
        .collection('recipes')
        .where('public', isEqualTo: true)
        .where('blocked', isEqualTo: false);

    // Obtém todos os documentos da coleção
    var querySnapshot = await recipesCollection.get();

    // Mapeia os documentos para uma lista de objetos Recipes
    var allRecipes =
        querySnapshot.docs.map((doc) => Recipes.fromFirestore(doc)).toList();

    if (query == null || query.isEmpty) {
      // Se searchValue for nulo ou vazio, retorna todas as receitas
      return allRecipes;
    } else {
      // Caso contrário, filtra os resultados localmente no lado do cliente
      var searchValues =
          query.toLowerCase().split(" ").map((e) => e.trim()).toList();

      // Retorna apenas as receitas que contêm todas as palavras de searchValue no nome
      return allRecipes.where((recipe) {
        return searchValues
            .every((value) => recipe.name.toLowerCase().contains(value));
      }).toList();
    }
  }

  Future<List<Recipes>> getMyRecipes(String id) async {
    Query<Map<String, dynamic>> recipesCollection =
        _firestore.collection('recipes').where('authorId', isEqualTo: id);
    var querySnapshot = await recipesCollection.get();
    var allRecipes =
        querySnapshot.docs.map((doc) => Recipes.fromFirestore(doc)).toList();
    return allRecipes;
  }

  Future<Recipes> saveRecipe(Recipes recipe) async {
    // Referência ao documento da receita no Firestore
    var docRef = _firestore.collection('recipes').doc(recipe.id);

    // Verifica se a receita com o ID já existe
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Se o documento existir, atualiza a receita existente
      await docRef.update(recipe.toMap());
    } else {
      // Caso o documento não exista, cria uma nova receita
      await docRef.set(recipe.toMap());
    }

    return recipe;
  }

  // Criar denuncia de receita
  Future<void> reportRecipe(String recipeId, String userId) async {
    // Criar instancia de denuncia de receita

    var docRefReport =
        _firestore.collection('recipe_reports').doc("${recipeId}_report");

    var docSnapshot = await docRefReport.get();

    if (docSnapshot.exists) {
      if (!docSnapshot.data()!['list_uids'].contains(userId)) {
        // Se o documento existir, atualiza a receita existente
        await docRefReport.update({
          'reports': FieldValue.increment(1),
          'list_uids': FieldValue.arrayUnion([userId]),
        });

        if (docSnapshot.data()!['reports'] >= 5) {
          // Se o documento existir, atualiza a receita existente
          var docRecipe = _firestore.collection('recipes').doc(recipeId);
          await docRecipe.update({
            'blocked': true,
          });
        }
      } else {
        throw Exception("Receita ja foi denunciada");
      }
    } else {
      // Caso o documento não exista, cria uma nova receita
      await docRefReport.set({
        'reports': FieldValue.increment(1),
        'list_uids': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
