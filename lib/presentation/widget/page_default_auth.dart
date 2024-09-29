import 'package:flutter/material.dart';

import '../../core/style/images_app.dart';

/// [PageDefaultAuth] é um widget que define uma estrutura de tela padrão para páginas de autenticação.
/// Este widget inclui um cabeçalho com um gradiente de cor e um corpo configurável.
///
/// - Parâmetros:
///   - [size] ([double]): Define a altura do cabeçalho como uma fração da altura total da tela. O valor padrão é 0.3.
///   - [body] ([Widget]): O widget que será exibido dentro do corpo da tela. Deve ser um widget que representa o conteúdo principal da página.
///
/// - Funcionamento:
///   - O cabeçalho possui um gradiente de cor que vai do canto inferior esquerdo para o superior direito, com um logotipo centralizado no topo.
///   - O corpo é exibido abaixo do cabeçalho e é configurável, podendo receber qualquer widget passado como argumento.
///   - O layout utiliza uma estrutura de [Stack] para sobrepor o cabeçalho e o corpo, criando uma transição suave entre ambos.
///
/// Referências:
/// - [ImageApp]: Classe que gerencia as imagens do aplicativo, incluindo o logotipo exibido no cabeçalho.
/// - [Scaffold]: Widget que fornece a estrutura básica de layout para a tela, incluindo o gerenciamento de barras de aplicação e de corpo.
/// - [Stack]: Widget que permite sobrepor widgets na tela.
class PageDefaultAuth extends StatelessWidget {
  /// Define a altura do cabeçalho como uma fração da altura total da tela.
  final double size;

  /// O widget que será exibido dentro do corpo da tela.
  final Widget body;

  /// Construtor do widget, que exige o corpo da tela e permite configurar a altura do cabeçalho.
  const PageDefaultAuth({
    super.key,
    required this.body,
    this.size = 0.3, // Valor padrão para o tamanho do cabeçalho.
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter, // Alinha o conteúdo ao topo da tela.
        children: [
          Container(
            // Define o cabeçalho com um gradiente e uma altura proporcional à tela.
            height: MediaQuery.of(context).size.height * size,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                // Gradiente que vai do canto inferior esquerdo para o superior direito.
                begin: Alignment.bottomLeft,
                colors: [
                  Color(0xffEFC136),
                  Color(0xff539F33)
                ], // Cores do gradiente.
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(ImageApp.logoWhite),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  // Configura o corpo da tela, que aparece abaixo do cabeçalho.
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: body, // Exibe o widget passado como corpo da tela.
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
