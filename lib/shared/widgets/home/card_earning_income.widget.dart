import 'package:chat/shared/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardEarningIncomeWidget extends StatefulWidget {
  const CardEarningIncomeWidget({super.key});

  @override
  State<CardEarningIncomeWidget> createState() =>
      _CardEarningIncomeWidgetState();
}

class _CardEarningIncomeWidgetState extends State<CardEarningIncomeWidget> {
  bool visable = false;

  @override
  void initState() {
    super.initState();

    var value = Services.configs.get(key: 'config:show-invite-card');
    if (value != 'false' && value != 'auto') {
      visable = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return visable
        ? Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade700,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: -10,
                  left: -10,
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset(
                      'lib/assets/images/confetti.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'کسب درآمد میلیونی با دعوت از دوستان',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'می دونید با دعوت از دوستان خود می توانید درآمد کسب کنید و تا یک ماه اشتراک رایگان دریافت کنید',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                visable = false;
                                setState(() {});

                                Services.configs.set(
                                  key: 'config:show-invite-card',
                                  value: 'false',
                                );
                              },
                              child: const Text(
                                'دیگر نشان نده',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/app/earning');
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                              child: const Text(
                                'شروع کنیم',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
