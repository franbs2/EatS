import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //salvar imagem no firebase
  Future<String> uploadImageToStorage(
      String childName,
      String name,
      Uint8List file,
      
      ) async {    
    // checar se já existe esse nome no firebase
    debugPrint("StorageMethods: iniciando uploadImageToStorage...");
    try {
       var ref = await _storage.ref().child(childName).child(name).getDownloadURL();
      debugPrint("StorageMethods: Imagem existe: $ref");

      return "";
    } catch (e) {

      debugPrint("StorageMethods: Imagem não existe");
      Reference ref =
          _storage.ref().child(childName).child(name);
      debugPrint("StorageMethods: ref: $ref");
      UploadTask uploadTask = ref.putData(file);
      await uploadTask.whenComplete(() => null);

      return "$childName/$name";
    }  
  }

  //salvar imagem de URL no firebase
  Future<String?> uploadImageUrlToStorage(
    String childName,
    String url,
  ) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(response.bodyBytes);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Uint8List> loadImageInMemory(
      String imagePath, bool fromStorage) async {
    if (!fromStorage) {
      var response = await http.get(Uri.parse(imagePath));
      return response.bodyBytes;
    } else {
      var ref = FirebaseStorage.instance.ref().child(imagePath);
      var downloadUrl = await ref.getDownloadURL();
      var response = await http.get(Uri.parse(downloadUrl));
      return response.bodyBytes;
    }
  }

  Future<String> loadImageInURL(String imagePath, bool fromStorage) async {
    if (!fromStorage) {
      return imagePath;
    }
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    var downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImageAtStorage(String imagePath) async {
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    await ref.delete();
  }

  Future<void> replaceImageAtStorage(String imagePath, Uint8List file) async {
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    await ref.putData(file);
  }
}
