part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthInitialUserCheckState extends AuthState {}

class AuthenticationUnauthenticated extends AuthState {}

class AuthenticationAuthenticated extends AuthState {}

class AuthenticationLoading extends AuthState {}

class AuthenticationLoggingOut extends AuthState {}
