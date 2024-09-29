import 'package:flutter/material.dart';

import '../../core/style/color.dart';

class LoadScreenWidget extends StatelessWidget {
  const LoadScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        )),
      ),
    );
  }
}
