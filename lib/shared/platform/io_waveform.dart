import 'package:waveform_extractor/waveform_extractor.dart';

Future<List<int>> generateWaveform({required String path}) async {
  try {
    var waveformExtractor = WaveformExtractor();
    var result = await waveformExtractor.extractWaveformDataOnly(
      path,
      samplePerSecond: 100,
      useCache: false,
    );

    return result;
  } catch (e) {
    return [];
  }
}
