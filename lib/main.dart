import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/data/datasources/recipes_repository.dart';
import 'package:eats/presentation/auth_wrapper_widget.dart';
import 'package:eats/presentation/providers/recipes_provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/routes/routes.dart';
import 'firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'presentation/providers/preferences_provider.dart';
import 'presentation/view/detail_recipe_page.dart';
import 'presentation/view/edit_perfil_page.dart';
import 'presentation/view/home_page.dart';
import 'presentation/view/initial_page.dart';
import 'presentation/view/login_page.dart';
import 'presentation/view/perfil_page.dart';
import 'presentation/view/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        Provider<AuthMethods>(
          create: (_) => AuthMethods(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthMethods>().authState,
          initialData: null,
        ),
        Provider<RecipesRepository>(
          create: (_) => RecipesRepository(
            FirebaseFirestore.instance,
          ),
        ),
        ChangeNotifierProxyProvider<RecipesRepository, RecipesProvider>(
          create: (context) =>
              RecipesProvider(context.read<RecipesRepository>()),
          update: (context, repository, previous) =>
              previous!..updateRepository(repository),
        ),
        ChangeNotifierProxyProvider<UserProvider, PreferencesProvider>(
          create: (context) => PreferencesProvider(
              Provider.of<UserProvider>(context, listen: false)),
          update: (context, userProvider, previousPreferencesProvider) =>
              previousPreferencesProvider!..updateUserProvider(userProvider),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.soraTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home:
            const AuthWrapperWidget(), // Usando AuthWrapper para controle de autenticação
        routes: {
          RoutesApp.initialPage: (context) => const InitialPage(),
          RoutesApp.registerPage: (context) => RegisterPage(),
          RoutesApp.loginPage: (context) => LoginPage(),
          RoutesApp.homePage: (context) => const HomePage(),
          RoutesApp.detailRecipePage: (context) => const DetailRecipePage(),
          RoutesApp.perfilPage: (context) => const PerfilPage(),
          RoutesApp.editPefilPage: (context) => const EditPerfilPage(),
        },
      ),
    );
  }
}
