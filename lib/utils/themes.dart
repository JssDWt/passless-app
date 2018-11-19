import 'package:flutter/material.dart';

/// Defines the dark theme
final ThemeData darkTheme = new ThemeData(
  brightness: Brightness.dark,
  buttonColor: Colors.white,
  unselectedWidgetColor: Colors.white,
  primaryTextTheme: new TextTheme(
    caption: new TextStyle(
      color: Colors.white,
    ),
    headline: new TextStyle(
      color: Colors.white,
    ),
  ),
);