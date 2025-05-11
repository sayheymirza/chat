import 'dart:js';

import 'package:js/js_util.dart';

Future<List<int>> generateWaveform({required String path}) async {
  try {
    final result = await promiseToFuture(
        callMethod(context['window'], 'generateWaveform', [path]));
    return List<double>.from(result).map((e) => e.toInt()).toList();
  } catch (e) {
    print('Error generating waveform on web: $e');
    return [];
  }
}
