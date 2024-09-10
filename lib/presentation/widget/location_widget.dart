import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

import '../../core/style/images_app.dart';

/// [LocationWidget] é um widget que exibe a localização do usuário.
/// Este widget mostra um texto indicando a localidade e um ícone associado.
///
/// - Funcionamento:
///   - O widget é estilizado com um fundo escuro, bordas arredondadas, e espaçamento interno para organizar o conteúdo.
///   - Apresenta o nome da localização e um ícone ao lado, usando uma combinação de textos e imagens.
///   - Este widget utiliza strings definidas externamente em [StringsApp] para exibir o texto da localização.
///
/// Referências:
/// - [StringsApp]: Classe que contém as strings usadas na aplicação.

class LocationWidget extends StatelessWidget {
  /// Construtor padrão do widget [LocationWidget].
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0XFF313131),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const FittedBox(
        // Ajusta o conteúdo para caber dentro do espaço disponível, sem estourar.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringsApp.local,
              style: TextStyle(
                color: Color(0xffB7B7B7),
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Text(
                  StringsApp
                      .local, // Localização (TODO: Substituir com a localização do usuário).
                  style: TextStyle(
                    color: Color(0xffDDDDDD),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image(
                  image: AssetImage(ImageApp.statMinusIcon),
                  height: 18,
                  width: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
