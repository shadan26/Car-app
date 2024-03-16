
import 'dart:async';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:ecommerc_project/product/presentation/widgets/Authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../constent.dart';
import '../views/Product Views/Admin_home_page.dart';
import '../views/Product Views/user_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    isLogin(context);
    Future.delayed(const Duration(seconds: 20), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,

        body: Center(
          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Lottie.asset('assets/images/Animation - 1709017925079.json'),

            ],
          ),
        ),
      ),
    );
  }


  void isLogin(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {

      Timer(const Duration(seconds: 2), () async {
       var isAdmin = await FirebaseManager().isAdmin();
       if (isAdmin) {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const ShowAdminProductView()),
         );
       } else {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const ShowProductView()),
         );
       }
      });
    } else {
      // User is not logged in, navigate to the login screen
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }
}


