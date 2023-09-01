import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/widgets/createPassword/mainWidget.dart';
import 'package:src/widgets/importExport/mainWidget.dart';
import 'package:src/widgets/listPassword/mainWidget.dart';
import 'package:src/widgets/editPassword/mainWidget.dart';
import 'package:src/widgets/restore/mainWidget.dart';
import 'package:src/widgets/systemConfig/mainWidget.dart';

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
            log(state.pathParameters['data']!);
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
            final Map<String, dynamic> passwordData =
                json.decode(state.pathParameters['data']!);
            return SystemConfig(data: passwordData);
          }),
      GoRoute(
          path: '/restore',
          builder: (BuildContext context, GoRouterState state) {
            return Restore();
          }),
      GoRoute(
          path: '/importexport',
          builder: (BuildContext context, GoRouterState state) {
            return const ImportExport();
          }),
    ],
  );

  static GoRouter get router => _router;
}
