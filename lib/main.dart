import 'package:eats/core/style/color.dart' as color;
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/presentation/view/detail_recipes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eats/presentation/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/view/home_page.dart';

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
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            textTheme: GoogleFonts.soraTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          // home: const HomePage(),
          // debugShowCheckedModeBanner: false,

          //To configure the Firebase Persisting Auth State, use the following code:

          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return DetailRecipesPage();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: color.AppTheme.primaryColor,
                ));
              }

              return DetailRecipesPage();
            },
          ),
        ));
  }
}
