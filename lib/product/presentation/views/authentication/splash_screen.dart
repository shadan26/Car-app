import 'dart:async';
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../admin/view/screens/admin_home_page.dart';
import '../../../../constent.dart';
import '../../../../user/view/screens/user_home_page.dart';
import 'login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)  async{
  if (kDebugMode) {
    if (kDebugMode) {
      print('on background message');
    }
  }
  if (kDebugMode) {
    print (message. data. toString());
  }

}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? messageData;
  @override
  void initState() {

    super.initState();


    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print("onMessage");
      }
      if (kDebugMode) {
        print(event.data. toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (kDebugMode) {
        print("onMessageOpenedApp");
      }
      if (kDebugMode) {
        print(event.data. toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("onMessageOpenedApp"),
          ));
      setState(() {
        messageData = event.data.toString();
      });
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    requestPermission();
    checkLoginStatus();
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
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
    bool isLoggedIn = await FirebaseManager().isLoggedIn();

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
        builder: (context) =>
            isAdmin ?  ShowAdminProductView() : const ShowProductView(),
      ),
    );
  }

  void navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
