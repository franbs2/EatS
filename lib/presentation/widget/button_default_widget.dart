import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

class ButtonDefaultlWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const ButtonDefaultlWidget({
    super.key,
    required this.text,
    this.color = AppTheme.primaryColor,
    this.onPressed,
    this.width = 0.3,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * width,
            vertical: height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16,
            color: AppTheme.secondaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
