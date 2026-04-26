import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get getDefault {
    return ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 53, 80, 91),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.getFont('Outfit',
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 56, 168, 224),
        ),
        colorScheme: const ColorScheme(
          primary: Colors.blue,
          secondary: Colors.orange,
          background: Color.fromARGB(255, 221, 192, 240),
          surface: Colors.grey,
          error: Colors.red,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ));
  }
}
