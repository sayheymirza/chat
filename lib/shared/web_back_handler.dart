import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to handle back button behavior in Flutter Web
/// Prevents the browser tab from closing when user presses back button
class WebBackHandler extends StatefulWidget {
  final Widget child;

  const WebBackHandler({
    super.key,
    required this.child,
  });

  @override
  State<WebBackHandler> createState() => _WebBackHandlerState();
}

class _WebBackHandlerState extends State<WebBackHandler> {
  late html.EventListener _popStateListener;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initWebHistory();
    }
  }

  void _initWebHistory() {
    // Push an initial state to the history
    html.window.history.pushState({'flutter': 'app'}, '', null);

    // Listen for popstate events (when user clicks back/forward)
    _popStateListener = (html.Event event) {
      _handleBrowserBack();
    };

    html.window.addEventListener('popstate', _popStateListener);
  }

  void _handleBrowserBack() {
    // Push another state to prevent actually going back
    html.window.history.pushState({'flutter': 'app'}, '', null);

    // Handle the back navigation within the app
    _handleAppBack();
  }

  void _handleAppBack() {
    // Check if we can go back in GetX navigation stack
    if (Get.routing.previous.isNotEmpty) {
      Get.back();
      return;
    }

    // Check if we can go back in Navigator stack
    if (Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
      return;
    }

    // If we're at the root, handle accordingly
    _handleRootNavigation();
  }

  void _handleRootNavigation() {
    // Navigate to app main page if not already there
    if (Get.currentRoute != '/app' && Get.currentRoute != '/') {
      Get.offAllNamed('/app');
      return;
    }

    // If already at root, show exit confirmation
    _showExitConfirmation();
  }

  void _showExitConfirmation() {
    if (Get.context == null) return;

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('exit_app'.tr),
        content: Text('exit_app_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to splash or home page
              Get.offAllNamed('/');
            },
            child: Text('exit'.tr),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (kIsWeb) {
      html.window.removeEventListener('popstate', _popStateListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
