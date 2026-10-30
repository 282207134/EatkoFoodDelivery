import 'package:flutter/material.dart';

const orange = Color(0xFFFF6D00);
const ink = Color(0xFF272D2F);
const muted = Color(0xFF9A9C9D);
const canvas = Color(0xFFFAFAFA);
const pale = Color(0xFFF3F3F3);
ThemeData eatkoTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Barlow',
  scaffoldBackgroundColor: canvas,
  colorScheme: ColorScheme.fromSeed(
    seedColor: orange,
    primary: orange,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: ink),
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: ink,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ink,
    ),
    bodySmall: TextStyle(fontSize: 13, color: muted),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: canvas,
    contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: orange),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: ink),
  ),
);
