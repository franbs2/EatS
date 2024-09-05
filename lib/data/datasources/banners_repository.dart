import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/model/banners.dart';

class BannersRepository {
  final FirebaseFirestore _firestore;

  BannersRepository(this._firestore);

// método para buscar as receitas no firebase
  Future<List<Banners>> getBanners() async {
    var bannersCollection = _firestore.collection('banners');
    var querySnapshot = await bannersCollection.get();
    return querySnapshot.docs.map((doc) => Banners.fromFirestore(doc)).toList();
  }
}