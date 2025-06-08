import 'dart:js';

import 'package:js/js_util.dart';

void NavigationToNamed(String path, {dynamic params}) {
  callMethod(context['window'], 'NavigationToNamed', [path, params]);
}
