import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/edit_perfil_page.dart';
import 'package:eats/presentation/view/home_page.dart';
import 'package:eats/presentation/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapperWidget extends StatefulWidget {
  const AuthWrapperWidget({super.key});

  @override
  _AuthWrapperWidgetState createState() => _AuthWrapperWidgetState();
}

class _AuthWrapperWidgetState extends State<AuthWrapperWidget> {
  bool hasNavigated = false; // Flag para evitar navegação repetida

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostrar um indicador de carregamento enquanto o estado de autenticação é verificado
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff529536)),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Se o usuário não está logado, vá para a página de login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToLogin();
          });
        } else {
          // Usuário está logado, carregue os dados do usuário
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadUserData(userProvider);
          });
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xff529536)),
          ),
        );
      },
    );
  }

  Future<void> _loadUserData(UserProvider userProvider) async {
    try {
      await userProvider.refreshUser();
      debugPrint('Dados do usuário carregados: ${userProvider.user}');
      _navigateToNextScreen(userProvider);
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
    }
  }

  void _navigateToNextScreen(UserProvider userProvider) {
    if (hasNavigated) return; // Evitar navegação múltipla

    hasNavigated = true; // Marcar que a navegação ocorreu
    if (userProvider.user == null) {
      _navigateToLogin();
    } else if (userProvider.user!.onboarding) {
      _navigateToHome();
    } else {
      _navigateToEditPerfil();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _navigateToEditPerfil() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EditPerfilPage()),
    );
  }
}
