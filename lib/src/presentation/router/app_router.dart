import 'package:flutter/material.dart';
import 'package:flutter_bloc_base_project/main.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/route_utils.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: APPAGE.home.toPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: APPAGE.home.toPath,
        name: APPAGE.home.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: MyHomePage(
              key: state.pageKey,
            )),
      ),
      GoRoute(
        path: APPAGE.login.toPath,
        name: APPAGE.login.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: LoginPage(
              key: state.pageKey,
            )),
      ),
      // GoRoute(
      //   path: '/profile/:id',
      //   pageBuilder: (context, state) {
      //     final id = state.params['id'];
      //     return ProfileScreen(userId: id);
      //   },
      // ),
      // GoRoute(
      //   path: '*',
      //   pageBuilder: (context, state) => NotFoundScreen(),
      // ),
    ],
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
