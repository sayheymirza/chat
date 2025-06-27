import 'dart:async';

import 'package:chat/models/event.model.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogConfirmView extends StatefulWidget {
  final String title;
  final String subtitle;
  final String cancel;
  final String submit;

  const DialogConfirmView({
    super.key,
    required this.title,
    required this.subtitle,
    this.cancel = 'انصراف',
    this.submit = 'تایید',
  });

  @override
  State<DialogConfirmView> createState() => _DialogConfirmViewState();
}

class _DialogConfirmViewState extends State<DialogConfirmView> {
  StreamSubscription<EventModel>? subevents;

  @override
  void initState() {
    super.initState();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_BACK) {
        Get.back();
      }
    });

    NavigationOpenedDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 200,
      width: Get.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              widget.subtitle,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    NavigationBack();
                  },
                  child: Text(widget.cancel),
                ),
                const Gap(4),
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: true);
                    NavigationBack();
                  },
                  child: Text(
                    widget.submit,
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            Gap(MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
