import 'dart:typed_data';

import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final VoidCallback ontap;
  final Uint8List? backgroundImage;

  const UploadWidget({super.key, required this.ontap, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundImage == null ? Colors.grey[300] : const Color(0xfff1f1f1),
          image: backgroundImage != null
              ? DecorationImage(
                  image: MemoryImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(
          child: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.secondaryColor,
            ),
            child: const Image(
              image: AssetImage('assets/icons/upload_icon.png'),
            ),
          ),
        ),
      ),
    );
  }

}
