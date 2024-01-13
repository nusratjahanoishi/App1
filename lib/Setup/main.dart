import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/Onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:nutritionapp/personalDietplan/planpage.dart';

import '../firebase_options.dart';
import '../pages/googlesignin.dart';
import 'package:nutritionapp/themes/app_theme.dart';

import 'authListener.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppTheme().lilas,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            fontFamily: 'Alata',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headline2: TextStyle(
            fontSize: 14,
            fontFamily: 'Alata',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline3: TextStyle(
            fontSize: 16,
            fontFamily: 'Alata',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headline4: TextStyle(
            fontSize: 20,
            fontFamily: 'Alata',
            fontWeight: FontWeight.w200,
            color: Colors.black87,
          ),
        ),
      ),
      home: Onboarding(),
      routes: {
        '/cart': (context) => const CartPage(),
      },
    ),
  );
}