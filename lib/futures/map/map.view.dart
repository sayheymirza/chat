import 'package:chat/futures/map/map.controller.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

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
              if (kIsWeb) {
                NavigationBack();
              } else {
                Get.back();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.paddingOf(context).bottom + 16 + 56,
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
                  icon: controller.gps.value == "gpsing"
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      : Icon(
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
        body: controller.inited.value == false
            ? Container()
            : Screenshot(
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
                      initialCenter: controller.centerPosition.value,
                      initialZoom: controller.centerZoom.value,
                      onPositionChanged: (position, hasGesture) {
                        controller.setPosition(position.center, position.zoom);
                      },
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                      ),
                    ),
                    children: [
                      if (controller.type.value == "raster")
                        TileLayer(
                          urlTemplate: controller.url.value,
                          tileProvider: CachedTileProvider(
                            // use the store for your CachedTileProvider instance
                            store: MemCacheStore(),
                          ),
                        ),
                      if (controller.type.value == "vector" &&
                          controller.style != null)
                        VectorTileLayer(
                          tileProviders: controller.style!.providers,
                          theme: controller.style!.theme,
                          sprites: controller.style!.sprites,
                          maximumZoom: 19,
                          tileOffset: TileOffset.mapbox,
                          layerMode: VectorTileLayerMode.vector,
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
