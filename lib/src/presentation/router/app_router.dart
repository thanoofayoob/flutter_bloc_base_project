import 'package:flutter/material.dart';
import 'package:flutter_bloc_base_project/main.dart';
import 'package:flutter_bloc_base_project/src/presentation/router/route_utils.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: APPAGE.login.toPath,
    routes: [
      GoRoute(
        path: APPAGE.login.toPath,
        name: APPAGE.login.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: MyHomePage(
              key: state.pageKey,
            )),
      ),
      GoRoute(
        path: APPAGE.home.toPath,
        name: APPAGE.home.toName,
        pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: MyHomePage(
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
    errorBuilder: (context, state) => Container(
      child: Text('Error'),
    ),
  );

  // static GoRouter get goRouter => _goRouter;

  static void navigateTo(String routeName) {
    goRouter.push(routeName);
  }
}
