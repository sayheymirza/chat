import 'package:get/get.dart';
import 'package:chat/shared/platform/web_waveform.dart'
    if (dart.library.io) 'package:chat/shared/platform/io_waveform.dart';

class WaveframeService extends GetxService {
  Future<List<int>> process({required String path}) async {
    return await generateWaveform(path: path);
  }
}
