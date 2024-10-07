import 'package:chat/futures/profile/profile.controller.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/title.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    controller.load();

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.loading.value
                ? [
                    SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ]
                : [
                    header(),
                    if (controller.showOptions.value) buttons(),
                    if (controller.showOptions.value) const Divider(),
                    Row(
                      children: [
                        item(
                          title: "شهر",
                          value: controller.profile.value.city!,
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        item(
                          title: 'نوع رابطه',
                          value: controller.profile.value.marriageType!,
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
                              text: controller.profile.value.verified == true
                                  ? "تایید شده"
                                  : "تایید نشده",
                              icon: controller.profile.value.verified == true
                                  ? Icons.done_all
                                  : Icons.close,
                              iconColor:
                                  controller.profile.value.verified == true
                                      ? Colors.blue
                                      : Colors.red,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            // has an active ad
                            badge(
                                text: 'account_ad_title'.tr,
                                icon: controller.profile.value.plan?.ad == true
                                    ? null
                                    : Icons.close,
                                iconColor:
                                    controller.profile.value.plan?.ad == true
                                        ? Colors.yellow
                                        : Colors.red,
                                image: controller.profile.value.plan?.ad == true
                                    ? Image.asset(
                                        'lib/app/assets/images/star.png')
                                    : null),
                            const SizedBox(
                              width: 6,
                            ),
                            badge(
                              text: "عضویت ویژه",
                              icon:
                                  controller.profile.value.plan?.special == true
                                      ? Icons.star_rate
                                      : Icons.close,
                              iconColor:
                                  controller.profile.value.plan?.special == true
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
                          value: controller.profile.value.gender ?? "",
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "قد",
                          value: controller.profile.value.height != null
                              ? '${controller.profile.value.height} سانتی متر'
                              : '',
                        ),
                        // weight
                        item(
                            title: "وزن",
                            value:
                                '${controller.profile.value.weight} کیلو گرم'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "رنگ پوست",
                          value: controller.profile.value.color ?? '',
                        ),
                        // weight
                        item(
                          title: "وضعیت سلامتی",
                          value: controller.profile.value.health ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "امتیاز زیبایی (1 کمترین)",
                          value: controller.profile.value.beauty ?? '',
                        ),
                        // weight
                        item(
                          title: "امتیاز خوشتیپی (1 کمترین)",
                          value: controller.profile.value.shape ?? '',
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
                          value: controller.profile.value.birthDate ?? '',
                        ),
                        item(
                          title: "تاریخ عضویت",
                          value: controller.profile.value.registerDate ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // وضعیت تاهل
                        item(
                          title: "وضعیت تاهل",
                          value: controller.profile.value.marital ?? '',
                        ),
                        // میزان تحصیلات
                        item(
                          title: "میزان تحصیلات",
                          value: controller.profile.value.education ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "تعداد فرزندان",
                          value: controller.profile.value.children ?? '',
                        ),
                        // weight
                        item(
                          title: "سن بزرگترین فرزند",
                          value: controller.profile.value.childMaxAge ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "شغل",
                          value: controller.profile.value.job ?? '',
                        ),
                        // weight
                        item(
                          title: "سبک زندگی",
                          value: controller.profile.value.living ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "میزان حقوق دریافتی",
                          value: controller.profile.value.salary ?? '',
                        ),
                        // weight
                        item(
                          title: "میزان مذهبی بودن",
                          value: controller.profile.value.religion ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        // height
                        item(
                          title: "وضعیت اتومبیل",
                          value: controller.profile.value.car ?? '',
                        ),
                        // weight
                        item(
                          title: "وضعیت مسکن",
                          value: controller.profile.value.house ?? '',
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        item(
                          title: 'درباره من',
                          value: controller.profile.value.about ?? '',
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
    );
  }

  Widget header() {
    return SizedBox(
      height: 460,
      child: Stack(
        children: [
          avatar(),
          Positioned(
            top: Get.mediaQuery.padding.top,
            left: 0,
            right: 0,
            child: appBar(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: info(),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
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
                      controller.favorite();
                      break;
                    case "disfavorite":
                      controller.disfavorite();
                      break;
                    case "block":
                      controller.block();
                      break;
                    case "unblock":
                      controller.unblock();
                      break;
                    case "report":
                      controller.report();
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

  Widget avatar() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CachedImageWidget(
        url: controller.profile.value.avatar!,
        category: "avatar",
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget info() {
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
                controller.profile.value.fullname!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (controller.profile.value.verified == true)
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.blue,
                  ),
                ),
              const Gap(10),
              Text(
                '${controller.profile.value.age} ساله',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                'کد کاربر: ${controller.profile.value.id}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            'آخرین بازدید ${controller.profile.value.last}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
                    Get.toNamed(
                      '/app/default-message',
                      parameters: {
                        'id': controller.profile.value.id.toString(),
                      },
                    );
                  },
                  child: const Text('ارسال علاقه مندی'),
                ),
              ),
              const Gap(10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.sendSMS();
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
