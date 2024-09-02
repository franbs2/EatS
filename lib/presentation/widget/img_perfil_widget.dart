import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';

class ImgPerfilWidget extends StatelessWidget {
  const ImgPerfilWidget({super.key});

  Widget _buildPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        color: Colors.grey,
        width: 52,
        height: 52,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<UserProvider>(context).profileImage;

    if (profileImage == null) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Image.memory(
        profileImage,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      ),
    );
  }
}