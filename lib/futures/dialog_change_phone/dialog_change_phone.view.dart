import 'package:chat/futures/dialog_change_phone/dialog_change_phone.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DialogChangePhoneView extends GetView<DialogChangePhoneController> {
  const DialogChangePhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DialogChangePhoneController());

    return Obx(
      () => PopScope(
        canPop: !controller.disabled.value,
        child: Dialog(
          child: Container(
            height: 220,
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
                        "تغییر شماره موبایل",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
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
