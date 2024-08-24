import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String seen;
  final String url;

  const AvatarWidget({
    super.key,
    required this.seen,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: color,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Image.network(url),
    );
  }

  Color get color {
    switch (seen) {
      case "online":
        return Colors.green;
      case "recently":
        return Colors.amber;
      case "offline":
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }
}
