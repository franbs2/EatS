import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/home_page.dart';
import 'package:eats/presentation/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthWrapperWidget extends StatelessWidget {
  const AuthWrapperWidget({super.key});
@override
Widget build(BuildContext context) {
  return StreamBuilder<fb.User?>(
    stream: fb.FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      final user = snapshot.data;
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (user == null) {
        return LoginPage();
      } else {
        return FutureBuilder(
          future: userProvider.refreshUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(color: Color(0xff529536))),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text('Erro ao carregar os dados do usuário')),
              );
            }
            return const HomePage();
          },
        );
      }
    },
  );
}

}
