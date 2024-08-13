import 'package:flutter/material.dart';
import '../style/color.dart';
import '../widget/button_initial_widget.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Image.asset(
              'assets/eats_logo.png',
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'O sabor de um mundo melhor',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textInitial,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 28),
                    ButtonInitialWidget(
                      text: 'Começar já',
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
