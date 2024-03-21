
import 'dart:async';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../admin/view/screens/admin_home_page.dart';
import '../../../../constent.dart';
import '../../../../user/view/screens/user_home_page.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    checkLoginStatus();
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


  void checkLoginStatus() async {
    bool isLoggedIn= await FirebaseManager().isloggedIn();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLoggedIn =   prefs.getBool("islogin") ?? false;

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        navigateToHomePage();
      } else {
        navigateToLoginScreen();
      }
    });
  }

  void navigateToHomePage() async {
    var isAdmin = await FirebaseManager().isAdmin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isAdmin ? const ShowAdminProductView() : const ShowProductView(),
      ),
    );
  }

  void navigateToLoginScreen()  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

}
