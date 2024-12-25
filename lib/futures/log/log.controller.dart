import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LogController extends GetxController {
  List<Map<String, String>> categories = [
    {
      'text': 'همه',
      'key': '',
    },
    // socket
    {
      'text': 'سوکت',
      'key': 'socket',
    },
  ];

  RxString category = ''.obs;

  Future<void> makeDB() async {
    try {
      // مسیر فایل دیتابیس در دایرکتوری اپلیکیشن
      final appDocDir = await getApplicationDocumentsDirectory();
      final databasePath = path.join(appDocDir.path, 'database.sqlite');

      // مسیر مقصد در دایرکتوری Downloads
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final copiedPath = path.join(downloadsDir.path, 'database.sqlite');

      // کپی فایل
      final databaseFile = File(databasePath);
      if (await databaseFile.exists()) {
        await databaseFile.copy(copiedPath);
        print('Database copied to: $copiedPath');
      } else {
        print('Database file does not exist.');
      }
    } catch (e) {
      print('Error copying database: $e');
    }
  }
}
