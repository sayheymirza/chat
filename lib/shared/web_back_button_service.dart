import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service to handle web browser back button behavior
/// This service prevents the browser tab from closing when back button is pressed
class WebBackButtonService extends GetxService {
  static WebBackButtonService get to => Get.find();

  late html.EventListener _popStateListener;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    if (kIsWeb) {
      _initWebHistory();
    }
  }

  void _initWebHistory() {
    if (_isInitialized) return;

    // Add a state to browser history
    html.window.history.pushState({'flutter_app': true}, '', null);

    // Listen for browser back/forward button events
    _popStateListener = (html.Event event) {
      html.PopStateEvent popEvent = event as html.PopStateEvent;
      _handleBrowserBack(popEvent);
    };

    html.window.addEventListener('popstate', _popStateListener);
    _isInitialized = true;

    print('WebBackButtonService initialized');
  }

  void _handleBrowserBack(html.PopStateEvent event) {
    // Immediately push a new state to prevent going back in browser history
    html.window.history.pushState({'flutter_app': true}, '', null);

    // Handle navigation within the Flutter app
    _handleFlutterNavigation();
  }

  void _handleFlutterNavigation() {
    try {
      // Check if we can navigate back in GetX
      if (Get.routing.previous.isNotEmpty) {
        print('Going back with GetX: ${Get.routing.previous}');
        Get.back();
        return;
      }

      // Check current route and handle accordingly
      String currentRoute = Get.currentRoute;
      print('Current route: $currentRoute');

      // If we're in a sub-page, go to main app page
      if (currentRoute != '/app' &&
          currentRoute != '/' &&
          currentRoute != '/auth') {
        print('Navigating to /app');
        Get.offAllNamed('/app');
        return;
      }

      // If we're at the main app page, show exit confirmation or go to auth
      if (currentRoute == '/app') {
        print('At app root, showing exit confirmation');
        _showExitDialog();
        return;
      }

      // If we're at splash or auth, stay there
      if (currentRoute == '/' || currentRoute == '/auth') {
        print('At root, staying here');
        // Do nothing, stay on current page
        return;
      }
    } catch (e) {
      print('Error in _handleFlutterNavigation: $e');
      // Fallback: go to app page
      Get.offAllNamed('/app');
    }
  }

  void _showExitDialog() {
    if (Get.context == null) return;

    Get.dialog(
      AlertDialog(
        title: Text('خروج از اپلیکیشن'),
        content: Text('آیا مطمئن هستید که می‌خواهید خارج شوید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('لغو'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed('/'); // Go to splash
            },
            child: Text('خروج'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  @override
  void onClose() {
    if (kIsWeb && _isInitialized) {
      html.window.removeEventListener('popstate', _popStateListener);
    }
    super.onClose();
  }
}

/// Extension to easily initialize the service
extension WebBackButtonExtension on GetxController {
  void initWebBackButton() {
    if (kIsWeb) {
      Get.put(WebBackButtonService(), permanent: true);
    }
  }
}
