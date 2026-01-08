import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double cardRadius = 16.0;
  static const double buttonRadius = 24.0;

  static BorderRadius get cardBorderRadius => .circular(cardRadius);
  static BorderRadius get buttonBorderRadius => .circular(buttonRadius);
}
