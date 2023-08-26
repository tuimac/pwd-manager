import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/widgets/createPassword/mainWidget.dart';
import 'package:src/widgets/listPassword/mainWidget.dart';
import 'package:src/widgets/editPassword/mainWidget.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ListItems();
          }),
      GoRoute(
          path: '/editpwd/:data',
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> passwordData =
                json.decode(state.pathParameters['data']!);
            return EditPassword(data: passwordData);
          }),
      GoRoute(
          path: '/createpwd/:data',
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> passwordData =
                json.decode(state.pathParameters['data']!);
            return CreatePassword(data: passwordData);
          }),
    ],
  );

  static GoRouter get router => _router;
}
