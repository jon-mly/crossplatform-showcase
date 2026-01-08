import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  //
  // Spacing Values
  //

  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 32.0;

  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double sectionSpacing = 32.0;

  //
  // Vertical SizedBox Spacers
  //

  static const SizedBox verticalS = .new(height: s);
  static const SizedBox verticalM = .new(height: m);
  static const SizedBox verticalL = .new(height: l);

  //
  // Horizontal SizedBox Spacers
  //

  static const SizedBox horizontalS = .new(width: s);
  static const SizedBox horizontalM = .new(width: m);
  static const SizedBox horizontalL = .new(width: l);

  //
  // Screen Padding Helpers
  //

  static const EdgeInsets screenPaddingAll = .all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal = .symmetric(
    horizontal: screenPadding,
  );
  static const EdgeInsets screenPaddingVertical = .symmetric(
    vertical: screenPadding,
  );

  static const EdgeInsets cardPaddingAll = .all(cardPadding);
}
