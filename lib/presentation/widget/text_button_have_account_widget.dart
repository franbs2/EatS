import 'package:flutter/material.dart';

/// [TextButtonHaveAccountWidget] é um widget que exibe um botão de texto centralizado entre duas linhas horizontais.
/// Este widget é útil para criar uma interface onde o usuário pode ver uma opção como "Já tem uma conta?" com um botão centralizado.
///
/// - Parâmetros:
///   - [title] (String): O texto a ser exibido no botão. Deve ser uma string que descreve a ação ou a mensagem desejada.
///   - [onPressed] (VoidCallback?): A função a ser chamada quando o botão é pressionado. Pode ser nulo se nenhuma ação for associada ao botão.
///
/// - Funcionamento:
///   - O widget exibe um [Row] contendo duas linhas horizontais com um botão de texto centralizado entre elas.
///   - As linhas horizontais são criadas usando [Container] com [BoxDecoration] para aplicar um gradiente que cria o efeito de linha.
///   - O botão de texto é estilizado com uma cor de texto e um tamanho de fonte específicos.
///
/// Referências:
/// - [TextButton]: Um widget de botão de texto que responde a toques.
/// - [TextStyle]: Define a aparência do texto exibido no botão.
/// - [BoxDecoration]: Usado para decorar o `Container` e criar as linhas horizontais com gradiente.

class TextButtonHaveAccountWidget extends StatelessWidget {
  /// O texto a ser exibido no botão.
  final String title;

  /// A função a ser chamada quando o botão é pressionado.
  final VoidCallback? onPressed;

  /// Construtor do widget que exige o título e o callback para o botão.
  const TextButtonHaveAccountWidget(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    // Cria um botão de texto centralizado entre duas linhas horizontais.
    return Row(
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
            margin: const EdgeInsets.only(
              left: 30.0,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff8D8D8D),
              fontSize: 14,
            ),
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
            margin: const EdgeInsets.only(right: 30.0),
          ),
        ),
      ],
    );
  }
}
