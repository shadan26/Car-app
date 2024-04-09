import 'package:ecommerc_project/signup_model/signup_bloc/signup_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final bloc =SignupBloc().state;
  //SignupBloc bloc =SignupBloc();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
      if (state is SignFailure) {
        setState(() {
          errorMassage = state.errorMassage;
        });
      } else if (state is SignSuccess) {
        if (_selectedRole == "admin") {
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
      }
    },
  builder: (context, state) {
    return Flexible(
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
                            //  obscureText: !showPassword,
                              maxLines: null,
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
                            child: Expanded(
                              child: MyButton (
                                onPressed: () async {


                                  if (_formKey.currentState!.validate()) {

                                    BlocProvider.of<SignupBloc>(context).add(
                                      SignupButtonPressed(
                                        email: emailTextEditingController.text,
                                        password: passwordTextEditingController.text ,
                                        role: _selectedRole.toString(),
                                      ),
                                    );

                                  }
                                },
                                style: ElevatedButton.styleFrom(),
                                child: const Text('Sign up'),
                              ),
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
  },

      ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../admin/view/screens/admin_home_page.dart';
// import '../../../../core/utils/widget/text_form_filed_widget.dart';
// import '../../../../register_model/register_bloc/register_bloc.dart';
// import '../../../../user/view/screens/user_home_page.dart';
// import 'login_screen.dart';
//
// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => RegisterBloc(),
//       child: SignUpForm(),
//     );
//   }
// }
//
// class SignUpForm extends StatefulWidget {
//   const SignUpForm({Key? key}) : super(key: key);
//
//   @override
//   _SignUpFormState createState() => _SignUpFormState();
// }
//
// class _SignUpFormState extends State<SignUpForm> {
//   bool showPassword = false;
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController passwordTextEditingController = TextEditingController();
//   String? _selectedRole;
//   String? errorMassage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: BlocListener<RegisterBloc, RegisterState>(
//         listener: (context, state) {
//           if (state is RegisterSuccess) {
//             if (_selectedRole == "admin") {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ShowAdminProductView()),
//               );
//             } else {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ShowProductView()),
//               );
//             }
//           } else if (state is RegisterFailure) {
//             setState(() {
//               errorMassage = state.error;
//             });
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 7),
//                 const Text(
//                   'Welcome! to App',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 66, 63, 63),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 TextFiledWidget(
//                   controller: emailTextEditingController,
//                   labelText: 'Email',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFiledWidget(
//                   controller: passwordTextEditingController,
//                   labelText: 'Password',
//                   maxLines: null,
//                  // obscureText: !showPassword,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       showPassword ? Icons.visibility : Icons.visibility_off,
//                       color: Theme.of(context).primaryColorDark,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         showPassword = !showPassword;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedRole,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedRole = newValue;
//                     });
//                   },
//                   items: <String>['admin', 'user']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(
//                     floatingLabelBehavior: FloatingLabelBehavior.always,
//                     labelText: 'Select Role',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(31.5),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select a role';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 errorMassage != null
//                     ? Row(
//                   children: [
//                     const Icon(
//                       Icons.error,
//                       color: Colors.red,
//                     ),
//                     Text(
//                       errorMassage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     )
//                   ],
//                 )
//                     : const SizedBox.shrink(),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: ElevatedButton(
//
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         BlocProvider.of<RegisterBloc>(context).add(
//                           RegisterUser(
//                             email: emailTextEditingController.text,
//                             password: passwordTextEditingController.text,
//                             role: _selectedRole!,
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text('Sign up'),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Already have an account?',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 66, 63, 63),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const LoginScreen()),
//                         );
//                       },
//                       child: const Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: Colors.cyan,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

