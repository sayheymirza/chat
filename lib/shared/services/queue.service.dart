import 'dart:async';

import 'package:get/get.dart';

// create a type for future function
typedef FutureFunction = Future<dynamic> Function();

class QueueService extends GetxService {
  late Timer _timer;
  List<FutureFunction> _queue = [];
  bool running = false;

  void add(FutureFunction callback) {
    _queue.add(callback);
  }

  void pop() {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0);
    }
  }

  void run() async {
    if (_queue.isNotEmpty) {
      running = true;
      await _queue.first();
      pop();
      running = false;
    }
  }

  void loop() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (running) return;
      run();
    });
  }

  void dispose() {
    _timer.cancel();
  }
}
