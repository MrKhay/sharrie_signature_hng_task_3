import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 64, 140, 43),
    surface: const Color.fromARGB(255, 250, 250, 250),
    error: const Color.fromARGB(255, 250, 0, 25),
  ),
  fontFamily: GoogleFonts.poppins().fontFamily,
  useMaterial3: true,
);
