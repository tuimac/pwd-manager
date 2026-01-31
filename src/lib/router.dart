import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/widgets/auth/main.dart';
import 'package:src/widgets/createPassword/main.dart';
import 'package:src/widgets/importExport/main.dart';
import 'package:src/widgets/listPassword/main.dart';
import 'package:src/widgets/editPassword/main.dart';
import 'package:src/widgets/restore/main.dart';
import 'package:src/widgets/systemConfig/main.dart';
import 'package:src/widgets/systemLogs/main.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const Authentication();
          }),
      GoRoute(
          path: '/listpwd',
          builder: (BuildContext context, GoRouterState state) {
            return const ListPasswords();
          }),
      GoRoute(
          path: '/editpwd/:primaryKey',
          builder: (BuildContext context, GoRouterState state) {
            return EditPassword(
                data: state.extra as Map<String, dynamic>,
                primaryKey: state.pathParameters['primaryKey']!);
          }),
      GoRoute(
          path: '/createpwd',
          builder: (BuildContext context, GoRouterState state) {
            return CreatePassword(data: state.extra as Map<String, dynamic>);
          }),
      GoRoute(
          path: '/systemconfig',
          builder: (BuildContext context, GoRouterState state) {
            return const SystemConfig();
          }),
      GoRoute(
          path: '/restore',
          builder: (BuildContext context, GoRouterState state) {
            return const Restore();
          }),
      GoRoute(
          path: '/importexport',
          builder: (BuildContext context, GoRouterState state) {
            return ImportExport(data: state.extra as Map<String, dynamic>);
          }),
      GoRoute(
          path: '/systemlogs',
          builder: (BuildContext context, GoRouterState state) {
            return const SystemLogs();
          }),
    ],
  );

  static GoRouter get router => _router;
}
