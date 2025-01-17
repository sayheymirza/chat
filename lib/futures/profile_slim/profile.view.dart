import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/futures/profile_slim/profile.controller.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class ProfileSlimView extends GetView<ProfileSlimController> {
  const ProfileSlimView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileSlimController());

    return Scaffold(
      body: StreamBuilder(
        stream: controller.profile.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);

            return Container(
              padding: EdgeInsets.all(16),
              child: Text("خطایی رخ داد"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = snapshot.data!.last;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.load,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                        fullname: data.fullname!,
                        verified: data.verified!,
                        age: data.age!.toString(),
                        id: data.id!,
                        avatar: data.avatar!,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/auth/login');
                          },
                          child: Text(
                            'ارسال پیام',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          item(
                            title: "شهر",
                            value: data.city!,
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          item(
                            title: 'نوع رابطه',
                            value: data.marriageType!,
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      br(
                        text: "ویژگی های ظاهری",
                      ),
                      Row(
                        children: [
                          item(
                            title: "جنسیت",
                            value: data.gender ?? "",
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "قد",
                            value: data.height != null
                                ? '${data.height} سانتی متر'
                                : '',
                          ),
                          // weight
                          item(title: "وزن", value: '${data.weight} کیلو گرم'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // وضعیت تاهل
                          item(
                            title: "وضعیت تاهل",
                            value: data.marital ?? '',
                          ),
                          // میزان تحصیلات
                          item(
                            title: "سبک زندگی",
                            value: data.living ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          item(
                            title: 'درباره من',
                            value: data.about ?? '',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget alert({
    required String title,
    required String content,
    Widget? action,
  }) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              // white background with 25% opacity
              color: Colors.white.withOpacity(0.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //   title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                  // content
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).asGlass(
              blurX: 20,
              blurY: 20,
            ),
            // back button on top right
            Positioned(
              top: Get.mediaQuery.padding.top + 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            //   if action exists Position to bottom and center
            if (action != null)
              Positioned(
                bottom: Get.mediaQuery.padding.bottom + 20,
                left: 20,
                right: 20,
                child: action,
              ),
          ],
        ));
  }

  Widget header({
    required String fullname,
    required bool verified,
    required String age,
    required String id,
    required String avatar,
  }) {
    return SizedBox(
      height: 460,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.dialog(
                DialogImageView(
                  url: avatar,
                ),
                useSafeArea: false,
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedImageWidget(
                url: avatar,
                category: "avatar",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: Get.mediaQuery.padding.top,
            left: 0,
            right: 0,
            child: appBar(
              id: id,
              fullname: fullname,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: info(
              id: id,
              fullname: fullname,
              verified: verified,
              age: age,
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar({
    required String id,
    required String fullname,
  }) {
    return Row(
      children: [
        // back button
        const Gap(8),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 48,
            height: 48,
            child: Icon(
              Icons.arrow_back_rounded,
            ),
          ).asGlass(
            clipBorderRadius: BorderRadius.circular(50),
          ),
        ),
      ],
    );
  }

  Widget info({
    required String fullname,
    required bool verified,
    required String age,
    required String id,
  }) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // linner gradient from black 80% to black 0% from bottom to top
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.0),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                fullname,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (verified)
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.blue,
                  ),
                ),
              const Gap(10),
              Text(
                '$age ساله',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                'کد کاربر: $id',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttons({required String id}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.openingChat.value ? null : () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  controller.openingChat.value ? Colors.grey.shade200 : null,
                ),
              ),
              child: const Text(
                'ارسال پیام',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget item({
    required String title,
    required String value,
    Icon? icon,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: icon,
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget badge({
    required String text,
    required IconData? icon,
    required Color iconColor,
    Widget? image,
  }) {
    return Container(
      width: 'type'.tr == 'dating' ? 130 : 110,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 10),
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          if (image != null)
            SizedBox(
              width: 20,
              height: 20,
              child: image,
            ),
        ],
      ),
    );
  }

  Widget br({
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
