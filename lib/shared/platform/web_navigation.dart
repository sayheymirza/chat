import 'dart:js';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/services.dart';
import 'package:js/js.dart';

import 'package:js/js_util.dart';

void NavigationToNamed(String path, {dynamic params}) {
  print('$path?$params');
  callMethod(context['window'], 'NavigationToNamed', [path, params]);
}

void NavigationBack() {
  print('NavitationBack');
  callMethod(context['window'], 'NavigationBack', []);
}

void NavigationPopDialog() {
  print('popdialog');
  callMethod(context['window'], 'NavigationPopDialog', []);
}

void NavigationOpenedDialog() {
  print('openeddialog');
  callMethod(context['window'], 'NavigationOpenedDialog', []);

  Services.event.fire(
    event: EVENTS.NAVIGATION_DIALOG,
  );
}

@JS('sendBackButtonEventToFlutter')
external set _sendBackButtonEventToFlutter(void Function(String location));

void NavigationListenOnBack() {
  print('listening to back button');
  _sendBackButtonEventToFlutter = allowInterop((String location) {
    Services.event.fire(
      event: EVENTS.NAVIGATION_BACK,
      value: location,
    );
  });
}
