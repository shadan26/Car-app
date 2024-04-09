part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}
class SignInLoading extends SignupState {}
class SignSuccess extends SignupState {}
class SignFailure extends SignupState {
  final String errorMassage;

  SignFailure({required this.errorMassage});
}