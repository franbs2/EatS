import 'package:flutter/material.dart';

import '../../core/style/strings_app.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(left: 30.0, right: 10.0),
          ),
        ),
        const Text(
          StringsApp.orContinue,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            margin: const EdgeInsets.only(left: 10.0, right: 30.0),
          ),
        ),
      ],
    );
  }
}
