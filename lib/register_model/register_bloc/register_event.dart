// class RegisterEvent {
//   final String email;
//   final String password;
//   final String role;
//
//   RegisterEvent({required this.email, required this.password, required this.role});
// }


// register_event.dart
part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterUser extends RegisterEvent {
  final String email;
  final String password;
  final String role;

  RegisterUser({required this.email, required this.password, required this.role});
}

