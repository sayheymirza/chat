import 'package:chat/futures/cache_manager/cache_manager.controller.dart';
import 'package:chat/shared/formats/byte.format.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CacheManagerView extends GetView<CacheManagerController> {
  const CacheManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CacheManagerController());

    controller.load();

    return Scaffold(
      appBar: const GradientAppBarWidget(
        back: true,
        title: "فضای ذخیره سازی",
      ),
      body: body(),
    );
  }

  Widget body() {
    return Obx(() {
      if (controller.loading.value) {
        return loading();
      }

      return data();
    });
  }

  Widget loading() {
    return Container();
  }

  Widget data() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: showingSections(
                  controller.categories,
                  controller.total.value,
                ),
              ),
            ),
          ),
          ...controller.categories.map(
            (e) => ListTile(
              onTap: () {
                controller.deleteByCategory(category: e['key']);
              },
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.colors[e['key']],
                ),
              ),
              title: Text(e['label']),
              trailing: Text(formatBytes(e['value'])),
            ),
          ),
          const Divider(),
          if (Services.profile.profile.value.permissions
              .contains('CLEAR_CACHE_DATABASE'))
          ListTile(
            onTap: () {
              controller.deleteAll();
            },
            leading: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            title: const Text('پاک کردن فضای ذخیره سازی'),
            trailing: Text(formatBytes(controller.total.value)),
          ),
          if (Services.profile.profile.value.permissions
              .contains('CLEAR_USER_DATABASE'))
          ListTile(
            onTap: () {
              controller.deleteUsers();
            },
            leading: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            title: const Text('پاک کردن دیتابیس کاربران'),
          ),
          if (Services.profile.profile.value.permissions
              .contains('CLEAR_CHAT_DATABASE'))
          ListTile(
            onTap: () {
              controller.deleteChats();
            },
            leading: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            title: const Text('پاک کردن دیتابیس چت ها'),
          ),
          Gap(Get.bottomBarHeight),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    List<Map<String, dynamic>> data,
    int total,
  ) {
    return data.map((element) {
      return PieChartSectionData(
        title: '${element['percent']}%',
        titleStyle: const TextStyle(
          fontSize: 10,
        ),
        radius: 50,
        value: total == 0 ? 6 : element['value'].toDouble(),
        color: controller.colors[element['key']],
      );
    }).toList();
  }
}
