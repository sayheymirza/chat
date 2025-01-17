import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';

class CardNumbersBlockedWidget extends StatelessWidget {
  const CardNumbersBlockedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        Services.configs.get(key: CONSTANTS.STORAGE_VERIFY_PHONE_DESCRIPTION),
      ),
    );
  }

}