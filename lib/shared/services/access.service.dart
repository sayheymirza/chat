import 'package:chat/shared/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccessService extends GetxService {
  Future<PackageInfo> generatePackageInfo() {
    return PackageInfo.fromPlatform();
  }

  Future<dynamic> generate() async {
    var package = await generatePackageInfo();

    if (GetPlatform.isAndroid) {
      var device = await DeviceInfoPlugin().androidInfo;

      var data = {
        'flavor': CONSTANTS.FLAVOR.toLowerCase(),
        'platform': 'android',
        'package_name': package.packageName,
        'package_version': package.version,
        'package_code': package.buildNumber,
        'device_os': 'android',
        'device_os_version': device.version.release,
        'device_brand': device.brand,
        'device_model': device.model,
      };

      return data;
    } else if (GetPlatform.isWeb) {
      var data = {
        'flavor': CONSTANTS.FLAVOR.toLowerCase(),
        'platform': 'web',
        'package_name': package.packageName,
        'package_version': package.version,
        'package_code': package.buildNumber,
      };

      return data;
    }

    return {};
  }
}
