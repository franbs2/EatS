import 'package:flutter/material.dart';

import '../../core/style/strings_app.dart';

/// [ContinueWithWidget] é um widget que exibe um texto centralizado com linhas de separação estilizadas em ambos os lados.
///
/// - Objetivo:
///   - Este widget é usado para separar seções de uma tela, como uma seção de login ou um formulário, com uma mensagem centralizada que indica uma ação alternativa (por exemplo, "Ou continue com").
///
/// - Estrutura:
///   - O widget usa um [Row] para posicionar os elementos horizontalmente.
///   - Inclui duas linhas estilizadas usando [Container] com gradientes lineares, e um texto centralizado.
///
class ContinueWithWidget extends StatelessWidget {
  /// Construtor do widget, com a chave opcional para identificar o widget na árvore.
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // Utiliza o widget Row para posicionar seus filhos horizontalmente.
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(left: 30.0, right: 10.0),
          ),
        ),
        const Text(
          StringsApp.orContinue,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(left: 10.0, right: 30.0),
          ),
        ),
      ],
    );
  }
}
