// ignore_for_file: prefer_const_constructors, unused_import

import 'package:fintagram/pages/home_page.dart';
import 'package:fintagram/pages/login_page.dart';
import 'package:fintagram/pages/register_page.dart';
import 'package:fintagram/services/firebase_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "",
     
    ));
  } else {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      
    ));
  }

  GetIt.instance.registerSingleton<FireBaseServices>(
    FireBaseServices(),
  );
  runApp(const MyApp());
}
//print("run");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Finstagram",
      theme: ThemeData(
          primarySwatch: Colors.red, scaffoldBackgroundColor: Colors.grey),
      initialRoute: 'login',
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
        'home': (context) => HomePage()
      },
    );
  }
}
