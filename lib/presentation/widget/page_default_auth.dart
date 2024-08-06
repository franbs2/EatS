import 'package:flutter/material.dart';

import '../style/color.dart';

class PageDefaultAuth extends StatelessWidget {
  final Widget body;
  final String title;
  final String subtitle;

  const PageDefaultAuth(
      {super.key,
      required this.body,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset('assets/eats_logo.png'),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xff2F2D2C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textInitial,
                fontWeight: FontWeight.normal,
              ),
            ),
            body,
          ],
        ),
      ),
    ));
  }
}
