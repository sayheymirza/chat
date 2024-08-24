import 'package:chat/futures/search_filter/search_filter.controller.dart';
import 'package:chat/shared/widgets/dropdowns/dropdowns.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SearchFilterView extends GetView<SearchFilterController> {
  const SearchFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchFilterController());

    controller.loadDropdowns().then((value) {
      controller.patchValue(Get.arguments);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('فیلتر ها'),
        actions: [
          IconButton(
            onPressed: () {
              controller.reset();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          const Gap(10),
        ],
      ),
      floatingActionButton: SizedBox(
        width: Get.width - 32,
        child: ElevatedButton(
          onPressed: () {
            controller.submit();
          },
          child: const Text(
            'اعمال فیلتر',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: controller.searchFilterFormKey,
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
                  onChange: (value) {
                    if (value != null) {
                      controller.setCitiesByProvider(value.toString());
                    }
                  },
                ),
                const Gap(16),
                DropdownsWidget(
                  group: 'City',
                  name: 'city',
                  items: controller.cities
                      .map((e) => e as DropdownMenuItem<String>)
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'شهر محل سکونت',
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownsWidget(
                        group: 'Age',
                        name: 'minAge',
                        items: controller.dropdownsItems['Age']!
                            .map((e) => e as DropdownMenuItem<String>)
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'حداقل سن',
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: DropdownsWidget(
                        group: 'Age',
                        name: 'maxAge',
                        items: controller.dropdownsItems['Age']!
                            .map((e) => e as DropdownMenuItem<String>)
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'حداکثر سن',
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
                ),
                const Gap(16),
                FormBuilderSwitch(
                  name: 'avatar',
                  title: const Text('فقط کاربرانی که عکس دارند'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
