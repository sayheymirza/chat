import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Mixin to handle web back button behavior
/// Add this to your page controllers or views to handle back button properly
mixin WebBackButtonMixin {
  void initWebBackButton() {
    if (kIsWeb) {
      // Listen to browser back/forward events
      html.window.addEventListener('popstate', _handlePopState);

      // Push current state to history
      html.window.history.pushState(null, '', html.window.location.href);
    }
  }

  void disposeWebBackButton() {
    if (kIsWeb) {
      html.window.removeEventListener('popstate', _handlePopState);
    }
  }

  void _handlePopState(html.Event event) {
    // Prevent default browser back behavior
    event.preventDefault();

    // Handle custom back logic
    handleCustomBack();
  }

  /// Override this method in your controllers/views to handle back navigation
  void handleCustomBack() {
    if (Get.routing.previous.isNotEmpty) {
      Get.back();
    } else {
      // Navigate to app main page instead of closing tab
      Get.offAllNamed('/app');
    }
  }
}

/// Alternative simpler approach using WillPopScope replacement
class SimpleWebBackHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;

  const SimpleWebBackHandler({
    super.key,
    required this.child,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          _defaultBackHandler();
        }
      },
      child: child,
    );
  }

  void _defaultBackHandler() {
    // Try to go back in GetX navigation
    if (Get.routing.previous.isNotEmpty) {
      Get.back();
      return;
    }

    // Try to go back in regular Navigator
    if (Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
      return;
    }

    // As last resort, navigate to app main page
    if (Get.currentRoute != '/app') {
      Get.offAllNamed('/app');
    }
  }
}
