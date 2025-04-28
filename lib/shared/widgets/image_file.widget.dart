import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Image CustomImageFile({
  required dynamic file,
  Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  AlignmentGeometry alignment = Alignment.center,
  BoxFit? fit,
}) {
  if (kIsWeb) {
    return Image.network(
      file.path,
      errorBuilder: errorBuilder,
      alignment: alignment,
      fit: fit,
    );
  } else {
    return Image.file(
      file,
      errorBuilder: errorBuilder,
      alignment: alignment,
      fit: fit,
    );
  }
}
