
import 'dart:async';

import 'package:ecommerc_project/product/presentation/views/car_filter_screen.dart';
import 'package:ecommerc_project/product/presentation/views/Product%20Views/user_home_page.dart';
import 'package:ecommerc_project/product/presentation/widgets/Authentication/login_screen.dart';
import 'package:ecommerc_project/product/presentation/widgets/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase/firebase_options.dart';
 bool ? islogin;
FirebaseAuth ? firebaseAuth;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform ,

  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
