import 'package:flutter/material.dart';

import '../../core/style/color.dart';

/// [TextPasswordInputWidget] é um widget que exibe um campo de entrada de senha.
///
/// Este widget permite a entrada de senhas com a funcionalidade de ocultar ou exibir o texto da senha,
/// e inclui validação e um controlador opcional para gerenciar o texto da entrada.
///
/// - Parâmetros:
///   - [hint] (String): Texto sugestivo que aparece no campo quando ele está vazio.
///   - [controller] ([TextEditingController]?) (opcional): Controlador para gerenciar o texto da entrada.
///   - [validator] ([FormFieldValidator]?) (opcional): Função para validar o texto da entrada.
///
/// - Funcionamento:
///   - O campo de senha oculta o texto por padrão e permite alternar a visibilidade através de um ícone de visibilidade.
///   - A borda do campo muda de cor quando está focado, com um estilo personalizado para bordas.
///   - O ícone de visibilidade permite ao usuário alternar entre ver e ocultar o texto da senha.
///
/// Referências:
/// - [AppTheme]: Classe que define o tema e as cores utilizadas no aplicativo.

class TextPasswordInputWidget extends StatefulWidget {
  /// Texto sugestivo exibido no campo quando está vazio.
  final String hint;

  /// Controlador opcional para gerenciar o texto da entrada.
  final TextEditingController? controller;

  /// Função opcional para validar o texto da entrada.
  final FormFieldValidator<String>? validator;

  /// Construtor do widget que exige um texto sugestivo e permite a configuração de controlador e validador.
  const TextPasswordInputWidget(
      {super.key, this.controller, this.validator, required this.hint});

  @override
  State<TextPasswordInputWidget> createState() =>
      _TextPasswordInputWidgetState();
}

class _TextPasswordInputWidgetState extends State<TextPasswordInputWidget> {
  /// Estado que controla se o texto da senha deve ser oculto.
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 1.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.0,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Define o ícone de visibilidade baseado no estado de _obscureText.
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppTheme.primaryColor,
          ),
          onPressed: () {
            // Função que será executada quando o botão de visibilidade for pressionado.
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      style: const TextStyle(
        color: Color(0xff2f4b4e),
      ),
    );
  }
}
