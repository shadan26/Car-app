// class RegisterState {
//   final bool isSuccess;
//   final String? error;
//
//   RegisterState({required this.isSuccess, this.error});
// }
//
// class RegisterInitial extends RegisterState {
//   RegisterInitial() : super(isSuccess: false);
// }
//
// class RegisterLoading extends RegisterState {
//   RegisterLoading() : super(isSuccess: false);
// }
//
// class RegisterSuccess extends RegisterState {
//   RegisterSuccess() : super(isSuccess: true);
// }
//
// class RegisterFailure extends RegisterState {
//   RegisterFailure({String? error}) : super(isSuccess: false, error: error);
// }


// register_state.dart
part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}

