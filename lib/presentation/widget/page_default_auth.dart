import 'package:flutter/material.dart';

import '../../core/style/images_app.dart';

class PageDefaultAuth extends StatelessWidget {
  final double size;
  final Widget body;

  const PageDefaultAuth({
    super.key,
    required this.body,
    this.size = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * size,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  colors: [Color(0xffEFC136), Color(0xff539F33)]),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(ImageApp.logoWhite),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2),
                    padding: const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: body),
              ),
            ],
          )
        ],
      ),
    );
  }
}
