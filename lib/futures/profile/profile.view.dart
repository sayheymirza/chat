import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/futures/profile/profile.controller.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

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
                    children: [
                      header(
                        fullname: data.fullname!,
                        verified: data.verified!,
                        age: data.age!.toString(),
                        id: data.id!,
                        last: data.last!,
                        avatar: data.avatar!,
                      ),
                      if (controller.showOptions.value) buttons(id: data.id!),
                      if (controller.showOptions.value) const Divider(),
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
                      const Divider(),
                      const TitleWidget(text: "وضعیت حساب کاربری"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              badge(
                                text: data.verified == true
                                    ? "تایید شده"
                                    : "تایید نشده",
                                icon: data.verified == true
                                    ? Icons.done_all
                                    : Icons.close,
                                iconColor: data.verified == true
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              // has an active ad
                              badge(
                                  text: 'account_ad_title'.tr,
                                  icon: data.plan?.ad == true
                                      ? null
                                      : Icons.close,
                                  iconColor: data.plan?.ad == true
                                      ? Colors.yellow
                                      : Colors.red,
                                  image: data.plan?.ad == true
                                      ? Image.asset(
                                          'lib/app/assets/images/star.png')
                                      : null),
                              const SizedBox(
                                width: 6,
                              ),
                              badge(
                                text: "عضویت ویژه",
                                icon: data.plan?.special == true
                                    ? Icons.star_rate
                                    : Icons.close,
                                iconColor: data.plan?.special == true
                                    ? Colors.yellow
                                    : Colors.red,
                              ),
                            ],
                          ),
                        ),
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
                          // height
                          item(
                            title: "رنگ پوست",
                            value: data.color ?? '',
                          ),
                          // weight
                          item(
                            title: "وضعیت سلامتی",
                            value: data.health ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "امتیاز زیبایی (1 کمترین)",
                            value: data.beauty ?? '',
                          ),
                          // weight
                          item(
                            title: "امتیاز خوشتیپی (1 کمترین)",
                            value: data.shape ?? '',
                          ),
                        ],
                      ),
                      br(
                        text: "اطلاعات تکمیلی",
                      ),
                      // birthday
                      Row(
                        children: [
                          item(
                            title: "تاریخ تولد",
                            value: data.birthDate ?? '',
                          ),
                          item(
                            title: "تاریخ عضویت",
                            value: data.registerDate ?? '',
                          ),
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
                            title: "میزان تحصیلات",
                            value: data.education ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "تعداد فرزندان",
                            value: data.children ?? '',
                          ),
                          // weight
                          item(
                            title: "سن بزرگترین فرزند",
                            value: data.childMaxAge ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "شغل",
                            value: data.job ?? '',
                          ),
                          // weight
                          item(
                            title: "سبک زندگی",
                            value: data.living ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "میزان حقوق دریافتی",
                            value: data.salary ?? '',
                          ),
                          // weight
                          item(
                            title: "میزان مذهبی بودن",
                            value: data.religion ?? '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          // height
                          item(
                            title: "وضعیت اتومبیل",
                            value: data.car ?? '',
                          ),
                          // weight
                          item(
                            title: "وضعیت مسکن",
                            value: data.house ?? '',
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
              //   if user blocked
              if (controller.relation.value.blocked == true)
                alert(
                  title: 'کاربر بلاک شده',
                  content:
                      'شما این کاربر را بلاک کرده اید و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
                  action: OutlinedButton(
                    onPressed: () {
                      controller.unblock(id: data.id!);
                    },
                    child: const Text('آنبلاک کردن'),
                  ),
                ),
              // if user blocked me
              if (controller.relation.value.blockedMe == true)
                alert(
                  title: 'بلاک شده اید',
                  content:
                      'این کاربر شما را بلاک کرده و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
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
    required String last,
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
                  url: "https://avatar.iran.liara.run/public/8",
                ),
                useSafeArea: false,
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedImageWidget(
                url: "https://avatar.iran.liara.run/public/8", //data.avatar!,
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
              last: last,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // back button
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        // menu button
        if (controller.showOptions.value)
          GetBuilder<ProfileController>(
            builder: (context) {
              return PopupMenuButton(
                child: const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black,
                  ),
                ),
                onSelected: (value) {
                  switch (value) {
                    case "favorite":
                      controller.favorite(id: id);
                      break;
                    case "disfavorite":
                      controller.disfavorite(id: id);
                      break;
                    case "block":
                      controller.block(id: id);
                      break;
                    case "unblock":
                      controller.unblock(id: id);
                      break;
                    case "report":
                      controller.report(id: id, fullname: fullname);
                      break;
                    default:
                  }
                },
                itemBuilder: (context) {
                  return [
                    controller.relation.value.favorited == true
                        ? const PopupMenuItem(
                            value: "disfavorite",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "حذف از علاقه مندی ها",
                                ),
                              ],
                            ),
                          )
                        : const PopupMenuItem(
                            value: "favorite",
                            child: Row(
                              children: [
                                Icon(Icons.favorite),
                                SizedBox(width: 10),
                                Text(
                                  "افزودن به علاقه مندی ها",
                                ),
                              ],
                            ),
                          ),
                    controller.relation.value.blocked == false
                        ? const PopupMenuItem(
                            value: "block",
                            child: Row(
                              children: [
                                Icon(Icons.block),
                                SizedBox(width: 10),
                                Text(
                                  "بلاک کردن",
                                ),
                              ],
                            ),
                          )
                        : const PopupMenuItem(
                            value: "unblock",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.block,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "آنبلاک کردن",
                                ),
                              ],
                            ),
                          ),
                    // report
                    const PopupMenuItem(
                      value: "report",
                      child: Row(
                        children: [
                          Icon(Icons.report),
                          SizedBox(width: 10),
                          Text(
                            "گزارش تخلف",
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              );
            },
          ),
      ],
    );
  }

  Widget info({
    required String fullname,
    required bool verified,
    required String age,
    required String id,
    required String last,
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
          const Gap(10),
          Text(
            'آخرین بازدید $last',
            style: const TextStyle(
              color: Colors.white,
            ),
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
              onPressed: controller.openingChat.value
                  ? null
                  : () {
                      controller.startChat(id: id);
                    },
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
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.sendDefaultMessage(id: id);
                  },
                  child: const Text('ارسال علاقه مندی'),
                ),
              ),
              const Gap(10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.sendSMS(id: id);
                  },
                  child: const Text('دعوت به گفتگو'),
                ),
              ),
            ],
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
      width: 'type'.tr == 'dating' ? 140 : 130,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
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
