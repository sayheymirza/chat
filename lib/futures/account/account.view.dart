import 'package:chat/futures/account/account.controller.dart';
import 'package:chat/futures/dialog_image/dialog_image.view.dart';
import 'package:chat/futures/dialog_logout/dialog_logout.view.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/platform/navigation.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());

    return Obx(
      () => Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            return controller.onRefresh();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: Get.mediaQuery.padding.top + 32,
              bottom: 32,
              left: 0,
              right: 0,
            ),
            child: Column(
              children: [
                header(),
                const Gap(16),
                abilities(),
                const Gap(16),
                buy(),
                const Gap(16),
                item(
                  title: 'پیام های مدیریت',
                  icon: Icons.forum_rounded,
                  color: Colors.cyan,
                  onTap: () {
                    NavigationToNamed('/app/admin/chat');
                    Get.toNamed('/app/admin/chat');
                  },
                  suffix: StreamBuilder(
                    stream: Services.adminChat.listenToUnreadedChats(),
                    builder: (context, snapshot) {
                      var count = snapshot.data ?? 0;

                      return Badge(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        label: Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (controller.profile.profile.value.id != null)
                  item(
                    title: 'نمایش پروفایل من',
                    icon: Icons.visibility,
                    color: Colors.green,
                    page: "/app/profile/me",
                    arguments: {
                      "options": false,
                    },
                  ),
                // edit profile
                item(
                  title: 'ویرایش پروفایل من',
                  icon: Icons.account_circle,
                  color: Colors.deepPurpleAccent,
                  page: "/app/profile",
                ),
                if (controller.profile.profile.value.verified != true)
                  item(
                    title: 'تایید شماره موبایل',
                    icon: Icons.smartphone,
                    color: Colors.blue,
                    page: "/app/account_verify_phone",
                  ),
                // sounds and notifications
                item(
                  title: 'صدا و اعلانات',
                  icon: Icons.notifications,
                  color: Colors.orange,
                  page: "/app/notification",
                ),
                // privacy and security
                item(
                  title: 'دسترسی ها و امنیت',
                  icon: Icons.lock,
                  color: Colors.blue,
                  page: "/app/security",
                ),
                item(
                  title: 'فضای ذخیره سازی',
                  icon: Icons.folder_copy,
                  color: Colors.blueGrey.shade600,
                  page: "/app/storage",
                ),
                // favorites (pink)
                item(
                  title: 'علاقه مندی ها',
                  icon: Icons.favorite,
                  color: Colors.pink,
                  page: "/app/favorites",
                ),
                // blocked users (red)
                item(
                  title: 'بلاکی ها',
                  icon: Icons.block,
                  color: Colors.red,
                  page: "/app/blocks",
                ),
                // transactions (green)
                item(
                  title: 'تراکنش ها',
                  icon: Icons.receipt,
                  color: Colors.green,
                  page: "/app/transactions",
                ),
                if ((Services.configs
                            .get<String>(key: CONSTANTS.STORAGE_INVITE_LINK) ??
                        '')
                    .isNotEmpty)
                  item(
                    title: 'کسب درآمد میلیونی با دعوت از دوستان',
                    icon: Icons.payments,
                    color: Colors.blue,
                    page: "/app/earning",
                  ),
                item(
                  title: 'به ما امتیاز بدید',
                  icon: Icons.star_rounded,
                  color: Colors.yellow.shade600,
                  onTap: () {
                    controller.fireFeedbackEvent();
                  },
                ),
                item(
                  title: 'شرایط استفاده',
                  icon: Icons.gavel,
                  color: Colors.brown.shade600,
                  page: "/page/terms",
                ),
                item(
                  title: 'حریم خصوصی',
                  icon: Icons.privacy_tip,
                  color: Colors.blue,
                  page: "/page/privacy",
                ),
                // contact us (blue)
                item(
                  title: 'تماس با ما',
                  icon: Icons.help_outline,
                  color: Colors.blue,
                  page: "/page/contact",
                ),
                if ((Services.configs
                            .get<String>(key: CONSTANTS.STORAGE_LINK_WEBLOG) ??
                        '')
                    .isNotEmpty)
                  item(
                    title: 'وبلاگ',
                    icon: Icons.article,
                    color: Colors.purple,
                    onTap: () async {
                      controller.openLink(CONSTANTS.STORAGE_LINK_WEBLOG);
                    },
                  ),
                if ((Services.configs
                            .get<String>(key: CONSTANTS.STORAGE_LINK_WEBSITE) ??
                        '')
                    .isNotEmpty)
                  item(
                    title: 'ورود به وب',
                    icon: Icons.language,
                    color: Colors.green,
                    onTap: () async {
                      controller.openLink(CONSTANTS.STORAGE_LINK_WEBSITE);
                    },
                  ),
                item(
                  title: 'خروج از حساب کاربری',
                  icon: Icons.logout,
                  color: Colors.black,
                  onTap: () {
                    Get.bottomSheet(
                      const DialogLogoutView(),
                      isScrollControlled: true,
                    );

                    NavigationPopDialog();
                  },
                ),
                // disable or delete account (red)
                item(
                  title: 'غیر فعال سازی و حذف',
                  icon: Icons.delete,
                  color: Colors.red,
                  page: '/app/account_delete_leave/choose',
                ),
                // dev log
                if (controller.profile.profile.value.permissions
                    .contains('DEBUG'))
                  item(
                    title: 'لاگ ها',
                    icon: Icons.bug_report,
                    color: Colors.red,
                    page: "/dev/log",
                  ),
                version(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget version() {
    String flavor = '';

    switch (CONSTANTS.FLAVOR) {
      case 'cafebazaar':
        flavor = 'کافه بازار';
        break;
      case 'myket':
        flavor = 'مایکت';
        break;
      case 'direct':
        flavor = 'دانلود مستقیم';
        break;
      case 'web':
        flavor = 'وب اپلیکیشن';
        break;
      case 'google-play':
        flavor = 'گوگل پلی';
        break;
      default:
    }

    return Obx(
      () => Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'نسخه برنامه',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              '$flavor-',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              controller.version.value,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            if (controller.updatable.value)
              GestureDetector(
                onTap: () {
                  controller.fireUpdateEvent();
                },
                child: Container(
                  height: 32,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'نیاز به بروزرسانی',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onErrorContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buy() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/app/purchase/one-step');
        NavigationToNamed('/app/purchase/one-step');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.tealAccent.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.stars),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text('فعال سازی حساب ویژه'),
            ),
            Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }

  Widget item({
    required String title,
    required IconData icon,
    required Color color,
    String? page,
    Map<String, dynamic> arguments = const {},
    Function? onTap,
    Widget? suffix,
  }) {
    return InkWell(
      onTap: () {
        if (page != null) {
          try {
            Get.toNamed(page, arguments: arguments);
            NavigationToNamed(
              page,
              params: arguments.keys
                  .map((key) => '$key=${arguments[key]}')
                  .join('&'),
            );
          } catch (e) {
            //
          }
        }
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(title),
            ),
            if (suffix != null) suffix
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Obx(
      () => Row(
        children: [
          const Gap(32),
          avatar(),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // fullname and verified icon
              Row(
                children: [
                  Text(
                    controller.profile.profile.value.fullname ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  if (controller.profile.profile.value.verified == true)
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    )
                ],
              ),
              const Gap(4),
              Text(
                controller.profile.profile.value.phone ?? '',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget avatar() {
    return SizedBox(
      width: 90,
      height: 90,
      child: Obx(
        () => Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  DialogImageView(
                    url: controller.profile.profile.value.avatar!,
                  ),
                  useSafeArea: false,
                );
              },
              child: AnimatedOpacity(
                opacity: controller.avatarDisabled.value ? 0.4 : 1,
                duration: const Duration(seconds: 1),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: controller.profile.profile.value.avatar == null
                      ? const Icon(Icons.person)
                      : CachedImageWidget(
                          url: controller.profile.profile.value.avatar!,
                          category: "avatar",
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                ),
              ),
            ),
            if (controller.avatarDisabled.value)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                bottom: 10,
                child: CircularProgressIndicator(
                  value:
                      (controller.avatarUploadPercent.value / 100).toDouble(),
                ),
              ),
            if (controller.profile.profile.value.defaultAvatar == false)
              Positioned(
                right: -10,
                bottom: -8,
                width: 36,
                height: 36,
                child: GestureDetector(
                  onTap: controller.avatarDisabled.value
                      ? null
                      : () {
                          controller.deleteAvatar();
                        },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.error,
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Get.theme.colorScheme.onError,
                      size: 16,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: -10,
              bottom: -8,
              width: 36,
              height: 36,
              child: GestureDetector(
                onTap: controller.avatarDisabled.value
                    ? null
                    : () {
                        controller.chooseAvatar();
                      },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      width: 4,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Get.theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget abilities() {
    Widget item({
      required String text,
      required int value,
      required String suffix,
    }) {
      return Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  suffix,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Obx(
      () => Row(
        children: [
          item(
            text: 'account_ad_title'.tr,
            value: controller.profile.profile.value.plan?.adDays ?? 0,
            suffix: 'روز',
          ),
          // divider line vertical
          Container(
            width: 1,
            height: 65,
            color: Colors.grey[300],
          ),
          item(
            text: 'اعتبار بسته ویژه',
            value: controller.profile.profile.value.plan?.specialDays ?? 0,
            suffix: 'روز',
          ),
          // divider line vertical
          Container(
            width: 1,
            height: 65,
            color: Colors.grey[300],
          ),
          item(
            text: 'تعداد پیامک',
            value: controller.profile.profile.value.plan?.sms ?? 0,
            suffix: 'عدد',
          ),
        ],
      ),
    );
  }
}
