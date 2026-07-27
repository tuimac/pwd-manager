import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get getDefault {
    return ThemeData(
        dialogTheme: const DialogThemeData(
            backgroundColor: Color.fromARGB(255, 209, 226, 228),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 53, 80, 91),
        appBarTheme: AppBarTheme(
            titleTextStyle: GoogleFonts.getFont('Outfit',
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            backgroundColor: const Color.fromARGB(255, 56, 168, 224)),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 11, 80, 136),
          onPrimary: Colors.black,
          secondary: Colors.orange,
          onSecondary: Color.fromARGB(255, 52, 121, 117),
          tertiary: Color.fromARGB(255, 146, 106, 45),
          onTertiary: Color.fromARGB(255, 146, 106, 45),
          surface: Colors.grey,
          onSurface: Colors.black,
          error: Color.fromARGB(255, 160, 63, 56),
          onError: Colors.red,
        ),
        textTheme: const TextTheme(
            titleMedium: TextStyle(color: Colors.white, fontSize: 12),
            bodyLarge:
                TextStyle(color: Color.fromARGB(255, 66, 33, 80), fontSize: 18),
            bodyMedium: TextStyle(
                color: Color.fromARGB(255, 216, 212, 243), fontSize: 16),
            bodySmall: TextStyle(
                color: Color.fromARGB(255, 216, 212, 243), fontSize: 14)),
        iconTheme: const IconThemeData(size: 30.0),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            iconSize: 30.0,
            backgroundColor: const Color.fromARGB(255, 62, 114, 134),
            foregroundColor: const Color.fromARGB(255, 133, 186, 229),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        cardTheme:
            const CardThemeData(color: Color.fromARGB(255, 196, 228, 232)),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(255, 216, 212, 243)),
          hintStyle: TextStyle(color: Color.fromARGB(255, 159, 156, 179)),
        ));
  }

  static EdgeInsets getDefaultPadding() {
    return const EdgeInsets.symmetric(horizontal: 10, vertical: 10);
  }
}
