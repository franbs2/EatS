import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Uint8List> loadImageInMemory(String imagePath, bool fromStorage) async {
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

  //salvar imagem do google no firebase
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
}
