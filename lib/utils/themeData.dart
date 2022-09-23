import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xffFCF8F3),
  cardColor: const Color(0xffAEDADD),
  backgroundColor: const Color(0xffFCF8F3),
  primaryColorDark: const Color(0xff6E7DA2),
  primaryColorLight: const Color(0xffDB996C),
  colorScheme: const ColorScheme.dark().copyWith(
    secondary: Color(0xff1E2022),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xff041C32),
  cardColor: const Color(0xff064663),
  backgroundColor: const Color(0xff041C32),
  primaryColorDark: const Color(0xff04293A),
  primaryColorLight: const Color(0xffECB365),
  colorScheme: const ColorScheme.dark().copyWith(
    secondary: const Color(0xffE8F9FD),
  ),
);