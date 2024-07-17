import 'package:flutter/material.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primaryColorDark: const Color.fromARGB(255, 11, 50, 113),
  secondaryHeaderColor: Colors.purple,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.blue,
    onPrimary: Colors.white,
    secondary: Colors.purple,
    onSecondary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black87,
    error: Colors.redAccent,
  ),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: 20,
      color: Colors.white70,
      fontStyle: FontStyle.normal,
    ),
    bodyLarge: TextStyle(
      fontSize: 25.0,
      color: Colors.black,
      fontFamily: 'Hind',
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontFamily: 'Hind',
    ),
  ),
);
