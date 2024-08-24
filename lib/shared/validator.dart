typedef FormFieldValidator<T> = String? Function(T? value);

RegExp english = RegExp(r'^[a-zA-Z]+$');
RegExp persian = RegExp(r'/^[\u0600-\u06FF\s\.\-\?\!\,]+$/');
RegExp number = RegExp(r'[0-9]');

List<String> persianNumbers = [
  '۰',
  '۱',
  '۲',
  '۳',
  '۴',
  '٥',
  '٦',
  '۷',
  '۸',
  '۹',
  '۵'
];
List<String> englishNumbers = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '5'
];

class CustomValidator {
  static FormFieldValidator<T> justEnglish<T>({
    required String errorText,
  }) {
    return (T? value) {
      if (value is String && value.trim().isNotEmpty) {
        if (english.hasMatch(value) == false) {
          return errorText;
        }
      }

      return null;
    };
  }

  static FormFieldValidator<T> justPersian<T>({
    required String errorText,
    List<String> skipChars = const [' ', '?', '!', '.', '؟', '\n'],
  }) {
    return (T? value) {
      if (value is String && value.trim().isNotEmpty) {
        for (var char in value.split('')) {
          if (!justEnglishNumber(char)) continue;
          if (skipChars.contains(char)) continue;

          var code = char.codeUnits.first;

          if (!(code >= 1570 && code <= 1773)) {
            return errorText;
          }
        }
      }

      return null;
    };
  }

  static FormFieldValidator<T> justNotPersian<T>({
    required String errorText,
    List<String> skipChars = const [],
  }) {
    return (T? value) {
      if (value is String && value.trim().isNotEmpty) {
        for (var char in value.split('')) {
          if (!justEnglishNumber(char)) continue;
          if (skipChars.contains(char)) continue;

          var code = char.codeUnits.first;

          if ((code >= 1570 && code <= 1773)) {
            return errorText;
          }
        }
      }

      return null;
    };
  }

  static FormFieldValidator<T> justNotNumber<T>({
    required String errorText,
  }) {
    return (T? value) {
      if (value is String && value.trim().isNotEmpty) {
        if (justEnglishNumber(value) == false) {
          return errorText;
        }
      }

      return null;
    };
  }

  static bool justEnglishNumber(String value) {
    value = convertPN2EN(value);

    // ignore: no_leading_underscores_for_local_identifiers
    final _value = value.replaceAll(number, '');

    return _value.length == value.length;
  }

  static String convertPN2EN(String value) {
    for (int i = 0; i < persianNumbers.length; i++) {
      value = value.replaceAll(persianNumbers[i], englishNumbers[i]);
    }
    return value;
  }
}
