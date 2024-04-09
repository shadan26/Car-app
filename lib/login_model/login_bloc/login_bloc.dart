import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        try {
          await _mapLoginButtonPressedToState(event, emit);
        } catch (e) {
          emit(LoginFailure(errorMassage: 'Unknown error'));
        }
      }
    });
  }

  Future<void> _mapLoginButtonPressedToState(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMassage: 'User not found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMassage: 'Wrong password'));
      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure(errorMassage: 'Invalid credential'));
      } else {
        emit(LoginFailure(errorMassage: 'Unknown error'));
      }
    } catch (e) {
      emit(LoginFailure(errorMassage: 'Unknown error'));
    }
  }
}
