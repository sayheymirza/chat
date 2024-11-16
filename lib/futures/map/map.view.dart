import 'package:chat/futures/map/map.controller.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:screenshot/screenshot.dart';

class MapView extends GetView<MapViewController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapViewController());

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height:
              MediaQuery.paddingOf(context).bottom + 16 + Get.bottomBarHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  controller.zoomIn();
                },
                icon: Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.zoomOut();
                },
                icon: Icon(
                  Icons.zoom_out,
                  color: Colors.white,
                ),
              ),
              if (controller.gps.value != "loading")
                IconButton(
                  onPressed: () {
                    controller.useCurrentLocation();
                  },
                  icon: Icon(
                    controller.gps.value == "ready"
                        ? Icons.gps_fixed_rounded
                        : Icons.gps_not_fixed_rounded,
                    color: Colors.white,
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  controller.submit();
                },
                child: const Text(
                  'ارسال',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Screenshot(
          controller: controller.screenshotController,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: const LatLng(32.4279, 53.688),
                initialZoom: 5,
                onPositionChanged: (position, hasGesture) {
                  controller.setPosition(position.center, position.zoom);
                },
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}&hl=fa',
                  tileProvider: CachedTileProvider(
                    // use the store for your CachedTileProvider instance
                    store: MemCacheStore(),
                  ),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 32.0,
                      height: 32.0,
                      point: controller.position.value,
                      child: Image.asset(
                        'lib/app/assets/images/map_marker.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
