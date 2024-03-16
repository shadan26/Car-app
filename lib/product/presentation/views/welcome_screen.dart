import 'package:flutter/material.dart';
import 'package:ecommerc_project/product/presentation/widgets/Authentication/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              width: size.width * 0.3,
              child: Image.asset("assets/images/main_top.png"),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width * 0.2,
              child: Image.asset("assets/images/main_bottom.png"),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Welcome to Edu!",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      // You need to define 'linearGradient' here
                      // foreground: Paint()..shader = linearGradient
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                    Image.asset(
                    "assets/icons/chat.svg",
                    height: size.height * 0.45,
                  ),
                  SizedBox(height: size.height * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Change to the color you want
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text("LOGIN"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen() ;
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Change to the color you want
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text("SIGN UP"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
