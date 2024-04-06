// register_bloc.dart
// register_state.dart
part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}


