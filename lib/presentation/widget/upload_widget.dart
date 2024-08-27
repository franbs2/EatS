import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final VoidCallback ontap;
  const UploadWidget({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        color: const Color(0xfff1f1f1),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/icons/upload_icon.png'),
              height: 36,
              width: 36,
            ),
          ],
        ),
      ),
    );
  }
}
