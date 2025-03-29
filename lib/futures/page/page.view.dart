import 'package:chat/futures/page/page.controller.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
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
        backgroundColor: Colors.white,
        appBar: GradientAppBarWidget(
          back: true,
          title: title,
        ),
        body: Stack(
          children: [
            if (controller.data.value.isNotEmpty)
              InAppWebView(
                initialData: InAppWebViewInitialData(
                  data: controller.data.value,
                ),
              ),
            if (controller.errored.value)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 64,
                      color: Colors.red,
                    ),
                    const Gap(10),
                    Text(
                      'متاسفانه صفحه وجود ندارد',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            if (controller.loading.value) LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
