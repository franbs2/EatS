import 'package:eats/presentation/style/color.dart';
import 'package:flutter/material.dart';

class ButtonDefaultlWidget extends StatelessWidget {
  final String text;
  final Color color;

  const ButtonDefaultlWidget({
    super.key,
    required this.text,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }
}
