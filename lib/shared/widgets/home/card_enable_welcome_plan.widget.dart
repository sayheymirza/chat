import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:flutter/material.dart';

class CardEnableWelcomePlanWidget extends StatefulWidget {
  const CardEnableWelcomePlanWidget({super.key});

  @override
  State<CardEnableWelcomePlanWidget> createState() =>
      _CardEnableWelcomePlanWidgetState();
}

class _CardEnableWelcomePlanWidgetState
    extends State<CardEnableWelcomePlanWidget> {
  bool loading = false;
  String time = 'کوتاهی';

  @override
  initState() {
    super.initState();

    var time_value = Services.configs.get(key: 'config:free-account-time');
    if (time_value != null) {
      setState(() {
        time = time_value;
      });
    }
  }

  void submit() async {
    if (loading) return;

    loading = true;
    setState(() {});

    var result = await ApiService.purchase.consumeFreePlan();

    loading = false;
    if (mounted) {
      setState(() {});
    }

    showSnackbar(message: result.message);

    if (result.status) {
      Services.configs.set(key: 'config:show_welcome_package', value: 'false');
      Services.profile.fetchMyProfile();
      showSnackbar(message: 'بسته خوش آمد گویی با موفقیت فعال شد');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.yellow.shade600,
            Colors.amber.shade800,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'فعال سازی بسته خوش آمدگویی',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            ' با فعال سازی این بسته به مدت $time از کلیه خدمات سایت به صورت رایگان بهرمند خواهید شد. فقط توجه نمایید که برای ارسال پیام شخصی موبایل خود را تایید نمایید ',
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: loading
                  ? null
                  : () {
                      submit();
                    },
              child: const Text(
                'فعال سازی',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
