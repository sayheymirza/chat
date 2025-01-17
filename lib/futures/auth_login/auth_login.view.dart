import 'package:chat/futures/auth_login/auth_login.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/or.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthLoginView extends GetView<AuthLoginController> {
  const AuthLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthLoginController());

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("lib/app/assets/images/auth_logo.png"),
        centerTitle: true,
      ),
      bottomNavigationBar: footer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ورود به حساب کاربری',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Gap(10),
            const Text(
              'برای استفاده از امکانات ماه‌عسل، لطفاً شماره موبایل خود را وارد کنید.',
            ),
            const Gap(32),
            Obx(
              () => FormBuilder(
                key: controller.loginFormKey,
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
                    const Gap(20),
                    FormBuilderTextField(
                      name: "password",
                      decoration: InputDecoration(
                        labelText: "رمز عبور",
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.visablePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            controller.visablePassword.value =
                                !controller.visablePassword.value;
                          },
                        ),
                      ),
                      textDirection: TextDirection.ltr,
                      obscureText: !controller.visablePassword.value,
                      validator: FormBuilderValidators.compose(
                        [
                          CustomValidator.justNotPersian(
                            errorText: 'از حروف فارسی استفاده نکنید',
                          ),
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                        'تایید و ورود',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 64,
            child: OrWidget(),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/auth/forgot');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pink),
              ),
              child: const Text(
                'فراموشی رمز عبور',
                style: TextStyle(
                  color: Colors.white,
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
