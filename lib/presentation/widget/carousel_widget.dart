import 'package:carousel_slider/carousel_slider.dart';
import 'package:eats/data/datasources/storage_methods.dart';
import 'package:eats/data/model/banners.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({required this.banners, super.key});
  final List<Banners> banners;

  @override
  Widget build(BuildContext context) {
    final StorageMethods storageMethods = StorageMethods();
    return CarouselSlider(
      items: banners
          .map((banner) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FutureBuilder<String>(
                future: storageMethods
                    .loadImageInURL(banner.image, true), // Use a função loadImage
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.grey.shade200,
                      ),
                      child:
                          const Center(child: Text('Erro ao carregar imagem')),
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        snapshot.data ?? '',
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
        height: MediaQuery.of(context).size.height * 0.2,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
      ),
    );
  }
}
