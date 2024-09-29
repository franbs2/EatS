import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

/// [TitleInitialWidget] é um widget que exibe um título e um subtítulo.
///
/// - Parâmetros:
///   - [title] (String): O título principal a ser exibido. Este texto é mostrado em fonte maior e negrito.
///   - [subtitle] (String): O subtítulo a ser exibido abaixo do título. Este texto é mostrado em fonte menor e com uma cor específica.
///   - [space] (double, opcional): O espaçamento vertical entre o título e o subtítulo. O valor padrão é 8.0.
///
/// - Funcionamento:
///   - O widget usa um [Column] para empilhar o título e o subtítulo verticalmente.
///   - O título é exibido com um estilo de texto em negrito e tamanho 22.
///   - O subtítulo é exibido com um estilo de texto em tamanho 16 e cor definida por [AppTheme.textInitial].
///
/// Referências:
/// - [AppTheme]: Classe que define temas e estilos para o aplicativo.


class TitleInitialWidget extends StatelessWidget {
  /// O título principal a ser exibido pelo widget.
  final String title;

  /// O subtítulo a ser exibido abaixo do título.
  final String subtitle;

  /// O espaçamento vertical entre o título e o subtítulo. O valor padrão é 8.0.
  final double space;

  /// Construtor do widget que exige um título e um subtítulo, e permite definir o espaçamento.
  const TitleInitialWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.space = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: space),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textInitial,
          ),
        ),
      ],
    );
  }
}
