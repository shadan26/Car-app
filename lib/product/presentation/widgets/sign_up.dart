


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constent.dart';
import '../views/show_product_view.dart';
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


  FirebaseAuth ? firebaseAuth ;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();

    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(

        backgroundColor: kPrimaryColor,
        body:
        SingleChildScrollView(
          physics:  ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                      
                children: [
                  SizedBox(
                    width: width,//
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
                          child: TextFormField(
                            obscureText: false,
                            controller: emailTextEditingController,//hhh
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // You can add more validation rules here if needed
                              return null;
                            },
                          ),
                        ),
              
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextFormField(
                            controller: passwordTextEditingController,
                            obscureText: !showPassword,
                            //show password=true =obscureText=>false
                            //not show password=false =obscureText=>true
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Password',
                              suffixIcon:
              
              
              
                              IconButton(
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              // You can add more validation rules here if needed
                              return null;
                            },
                          ),
                        ),        Padding(
                          padding: const EdgeInsets.only(top: 20,),
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
                              floatingLabelBehavior: FloatingLabelBehavior.always,
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
              
                        const SizedBox(height: 10),
                        errorMassage!=null? Row(children: [
                          Icon(Icons.error,color: Colors.red,),
                          Text(errorMassage!,style: TextStyle(color: Colors.red,overflow:TextOverflow.ellipsis, ),maxLines: 2,overflow: TextOverflow.ellipsis,)
                        ],):Text(''),
                        SizedBox(
                          width: width,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
              
              
                                try {
                                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: emailTextEditingController.text,
                                    password: passwordTextEditingController.text,
                                  );
                                  var collectoin = FirebaseFirestore.instance.collection('users');
                                   await collectoin.add (

                                    {
                                      'email':emailTextEditingController.text,
                                      'role': _selectedRole,
                                    },
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowProductView(),));
                                  // Successfully signed in
                                  // You can access the user information via userCredential.user
                                }
                                on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    setState(() {
                                      errorMassage='The password provided is too weak.';
                                    });
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    setState(() {
                                      errorMassage='The account already exists for that email.';
                                    });
                                    print('The account already exists for that email.');
                                  }
                                } catch (e) {
                                  // Handle other exceptions
                                  setState(() {
                                    errorMassage=e.toString();
                                  });
                                  print('Error: $e');
                                }
                              }},
                            child: const Text('Sign up'),
                            style: ElevatedButton.styleFrom(
                            ),
                          ),
                        ),
              
              
                        // Row(children: [
                        //   TextButton(child: Text("Already have account ?",
                        //     style: GoogleFonts.poppins(
                        //       textStyle: const TextStyle(
                        //         color: Color.fromARGB(255, 66, 63, 63),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w400,
                        //
                        //       ),),),
                        //     onPressed: () {
                        //
                        //       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                        //     },)
                        // ],)
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       'Don\'t have an account?',
                        //       style: GoogleFonts.poppins(
                        //         textStyle: const TextStyle(
                        //           color: Color.fromARGB(255, 66, 63, 63),
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //       ),
                        //     ),
                        //     TextButton(
                        //       onPressed: () async {
                        //         // Handle registration button pressed
                        //       },
                        //       child: Text(
                        //         'Register',
                        //         style: TextStyle(
                        //           color: Colors.cyan,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
  }}