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

  /// Construtor do widget que aceita um nome de usuário opcional.
  /// Se o nome de usuário não for fornecido, o valor padrão será [Username].
  const TextUsernameWidget({super.key, this.username = StringsApp.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: const TextStyle(
        color: Color(0xff624242),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
