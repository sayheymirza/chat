import 'package:chat/futures/contact/contact.controller.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/cached_image.widget.dart';
import 'package:chat/shared/widgets/contact_form/contact_form.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactController());

    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: 'تماس با ما',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            time(),
            channels(),
            const Text('از راه های زیر می توانید با ما در ارتباط باشید'),
            const Gap(20),
            phone(),
            email(),
            address(),
            form(),
            Gap(Get.bottomBarHeight + 32),
          ],
        ),
      ),
    );
  }

  Widget form() {
    var form = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_FORM,
    );

    if (form == true) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Gap(20),
            const Text(
              'پیام خود را برای ما ارسال کنید',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(40),
            ContactFormWidget(
              formKey: controller.formKey,
              disabled: controller.disabled.value,
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.disabled.value
                    ? null
                    : () {
                        controller.submit();
                      },
                child: const Text(
                  'ارسال',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget address() {
    var address = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_ADDRESS,
    );
    var description = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_ADDRESS_DESCRIPTION,
    );

    if (address.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 42,
              color: Colors.grey.shade600,
            ),
            const Gap(20),
            const Text(
              'آدرس دفتر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              address,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Text(
              description,
              style: const TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget email() {
    var email = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_EMAIL,
    );
    var description = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_EMAIL_DESCRIPTION,
    );

    if (email.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.alternate_email,
              size: 42,
              color: Colors.grey.shade600,
            ),
            const Gap(20),
            Text(
              email,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Services.launch.launch('mailto:$email');
                },
                child: const Text(
                  'ارسال ایمیل',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget phone() {
    var phone = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_PHONE,
    );
    var description = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_PHONE_DESCRIPTION,
    );
    var platform = Services.configs.get(
      key: CONSTANTS.STORAGE_CONTACT_US_PHONE_PLATFORMS,
    );

    if (phone.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Wrap(
              children: [
                ...platform
                    .map(
                      (element) => Container(
                        width: 42,
                        height: 42,
                        margin: const EdgeInsets.all(4),
                        child: CachedImageWidget(
                          url: element['logo'],
                          background: Colors.white,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
            const Gap(20),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Services.launch.launch('sms:$phone');
                },
                child: const Text(
                  'ارسال پیامک',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget channels() {
    var channels =
        Services.configs.get(key: CONSTANTS.STORAGE_CONTACT_US_CHANNELS);

    if (channels.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ...channels
                .map(
                  (element) => ListTile(
                    dense: true,
                    onTap: () {
                      Services.launch.launch(element['link']);
                    },
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CachedImageWidget(
                        url: element['logo'],
                        background: Colors.white,
                      ),
                    ),
                    title: Text(
                      element['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      );
    }

    return Container();
  }

  Widget time() {
    var time = Services.configs.get(key: CONSTANTS.STORAGE_CONTACT_US_TIME);

    if (time.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.amber.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('ساعت پاسخگویی'),
                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
