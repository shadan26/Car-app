// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:meta/meta.dart';
//
// import '../../core/Firebase/FirebaseManager.dart';
// import '../../main.dart';
//
// part 'signup_event.dart';
// part 'signup_state.dart';
//
// class SignupBloc extends Bloc<SignupEvent, SignupState> {
//   SignupBloc() : super(SignupInitial()) {
//     on<SignupEvent>((event, emit) {
//
//
//       Future<AuthResult> register(String email, String password,
//           String role) async {
//         emit(SignInLoading());
//         try {
//           var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//             email: email,
//             password: password,
//           );
//           emit(SignSuccess());
//
//           var collect = FirebaseFirestore.instance.collection('users');
//           await collect.add(
//             {
//               'id': user.user?.uid,
//               "token": await getToken(),
//               'email': email,
//               'role': role,
//               'createdAt': DateTime
//                   .now()
//                   .millisecondsSinceEpoch
//             },
//           );
//           emit(SignSuccess());
//
//           await FirebaseMessaging.instance.subscribeToTopic(role);
//
//           return AuthResult(isSuccess: true);
//
//
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'weak-password') {} else
//           if (e.code == 'email-already-in-use') {}
//           emit(SignFailure(errorMassage: 'weak-password'));
//           emit(SignFailure(errorMassage: 'email-already-in-use'));
//           return AuthResult(isSuccess: false, error: e.message);
//
//
//         } catch (e) {
//           emit(SignFailure(errorMassage: "Unknown error."));
//           return AuthResult(isSuccess: false, error: e.toString());
//         }
//       }
//
//
//     });
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import '../../main.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      if (event is SignupButtonPressed) {
        try {
          await _mapSignupButtonPressedToState(event, emit);
        } catch (e) {
          // Handle exceptions if any
          emit(SignFailure(errorMassage: 'Unknown error'));
        }
      }
    });
  }

  Future<void> _mapSignupButtonPressedToState(
      SignupButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignInLoading());
    try {
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      var user = userCredential.user;

      await FirebaseFirestore.instance.collection('users').add({
        'id': user?.uid,
        "token": await getToken(),
        'email': event.email,
        'role': event.role,
        'createdAt': DateTime.now().millisecondsSinceEpoch
      });

      await FirebaseMessaging.instance.subscribeToTopic(event.role);

      emit(SignSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignFailure(errorMassage: 'Weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignFailure(errorMassage: 'Email already in use'));
      } else {
        emit(SignFailure(errorMassage: e.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(SignFailure(errorMassage: 'Unknown error'));
    }
  }
}



