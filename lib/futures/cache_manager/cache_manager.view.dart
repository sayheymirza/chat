import 'package:chat/futures/cache_manager/cache_manager.controller.dart';
import 'package:chat/shared/formats/byte.format.dart';
import 'package:chat/shared/widgets/empty.widget.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

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

      if (controller.total.value == 0) {
        return empty();
      }

      return data();
    });
  }

  Widget loading() {
    return Container();
  }

  Widget empty() {
    return const EmptyWidget(
      message: 'فضا ذخیره سازی خالی است',
    );
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
                sections: showingSections(controller.categories),
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
                  color: e['color'],
                ),
              ),
              title: Text(e['label']),
              trailing: Text(formatBytes(e['value'])),
            ),
          ),
          const Divider(),
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
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Map<String, dynamic>> data) {
    return data.map((element) {
      return PieChartSectionData(
        title: element['label'],
        titleStyle: const TextStyle(
          fontSize: 10,
        ),
        radius: 50,
        value: element['value'].toDouble(),
        color: element['color'],
      );
    }).toList();
  }
}
