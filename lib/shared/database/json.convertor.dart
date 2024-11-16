import 'dart:convert';

import 'package:drift/drift.dart';

class JsonConverter extends TypeConverter<Map, String>
    with JsonTypeConverter<Map, String> {
  const JsonConverter();

  @override
  Map fromSql(String fromDb) {
    return jsonDecode(fromDb);
  }

  @override
  String toSql(dynamic value) {
    return jsonEncode(value);
  }
}
