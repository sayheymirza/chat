import 'package:chat/shared/database/database.dart';

class LogModel {
  // id, category, message, createdAt
  final int id;
  final String category;
  final String message;
  final DateTime createdAt;

  LogModel({
    required this.id,
    required this.category,
    required this.message,
    required this.createdAt,
  });

  // form database (LogTableData)
  factory LogModel.fromDatabase(LogTableData data) {
    return LogModel(
      id: data.id,
      category: data.category,
      message: data.message,
      createdAt: data.createdAt,
    );
  }
}
