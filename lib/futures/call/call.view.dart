import 'dart:convert';

import 'package:chat/futures/call/call.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallController());

    var token = Get.parameters['token'] ?? Get.arguments['token'];
    var mode = Get.parameters['mode'] ?? Get.arguments['mode'] ?? 'video';
    // var url = Services.configs.get(key: CONSTANTS.STORAGE_CALL_URL);
    var url = "https://public.doting.ir/call.html?token=\$1&mode=\$2";

    url = url.replaceAll('\$1', token);
    url = url.replaceAll('\$2', mode);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              iframeAllow: "camera; microphone",
              // for camera and microphone permissions
              iframeAllowFullscreen: true,
              // if you need fullscreen support
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              transparentBackground: true,
            ),
            onPermissionRequest: (controller, permissionRequest) async {
              return PermissionResponse(
                resources: permissionRequest.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            onWebViewCreated: (ctx) async {
              controller.web = ctx;

              ctx.addJavaScriptHandler(
                handlerName: 'flutter',
                callback: (JavaScriptHandlerFunctionData e) {
                  var d = e.args.firstOrNull;
                  if (d != null) {
                    var json = d;

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
                      return {
                        'event': 'options',
                        'data': {
                          'video': controller.camera.value,
                          'audio': controller.microphone.value,
                        }
                      };
                    }
                  }
                },
              );

              await ctx.addWebMessageListener(
                WebMessageListener(
                  jsObjectName: "flutter",
                  allowedOriginRules: {"*"},
                  onPostMessage:
                      (message, sourceOrigin, isMainFrame, replyProxy) {
                    if (message != null) {
                      var json = jsonDecode(message.data);

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
                        replyProxy.postMessage(
                          WebMessage(
                            data: jsonEncode({
                              'event': 'options',
                              'data': {
                                'video': controller.camera.value,
                                'audio': controller.microphone.value,
                              }
                            }),
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            right: 20,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    controller.microphoneToggle();
                  },
                  icon: Obx(
                    () => Icon(
                      controller.microphone.value
                          ? Icons.mic_off_rounded
                          : Icons.mic_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.cameraToggle();
                  },
                  icon: Obx(
                    () => Icon(
                      controller.camera.value
                          ? Icons.videocam_rounded
                          : Icons.videocam_off_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.hangup();
                  },
                  icon: Icon(
                    Icons.call_end_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
