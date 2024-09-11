import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/edit_perfil_page.dart';
import 'package:eats/presentation/view/login_page.dart';

import 'main_screen.dart';

/// [AuthWrapperWidget] é um widget que gerencia a navegação com base no estado de autenticação do usuário.
///
/// Este widget utiliza o [StreamBuilder] para ouvir mudanças no estado de autenticação do [Firebase].
/// Dependendo do estado de autenticação e das informações do usuário, navega para a página de login, 
/// a página de edição de perfil ou a página principal.
class AuthWrapperWidget extends StatefulWidget {
  const AuthWrapperWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthWrapperWidgetState createState() => _AuthWrapperWidgetState();
}

class _AuthWrapperWidgetState extends State<AuthWrapperWidget> {
  bool hasNavigated = false; // Flag para evitar navegação repetida.

  @override
  Widget build(BuildContext context) {
    // Utiliza o StreamBuilder para escutar as mudanças no estado de autenticação.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Stream do Firebase que notifica sobre mudanças no estado de autenticação.
      builder: (context, snapshot) {
        final userProvider = Provider.of<UserProvider>(context, listen: false); // Obtém o UserProvider para acessar os dados do usuário.

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibe um indicador de carregamento enquanto o estado de autenticação é verificado.
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xff529536)), // Cor do indicador de carregamento.
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Se não há dados de usuário, navega para a página de login.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToLogin(); // Chama método para navegar para a página de login.
          });
        } else {
          // Se o usuário está autenticado, carrega os dados do usuário.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadUserData(userProvider); // Chama método para carregar dados do usuário e gerenciar navegação.
          });
        }

        // Exibe um indicador de carregamento enquanto decide a navegação.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xff529536)), // Cor do indicador de carregamento.
          ),
        );
      },
    );
  }

  /// Carrega os dados do usuário e navega para a próxima tela com base nas informações carregadas.
  Future<void> _loadUserData(UserProvider userProvider) async {
    try {
      await userProvider.refreshUser(); // Atualiza os dados do usuário.
      debugPrint('AuthWrapperWidget: Dados do usuário carregados: ${userProvider.user}');
      _navigateToNextScreen(userProvider); // Chama método para decidir a navegação com base nos dados do usuário.
    } catch (e) {
      // Registra o erro no console se houver um problema ao carregar os dados do usuário.
      debugPrint('AuthWrapperWidget: Erro ao carregar dados do usuário: $e');
    }
  }

  /// Decide para qual tela o usuário deve ser navegado com base nos dados carregados.
  void _navigateToNextScreen(UserProvider userProvider) {
    if (hasNavigated) return; // Evita navegação múltipla para a mesma tela.

    hasNavigated = true; // Marca que a navegação ocorreu.

    if (userProvider.user == null) {
      // Se não há dados de usuário, navega para a página de login.
      debugPrint('AuthWrapperWidget: Nenhum usuário encontrado. Navegando para a página de login...');
      _navigateToLogin(); // Chama método para navegar para a página de login.
    } else if (userProvider.user!.onboarding) {
      // Se o usuário concluiu o onboarding, navega para a página principal.
      debugPrint('AuthWrapperWidget: Usuário concluiu o onboarding. Navegando para a página inicial...');
      _navigateToHome(); // Chama método para navegar para a página principal.
    } else {
      // Se o usuário não concluiu o onboarding, navega para a página de edição de perfil.
      debugPrint('AuthWrapperWidget: Usuário não concluiu o onboarding. Navegando para a página de edição de perfil...');
      _navigateToEditPerfil(); // Chama método para navegar para a página de edição de perfil.
    }
  }

  /// Navega para a página de login.
  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()), // Cria uma rota para a página de login.
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores da pilha.
    );
  }

  /// Navega para a página principal.
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()), // Cria uma rota para a página principal e substitui a rota atual.
    );
  }

  /// Navega para a página de edição de perfil.
  void _navigateToEditPerfil() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EditPerfilPage()), // Cria uma rota para a página de edição de perfil e substitui a rota atual.
    );
  }
}
