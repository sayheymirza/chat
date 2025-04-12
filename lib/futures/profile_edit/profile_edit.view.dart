import 'package:chat/futures/profile_edit/profile_edit.controller.dart';
import 'package:chat/shared/validator.dart';
import 'package:chat/shared/widgets/dropdowns/dropdowns.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileEditController());

    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: "ویرایش پروفایل من",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Container(
        width: Get.width - 32,
        margin: const EdgeInsets.only(bottom: 24),
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.disabled.value
                ? null
                : () {
                    controller.submit();
                  },
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
                    'ثبت و ویرایش',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: Get.bottomBarHeight + 32,
          ),
          child: Column(
            children: [
              FormBuilder(
                key: controller.formKey,
                enabled: !controller.disabled.value,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    controller.index.value = isExpanded ? index : -1;
                  },
                  elevation: 0,
                  children: [
                    expansion(
                      expanded: controller.index.value == 0,
                      title: "اطلاعات کاربری",
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
                                  skipChars: [' '],
                                  errorText: 'فقط حروف فارسی وارد کنید'),
                              CustomValidator.justNotNumber(
                                  errorText: 'عدد وارد نکنید'),
                            ],
                          ),
                        ),
                        const Gap(16),
                        const Text('تاریخ تولد'),
                        const Gap(8),
                        Row(
                          children: [
                            // all fields are dropdown with empty array
                            Expanded(
                              child: DropdownsWidget(
                                group: 'year',
                                name: 'year',
                                items: controller.dropdownsItems['year']!
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
                                group: 'month',
                                name: 'month',
                                items: controller.dropdownsItems['month']!
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
                                group: 'day',
                                name: 'day',
                                items: controller.dropdownsItems['day']!
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
                        DropdownsWidget(
                          group: 'MaritalStatus',
                          name: 'marital',
                          items: controller.dropdownsItems['marital']!
                              .map((e) => e as DropdownMenuItem<String>)
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'وضعیت تاهل',
                          ),
                          onChange: (value) {
                            controller.formKey.currentState!.patchValue({
                              "children": '0',
                              "maxAge": '0',
                            });

                            controller.isSingle.value = value == '0';
                          },
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                            ],
                          ),
                        ),
                        if (controller.isSingle.value == false) const Gap(16),
                        if (controller.isSingle.value == false)
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
                        const Gap(16),
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
                              controller.formKey.currentState!
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
                      ],
                    ),
                    expansion(
                      expanded: controller.index.value == 1,
                      title: "ویژگی ها ظاهری",
                      children: [
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
                        const Gap(16),
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
                        Row(
                          children: [
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                            const Gap(16),
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                          ],
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
                      ],
                    ),
                    expansion(
                      expanded: controller.index.value == 2,
                      title: "اطلاعات تکمیلی",
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
                                  skipChars: [' '],
                                  errorText: 'فقط حروف فارسی وارد کنید'),
                              CustomValidator.justNotNumber(
                                  errorText: 'عدد وارد نکنید'),
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
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                            const Gap(16),
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                            const Gap(16),
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownsWidget(
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
                            ),
                            const Gap(16),
                            Expanded(
                              child: DropdownsWidget(
                                group: 'marriageType',
                                name: 'marriageType',
                                items: controller
                                    .dropdownsItems['marriageType']!
                                    .map((e) => e as DropdownMenuItem<String>)
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'marriage_type_title'.tr,
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
                        FormBuilderTextField(
                          name: 'about',
                          decoration: InputDecoration(
                            labelText: 'type'.tr == 'dating'
                                ? 'درباره همسر من'
                                : 'درباره من',
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
                                  errorText:
                                      'نباید بیشتر از ۵۰۰ حرف وارد کنید'),
                              CustomValidator.justPersian(
                                  skipChars: [' '],
                                  errorText: 'فقط حروف فارسی وارد کنید'),
                              CustomValidator.justNotNumber(
                                  errorText: 'عدد وارد نکنید'),
                            ],
                          ),
                        ),
                      ],
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

  ExpansionPanel expansion({
    required bool expanded,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionPanel(
      canTapOnHeader: true,
      backgroundColor: Colors.transparent,
      headerBuilder: (context, isExpanded) => ListTile(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            ...children
          ],
        ),
      ),
      isExpanded: expanded,
    );
  }
}
