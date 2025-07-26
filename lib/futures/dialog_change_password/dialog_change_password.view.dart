import 'package:chat/futures/dialog_change_password/dialog_change_password.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogChangePasswordView extends GetView<DialogChangePasswordController> {
  const DialogChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DialogChangePasswordController());

    return Obx(
      () => PopScope(
        canPop: !controller.disabled.value,
        child: Dialog(
          child: Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilder(
                  key: controller.formKey,
                  enabled: !controller.disabled.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "تغییر رمز عبور",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      FormBuilderTextField(
                        initialValue: "",
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
                            FormBuilderValidators.required(),
                            CustomValidator.justNotPersian(
                              errorText: 'از حروف فارسی استفاده نکنید',
                            ),
                          ],
                        ),
                        onSubmitted: (_) {
                          controller.submit();
                        },
                      ),
                      const Gap(10),
                      FormBuilderTextField(
                        initialValue: "",
                        name: "password_repeat",
                        decoration: InputDecoration(
                          labelText: "تکرار رمز عبور",
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
                            FormBuilderValidators.required(),
                            CustomValidator.justNotPersian(
                              errorText: 'از حروف فارسی استفاده نکنید',
                            ),
                          ],
                        ),
                        onSubmitted: (_) {
                          controller.submit();
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('انصراف'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.submit();
                      },
                      child: controller.disabled.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Get.theme.colorScheme.onPrimary,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'تایید و تغییر',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
