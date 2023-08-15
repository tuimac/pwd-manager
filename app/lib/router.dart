import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/listPwdWidgets.dart';
import 'widgets/managePwdWidget.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ListItems();
          }),
      GoRoute(
          path: '/managepwd',
          builder: (BuildContext context, GoRouterState state) {
            return const ManagePassword();
          }),
    ],
  );

  static GoRouter get router => _router;
}
