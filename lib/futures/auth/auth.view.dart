import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("lib/app/assets/images/auth_logo.png"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            background(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  width: Get.width,
                  child: Image.asset(
                    "lib/app/assets/images/auth_hero.png",
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                hero(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget background({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // gradient from bottom to top (top is white)
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.white.withOpacity(0.2),
            const Color(0xff9a5bff).withOpacity(0.1),
            const Color(0xff23bdab).withOpacity(0.1),
            const Color(0xffff3c5c).withOpacity(0.1),
            Colors.white.withOpacity(0.2)
          ],
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget hero() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auth_hero_title'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Text(
            'auth_hero_subtitle'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const Gap(32),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/auth/login');
                },
                child: const Text(
                  "ورود به حساب کاربری",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/auth/register');
                },
                child: const Text(
                  "ایجاد حساب کاربری",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/auth/forgot');
                },
                child: const Text(
                  "فراموشی رمز عبور",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
