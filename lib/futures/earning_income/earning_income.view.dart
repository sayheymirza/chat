import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EarningIncomeView extends StatelessWidget {
  const EarningIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: "کسب درآمد",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 100,
          left: 32,
          right: 32,
          bottom: 32,
        ),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/images/confetti.png',
              width: 128,
              height: 128,
            ),
            const Gap(32),
            const Text(
              'کسب درآمد میلیونی با دوعو از دوستان',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Gap(12),
            Text(
              Services.configs.get(key: CONSTANTS.STORAGE_TEXT_EARNING_INCOME),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      Services.configs.get(key: CONSTANTS.STORAGE_INVITE_LINK) ?? '',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const Gap(4),
                  IconButton(
                    onPressed: () async {
                      await Services.app.copy(Services.configs.get(key: CONSTANTS.STORAGE_INVITE_LINK));

                      showSnackbar(message: 'لینک کپی شد');
                    },
                    icon: const Icon(Icons.copy_rounded),
                  )
                ],
              ),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Services.app.share('https://mah1.org?ref=1234');
                },
                child: const Text(
                  'اشتراک گذاری',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
