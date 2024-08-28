import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../core/style/images_app.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Image.asset(
            ImageApp.banner,
            fit: BoxFit.fill,
          ),
        ),
      ],
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
