import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerc_project/admin/view/screens/admin_home_page.dart';
import 'package:ecommerc_project/product/presentation/views/authentication/splash_screen.dart';
import 'package:ecommerc_project/signup_model/signup_bloc/signup_bloc.dart';
import 'package:ecommerc_project/structured/observing.dart';
import 'package:ecommerc_project/user/view/screens/user_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/firebase/firebase_options.dart';
import 'core/utils/widget/test.dart';



FirebaseAuth ? firebaseAuth;
FirebaseMessaging?firebaseMessaging;

Future<void> main() async {


  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform ,

  );
  runApp(const MyApp());
  getToken();
}
getToken() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();

  if (kDebugMode) {
    print("Token = $token");
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(create: (BuildContext context)
        =>SignupBloc())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      ),
    );
  }
}
