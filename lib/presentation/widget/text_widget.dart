import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

/// [TextInputWidget] é um widget personalizado que representa um campo de entrada de texto.
///
/// - Parâmetros:
///   - [hint] ([String]): O texto que será exibido como dica no campo de entrada, quando ele estiver vazio.
///   - [controller] ([TextEditingController]?): O controlador para o campo de texto, opcional. Permite manipular o texto exibido.
///   - [validator] ([FormFieldValidator]<String>?): A função de validação para o campo de texto, opcional. Usada para validar a entrada do usuário.
///
/// - Funcionamento:
///   - O campo de entrada exibe um texto de dica (hint) quando não há texto inserido.
///   - O estilo do campo é ajustado com base no estado de foco:
///     - [enabledBorder]: Define a borda quando o campo está habilitado e não focado.
///     - [focusedBorder]: Define a borda quando o campo está focado.
///   - O estilo do texto inserido é personalizado.
///
/// Referências:
/// - [TextFormField]: O widget base usado para criar o campo de entrada de texto com validação.
/// - [AppTheme]: Classe que define as cores usadas no aplicativo. O [primaryColor] é utilizado para a borda quando o campo está focado.

class TextInputWidget extends StatelessWidget {
  /// O texto que será exibido como dica no campo de entrada.
  final String hint;

  /// O controlador para o campo de texto. Permite manipular o texto exibido.
  final TextEditingController? controller;

  /// A função de validação para o campo de texto. Usada para validar a entrada do usuário.
  final FormFieldValidator<String>? validator;

  /// Construtor do widget que exige o texto da dica e permite a configuração opcional do controlador e da função de validação.
  const TextInputWidget(
      {super.key, this.controller, this.validator, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 73, 139, 45),
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(
        color: Color(0xff2f4b4e),
      ),
    );
  }
}
