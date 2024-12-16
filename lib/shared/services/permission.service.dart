import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<PermissionStatus> ask(String permission) async {
    switch (permission) {
      case "camera":
        return Permission.camera.request();
      case "mic":
      case "microphone":
        return Permission.microphone.request();
      case "gps":
        return Permission.locationWhenInUse.request();
      case "storage":
        var value = await Permission.storage.request();

        if (!value.isGranted) {
          value = await Permission.accessMediaLocation.request();
        }

        if (!value.isGranted) {
          value = await Permission.manageExternalStorage.request();
        }

        return value;

      case "notification":
        return Permission.notification.request();

      default:
        return Future.value(PermissionStatus.denied);
    }
  }

  Future<bool> has(String permission) async {
    switch (permission) {
      case "camera":
        return Permission.camera.isGranted;
      case "mic":
      case "microphone":
        return Permission.microphone.isGranted;
      case "gps":
        return Permission.locationWhenInUse.isGranted;
      case "storage":
        return (await Permission.storage.isGranted) ||
            (await Permission.accessMediaLocation.isGranted) ||
            (await Permission.manageExternalStorage.isGranted);
      case "notification":
        return Permission.notification.isGranted;
      default:
        return Future.value(false);
    }
  }

  Future<bool> camera() async {
    try {
      var result = await Permission.camera.request();

      return result.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> microphone() async {
    try {
      var result = await Permission.microphone.request();

      return result.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> gps() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return Future.value(true);
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.value(false);
      }

      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        return gps();
      }

      return Future.value(false);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<LatLng?> location() async {
    try {
      var value = await Geolocator.getCurrentPosition();

      return LatLng(value.latitude, value.longitude);
    } catch (e) {
      return null;
    }
  }
}
