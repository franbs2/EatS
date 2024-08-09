import 'package:flutter/material.dart';

class PageDefaultAuth extends StatelessWidget {
  final Widget body;

  const PageDefaultAuth({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  colors: [Color(0xffEFC136), Color(0xff539F33)]),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset('assets/logo_white.png'),
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
