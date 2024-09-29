import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../core/style/images_app.dart';

/// [StarRating] é um widget que exibe uma avaliação por estrelas.
/// Este widget mostra uma classificação baseada em um valor de rating fornecido.
///
/// - Parâmetros:
///   - [rating] ([double]): A avaliação numérica a ser exibida pelo widget, variando de 0 a 5.
///
/// - Funcionamento:
///   - O widget utiliza o [RatingBar.builder] para exibir estrelas de avaliação.
///   - A classificação inicial é definida pelo parâmetro [rating], que é um valor decimal.
///   - As estrelas são exibidas horizontalmente, com possibilidade de mostrar classificações inteiras e fracionadas.
///   - As estrelas são renderizadas usando um ícone de estrela personalizado definido em [ImagesApp].
///   - O widget é configurado para ser somente leitura, desativando a interação com gestos.
///
/// Referências:
/// - [RatingBar.builder]: Widget usado para construir uma barra de avaliação com comportamento personalizável.
/// - [ImagesApp]: Classe que contém os caminhos das imagens usadas no aplicativo, incluindo o ícone da estrela.

class StarRating extends StatelessWidget {
  /// A avaliação numérica a ser exibida.
  final double rating;

  /// Construtor do widget que exige uma avaliação.
  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      // Define a classificação inicial exibida pelas estrelas.
      initialRating: rating,
      // Define o tamanho das estrelas.
      itemSize: 24,
      // Define a avaliação mínima que pode ser exibida.
      minRating: 0,
      // Define a direção da barra de avaliação.
      direction: Axis.horizontal,
      // Permite a exibição de avaliações com meia estrela.
      allowHalfRating: true,
      // Desabilita gestos de interação para impedir que a classificação seja alterada.
      ignoreGestures: true,
      // Define o número total de estrelas a serem exibidas.
      itemCount: 5,
      // Define o espaçamento horizontal entre as estrelas.
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      // Constrói cada item da barra de avaliação com um ícone de estrela.
      itemBuilder: (context, _) => Image.asset(
        ImageApp.starIcon, // Caminho do ícone da estrela.
        // ignore: no_wildcard_variable_uses
        color: _ < rating ? null : Colors.grey, // Define a cor da estrela com base na avaliação.
      ),
      // Função chamada ao atualizar a classificação, sem ação neste caso.
      onRatingUpdate: (rating) {},
    );
  }
}
