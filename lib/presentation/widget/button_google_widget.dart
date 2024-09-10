import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/images_app.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:eats/data/datasources/auth_methods.dart';

/// Widget personalizado para um botão de login com Google.
///
/// Este widget representa um botão estilizado que permite aos usuários fazer login usando sua conta Google.
/// Utiliza o [ElevatedButton] do Flutter para criar o botão e aplica estilos personalizados,
/// além de incluir um ícone e texto descritivo.
///
/// Referências:
/// - `ElevatedButton`: Widget do Flutter que cria um botão elevado com sombra.
/// - `AuthMethods`: Classe que gerencia a autenticação, incluindo o login com Google.
/// - `AppTheme.primaryColor`: Cor primária definida no tema do aplicativo.
/// - `ImageApp.googleIcon`: Caminho para o ícone do Google.
/// - `StringsApp.singUpGoogle`: Texto a ser exibido no botão.
class ButtonGoogleWidget extends StatelessWidget {
  const ButtonGoogleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria um botão estilizado com um ícone e um texto descritivo.
    return ElevatedButton(
      onPressed: () {
        // Chama o método de login com Google ao clicar no botão.
        context.read<AuthMethods>().signInWithGoogle(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppTheme.primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(ImageApp.googleIcon),
            fit: BoxFit.fill,
            height: 24,
          ),
          Text(
            StringsApp.singUpGoogle, // Texto exibido no botão.
            style: TextStyle(
              color: Color(0xff2f4b4e),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
