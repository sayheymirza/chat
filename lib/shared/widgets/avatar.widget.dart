import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String seen;
  final String url;
  final double size;

  const AvatarWidget({
    super.key,
    required this.seen,
    required this.url,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: color,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: CachedImageWidget(
        url: "https://avatar.iran.liara.run/public/8", // url,
        category: "avatar",
      ),
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
