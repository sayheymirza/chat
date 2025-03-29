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
      backgroundColor: Colors.grey.shade100,
      body: Obx(
        () {
          if (controller.loading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = controller.profile.value;

          Widget error = Container();

          if (data.relation!.blocked == true) {
            error = errorBlocked();
          }

          if (data.relation!.blockedMe == true) {
            error = errorBlockedMe();
          }

          if (data.status!.toLowerCase() == 'unsubscribe') {
            error = errorCanceled();
          }

          if (data.status!.toLowerCase() == 'left_for_ever') {
            error = errorDeleted();
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
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
              ),
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
                      buttons(id: data.id!),
                      // if (controller.showOptions.value) const Divider(),
                      row(
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
                      // const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: const TitleWidget(text: "وضعیت حساب کاربری"),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            const Gap(6),
                            // has an active ad
                            badge(
                                text: 'account_ad_title'.tr,
                                icon:
                                    data.plan?.ad == true ? null : Icons.close,
                                iconColor: data.plan?.ad == true
                                    ? Colors.yellow
                                    : Colors.red,
                                image: data.plan?.ad == true
                                    ? Image.asset(
                                        'lib/app/assets/images/star.png')
                                    : null),
                            const Gap(6),
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
                      br(
                        text: "ویژگی های ظاهری",
                      ),
                      row(
                        children: [
                          item(
                            title: "جنسیت",
                            value: data.gender ?? "",
                          ),
                        ],
                      ),
                      // const Divider(),
                      row(
                        children: [
                          // height
                          item(
                            title: "قد",
                            value: data.height ?? '',
                          ),
                          // weight
                          item(title: "وزن", value: '${data.weight} کیلو گرم'),
                        ],
                      ),
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
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
                      row(
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
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
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
                      // const Divider(),
                      row(
                        children: [
                          item(
                            title: 'درباره من',
                            value: data.about ?? '',
                          ),
                        ],
                      ),
                      if (Get.parameters['id'] == 'me' &&
                          controller.profile.value.reports != 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.red,
                              ),
                              const Gap(10),
                              Text(
                                'شما ${controller.profile.value.reports ?? 0} تخلف گزارش شده دارید.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              error,
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
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          Container(
            width: Get.width,
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
      ),
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // back button
        const Gap(8),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              Icons.arrow_back_rounded,
            ),
          ).asGlass(
            clipBorderRadius: BorderRadius.circular(50),
          ),
        ),
        const Spacer(),
        // menu button
        if (controller.showOptions.value)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GetBuilder<ProfileController>(
                builder: (context) {
                  return PopupMenuButton(
                    child: Container(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.more_vert_rounded,
                      ),
                    ).asGlass(
                      clipBorderRadius: BorderRadius.circular(50),
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
                        controller.profile.value.relation!.favorited == true
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
                        controller.profile.value.relation!.blocked == false
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
              const Gap(10),
              Container(
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: controller.profile.value.seen == "online"
                            ? Colors.green
                            : controller.profile.value.seen == "offline"
                                ? Colors.red
                                : Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      controller.profile.value.seen == "online"
                          ? "آنلاین"
                          : controller.profile.value.seen == "offline"
                              ? "آفلاین"
                              : "اخیرا آنلاین بوده",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ).asGlass(
                clipBorderRadius: BorderRadius.circular(56),
              ),
            ],
          ),
        const Gap(8),
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
          if (controller.showOptions.value)
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
          if (controller.showOptions.value) const Gap(10),
          if (controller.showOptions.value)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      controller.sendDefaultMessage(id: id);
                    },
                    child: const Text('ارسال علاقه مندی'),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      controller.sendSMS(id: id);
                    },
                    child: const Text('دعوت به گفتگو'),
                  ),
                ),
              ],
            ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      controller.profile.value.relation?.liked == true
                          ? Colors.green
                          : Colors.white,
                    ),
                    // border color to red
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: controller.profile.value.relation?.liked == true
                            ? Colors.green
                            : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  onPressed: controller.profile.value.relation?.liked == true ||
                          !controller.showOptions.value
                      ? null
                      : () {
                          controller.like(id: id);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thumb_up_alt_rounded,
                        color: controller.profile.value.relation?.liked == true
                            ? Colors.white
                            : Colors.green,
                      ),
                      const Gap(12),
                      Text(
                        'پسندیدم',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              controller.profile.value.relation?.liked == true
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        controller.profile.value.relationCount?.likes
                                .toString() ??
                            '0',
                        style: TextStyle(
                          color:
                              controller.profile.value.relation?.liked == true
                                  ? Colors.white
                                  : Get.theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      controller.profile.value.relation?.disliked == true
                          ? Colors.red
                          : Colors.white,
                    ),
                    // border color to red
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color:
                            controller.profile.value.relation?.disliked == true
                                ? Colors.red
                                : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  onPressed:
                      controller.profile.value.relation?.disliked == true ||
                              !controller.showOptions.value
                          ? null
                          : () {
                              controller.dislike(id: id);
                            },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.thumb_down_alt_rounded,
                        color:
                            controller.profile.value.relation?.disliked == true
                                ? Colors.white
                                : Colors.red,
                      ),
                      const Gap(12),
                      Text(
                        'نپسندیدم',
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.profile.value.relation?.disliked ==
                                  true
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        controller.profile.value.relationCount?.dislikes
                                .toString() ??
                            '0',
                        style: TextStyle(
                          color: controller.profile.value.relation?.disliked ==
                                  true
                              ? Colors.white
                              : Get.theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget row({required List<Widget> children}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: children,
      ),
    );
  }

  Widget item({
    required String title,
    required String value,
    Icon? icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (icon != null)
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: icon,
                  ),
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
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
              textAlign: TextAlign.start,
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
        color: Colors.white,
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
          // color: Get.theme.colorScheme.primaryContainer,
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

  Widget errorBlocked() {
    return alert(
      title: '${controller.profile.value.fullname} بلاک شده',
      content:
          'شما این کاربر را بلاک کرده اید و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
      action: OutlinedButton(
        onPressed: () {
          controller.unblock(id: controller.profile.value.id!);
        },
        child: const Text('آنبلاک کردن'),
      ),
    );
  }

  Widget errorBlockedMe() {
    return alert(
      title: 'بلاک شده اید',
      content:
          'این کاربر شما را بلاک کرده و امکان مشاهده اطلاعات و ارسال پیام به او وجود ندارد',
    );
  }

  Widget errorCanceled() {
    // کاربر از عضویت خود منصرف شده است ولی امکان بازگشت دارد
    return alert(
      title: 'کاربر از عضویت خود منصرف شده است',
      content:
          'این کاربر از عضویت خود انصراف داده است اما احتمال بازگشت مجدد او وجود دارد',
    );
  }

  Widget errorDeleted() {
    return alert(
      title: 'کاربر حذف شده',
      content: 'این کاربر حساب کاربری خودش را حذف کرده است',
    );
  }
}
