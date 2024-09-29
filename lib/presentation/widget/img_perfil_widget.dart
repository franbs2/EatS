import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';

/// [ImgPerfilWidget] é um widget que exibe a imagem de perfil do usuário.
/// Este widget mostra a imagem carregada a partir de um [Uint8List] que representa
/// a imagem em memória, utilizando o [Provider] para obter a imagem do perfil.
///
/// - Funcionamento:
///   - Se a imagem do perfil estiver disponível, ela será exibida com um contorno arredondado.
///   - Caso contrário, um placeholder cinza é mostrado no lugar da imagem.
///   - Em caso de erro ao carregar a imagem, o placeholder é exibido.
///
/// - Parâmetros:
///   - Este widget não possui parâmetros diretos, mas depende do [UserProvider]
///     para obter a imagem de perfil do usuário.
///
/// Referências:
/// - [UserProvider]: Provider que gerencia o estado do usuário e fornece a imagem de perfil.

class ImgPerfilWidget extends StatelessWidget {
  /// Construtor do widget de imagem de perfil.
  const ImgPerfilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém a imagem de perfil a partir do UserProvider.
    final profileImage = Provider.of<UserProvider>(context).profileImage;

    // Verifica se a imagem de perfil é nula e exibe o placeholder caso seja.
    if (profileImage == null) {
      return _buildPlaceholder();
    }

    // Exibe a imagem de perfil com bordas arredondadas.
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Image.memory(
        profileImage, // Carrega a imagem de perfil a partir da memória.
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Exibe o placeholder caso ocorra um erro ao carregar a imagem.
          return _buildPlaceholder();
        },
      ),
    );
  }

  /// Constrói um placeholder para ser exibido quando a imagem de perfil
  /// não estiver disponível ou ocorrer um erro ao carregá-la.
  ///
  /// - Funcionamento:
  ///   - Exibe um container cinza com bordas arredondadas para indicar
  ///     a ausência da imagem de perfil.
  ///
  /// - Retorno:
  ///   - Retorna um widget [ClipRRect] contendo um [Container] cinza
  ///     com bordas arredondadas.
  Widget _buildPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        color: Colors.grey, // Cor de fundo do placeholder.
        width: 52,
        height: 52,
      ),
    );
  }
}
