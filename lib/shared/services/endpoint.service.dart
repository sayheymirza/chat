import 'dart:developer';

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class EndpointService extends GetxService {
  final List<String> sites = [
    "https://config.mah-asal2024.workers.dev/",
  ];

  Future<bool> init() async {
    try {
      // check last endpoint is working or not else try to find new endpoint
      var lastEndpoint =
          Services.configs.get(key: CONSTANTS.STORAGE_ENDPOINT_API);

      if (lastEndpoint != null) {
        var result = await work(endpoint: lastEndpoint);

        if (result == true) {
          log('[endpoint.service.dart] endpoint inited successfully');

          return true;
        }
      }

      for (var site in sites) {
        var endpoint = await lookup(site: site);

        log('[endpoint.service.dart] lookup $site=$endpoint');

        if (endpoint != null) {
          var result = await work(endpoint: endpoint);

          if (result == true) {
            Services.configs.set(
              key: CONSTANTS.STORAGE_ENDPOINT_API,
              value: endpoint,
            );

            log('[endpoint.service.dart] endpoint inited successfully');

            return true;
          }
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> lookup({required String site}) async {
    try {
      var result = await Services.http.client.get(site);

      if (result.statusCode == 200) {
        return result.data.toString();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> work({required String endpoint}) async {
    try {
      var result = await Services.http.client.get(endpoint);

      if (result.statusCode == 200) {
        return result.data.toString().trim() ==
            "HELLO WELCOME TO FRONTEND SERVICE";
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
