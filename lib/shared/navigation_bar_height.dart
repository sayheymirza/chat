import 'package:flutter/material.dart';

var navigationBarHeight = 0.0;

double getNavigationBarHeight(BuildContext context) {
  // Get the padding of the bottom, but make sure it's unaffected by the keyboard.
  double bottomPadding = MediaQuery.of(context).padding.bottom;

  // Optionally, use a fixed height value for the navigation bar
  if (bottomPadding == 0) {
    return kBottomNavigationBarHeight; // Default height
  }
  return bottomPadding; // This will give the actual padding if the system bar is visible.
}
