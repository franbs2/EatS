// Importações necessárias para o funcionamento do app, incluindo bibliotecas do Flutter,
// Firebase, provedores de estado (Provider) e outras dependências utilizadas no projeto.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/data/datasources/banners_repository.dart';
import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/presentation/auth_wrapper_widget.dart';
import 'package:eats/presentation/providers/banners_provider.dart';
import 'package:eats/presentation/providers/recipes_provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/generate_recipes_page.dart';

import 'core/routes/routes.dart';
import 'data/datasources/ia_repository.dart';
import 'firebase/firebase_options.dart';
import 'presentation/providers/preferences_provider.dart';
import 'presentation/view/detail_recipes_page.dart';
import 'presentation/view/edit_perfil_page.dart';
import 'presentation/view/home_page.dart';
import 'presentation/view/login_page.dart';
import 'presentation/view/perfil_page.dart';
import 'presentation/view/register_page.dart';

/// Função principal do aplicativo. Inicializa o [Firebase], define a orientação da tela
/// para retrato e executa o aplicativo.
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que a árvore de widgets foi inicializada.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Inicializa o Firebase com as opções específicas da plataforma.
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barra de status transparente
      systemNavigationBarColor:
          Colors.transparent, // Barra de navegação transparente
      statusBarIconBrightness:
          Brightness.light, // Ícones da barra de status claros
      systemNavigationBarIconBrightness:
          Brightness.light, // Ícones da barra de navegação claros
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]); // Define a orientação da tela para retrato.

  runApp(const MyApp()); // Executa o aplicativo.
}

/// Classe principal do aplicativo que configura o [MaterialApp] e os provedores.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura os provedores para gerenciar o estado do aplicativo.
    return MultiProvider(
      providers: [
        // Provedor de autenticação que gerencia o estado do usuário autenticado.
        StreamProvider<User?>(
          create: (context) => context.read<AuthMethods>().authState,
          initialData: null,
        ),
        // Provedor que gerencia o estado do usuário.
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        // Provedor para autenticação, utilizando métodos personalizados.
        Provider<AuthMethods>(
          create: (_) => AuthMethods(),
        ),
        // Provedor para gerenciar as receitas, conectando ao Firestore.
        Provider<RecipesRepository>(
          create: (_) => RecipesRepository(
            FirebaseFirestore.instance,
          ),
        ),
        // Provedor para gerenciar a integração com a IA.
        Provider<AIRepository>(
          create: (_) =>
              AIRepository(apiKey: 'AIzaSyD5Sd9GNhXfGf-fq4setyqWFcUdFxB-YCs'),
        ),
        // Provedor para gerenciar os banners, conectando ao Firestore.
        Provider<BannersRepository>(
          create: (_) => BannersRepository(
            FirebaseFirestore.instance,
          ),
        ),
        // Provedor que atualiza o RecipesProvider com base no RecipesRepository.
        ChangeNotifierProxyProvider<RecipesRepository, RecipesProvider>(
          create: (context) =>
              RecipesProvider(context.read<RecipesRepository>()),
          update: (context, repository, previous) =>
              previous!..updateRepository(repository),
        ),
        // Provedor que atualiza o BannersProvider com base no BannersRepository.
        ChangeNotifierProxyProvider<BannersRepository, BannersProvider>(
          create: (context) =>
              BannersProvider(context.read<BannersRepository>()),
          update: (context, repository, previous) =>
              previous!..updateRepository(repository),
        ),
        // Provedor que gerencia as preferências do usuário, atualizando com base no UserProvider.
        ChangeNotifierProxyProvider<UserProvider, PreferencesProvider>(
          create: (context) => PreferencesProvider(
              Provider.of<UserProvider>(context, listen: false)),
          update: (context, userProvider, previousPreferencesProvider) =>
              previousPreferencesProvider!..updateUserProvider(userProvider),
        ),
      ],
      // Configura o MaterialApp com tema, rotas e a tela inicial.
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.soraTextTheme(
            Theme.of(context).textTheme,
          ), // Define a fonte padrão do aplicativo usando Google Fonts.
        ),
        home:
            const AuthWrapperWidget(), // Tela inicial que decide se o usuário está autenticado.
        routes: {
          RoutesApp.registerPage: (context) => RegisterPage(),
          RoutesApp.loginPage: (context) => LoginPage(),
          RoutesApp.homePage: (context) => const HomePage(),
          RoutesApp.detailRecipePage: (context) => const DetailRecipesPage(),
          RoutesApp.perfilPage: (context) => const PerfilPage(),
          RoutesApp.editPefilPage: (context) => EditPerfilPage(),
          RoutesApp.generateRecipePage: (context) =>
              const GenerateRecipesPage(),
        },
      ),
    );
  }
}
