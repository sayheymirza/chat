import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat/shared/services.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  Future<void> init() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'download_upload_group',
          channelKey: 'download_channel',
          channelName: 'دانلود',
          channelDescription: 'فایل های در حال دانلود',
          locked: true,
        ),
        NotificationChannel(
          channelGroupKey: 'download_upload_group',
          channelKey: 'upload_channel',
          channelName: 'آپلود',
          channelDescription: 'فایل های در حال آپلود',
          locked: true,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'download_upload_group',
          channelGroupName: 'دانلود و آپلود',
        )
      ],
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  // ask for notification access
  Future<bool> ask() async {
    // if the user has already granted permission, this will return true
    if (await AwesomeNotifications().isNotificationAllowed()) {
      return true;
    }

    return AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Future<void> progress({
    required int id,
    required String title,
    required double progress,
    required String channel,
  }) {
    return AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: channel,
            actionType: ActionType.Default,
            title: title,
            notificationLayout: progress == -1
                ? NotificationLayout.Default
                : NotificationLayout.ProgressBar,
            progress: progress == -1 ? null : progress,
            autoDismissible: false,
            locked: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "$channel:cancel",
              label: "انصراف",
              autoDismissible: false,
              actionType: ActionType.DismissAction,
            ),
          ],
        );
      }
    });
  }

  Future<void> dismiss({required int id}) async {
    log('[notification.service.dart] dismissed with id $id');
    AwesomeNotifications().dismiss(id);
    log('[notification.service.dart] canceled with id $id');
    AwesomeNotifications().cancel(id);
  }
}

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    var id = receivedAction.id!;
    if (receivedAction.buttonKeyPressed == "download_channel:cancel") {
      log('[notification.service.dart] download canceled');
      Services.file.downloads[id]!.cancelToken.cancel();
    }
    if (receivedAction.buttonKeyPressed == "upload_channel:cancel") {
      log('[notification.service.dart] upload canceled');
      Services.file.uploads[id]!.cancelToken.cancel();
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {}
}
