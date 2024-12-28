import 'dart:convert';

import 'package:chat/futures/call/call.controller.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    var token = Get.parameters['token'];
    var mode = Get.parameters['mode'] ?? 'video';
    var url = Services.configs.get(key: CONSTANTS.STORAGE_CALL_URL);

    url = url.replaceAll('\$1', token);
    url = url.replaceAll('\$2', mode);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                transparentBackground: true,
              ),
            ),
            onCreateWindow: (controller, createWindowRequest) async {
              await controller.addWebMessageListener(
                WebMessageListener(
                  jsObjectName: "flutter",
                  allowedOriginRules: {"*"},
                  onPostMessage:
                      (message, sourceOrigin, isMainFrame, replyProxy) {
                    if (message != null) {
                      var json = jsonDecode(message);

                      var event = json['event'];
                      var data = json['data'];

                      if (event == 'state') {
                        // setState(() {
                        //   state = data;
                        // });
                        //
                        // if (data == 'connected') {
                        //   player.stop();
                        // }
                      }

                      if (event == 'options') {
                        // replyProxy.postMessage(
                        //   WebMessage(
                        //     data: jsonEncode({
                        //       'event': 'options',
                        //       'data': {
                        //         'video': hasCamera,
                        //         'audio': isMuted,
                        //       }
                        //     }),
                        //   ),
                        // );
                      }
                    }
                  },
                ),
              );

              return true;
            },
          ),
        ],
      ),
    );
  }
}
