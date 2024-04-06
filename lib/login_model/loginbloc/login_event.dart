// register_event.dart
part of 'register_bloc.dart';


abstract class RegisterEvent {}

class RegisterUser extends RegisterEvent {
  final String ?email;
  final String ?password;
  final String ?role;

  RegisterUser({ this.email, this.password,  this.role});
}

