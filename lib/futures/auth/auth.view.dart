import 'dart:math';

import 'package:chat/shared/constants.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  List<Map<String, dynamic>> links = [
    {
      "icon": Icons.search_rounded,
      "text": "جستجو کاربران",
      "path": "/search",
    },
    {
      "icon": Icons.call_rounded,
      "text": "تماس با ما",
      "path": "/page/contact",
    },
    {
      "icon": Icons.gavel_rounded,
      "text": "شرایط استفاده",
      "path": "/page/terms",
    },
    {
      "icon": Icons.privacy_tip_rounded,
      "text": "حریم خصوصی",
      "path": "/page/privacy",
    },
  ];

  List<int> avatars = RxList.empty(growable: true);

  void generateAvatars() {
    Random random = Random();
    // random avatar ids between 1..13 (limit: 5) - not repeating
    while (avatars.length < 6) {
      int randomId = (1 + (12 * random.nextDouble())).toInt();
      if (!avatars.contains(randomId)) {
        avatars.add(randomId);
      }
    }
  }

  void openLink(String key, {String path = ''}) {
    var link = Services.configs.get(key: key);
    print('$key = $link');
    if (link != null) {
      Services.launch.launch('$link$path');
    }
  }

  @override
  void initState() {
    super.initState();
    generateAvatars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("lib/app/assets/images/auth_logo.png"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Get.theme.primaryColor,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'lib/app/assets/images/pattern.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Image.asset('lib/app/assets/images/logo-white.png'),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed("/auth/login");
                      NavigationToNamed('/auth/login');
                    },
                    child: const Text(
                      "ورود",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed("/auth/register");
                      NavigationToNamed('/auth/register');
                    },
                    child: const Text(
                      "ثبت نام",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Gap(4),
            for (var link in links)
              ListTile(
                dense: true,
                leading: Icon(link["icon"], color: Colors.green),
                title: Text(
                  link["text"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed(link["path"]);
                  NavigationToNamed(link['path']);
                },
              ),
            ListTile(
              dense: true,
              leading: Icon(Icons.download, color: Colors.green),
              title: Text(
                CONSTANTS.FLAVOR == 'web' ? 'دانلود اپلیکیشن' : 'ورود به وب',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                if (CONSTANTS.FLAVOR == 'web') {
                  openLink(CONSTANTS.STORAGE_LINK_DOWNLOAD);
                } else {
                  openLink(CONSTANTS.STORAGE_LINK_WEBSITE);
                }

                Get.back();
              },
            ),
          ],
        ),
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
            const Gap(50),
            earning(),
            const Gap(30),
            content(
              image: "lib/app/assets/images/one.png",
              title: "اپلیکیشن شبکه اجتماعی ماه عسل",
              subtitle:
                  "سایت شبکه اجتماعی ماه عسل یک شبکه اجتماعی آنلاین با محیطی جذاب و حرفه ای است ، که دارای امکاناتی مانند تماس صوتی ، تماس تصویری ، ارسال عکس ، ارسال موزیک ، ارسال فیلم و ارسال لوکیشن می باشد . این سایت به کسانی که دنبال دوست های جدید هستند کمک میکند که دوستان خود را در کوتاه ترین زمان ممکن بصورت آنلاین پیدا کنند .",
            ),
            content(
              image: "lib/app/assets/images/two.png",
              title: "چت سریع و بی حد و مرز ",
              subtitle:
                  "نگران سرعت نباش، از چت سریع و روان با کاربران لذت ببر همچنین از تماس صوتی و تصویری بصورت رایگان همراه با ارسال عکس و لوکیشن لذت ببر ",
            ),
            content(
              image: "lib/app/assets/images/three.png",
              title: "کاربران حقیقی از سراسر ایران",
              subtitle:
                  "ما به صورت سخت گیرانه به تخلفات کاربران رسیدگی می کنیم و از ایجاد هر گونه مزاحمت جلوگیری می کنیم ",
            ),
            // random avatars
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'ماه عسلی های جدید',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: "YekanBakh",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      children: [
                        const TextSpan(
                          text: 'با ایجاد ',
                          style: TextStyle(
                            fontFamily: "YekanBakh",
                          ),
                        ),
                        TextSpan(
                          text: 'حساب کاربری',
                          style: TextStyle(
                            color: Get.theme.primaryColor,
                            decoration: TextDecoration.underline,
                            fontFamily: "YekanBakh",
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed('/auth/register');
                              NavigationToNamed('/auth/register');
                            },
                        ),
                        const TextSpan(
                          text: ' به جستجوی همسر اینده‌آت بپرداز!',
                          style: TextStyle(
                            fontFamily: "YekanBakh",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(40),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 40,
                crossAxisSpacing: 40,
                children: avatars
                    .map((id) => Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'lib/assets/avatars/$id.jpg',
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Gap(
              navigationBarHeight + 32,
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
                  NavigationToNamed('/auth/login');
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
                  NavigationToNamed('/auth/register');
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
                  NavigationToNamed('/auth/forgot');
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
          Row(
            children: [
              const SizedBox(
                width: 150,
              ),
              ElevatedButton(
                onPressed: () {
                  if (CONSTANTS.FLAVOR == 'web') {
                    openLink(CONSTANTS.STORAGE_LINK_DOWNLOAD);
                  } else {
                    openLink(CONSTANTS.STORAGE_LINK_WEBSITE);
                  }
                },
                child: Text(
                  CONSTANTS.FLAVOR == 'web' ? 'دانلود اپلیکیشن' : 'ورود به وب',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget earning() {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('lib/assets/images/confetti.png'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'کسب درآمد میلیونی با دعوت از دوستان',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget content({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 20, left: 32, right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(image),
              ),
              const Gap(20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
