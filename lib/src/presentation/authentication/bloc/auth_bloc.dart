import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/ui/home_page.dart';

import '../../../core/local_storage/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final bool _loginState = false;
  final bool _initialized = false;
  final bool _onboarding = false;

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get onboarding => _onboarding;
  final SecureStorage userRepository;

  AuthBloc({required this.userRepository}) : super(AuthInitialState()) {
    on<AuthInitial>(onAuthInitial);
    on<AppStarted>(onAppstarted);

    on<AuthValidatyCheckEvent>(onAuthValidatyCheckEvent);
  }

  FutureOr<void> onAuthInitial(AuthInitial event, Emitter<AuthState> emit) {}

  Future<FutureOr<void>> onAppstarted(
      AppStarted event, Emitter<AuthState> emit) async {
    debugPrint('App started');

    await Future.delayed(const Duration(seconds: 1));

    emit(AuthenticationLoading());

    await Future.delayed(const Duration(seconds: 1));
    emit(AuthenticationAuthenticated());
  }

  FutureOr<void> onAuthValidatyCheckEvent(
      AuthValidatyCheckEvent event, Emitter<AuthState> emit) {
    emit(AuthInitialUserCheckState());
  }
}
