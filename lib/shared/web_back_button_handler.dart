import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Simple and effective web back button handler
/// Just call WebBackButtonHandler.init() in your main app
class WebBackButtonHandler {
  static bool _initialized = false;
  static late html.EventListener _popStateListener;

  /// Initialize the web back button handler
  /// Call this once in your main app
  static void init() {
    if (!kIsWeb || _initialized) return;

    print('Initializing WebBackButtonHandler');

    // Listen to browser back/forward events
    _popStateListener = (html.Event event) {
      // Prevent the browser from actually going back
      html.window.history.pushState(null, '', html.window.location.href);

      // Handle app navigation
      _handleAppNavigation();
    };

    // Add event listener
    html.window.addEventListener('popstate', _popStateListener);

    // Push initial state to prevent going back to previous site
    html.window.history.pushState(null, '', html.window.location.href);

    _initialized = true;
    print('WebBackButtonHandler initialized successfully');
  }

  static void _handleAppNavigation() {
    print('Browser back button pressed - current route: ${Get.currentRoute}');

    try {
      // If we can go back in GetX routing, do it
      if (Get.routing.previous.isNotEmpty) {
        print('Going back with GetX to: ${Get.routing.previous}');
        Get.back();
        return;
      }

      // Check current route and decide what to do
      String currentRoute = Get.currentRoute;

      switch (currentRoute) {
        case '/app':
          // At main app page - show exit dialog
          _showExitDialog();
          break;

        case '/':
        case '/auth':
        case '/auth/login':
        case '/auth/register':
          // At auth pages - stay here or go to main app
          print('At auth page, staying here');
          break;

        default:
          // In other pages - go to main app
          print('Going to main app from: $currentRoute');
          Get.offAllNamed('/app');
          break;
      }
    } catch (e) {
      print('Error handling app navigation: $e');
      // Fallback - go to app
      Get.offAllNamed('/app');
    }
  }

  static void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('خروج از اپلیکیشن'),
        content: Text('آیا مطمئن هستید که می‌خواهید به صفحه اصلی برگردید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('خیر'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed('/'); // Go to splash
            },
            child: Text('بله'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Clean up the handler
  static void dispose() {
    if (kIsWeb && _initialized) {
      html.window.removeEventListener('popstate', _popStateListener);
      _initialized = false;
    }
  }
}
