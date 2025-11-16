import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF006C5F);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  appBarTheme: const AppBarTheme(centerTitle: true),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
  ),
);
