import 'dart:convert';

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
          path: '/managepwd/:data',
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> passwordData =
                json.decode(state.pathParameters['data']!);
            return ManagePassword(data: passwordData);
          }),
    ],
  );

  static GoRouter get router => _router;
}
