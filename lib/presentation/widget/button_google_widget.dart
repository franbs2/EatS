import 'package:eats/core/style/color.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:provider/provider.dart';

class ButtonGoogleWidget extends StatelessWidget {
  const ButtonGoogleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthMethods>().signInWithGoogle(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppTheme.primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage('assets/google_icon.png'),
            fit: BoxFit.fill,
            height: 24,
          ),
          Text(StringsApp.singUpGoogle,
              style: TextStyle(color: Color(0xff2f4b4e), fontSize: 18)),
        ],
      ),
    );
  }
}
