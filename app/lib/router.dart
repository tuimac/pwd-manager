import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/list_widgets.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ListItems();
          }),
    ],
  );

  static GoRouter get router => _router;
}
