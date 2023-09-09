import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/widgets/createPassword/main.dart';
import 'package:src/widgets/importExport/main.dart';
import 'package:src/widgets/listPassword/main.dart';
import 'package:src/widgets/editPassword/main.dart';
import 'package:src/widgets/logging/main.dart';
import 'package:src/widgets/restore/main.dart';
import 'package:src/widgets/systemConfig/main.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ListItems();
          }),
      GoRoute(
          path: '/editpwd/:data/:primaryKey',
          builder: (BuildContext context, GoRouterState state) {
            return EditPassword(
                data: json.decode(state.pathParameters['data']!),
                primaryKey: state.pathParameters['primaryKey']!);
          }),
      GoRoute(
          path: '/createpwd/:data',
          builder: (BuildContext context, GoRouterState state) {
            return CreatePassword(
                data: json.decode(state.pathParameters['data']!));
          }),
      GoRoute(
          path: '/systemconfig/:data',
          builder: (BuildContext context, GoRouterState state) {
            return SystemConfig(
                data: json.decode(state.pathParameters['data']!));
          }),
      GoRoute(
          path: '/restore',
          builder: (BuildContext context, GoRouterState state) {
            return const Restore();
          }),
      GoRoute(
          path: '/importexport/:data',
          builder: (BuildContext context, GoRouterState state) {
            return ImportExport(data: state.pathParameters['data']!);
          }),
      GoRoute(
          path: '/logging/:data',
          builder: (BuildContext context, GoRouterState state) {
            return Logging(data: json.decode(state.pathParameters['data']!));
          }),
    ],
  );

  static GoRouter get router => _router;
}
