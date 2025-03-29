import 'package:chat/models/event.model.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';

class CardNewVersionWidget extends StatelessWidget {
  const CardNewVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade500,
            Colors.green.shade700,
          ],
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.download_rounded,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12,
          ),
          const Text(
            'نسخه جدید رسید',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {
              Services.event.fire(event: EVENTS.UPDATE);
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
              ),
              minimumSize: WidgetStateProperty.all(
                const Size(48, 32),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              side: WidgetStateProperty.all(
                BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: const Text(
              'دانلود کنید',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
