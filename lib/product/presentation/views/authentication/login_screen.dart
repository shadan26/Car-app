
import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:ecommerc_project/product/presentation/views/authentication/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constent.dart';
import '../../../../core/utils/widget/button_widget.dart';
import '../../../../core/utils/widget/text_form_filed_widget.dart';
import '../../../../admin/view/screens/admin_home_page.dart';
import '../../../../user/view/screens/user_home_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);



  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool showPassword = false;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth ? firebaseAuth;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(
                width: width,
                height: height * .3,
                child: Center(
                  child: Image.asset(
                    "assets/images/Green Abstract Illustrative Automotive Car Logo.png",
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: width,
                  height: height * .71,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Welcome! Log in with your email and password',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 66, 63, 63),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextFiledWidget(
                            controller: emailTextEditingController,
                            labelText: 'email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextFiledWidget(
                          obscureText: !showPassword,
                          controller: passwordTextEditingController,
                          labelText: 'password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ?
                              Icons.visibility :
                              Icons.visibility_off,
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.only(right: 20),

                      ),
                      const SizedBox(height: 10),
                      errorMessage != null ?
                      Row(children: [
                        const Icon(Icons.error, color: Colors.red,),
                        Expanded(child: Text(errorMessage!))

                      ],) : const Text((''))
                      , SizedBox(
                        width: width,
                        height: 40,
                        child: Expanded(
                          child: MyButton(

                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var loginResults = await FirebaseManager()
                                    .login(emailTextEditingController.text,
                                    passwordTextEditingController.text);
                                if (loginResults.isSuccess) {
                                  await FirebaseManager().truelogin();
                                  //  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  // await prefs.setBool("islogin", true);
                                  var isAdmin = await FirebaseManager()
                                      .isAdmin();
                                  if (isAdmin) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (
                                            context) => const ShowAdminProductView()));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (
                                            context) => const ShowProductView()));
                                  }
                                } else {
                                  setState(() {
                                    errorMessage =
                                        loginResults.error;
                                  });
                                }
                              }

                              else {
                                print("error");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                            ),
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 66, 63, 63),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),));
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







