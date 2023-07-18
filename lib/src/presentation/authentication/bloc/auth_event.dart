part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthInitial extends AuthEvent {}

class AuthValidatyCheck extends AuthEvent {}

class AuthValidatyCheckEvent extends AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  String email;
  String password;
  LoggedIn({required this.email, required this.password});
}

class LoggedOut extends AuthEvent {}

class OnboardingStepCompleted extends AuthEvent {}

class UserDeleted extends AuthEvent {}
