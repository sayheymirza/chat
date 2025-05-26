import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// GetX-specific web back button handler
/// Handles browser back button for GetX routing with hash URLs (/#/route)
class GetXWebBackHandler extends GetxService {
  static GetXWebBackHandler get to => Get.find<GetXWebBackHandler>();

  html.EventListener? _popStateListener;
  bool _isHandlingPop = false;

  @override
  void onInit() {
    super.onInit();
    if (kIsWeb) {
      _initWebBackButton();
    }
  }

  void _initWebBackButton() {
    print('🔄 Initializing GetX Web Back Handler');

    // Add initial state to prevent going back to previous website
    html.window.history.pushState({
      'flutter': true,
      'route': Get.currentRoute,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }, '', null);

    // Listen to popstate events (browser back/forward)
    _popStateListener = (html.Event event) {
      if (_isHandlingPop) return;

      html.PopStateEvent popEvent = event as html.PopStateEvent;
      _handleBrowserBackButton(popEvent);
    };

    html.window.addEventListener('popstate', _popStateListener!);

    print('✅ GetX Web Back Handler initialized');
  }

  void _handleBrowserBackButton(html.PopStateEvent event) {
    print('🔙 Browser back button pressed');
    print('📍 Current route: ${Get.currentRoute}');
    print('📜 Event state: ${event.state}');

    _isHandlingPop = true;

    // Prevent browser from actually going back
    html.window.history.pushState({
      'flutter': true,
      'route': Get.currentRoute,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }, '', null);

    // Handle app navigation
    _handleAppNavigation();

    // Reset flag after a short delay
    Future.delayed(Duration(milliseconds: 100), () {
      _isHandlingPop = false;
    });
  }

  void _handleAppNavigation() {
    String currentRoute = Get.currentRoute;
    print('🎯 Handling navigation from: $currentRoute');

    try {
      // Check if we can go back in GetX navigation stack
      var routingHistory = Get.routing.previous;
      print('📚 Routing history: $routingHistory');

      if (routingHistory.isNotEmpty) {
        print('⬅️ Going back with GetX');
        Get.back();
        return;
      }

      // Handle specific routes
      if (currentRoute.contains('/app')) {
        print('🏠 At app route, showing exit dialog');
        _showExitDialog();
      } else if (currentRoute.contains('/auth') ||
          currentRoute == '/' ||
          currentRoute == '/#/') {
        print('🔐 At auth/root, staying here');
        // Stay on current page
      } else {
        print('🔄 Going to app from: $currentRoute');
        Get.offAllNamed('/app');
      }
    } catch (e) {
      print('❌ Error in navigation: $e');
      // Fallback
      Get.offAllNamed('/app');
    }
  }

  void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        title:
            Text('خروج از اپلیکیشن', style: TextStyle(fontFamily: 'IranSans')),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید به صفحه اصلی برگردید؟',
          style: TextStyle(fontFamily: 'IranSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('خیر', style: TextStyle(fontFamily: 'IranSans')),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed('/'); // Go to splash/home
            },
            child: Text('بله', style: TextStyle(fontFamily: 'IranSans')),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // Method to manually push state when route changes
  void pushRouteState(String route) {
    if (!kIsWeb) return;

    html.window.history.pushState({
      'flutter': true,
      'route': route,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    }, '', null);
  }

  @override
  void onClose() {
    if (kIsWeb && _popStateListener != null) {
      html.window.removeEventListener('popstate', _popStateListener!);
    }
    super.onClose();
  }
}

/// GetX Route observer to track route changes
class GetXWebRouteObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (kIsWeb && Get.isRegistered<GetXWebBackHandler>()) {
      GetXWebBackHandler.to.pushRouteState(Get.currentRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (kIsWeb && Get.isRegistered<GetXWebBackHandler>()) {
      GetXWebBackHandler.to.pushRouteState(Get.currentRoute);
    }
  }
}
