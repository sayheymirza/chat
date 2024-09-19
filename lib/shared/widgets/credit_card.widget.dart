import 'package:chat/shared/color.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({super.key});

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  String number = '';
  String name = '';
  String color = '#ffffff';
  String bank = '';

  @override
  void initState() {
    super.initState();

    number = Services.configs.get(key: CONSTANTS.STORAGE_CARD_NUMBER);
    name = Services.configs.get(key: CONSTANTS.STORAGE_CARD_NAME);
    color = Services.configs.get(key: CONSTANTS.STORAGE_CARD_COLOR);
    bank = Services.configs.get(key: CONSTANTS.STORAGE_CARD_BANK);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            HexColor(color),
            Colors.white,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 38,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: number.replaceAll('-', '')),
              );

              showSnackbar(message: 'شماره کارت کپی شد');
            },
            icon: const Icon(
              Icons.copy,
              size: 16,
            ),
            label: const Text('کپی'),
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(
                Size(80, 32),
              ),
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Text(
                bank,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
