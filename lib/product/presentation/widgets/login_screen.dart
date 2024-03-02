
import 'package:ecommerc_project/product/presentation/views/show_product_view.dart';
import 'package:ecommerc_project/product/presentation/widgets/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constent.dart';
import '../../../core/utils/widget/text_form_filed_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth ? firebaseAuth;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

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
                        margin: const EdgeInsets.only(right: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextFiledWidget(
                            controller: emailTextEditingController,
                            labelText: 'email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // You can add more validation rules here if needed
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextFiledWidget(
                          controller: passwordTextEditingController,
                          labelText: 'password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            // You can add more validation rules here if needed
                            return null;
                          },
                          suffixIcon:  IconButton(
                            icon: Icon(
                              // true? print(true):print(false)
                              showPassword ? Icons.visibility : Icons.visibility_off,
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
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        // child: DropdownButtonFormField<String>(
                        //   value: _selectedRole,
                        //   onChanged: (String? newValue) {
                        //     setState(() {
                        //       _selectedRole = newValue;
                        //     });
                        //   },
                        //   items: <String>['doctor', 'patient']
                        //       .map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   decoration: InputDecoration(
                        //     floatingLabelBehavior: FloatingLabelBehavior.always,
                        //     labelText: 'Select Role',
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(31.5),
                        //     ),
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please select a role';
                        //     }
                        //     return null;
                        //   },
                        // ),
                      ),
                      const SizedBox(height: 10),
                      errorMessage != null ? Row(children: [
                        const Icon(Icons.error, color: Colors.red,),
                        Text(errorMessage!)

                      ],) : const Text((''))
                      , SizedBox(
                        width: width,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const ShowProductView(),));
                                // Successfully signed in
                                // You can access the user information via userCredential.user
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  setState(() {
                                    errorMessage =
                                    'passwordTextEditingController';
                                  });
                                  print('passwordTextEditingController');
                                } else if (e.code == 'wrong-password') {
                                  // Handle the case where password is incorrect
                                  setState(() {
                                    errorMessage =
                                    'Wrong password provided for that user.';
                                  });
                                  print(
                                      'Wrong password provided for that user.');
                                } else {
                                  // Handle other errors
                                  setState(() {
                                    errorMessage = e.message;
                                  });
                                  print('Error: ${e.message}');
                                }
                              } catch (e) {
                                // Handle other exceptions
                                print('Error: $e');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                          ),
                          child: const Text('Login'),
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





