import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

class TitleInitialWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double space;

  const TitleInitialWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      this.space = 8.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: space),
        Text(subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textInitial,
            )),
      ],
    );
  }
}
