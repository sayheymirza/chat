import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? right;
  final Widget? left;
  final bool? back;
  final List<Color>? colors;
  final Function? onBack;

  const GradientAppBarWidget({
    super.key,
    this.title,
    this.right,
    this.left,
    this.back,
    this.colors,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: Get.mediaQuery.padding.top + 56,
        padding: EdgeInsets.only(
          top: Get.mediaQuery.padding.top,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors == null || colors!.isEmpty
                ? [
                    Get.theme.primaryColor.withOpacity(0.7),
                    Get.theme.primaryColor,
                  ]
                : colors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // back button
            if (back != null && back!)
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () =>
                    onBack != null ? onBack!() : Navigator.of(context).pop(),
              ),
            if (right != null) Expanded(child: right!),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (left != null) left!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
