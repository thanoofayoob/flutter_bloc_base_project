import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/bloc/auth_bloc.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/ui/home_page.dart';
import 'package:flutter_bloc_base_project/src/presentation/authentication/ui/on_boarding_screens.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/route_utils.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_storage/auth_service.dart';
import '../authentication/ui/login_page.dart';

class AppRouter {
  late final SecureStorage appService;

  AppRouter({required this.appService});
  static final GoRouter goRouter = GoRouter(
    initialLocation: APPAGE.home.toPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: APPAGE.home.toPath,
          name: APPAGE.home.toName,
          // pageBuilder: (context, state) => MaterialPage<void>(
          //     key: state.pageKey,
          //     child: BlocProvider.value(
          //         value: BlocProvider.of<AuthBloc>(context),
          //         child: HomePage())),
          builder: (context, state) {
            return BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (oldState, newState) {
                return true;
              },
              // buildWhen:,
              builder: (context, state) {
                // debugPrint(state.toString());
                log('statee is');
                log(state.toString());
                if (state is AuthenticationLoading) {
                  debugPrint('Auth Loading');
                  return const OnBoardingScreen(); // alternative way

                  // context.goNamed(APPAGE.splash.toName);
                  //  👈 Display your splash screen here and you can provide delay while changing state in your bloc
                } else if (state is AuthenticationUnauthenticated) {
                  context.goNamed(APPAGE.login.toName);
                } else if (state is AuthenticationAuthenticated) {
                  return HomePage();
                  // context.goNamed(APPAGE.home.toName);
                } else {
                  return const Scaffold();
                }
                throw 'error';
              },
            );
          }),
      GoRoute(
        path: APPAGE.login.toPath,
        name: APPAGE.login.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: BlocProvider.value(
                value: BlocProvider.of<AuthBloc>(context), child: LoginPage())),
      ),
      GoRoute(
        path: APPAGE.splash.toPath,
        name: APPAGE.splash.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: BlocProvider.value(
                value: BlocProvider.of<AuthBloc>(context),
                child: const OnBoardingScreen())),
      ),
    ],
    // redirect: (context, state) {
    //   SecureStorage data = SecureStorage();

    //   final loginLocation = state.namedLocation(APPAGE.login.toName);
    //   final homeLocation = state.namedLocation(APPAGE.home.toName);
    //   final splashLocation = state.namedLocation(APPAGE.splash.toName);
    //   final onboardLocation = state.namedLocation(APPAGE.splash.toName);

    //   final isLogedIn = data.loginState;
    //   final isInitialized = data.initialized;
    //   final isOnboarded = data.onboarding;

    //   final isGoingToLogin = state.location == loginLocation;
    //   final isGoingToInit = state.location == splashLocation;
    //   final isGoingToOnboard = state.location == onboardLocation;

    //   // If not Initialized and not going to Initialized redirect to Splash
    //   if (!isInitialized && !isGoingToInit) {
    //     return splashLocation;
    //     // If not onboard and not going to onboard redirect to OnBoarding
    //   } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
    //     return onboardLocation;
    //     // If not logedin and not going to login redirect to Login
    //   } else if (isInitialized &&
    //       isOnboarded &&
    //       !isLogedIn &&
    //       !isGoingToLogin) {
    //     return loginLocation;
    //     // If all the scenarios are cleared but still going to any of that screen redirect to Home
    //   } else if ((isLogedIn && isGoingToLogin) ||
    //       (isInitialized && isGoingToInit) ||
    //       (isOnboarded && isGoingToOnboard)) {
    //     return homeLocation;
    //   } else {
    //     // Else Don't do anything
    //     return null;
    //   }
    // },
    errorBuilder: (context, state) => const Text('Error'),
  );

  static void navigateTo(String routeName) {
    goRouter.push(routeName);
  }

  static void pushAndRemoveUntil(String routeName) {
    while (goRouter.canPop()) {
      goRouter.pop();
    }
    goRouter.pushReplacement(routeName);
  }

  static void test() {}
}
