import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget to handle back button behavior in Flutter Web
/// Prevents the browser tab from closing when user presses back button
class WebBackHandler extends StatelessWidget {
  final Widget child;

  const WebBackHandler({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          // Handle back navigation
          await _handleBackNavigation();
        },
        child: child,
      );
    }

    // For non-web platforms, return child as is
    return child;
  }

  Future<void> _handleBackNavigation() async {
    // Check if we can go back in GetX navigation stack
    if (Get.routing.previous.isNotEmpty) {
      // Go back to previous page using GetX
      Get.back();
      return;
    }

    // Check if we can go back in Navigator stack
    if (Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
      return;
    }

    // If we're at the root, show confirmation dialog or navigate to home
    await _handleRootNavigation();
  }

  Future<void> _handleRootNavigation() async {
    // Option 1: Navigate to home/app page instead of closing
    if (Get.currentRoute != '/app' && Get.currentRoute != '/') {
      Get.offAllNamed('/app');
      return;
    }

    // Option 2: Show exit confirmation dialog
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
              // Navigate to home page instead of closing the tab
              Get.offAllNamed('/');
            },
            child: Text('exit'.tr),
          ),
        ],
      ),
    );
  }
}
