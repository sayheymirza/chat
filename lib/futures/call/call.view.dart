import 'dart:convert';
import 'dart:developer';

import 'package:chat/futures/call/call.controller.dart';
import 'package:chat/models/call.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CallController());

    var token = Get.parameters['token'] ?? Get.arguments?['token'];

    var mode = Get.parameters['mode'] ?? Get.arguments['mode'] ?? 'video';
    var url = Services.configs.get(key: CONSTANTS.STORAGE_CALL_URL);

    url = url.replaceAll('\$1', token);
    url = url.replaceAll('\$2', mode);

    print(url);

    if (mode == "audio") {
      controller.microphone.value = true;
      controller.camera.value = false;
    } else {
      controller.microphone.value = true;
      controller.camera.value = true;
    }

    onMessage(dynamic json) {
      var event = json['event'];
      var data = json['data'];

      log('[call.view.dart] got $event event with $data');

      if (event == 'init') {
        return {
          'event': 'init',
          'data': {
            'token': token,
            'mode': mode,
          },
        };
      }

      if (event == 'state') {
        print('state is $data');
        if (data == 'connected') {
          Services.sound.stop(type: 'ringtone');
          Services.sound.stop(type: 'dialing');
          controller.durationing();
        }
      }

      if (event == 'options') {
        Services.call.action(type: CALL_ACTIONS.HEARTBEAT);

        // controller.devices.value = data['devices'];

        return {
          'event': 'options',
          'data': {
            'video': controller.camera.value,
            'audio': controller.microphone.value,
            'audio_device': controller.selected_speaker.value,
            'video_device': controller.selected_camera.value,
          }
        };
      }
    }

    return Obx(
      () => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Get.theme.primaryColor,
                      Get.theme.primaryColorDark,
                      Get.theme.primaryColorLight,
                    ],
                  ),
                ),
              ),
              webview(
                url: url,
                onMessage: onMessage,
              ),
              if (controller.profile.value.avatar != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 100,
                  child: AnimatedOpacity(
                    opacity: controller.profiling.value &&
                            controller.camera.value == false
                        ? 1
                        : 0,
                    duration: Duration(seconds: 1),
                    child: Column(
                      children: [
                        AvatarWidget(
                          seen: 'online',
                          url: controller.profile.value.avatar!,
                          size: 128,
                        ),
                        const Gap(20),
                        Text(
                          controller.profile.value.fullname!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          controller.time.value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 40,
                    right: 20,
                    left: 20,
                    top: 40,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white24,
                        Colors.white54,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      button(
                        onTap: () => controller.microphoneToggle(),
                        icon: controller.microphone.value
                            ? Icons.mic_rounded
                            : Icons.mic_off_rounded,
                        label: controller.microphone.value
                            ? "میکروفون روشن"
                            : "میکروفون خاموش",
                        backgroundColor: controller.microphone.value
                            ? Colors.green
                            : Colors.red,
                      ),
                      button(
                        onTap: () => controller.cameraToggle(),
                        icon: controller.camera.value
                            ? Icons.videocam_rounded
                            : Icons.videocam_off_rounded,
                        label: controller.camera.value
                            ? "دوربین روشن"
                            : "دوربین خاموش",
                        backgroundColor:
                            controller.camera.value ? Colors.green : Colors.red,
                      ),
                      button(
                        onTap: () => controller.hangup(),
                        icon: Icons.call_end_rounded,
                        label: "قطع تماس",
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget webview({
    required String url,
    required Function(dynamic json) onMessage,
  }) {
    return InAppWebView(
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

        if (await WebViewFeature.isFeatureSupported(
            WebViewFeature.WEB_MESSAGE_LISTENER)) {
          await ctx.addWebMessageListener(
            WebMessageListener(
              jsObjectName: "flutter",
              onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
                if (message?.data != null &&
                    message?.type == WebMessageType.STRING) {
                  var json = jsonDecode(message!.data.toString());

                  var result = onMessage(json);

                  replyProxy.postMessage(
                    WebMessage(
                      data: jsonEncode(result),
                      type: WebMessageType.STRING,
                    ),
                  );
                }
              },
            ),
          );
        }

        if (await WebViewFeature.isFeatureSupported(
            WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
          var webMessageChannel = await ctx.createWebMessageChannel();
          var port1 = webMessageChannel!.port1;

          await port1.setWebMessageCallback((message) async {
            print("Message coming from the JavaScript side: $message");
            // when it receives a message from the JavaScript side, respond back with another message.
            await port1.postMessage(
              WebMessage(data: message!.data + " and back"),
            );
          });

          ctx.postWebMessage(
            message: WebMessage(
              data: {'event': 'handshake'},
              ports: [port1],
            ),
            targetOrigin: WebUri("*"),
          );
        }

        if (!kIsWeb) {
          ctx.addJavaScriptHandler(
            handlerName: 'flutter',
            callback: (JavaScriptHandlerFunctionData e) {
              var d = e.args.firstOrNull;
              if (d != null) {
                var json = d;

                return onMessage(json);
              }
            },
          );

          ctx.postWebMessage(
            message: WebMessage(
              data: {'event': 'handshake'},
            ),
          );
        }

        await ctx.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      },
    );
  }

  Widget button({
    required Function onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    Color iconColor = Colors.white,
    Color labelColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
            ),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                  shadows: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black45,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
