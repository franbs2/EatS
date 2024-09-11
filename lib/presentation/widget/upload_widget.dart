import 'dart:typed_data';

import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/images_app.dart';
import 'package:flutter/material.dart';

/// [UploadWidget] é um widget que exibe uma área para upload de imagem.
///
/// - Parâmetros:
///   - [ontap] ([VoidCallback]): Função de callback que é chamada quando o widget é clicado.
///   - [backgroundImage] ([Uint8List]?): Opcional. Lista de bytes que representa a imagem de fundo. Se não fornecida, será usada uma cor de fundo padrão.
///
/// - Funcionamento:
///   - O widget exibe um [Container] com uma altura de 50% da altura da tela e largura total.
///   - Se [backgroundImage] não for nulo, a imagem é exibida como plano de fundo do [Container]. Caso contrário, uma cor de fundo cinza claro é usada.
///   - No centro do [Container], um [Container] adicional é exibido com um ícone de upload. Este ícone é carregado a partir dos ativos.
///
/// Referências:
/// - [AppTheme]: Classe que contém as cores usadas no aplicativo.
/// - [ImageApp]: Classe que define o caminho do ícone de upload.

class UploadWidget extends StatelessWidget {
  /// Função de callback que é chamada quando o widget é clicado.
  final VoidCallback ontap;

  /// Lista de bytes que representa a imagem de fundo. Pode ser nula.
  final Uint8List? backgroundImage;

  /// Construtor do widget que exige a função [ontap] e opcionalmente a [backgroundImage].
  const UploadWidget({super.key, required this.ontap, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Define o comportamento ao clicar no widget.
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundImage == null
              ? AppTheme.backgroundColor // Cor de fundo padrão se nenhuma imagem for fornecida.
              : AppTheme.backgroundColor, // Cor de fundo alternativa para quando a imagem é fornecida.
          image: backgroundImage != null
              ? DecorationImage(
                  image: MemoryImage(
                      backgroundImage!), // Imagem de fundo quando fornecida.
                  fit: BoxFit.cover,
                )
              : null, // Sem imagem de fundo se [backgroundImage] for nulo.
        ),
        child: Center(
          child: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.secondaryColor,
            ),
            child: const Image(
              image: AssetImage(ImageApp.uploadIcon),
            ),
          ),
        ),
      ),
    );
  }
}
