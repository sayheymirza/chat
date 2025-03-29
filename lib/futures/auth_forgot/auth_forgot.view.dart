import 'package:chat/futures/auth_forgot/auth_forgot.controller.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/card_numbers_blocked.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthForgotView extends GetView<AuthForgotController> {
  const AuthForgotView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthForgotController());

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("lib/app/assets/images/auth_logo.png"),
        centerTitle: true,
      ),
      bottomNavigationBar: footer(),
      body: Obx(
        () => Container(
          padding: EdgeInsets.only(
            top: 32,
            left: 32,
            right: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'فراموشی رمز عبور',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Gap(10),
              const Text(
                'شماره موبایل خود را وارد کنید تا رمز جدید برای شما ارسال شود',
              ),
              const Gap(32),
              FormBuilder(
                key: controller.forgotFormKey,
                enabled: !controller.disabled.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBuilderTextField(
                      name: "phone",
                      decoration: const InputDecoration(
                        labelText: "شماره موبایل",
                        hintText: "09",
                        hintTextDirection: TextDirection.ltr,
                      ),
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.maxLength(11),
                          CustomValidator.justPhoneNumber(
                            errorText: 'فرمت شماره موبایل اشتباه است',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      height: 314,
      width: Get.width,
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: navigationBarHeight + 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardNumbersBlockedWidget(),
          const Gap(10),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !controller.disabled.value
                    ? () {
                        controller.submit();
                      }
                    : null,
                child: controller.disabled.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'ارسال رمز عبور جدید',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
