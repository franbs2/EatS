import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

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
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.soraTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const AuthWrapper(), // Usa o AuthWrapper
      ),
    );
  }
}