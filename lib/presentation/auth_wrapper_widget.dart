import 'dart:async';

import 'package:eats/presentation/widget/load_screen_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/edit_perfil_page.dart';
import 'package:eats/presentation/view/login_page.dart';
import 'main_screen.dart';


class AuthWrapperWidget extends StatefulWidget {
  const AuthWrapperWidget({super.key});

  @override
  State<AuthWrapperWidget> createState() => _AuthWrapperWidgetState();
}


class _AuthWrapperWidgetState extends State<AuthWrapperWidget> {
  bool _isUserDataLoaded = false;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Escutar mudanças na autenticação
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // Usuário deslogado
        setState(() {
          _isUserDataLoaded = false;
        });
      } else {
        // Usuário logado
        userProvider.refreshUser().then((_) {
          setState(() {
            _isUserDataLoaded = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context);

    if (firebaseUser == null) {
      // Usuário não está logado
      return LoginPage();
    } else {
      if (!_isUserDataLoaded || userProvider.user == null) {
        // Dados do usuário ainda não carregados
        return const LoadScreenWidget();
      } else {
        // Dados do usuário carregados, navegar para a tela apropriada
        if (userProvider.user!.onboarding) {
          return const MainScreen();
        } else {
          return EditPerfilPage();
        }
      }
    }
  }
}
