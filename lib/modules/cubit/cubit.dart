import 'package:bloc/bloc.dart';
import 'package:ecommerc_project/modules/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarCubit extends Cubit<Carstates>{

  CarCubit():super(CarInitialState());

  static  CarCubit get(context) => BlocProvider.of(context);
   static bool showPassword = false;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth ? firebaseAuth;


   static bool getShowPassword() {
    return showPassword;
  }

  void setEmailText(String text) {
    emit(text as Carstates); // Set the text value in the state
  }

  Carstates getEmailText() {
    return state; // Return the current text value
  }
}
