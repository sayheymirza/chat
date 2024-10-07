import 'package:flutter/material.dart';

class CardDynamicWidget extends StatelessWidget {
  final List<String> gradientColors;
  final String title;
  final String titleColor;
  final String subtitle;
  final String subtitleColor;
  final String? buttonText;
  final String? buttonOnTap;
  final bool buttonVisable;
  final bool closeable;

  const CardDynamicWidget({
    super.key,
    required this.gradientColors,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    this.buttonText,
    this.buttonOnTap,
    required this.buttonVisable,
    required this.closeable,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
