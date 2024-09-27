import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/widget/text_username_widget.dart';
import 'package:flutter/material.dart';

/// [TextUsernameInputWidget] é um widget que exibe um campo de entrada de texto para o nome de usuário.
/// Este widget é usado para capturar o nome de usuário do usuário e exibe um texto de dica quando o campo está vazio.
///
/// - Parâmetros:
///   - [controller] ([TextEditingController]): Controlador do campo de texto que gerencia o estado do texto inserido pelo usuário.
///
/// - Funcionamento:
///   - O widget adiciona um listener ao controlador de texto para atualizar o estado do widget quando o texto mudar.
///   - Quando o campo de texto está vazio, um texto de dica ([StringsApp.username]) é exibido no campo.
///   - Quando o campo de texto possui algum texto, o texto de dica desaparece, e o texto inserido pelo usuário é exibido.
///
/// Referências:
/// - [StringsApp]: Classe que contém strings de texto usadas em várias partes do aplicativo.
/// - [TextEditingController]: Controlador que gerencia o texto no campo de entrada.

class TextUsernameInputWidget extends StatefulWidget {
  /// Controlador do campo de texto que gerencia o estado do texto inserido pelo usuário.
  final TextEditingController controller;

  const TextUsernameInputWidget({
    super.key,
    required this.controller,
  });

  @override
  State<TextUsernameInputWidget> createState() =>
      _TextUsernameInputWidgetState();
}

class _TextUsernameInputWidgetState extends State<TextUsernameInputWidget> {
  @override
  void initState() {
    super.initState();
    // Adiciona um listener ao controlador de texto para atualizar o estado quando o texto mudar.
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove o listener do controlador de texto quando o widget é descartado.
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// Atualiza o estado do widget quando o texto no controlador muda.
  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Exibe o texto de dica quando o campo de texto está vazio.
        if (widget.controller.text.isEmpty)
          const TextUsernameWidget(
            username: StringsApp.username,
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        // Campo de entrada de texto.
        TextFormField(
          enableSuggestions: false,
          cursorColor: AppTheme.perfilYellow,
          controller: widget.controller,
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          style: const TextStyle(
              color: Color(0xff624242),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
