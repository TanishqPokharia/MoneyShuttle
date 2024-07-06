import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)).copyWith(
      appBarTheme:
          AppBarTheme(backgroundColor: Color.fromARGB(255, 36, 176, 129)),
      drawerTheme: DrawerThemeData(),
      cardTheme: CardTheme(color: Colors.grey.withOpacity(0.5)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              padding:
                  MaterialStatePropertyAll(EdgeInsets.all(context.rSize(15))),
              alignment: Alignment.center,
              textStyle: MaterialStatePropertyAll(
                  GoogleFonts.lato(fontSize: context.rSize(26))),
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 36, 176, 129)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.rSize(50)))))),
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: MaterialStatePropertyAll(5),
              alignment: Alignment.center)),
      textTheme: TextTheme(
          titleSmall: GoogleFonts.lato(
              fontSize: context.rSize(18), color: Colors.black),
          titleMedium: GoogleFonts.lato(fontSize: context.rSize(26), color: Colors.black),
          titleLarge: GoogleFonts.lato(fontSize: context.rSize(36), color: Colors.black)),
      inputDecorationTheme: InputDecorationTheme(focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rSize(5))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rSize(5))), disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rSize(5))), border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rSize(5))), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(context.rSize(5)))),
      iconTheme: IconThemeData(color: Colors.black));
}
