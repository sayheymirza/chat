import 'dart:math';

String formatBytes(int bytes, {int decimals = 0}) {
  // nan
  if (bytes.isNaN) return '0 بایت';

  if (bytes == 0) return '0 بایت';

  const double k = 1024;
  final int dm = decimals < 0 ? 0 : decimals;
  final List<String> sizes = [
    'بایت',
    'کیلوبایت',
    'مگابایت',
    'گیگابایت',
    'ترابایت',
    'PiB',
    'EiB',
    'ZiB',
    'YiB'
  ];

  try {
    final int i = (log(bytes) / log(k)).floor();

    return '${(bytes / pow(k, i)).toStringAsFixed(dm)} ${sizes[i]}';
  } catch (e) {
    return '0 بایت';
  }
}
