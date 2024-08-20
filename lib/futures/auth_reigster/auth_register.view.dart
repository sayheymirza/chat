import 'package:chat/futures/auth_reigster/auth_registor.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/dropdowns/dropdowns.widget.dart';
import 'package:chat/shared/widgets/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AuthRegisterView extends GetView<AuthRegisterController> {
  const AuthRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthRegisterController());

    controller.loadDropdowns();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("lib/app/assets/images/auth_logo.png"),
        centerTitle: true,
      ),
      bottomNavigationBar: footer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ثبت نام',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'برای استفاده از امکانات این برنامه، لطفاً اطلاعات خود را وارد کنید.',
                  ),
                ],
              ),
            ),
            const Gap(24),
            Obx(
              () => Column(
                children: [
                  StepperWidget(
                    current: controller.step.value,
                    count: 7,
                  ),
                  IndexedStack(
                    index: controller.step.value,
                    children: [
                      step1(),
                      step2(),
                      step3(),
                      step4(),
                      step5(),
                      step6(),
                      step7(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step1() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep1FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'نام',
                helperText: " پس از بررسی و تایید قابل نمایش است",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(10,
                      errorText: 'نباید بیشتر از ۱۰ حرف وارد کنید'),
                  CustomValidator.justPersian(
                      skipChars: [' '], errorText: 'فقط حروف فارسی وارد کنید'),
                  CustomValidator.justNotNumber(errorText: 'عدد وارد نکنید'),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: "gender",
              name: "gender",
              items: controller.dropdownsItems['gender']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: "جنسیت",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step2() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep2FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تاریخ تولد'),
            const Gap(8),
            Row(
              children: [
                // all fields are dropdown with empty array
                Expanded(
                  child: DropdownsWidget(
                    group: 'BirthDateYear',
                    name: 'year',
                    items: controller.dropdownsItems['BirthDateYear']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'سال',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DropdownsWidget(
                    group: 'BirthDateMounth',
                    name: 'month',
                    items: controller.dropdownsItems['BirthDateMounth']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'ماه',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DropdownsWidget(
                    group: 'BirthDateDay',
                    name: 'day',
                    items: controller.dropdownsItems['BirthDateDay']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'روز',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                // weight and height dropdowns
                Expanded(
                  child: DropdownsWidget(
                    group: 'Weight',
                    name: 'weight',
                    items: controller.dropdownsItems['weight']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'وزن',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: DropdownsWidget(
                    group: 'Height',
                    name: 'height',
                    items: controller.dropdownsItems['height']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'قد',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget step3() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep3FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            DropdownsWidget(
              group: 'MaritalStatus',
              name: 'marital',
              items: controller.dropdownsItems['marital']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت تاهل',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: DropdownsWidget(
                    group: 'ChildCount',
                    name: 'children',
                    items: controller.dropdownsItems['children']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'تعداد فرزندان',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DropdownsWidget(
                    group: 'OldestChildAge',
                    name: 'maxAge',
                    items: controller.dropdownsItems['maxAge']!
                        .map((e) => e as DropdownMenuItem<String>)
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'بزرگترین سن فرزند',
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget step4() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep4FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            DropdownsWidget(
              group: 'SkinColor',
              name: 'color',
              items: controller.dropdownsItems['color']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'رنگ پوست',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'BeautyRate',
              name: 'beauty',
              items: controller.dropdownsItems['beauty']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'امتیاز زیبایی',
                helperText: "1 کمترین و 5 بیشترین",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'StyleRate',
              name: 'shape',
              items: controller.dropdownsItems['shape']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'امتیاز خوشتیپی',
                helperText: "1 کمترین و 5 بیشترین",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'HealthStatus',
              name: 'health',
              items: controller.dropdownsItems['health']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت سلامتی',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'Education',
              name: 'education',
              items: controller.dropdownsItems['education']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت تحصیلی',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step5() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep5FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'job',
              decoration: const InputDecoration(
                labelText: 'وضعیت شغلی',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(10,
                      errorText: 'نباید بیشتر از ۱۰ حرف وارد کنید'),
                  CustomValidator.justPersian(
                      skipChars: [' '], errorText: 'فقط حروف فارسی وارد کنید'),
                  CustomValidator.justNotNumber(errorText: 'عدد وارد نکنید'),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: "gender",
              name: "gender",
              items: controller.dropdownsItems['gender']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: "جنسیت",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step6() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep6FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'نام',
                helperText: " پس از بررسی و تایید قابل نمایش است",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(10,
                      errorText: 'نباید بیشتر از ۱۰ حرف وارد کنید'),
                  CustomValidator.justPersian(
                      skipChars: [' '], errorText: 'فقط حروف فارسی وارد کنید'),
                  CustomValidator.justNotNumber(errorText: 'عدد وارد نکنید'),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: "gender",
              name: "gender",
              items: controller.dropdownsItems['gender']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: "جنسیت",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step7() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: FormBuilder(
        key: controller.registerStep7FormKey,
        enabled: !controller.disabled.value,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'نام',
                helperText: " پس از بررسی و تایید قابل نمایش است",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(10,
                      errorText: 'نباید بیشتر از ۱۰ حرف وارد کنید'),
                  CustomValidator.justPersian(
                      skipChars: [' '], errorText: 'فقط حروف فارسی وارد کنید'),
                  CustomValidator.justNotNumber(errorText: 'عدد وارد نکنید'),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: "gender",
              name: "gender",
              items: controller.dropdownsItems['gender']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: "جنسیت",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Row(
              children: [
                if (controller.step.value > 0)
                  Container(
                    width: Get.width / 2 - 50,
                    margin: const EdgeInsets.only(left: 16),
                    child: OutlinedButton(
                      onPressed: !controller.disabled.value
                          ? () {
                              controller.step.value -= 1;
                            }
                          : null,
                      child: const Text(
                        'مرحله قبلی',
                      ),
                    ),
                  ),
                SizedBox(
                  width: controller.step.value == 0
                      ? Get.width - 64
                      : Get.width / 2 - 30,
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
                        : Text(
                            controller.step.value == 7
                                ? 'تایید و ثبت نام'
                                : 'مرحله بعد',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
