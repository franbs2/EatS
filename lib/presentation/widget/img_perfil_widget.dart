import 'package:eats/data/datasources/storage_methods.dart';
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
    final user = Provider.of<UserProvider?>(context)?.getUser;

    if (user?.photoURL == null || user!.photoURL.isEmpty) {
      return _buildPlaceholder();
    }

    return FutureBuilder<String>(
      future: StorageMethods().loadImageAtStorage(user.photoURL),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || snapshot.data?.isEmpty == true) {
          return _buildPlaceholder();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Image.network(
            snapshot.data!,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          ),
        );
      },
    );
  }
}
