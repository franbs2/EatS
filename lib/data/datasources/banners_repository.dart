import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/banners.dart';

/// [BannersRepository] - Repositorio responsável por buscar banners no Firestore.
class BannersRepository {
  final FirebaseFirestore _firestore;

  BannersRepository(this._firestore);

  /// [getBanners] - Retorna uma lista de banners do Firestore.
  ///
  /// A lista de banners [bannersCollection] é retornada como um futuro, pois a leitura do Firestore é um processo assincrono.
  ///
  /// Retorna:
  ///   Uma lista de [Banners] carregados do Firestore.

  Future<List<Banners>> getBanners() async {
    var bannersCollection = _firestore.collection('banners');
    var querySnapshot = await bannersCollection.get();
    return querySnapshot.docs.map((doc) => Banners.fromFirestore(doc)).toList();
  }
}
