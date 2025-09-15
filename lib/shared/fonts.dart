import 'package:flutter/services.dart';

void loadFontNotoColorEmoji() async {
  try {
    final fontLoader = FontLoader('NotoColorEmoji')
      ..addFont(rootBundle.load('lib/assets/fonts/NotoColorEmoji-Regular.ttf'));
    await fontLoader.load();
  } catch (e) {
    //
  }
}
