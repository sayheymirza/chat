import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Color HexColor(String hexColor) {
  try {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    return Colors.transparent;
  }
}
