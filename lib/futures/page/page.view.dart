import 'package:chat/futures/page/page.controller.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PageView extends GetView<PageViewController> {
  final String title;
  final String page;

  const PageView({
    super.key,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(PageViewController());

    controller.load(page: page);

    return Obx(
      () => Scaffold(
        appBar: GradientAppBarWidget(
          back: true,
          title: title,
        ),
        body: controller.data.isEmpty
            ? Container()
            : InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: controller.data.value,
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    transparentBackground: true,
                  ),
                ),
              ),
      ),
    );
  }
}
