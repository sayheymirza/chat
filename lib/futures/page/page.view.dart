import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PageView extends StatelessWidget {
  final String title;
  final String page;

  const PageView({
    super.key,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    var link = Services.configs.get(key: 'page:$page');

    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: title,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(link),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            transparentBackground: true,
          ),
        ),
      ),
    );
  }
}
