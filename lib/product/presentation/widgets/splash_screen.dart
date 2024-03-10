
import 'package:ecommerc_project/product/presentation/widgets/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constent.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 20), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>   const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor:kPrimaryColor,

        body: Center(
          // child: SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
            child: Column(

              mainAxisSize:MainAxisSize.min ,

              children: [

                Lottie.asset('assets/images/Animation - 1709017925079.json'),

              ],
            ),
          ),
        ),
    );
  }
}


