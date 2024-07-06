import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: context.theme.colorScheme.onSurface,
        foregroundColor: Colors.white),
    drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade900),
    cardTheme: CardTheme(color: Colors.grey.shade800),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            padding:
                MaterialStatePropertyAll(EdgeInsets.all(context.rSize(12))),
            alignment: Alignment.center,
            textStyle: MaterialStatePropertyAll(
                GoogleFonts.lato(fontSize: context.rSize(26))),
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
    iconTheme: IconThemeData(color: Colors.white),
  );
}
