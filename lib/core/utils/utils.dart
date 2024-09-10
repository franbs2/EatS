import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// [pickImage] - Função para escolher imagem de acordo do usuário.
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

/// [showSnackBar] - Função para mostrar uma snackbar.
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
