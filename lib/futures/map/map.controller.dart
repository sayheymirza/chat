import 'package:chat/shared/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class MapViewController extends GetxController {
  MapController mapController = MapController();
  ScreenshotController screenshotController = ScreenshotController();

  Rx<LatLng> position = LatLng(32.4279, 53.688).obs;
  RxDouble zoom = 5.0.obs;

  RxString gps = "loading".obs;

  @override
  void onInit() {
    super.onInit();

    Services.permission.has('gps').then((value) {
      gps.value = value ? 'ready' : 'faild';
    });
  }

  void useCurrentLocation() async {
    try {
      if (gps.value != "ready") {
        var result = await Services.permission.gps();

        if (result == false) {
          return;
        } else {
          gps.value = "ready";
        }
      }

      var position = await Services.permission.location();

      if (position != null) {
        mapController.move(position, 15);
      }
    } catch (e) {
      print(e);
    }
  }

  void submit() async {
    // save file in temp
    var tempDir = await getTemporaryDirectory();

    var image = await screenshotController.captureAndSave(
      tempDir.path,
      fileName: 'map.png',
    );

    Get.back(
      result: {
        'lat': position.value.latitude,
        'lon': position.value.longitude,
        'zoom': zoom.value,
        'path': image,
      },
    );
  }

  void zoomIn() {
    mapController.move(
      mapController.camera.center,
      mapController.camera.zoom + 1,
    );
  }

  void zoomOut() {
    mapController.move(
      mapController.camera.center,
      mapController.camera.zoom - 1,
    );
  }

  void setPosition(LatLng position, double zoom) {
    this.position.value = position;
    this.zoom.value = zoom;
  }
}
