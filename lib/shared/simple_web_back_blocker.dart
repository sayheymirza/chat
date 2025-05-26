import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Simple web back button blocker for GetX apps
/// Prevents browser tab from closing when back button is pressed
class SimpleWebBackBlocker {
  static bool _initialized = false;
  static html.EventListener? _popStateListener;

  /// Initialize the web back button blocker
  /// Call this once in your main GetMaterialApp
  static void init() {
    if (!kIsWeb || _initialized) return;

    print('🚀 Initializing Simple Web Back Blocker');

    // Push initial state to browser history
    html.window.history.pushState({
      'flutter_page': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }, '', null);

    // Listen to browser back button
    _popStateListener = (html.Event event) {
      print('🔙 Browser back detected - blocking and handling...');

      // Immediately push state back to prevent browser navigation
      html.window.history.pushState({
        'flutter_page': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      }, '', null);

      // Handle in-app navigation
      _handleInAppBack();
    };

    html.window.addEventListener('popstate', _popStateListener!);
    _initialized = true;

    print('✅ Simple Web Back Blocker initialized');
  }

  static void _handleInAppBack() {
    String currentRoute = Get.currentRoute;
    print('📍 Current route: $currentRoute');

    try {
      // Try GetX back first
      if (Get.routing.previous.isNotEmpty) {
        print('⬅️ Using GetX back navigation');
        Get.back();
        return;
      }

      // Handle specific routes
      if (currentRoute.contains('app') || currentRoute == '/#/app') {
        print('🏠 At main app - staying here');
        // Stay on app page instead of closing
        return;
      }

      if (currentRoute.contains('auth') ||
          currentRoute == '/' ||
          currentRoute == '/#/' ||
          currentRoute.isEmpty) {
        print('🔐 At auth/root - staying here');
        return;
      }

      // For other routes, go to app
      print('🔄 Going to app page');
      Get.offAllNamed('/app');
    } catch (e) {
      print('❌ Error: $e - Going to app');
      Get.offAllNamed('/app');
    }
  }

  /// Dispose the blocker
  static void dispose() {
    if (kIsWeb && _initialized && _popStateListener != null) {
      html.window.removeEventListener('popstate', _popStateListener!);
      _initialized = false;
    }
  }
}
