import 'package:flutter/material.dart';

class FilterCategoriesWidget extends StatelessWidget {
  final String text;
  final Color colorBackground;
  final FontWeight fontWeight;
  final Color textColor;

  const FilterCategoriesWidget(
      {super.key,
      required this.text,
      required this.colorBackground,
      required this.fontWeight,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: 16,
                )),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
