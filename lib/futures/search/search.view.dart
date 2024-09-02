import 'package:chat/futures/search/search.controller.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:chat/shared/widgets/pagination.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchViewController());

    controller.reset();

    return Scaffold(
      appBar: GradientAppBarWidget(
        title: 'جستجو کاربران',
        left: TextButton.icon(
          onPressed: () {
            controller.openFilters();
          },
          icon: Icon(
            Icons.filter_alt_rounded,
            color: Get.theme.colorScheme.onPrimary,
          ),
          label: Text(
            'فیلتر ها',
            style: TextStyle(color: Get.theme.colorScheme.onPrimary),
          ),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in controller.profiles) profile(item),
                  if (controller.profiles.isNotEmpty)
                    PaginationWidget(
                      last: controller.lastPage.value,
                      page: controller.page.value,
                      onChange: (page) {
                        controller.goToPage(page);
                      },
                    ),
                ],
              ),
            ),
            if (controller.loading.value)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget profile(ProfileSearchModel item) {
    return GestureDetector(
      onTap: () {
        // showSnackbar(message: 'باز شدن صفحه پروفایل');
        Get.toNamed(
          '/profile/${item.id}',
          arguments: {
            'id': item.id,
            'options': true,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
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
            // avatar
            AvatarWidget(url: item.avatar!, seen: item.seen!),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.fullname!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(6),
                      if (item.verified == true)
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                  const Gap(10),
                  Text('${item.age} ساله'),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 32,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.blue,
                        size: 18,
                      ),
                      const Gap(5),
                      Text(item.city!),
                    ],
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Opacity(
                          opacity: 0,
                          child: const Icon(
                            Icons.visibility,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Opacity(
                          opacity: item.ad == true ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Opacity(
                          opacity: item.special == true ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
