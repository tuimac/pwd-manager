import 'package:flutter/material.dart';
import 'router.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

void main() {
  runApp(const MainApp());
}

void initData() {
  final baseDirInfo = getApplicationDocumentsDirectory();
  log(baseDirInfo.toString());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp.router(
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      title: 'PWD Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 53, 80, 91)),
    );
  }
}
