import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';
import '../../core/style/color.dart';
import '../widget/button_default_widget.dart';

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
                      StringsApp.initilText,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textInitial,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 28),
                    ButtonDefaultlWidget(text: StringsApp.startNow),
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
