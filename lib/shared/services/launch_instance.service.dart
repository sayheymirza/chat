import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchInstanceService extends GetxService {
  void launch(String url, {String mode = "default"}) {
    var mode0 = LaunchMode.platformDefault;

    if (mode == "external") {
      mode0 = LaunchMode.externalApplication;
    }

    launchUrl(
      Uri.parse(url),
      mode: mode0,
    );
  }
}
