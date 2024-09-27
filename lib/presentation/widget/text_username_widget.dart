import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

/// [TextUsernameWidget] é um widget que exibe um nome de usuário em um texto.
/// Este widget mostra o nome de usuário com um estilo específico.
///
/// - Parâmetros:
///   - [username] (String): O nome de usuário a ser exibido. Se não for fornecido, o valor padrão será 'Username'.
///
/// - Funcionamento:
///   - O widget exibe o texto do nome de usuário com uma cor, tamanho e peso de fonte específicos.
///
/// Referências:
/// - [Text]: Widget do Flutter que exibe uma única linha de texto com estilo.
/// - [TextStyle]: Classe que define o estilo visual do texto.
class TextUsernameWidget extends StatelessWidget {
  final String username;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  /// Construtor do widget que aceita um nome de usuário opcional.
  /// Se o nome de usuário não for fornecido, o valor padrão será [Username].
  const TextUsernameWidget(
      {super.key,
      this.username = StringsApp.username,
      this.color = const Color(0xff624242),
      this.fontSize = 20,
      this.fontWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
