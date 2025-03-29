import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatCardPlanWidget extends StatefulWidget {
  final String userId;

  const ChatCardPlanWidget({
    super.key,
    required this.userId,
  });

  @override
  State<ChatCardPlanWidget> createState() => _ChatCardPlanWidgetState();
}

class _ChatCardPlanWidgetState extends State<ChatCardPlanWidget> {
  bool visable = false;

  @override
  void initState() {
    super.initState();

    var key = 'chat:plan:${widget.userId}';

    var value = Services.configs.get(key: key);

    if (value == null) {
      visable = true;

      setState(() {});
    }
  }

  void close() {
    var key = 'chat:plan:${widget.userId}';

    Services.configs.set(key: key, value: true);

    visable = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return visable
        ? Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(0xffFF4B2B), Color(0xffFF416C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'برای ارسال پیام خصوصی و استفاده از چت صوتی و تصویری باید حداقل یکی از طرفین حساب کاربری ویژه داشته باشد. می توانید جهت خرید از این لینک استفاده کنید',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/app/purchase/one-step');
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'خرید حساب کاربری ویژه',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(10),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(12),
                const Text(
                  ' البته می توانید به کاربر پیام علاقه مندی به صورت رایگان بفرستید در صورتی که ایشان عضویت ویژه داشته باشند می توانید به گفتگو ادامه دهید',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        '/app/default-message',
                        arguments: {
                          'id': widget.userId,
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ارسال پیام علاقه مندی (رایگان)',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(10),
                        Icon(
                          Icons.message,
                          color: Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      close();
                    },
                    child: Text(
                      'دیگر نشان نده',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
