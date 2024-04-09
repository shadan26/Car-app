part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;
  final String role;

  SignupButtonPressed({required this.email, required this.password, required this.role});
}

