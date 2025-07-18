// statefull class for chat_delete_message_dialog
// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDeleteMessageDialog extends StatefulWidget {
  const ChatDeleteMessageDialog({Key? key}) : super(key: key);

  @override
  _ChatDeleteMessageDialogState createState() =>
      _ChatDeleteMessageDialogState();
}

class _ChatDeleteMessageDialogState extends State<ChatDeleteMessageDialog> {
  bool all = false;

  StreamSubscription<EventModel>? subevents;

  @override
  void initState() {
    super.initState();

    if (subevents == null) {
      NavigationOpenedDialog();

      subevents = event.on<EventModel>().listen((data) async {
        if (data.event == EVENTS.NAVIGATION_BACK) {
          Get.back();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حذف پیام',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // checkbox "ین پیام برای هر دو حذف شود."
            Row(
              children: [
                Checkbox(
                  value: all,
                  onChanged: (value) {
                    setState(() {
                      all = value!;
                    });
                  },
                ),
                const Text('این پیام برای هر دو حذف شود.'),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //   انصراف button
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('انصراف'),
                ),
                // حذف پیام button
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: all);
                  },
                  child: Text(
                    'حذف پیام',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
