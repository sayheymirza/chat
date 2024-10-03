// ignore_for_file: invalid_use_of_protected_member

import 'package:chat/futures/auth_reigster/auth_registor.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/dropdowns/dropdowns.widget.dart';
import 'package:chat/shared/widgets/stepper.widget.dart';
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

    return Obx(
      () => PopScope(
        canPop: controller.step.value == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (controller.step.value != 0) {
            controller.step.value -= 1;
          }
        },
        child: Scaffold(
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
              group: 'LifeStyle',
              name: 'living',
              items: controller.dropdownsItems['living']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'سبک زندگی',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'SalaryRange',
              name: 'salary',
              items: controller.dropdownsItems['salary']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت درآمد',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'CarStatus',
              name: 'car',
              items: controller.dropdownsItems['car']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت اتومبیل',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            DropdownsWidget(
              group: 'HouseStatus',
              name: 'home',
              items: controller.dropdownsItems['home']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'وضعیت مسکن',
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
            DropdownsWidget(
              group: 'Province',
              name: 'province',
              items: controller.dropdownsItems['province']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'استان محل سکونت',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
              onChange: (value) {
                // onProvinceChanged(value);
                if (value != null) {
                  controller.setCitiesByProvider(value.toString());
                  controller.registerStep6FormKey.currentState!
                      .patchValue({"city": null});
                }
              },
            ),
            const Gap(16),
            if (controller.cities.isNotEmpty)
              DropdownsWidget(
                group: 'City',
                name: 'city',
                items: controller.cities
                    .map((e) => e as DropdownMenuItem<String>)
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'شهر محل سکونت',
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
            if (controller.cities.isNotEmpty) const Gap(16),
            DropdownsWidget(
              group: 'ReligionRate',
              name: 'religion',
              items: controller.dropdownsItems['religion']!
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'میزان مذهبی بودن',
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            const Gap(16),
            if ('type'.tr == 'dating')
              // mariage type
              DropdownsWidget(
                group: 'MarriageType',
                name: 'marriageType',
                items: controller.dropdownsItems['marriageType']!
                    .map((e) => e as DropdownMenuItem<String>)
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'نوع ازدواج',
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
            if ('type'.tr == 'dating') const Gap(16),
            FormBuilderTextField(
              name: 'about',
              decoration: InputDecoration(
                labelText:
                    'type'.tr == 'dating' ? 'درباره همسر من' : 'درباره من',
                helperText: " پس از بررسی و تایید قابل نمایش است",
              ),
              minLines: 2,
              maxLines: 4,
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(4,
                      errorText: 'نباید بیشتر از ۴ حرف وارد کنید'),
                  FormBuilderValidators.maxLength(500,
                      errorText: 'نباید بیشتر از ۵۰۰ حرف وارد کنید'),
                  CustomValidator.justPersian(
                      skipChars: [' '], errorText: 'فقط حروف فارسی وارد کنید'),
                  CustomValidator.justNotNumber(errorText: 'عدد وارد نکنید'),
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
            const Text(
              " شماره موبایل صرفا جهت احراز هویت کاربران است و به هیچ عنوان در معرض نمایش دیگران قرار نمیگیرد و یا در اختیار دیگر کاربران قرار نخواهد گرفت ",
            ),
            const Gap(8),
            FormBuilderTextField(
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'شماره موبایل',
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
            const Gap(16),
            // password
            FormBuilderTextField(
              name: 'password',
              obscureText: !controller.visablePassword.value,
              decoration: InputDecoration(
                labelText: 'رمز عبور',
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
            const Gap(16),
            // repeat password
            FormBuilderTextField(
              name: 'repeatPassword',
              obscureText: !controller.visablePassword.value,
              decoration: InputDecoration(
                labelText: 'تکرار رمز عبور',
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
                            controller.step.value == 6
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
