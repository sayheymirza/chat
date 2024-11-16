import 'package:get/get.dart';
import 'package:waveform_extractor/waveform_extractor.dart';

class WaveframeService extends GetxService {
  Future<List<int>> process({required String path}) async {
    try {
      var waveformExtractor = WaveformExtractor();
      var result = await waveformExtractor.extractWaveformDataOnly(
        path,
        samplePerSecond: 100,
        useCache: false,
      );

      print(result.length);

      return result;
    } catch (e) {
      return [];
    }
  }
}
