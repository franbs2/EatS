import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

/// Um widget de botão personalizado para ser utilizado em diversas partes do aplicativo.
///
/// Este widget utiliza a classe [ElevatedButton] do Flutter para criar um botão com estilo
/// personalizado. Ele permite a personalização da cor, tamanho e ação do botão.
class ButtonDefaultlWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  /// Construtor do [ButtonDefaultlWidget].

  /// @param text - O texto a ser exibido no botão.
  /// @param color - A cor de fundo do botão. O padrão é [AppTheme.primaryColor].
  /// @param onPressed - A função a ser chamada quando o botão é pressionado. Pode ser nula.
  /// @param width - A largura do botão como uma fração da largura da tela. O padrão é 0.3.
  /// @param height - A altura do botão em pixels. O padrão é 20.
  const ButtonDefaultlWidget({
    super.key,
    required this.text,
    this.color = AppTheme.primaryColor,
    this.onPressed,
    this.width = 0.3,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          onPressed, // Ação a ser realizada quando o botão é pressionado.
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * width,
            vertical: height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        text, // O texto exibido no botão.
        style: const TextStyle(
            fontSize: 16,
            color: AppTheme.secondaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
