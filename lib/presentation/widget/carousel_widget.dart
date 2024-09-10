import 'package:carousel_slider/carousel_slider.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/data/model/banners.dart';
import 'package:flutter/material.dart';

/// [CarouselWidget] é um widget que exibe um carrossel de banners em um slider.
///
/// Parâmetros:
///   - [banners] ([List<Banners>]): Lista de banners a serem exibidos no carrossel.
///   Cada banner é um objeto da classe [Banners].
///
/// Funcionamento:
///   - O widget utiliza o [CarouselSlider] para criar um carrossel de imagens.
///   - Cada banner é exibido com uma imagem carregada de uma URL.
///   - O estado de carregamento da imagem é gerenciado com [FutureBuilder].
///
/// Referências:
/// - [CarouselSlider](https://pub.dev/packages/carousel_slider): Pacote para criar carrosséis de imagens no Flutter.
/// - [StorageMethods]: Classe que contém métodos para manipulação de armazenamento e carregamento de imagens.
/// - [Banners]: Modelo de dados que define a estrutura de um banner.
class CarouselWidget extends StatelessWidget {
  /// Lista de banners a serem exibidos no carrossel.
  final List<Banners> banners;

  /// Construtor do widget que exige uma lista de banners.
  const CarouselWidget({required this.banners, super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia o método de armazenamento para carregar a imagem do banner.
    final StorageMethods storageMethods = StorageMethods();

    return CarouselSlider(
      items: banners
          .map((banner) => Padding(
                // Adiciona um preenchimento ao redor do item do carrossel.
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FutureBuilder<String>(
                  // Constrói o widget com base no estado do futuro.
                  future: storageMethods.loadImageInURL(
                    banner.image, // URL da imagem do banner.
                    true, // Indica que a imagem deve ser carregada.
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Exibe um indicador de carregamento enquanto a imagem está sendo carregada.
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey.shade200,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      // Exibe uma mensagem de erro se ocorrer um problema ao carregar a imagem.
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors
                              .grey.shade200, // Cor de fundo quando há erro.
                        ),
                        child: const Center(
                            child: Text(StringsApp.errorLoadImage)),
                      );
                    } else {
                      // Exibe a imagem do banner quando estiver carregada.
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          snapshot.data ?? '', // URL da imagem.
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: double.infinity,
                        ),
                      );
                    }
                  },
                ),
              ))
          .toList(),
      options: CarouselOptions(
        height:
            MediaQuery.of(context).size.height * 0.2, // Altura do carrossel.
        aspectRatio: 16 / 9, // Proporção do carrossel.
        viewportFraction: 1, // Fração da largura da tela que o carrossel ocupa.
        initialPage: 0, // Página inicial do carrossel.
        autoPlay: true, // Habilita a reprodução automática das imagens.
        enableInfiniteScroll: true, // Habilita a rotação infinita das imagens.
        enlargeCenterPage: true, // Amplia a imagem central.
        enlargeFactor: 0.3, // Fator de ampliação da imagem central.
      ),
    );
  }
}
