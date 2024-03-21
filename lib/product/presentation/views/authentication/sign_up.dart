import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constent.dart';
import '../../../../core/utils/widget/button_widget.dart';
import '../../../../core/utils/widget/text_form_filed_widget.dart';
import '../../../../admin/view/screens/admin_home_page.dart';
import '../../../../user/view/screens/user_home_page.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? _selectedRole;
  String? errorMassage;

  FirebaseAuth? firebaseAuth;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: width, //
                    height: height * .3,
                    child: Image.asset(
                      'assets/images/Green Abstract Illustrative Automotive Car Logo.png',
                    ),
                  ),
                  Container(
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
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Welcome! to App',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 66, 63, 63),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
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
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedRole,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            },
                            items: <String>['admin', 'user']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Select Role',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a role';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        errorMassage != null
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    errorMassage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              )
                            : const Text(''),
                        SizedBox(
                          width: width,
                          height: 30,
                          child: MyButton (
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                              var authResult = await FirebaseManager().register(emailTextEditingController.text,
                                  passwordTextEditingController.text,
                                  _selectedRole!);

                              if (authResult.isSuccess) {
                                if (_selectedRole == "admin") {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const ShowAdminProductView()));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const ShowProductView()));
                                }
                              } else {
                                setState(() {
                                  errorMassage = authResult.error;
                                });
                              }
                              }
                            },
                            style: ElevatedButton.styleFrom(),
                            child: const Text('Sign up'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
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
                                  builder: (context) => const LoginScreen(),));
                              },
                              child: const Text(
                                'Sign In',
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
