// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import '../../main.dart';
// import 'register_event.dart';
// import 'register_state.dart';
//
// class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
//   RegisterBloc() : super(RegisterInitial());
//
//   @override
//   Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
//     if (event is RegisterEvent) {
//       emit (RegisterLoading());
//
//       try {
//         var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: event.email,
//           password: event.password,
//         );
//
//         var collect = FirebaseFirestore.instance.collection('users');
//         await collect.add(
//           {
//             'id': user.user?.uid,
//             "token": await getToken(),
//             'email': event.email,
//             'role': event.role,
//             'createdAt': DateTime.now().millisecondsSinceEpoch
//           },
//         );
//
//         await FirebaseMessaging.instance.subscribeToTopic(event.role);
//
//         emit (RegisterLoading());
//       } on FirebaseAuthException catch (e) {
//         yield RegisterFailure(error: e.message);
//       } catch (e) {
//          emit (RegisterFailure(error: e.toString()));
//       }
//     }
//   }
// }


// register_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());


  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterUser) {
     emit(RegisterLoading());
      try {
        // Perform registration logic here
        register();
        emit( RegisterSuccess());
      } catch (error) {
       emit (RegisterFailure(error: error.toString()));
      }
    }
  }
  void register() {
    RegisterBloc().add(RegisterUser(
      email: 'example@example.com',
      password: 'password',
      role: 'user',
    ));
  }
}


