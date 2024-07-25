import 'package:flutter/material.dart';

class ImgPerfilWidget extends StatelessWidget {
  const ImgPerfilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Image.asset(
                                'assets/img_perfil.png',
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            );
  }
}