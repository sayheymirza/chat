import 'package:file_picker/file_picker.dart';

Future<String> getFilePath(PlatformFile file) async {
  return file.path!;
}
