import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900, foregroundColor: Colors.white),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            alignment: Alignment.center,
            backgroundColor: const MaterialStatePropertyAll(
                Color.fromARGB(255, 36, 176, 129)),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.rSize(50)))))),
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll(5),
            alignment: Alignment.center)),
    textTheme: TextTheme(
        titleSmall: GoogleFonts.lato(fontSize: context.rSize(18)),
        titleMedium: GoogleFonts.lato(fontSize: context.rSize(26)),
        titleLarge: GoogleFonts.lato(fontSize: context.rSize(36))),
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.rSize(5))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.rSize(5))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.rSize(5))),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.rSize(5))),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.rSize(5)))),
  );
}
