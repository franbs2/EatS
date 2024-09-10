import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import 'package:http/http.dart' as http;

/// [StorageMethods] - Repositorio responsável por salvar imagem no Firebase.
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// [uploadImageToStorage] - Salva uma imagem no Storage do Firebase.
  ///
  /// - Parâmetros:
  ///   - [childName] (String): O nome da pasta onde a imagem será salva.
  ///   - [name] (String): O nome da imagem a ser salva.
  ///   - [file] (Uint8List): O arquivo da imagem a ser salva.
  ///
  /// - Retorna:
  ///   - [String]: O caminho da imagem salva no Storage do Firebase.

  Future<String> uploadImageToStorage(
    String childName,
    String name,
    Uint8List file,
  ) async {
    // checar se já existe esse nome no firebase
    debugPrint("StorageMethods: iniciando uploadImageToStorage...");
    try {
      var ref =
          await _storage.ref().child(childName).child(name).getDownloadURL();
      debugPrint("StorageMethods: Imagem existe: $ref");

      return "";
    } catch (e) {
      // se não existir, faz upload
      debugPrint("StorageMethods: Imagem não existe");
      Reference ref = _storage.ref().child(childName).child(name);
      debugPrint("StorageMethods: ref: $ref");
      UploadTask uploadTask = ref.putData(file);
      await uploadTask.whenComplete(() => null);

      return "$childName/$name";
    }
  }

  /// [uploadImageUrlToStorage] - Faz upload de uma imagem a partir de uma URL no Storage do Firebase.
  ///
  /// - Parâmetros:
  ///   - [childName] (String): O nome da pasta onde a imagem será salva.
  ///   - [url] (String): A URL da imagem a ser salva.
  ///
  /// - Retorna:
  ///   - [String?]: O caminho da imagem salva no Storage do Firebase, ou null se ocorrer um erro.

  Future<String?> uploadImageUrlToStorage(
    String childName,
    String url,
  ) async {
    // checar se já existe esse nome no firebase
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

  /// [loadImageInMemory] - Carrega uma imagem em memória a partir de um caminho ou URL.
  ///
  /// - Parâmetros:
  ///   - [imagePath] (String): O caminho da imagem a ser carregada.
  ///   - [fromStorage] (bool): Indica se a imagem deve ser carregada a partir do Storage do Firebase.
  ///
  /// - Retorna:
  ///   - [Future<Uint8List>]: A imagem em memória como um [Uint8List].

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

  /// [loadImageInURL] - Retorna a URL da imagem no Storage do Firebase.
  ///
  /// - Parâmetros:
  ///   - [imagePath] (String): O caminho da imagem no Storage do Firebase.
  ///   - [fromStorage] (bool): Indica se a imagem deve ser carregada a partir do Storage do Firebase.
  ///
  /// - Retorna:
  ///   - [Future<String>]: A URL da imagem no Storage do Firebase.
  Future<String> loadImageInURL(String imagePath, bool fromStorage) async {
    if (!fromStorage) {
      return imagePath;
    }
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    var downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  /// [deleteImageAtStorage] - Deleta uma imagem do Storage do Firebase.
  ///
  /// - Parâmetros:
  ///   - [imagePath] (String): O caminho da imagem a ser deletada.
  ///
  /// - Retorna:
  ///   - [Future<void>]: Um futuro que completa quando a imagem é deletada.
  ///
  Future<void> deleteImageAtStorage(String imagePath) async {
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    await ref.delete();
  }

  /// [replaceImageAtStorage] - Substitui uma imagem existente no Storage do Firebase.
  ///
  /// - Parâmetros:
  ///   - [imagePath] (String): O caminho da imagem a ser substitu da.
  ///   - [file] (Uint8List): O arquivo da imagem a ser substitu da.
  ///
  /// - Retorna:
  ///   - [Future<void>]: Um futuro que completa quando a imagem   substitu da.
  ///
  Future<void> replaceImageAtStorage(String imagePath, Uint8List file) async {
    var ref = FirebaseStorage.instance.ref().child(imagePath);
    await ref.putData(file);
  }
}
