import 'package:flutter/material.dart';
import 'package:src/services/logFileIo.dart';
import 'router.dart';

void main() {
  try {
    runApp(const MainApp());
  } catch (e) {
    LogFileIO.logging(e.toString());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
