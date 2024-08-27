import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0XFF313131),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(StringsApp.local,
                style: TextStyle(color: Color(0xffB7B7B7), fontSize: 12)),
            SizedBox(width: 8),
            Row(
              children: [
                Text( //TODO: Add location from user
                  'Pará, Santarém',
                  style: TextStyle(
                      color: Color(0xffDDDDDD),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Image(
                  image: AssetImage('assets/icons/stat_minus_icon.png'),
                  height: 18,
                  width: 18,
                ), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}
