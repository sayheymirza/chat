import 'dart:async';

import 'package:chat/app/shared/i18n.dart';
import 'package:chat/app/shared/theme.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/pages.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool dialoging = false;
  StreamSubscription<EventModel>? subevents;

  @override
  void initState() {
    super.initState();

    subevents = event.on<EventModel>().listen((data) async {
      if (data.event == EVENTS.NAVIGATION_DIALOG) {
        dialoging = true;
      }

      if (data.event == EVENTS.NAVIGATION_BACK) {
        String currentPath = data.value;

        print('$currentPath, ${Get.currentRoute}');

        if (dialoging) {
          dialoging = false;
          return;
        }

        if (currentPath.startsWith('/app/purchase/one-step')) {
          return;
        }

        Get.back();

        // if ((currentPath.startsWith('/app') || currentPath == '/') &&
        //     Get.currentRoute.startsWith('/app')) {
        //   back();
        // } else {
        //   Get.back();
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var val = getNavigationBarHeight(context);

    if (navigationBarHeight == 0) {
      navigationBarHeight = val;
    }

    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: themeData.copyWith(
        bottomNavigationBarTheme: themeData.bottomNavigationBarTheme.copyWith(
          selectedItemColor: themeData.primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: themeData.elevatedButtonTheme.style!.copyWith(
            backgroundColor: WidgetStatePropertyAll(themeData.primaryColor),
          ),
        ),
      ),
      getPages: pages,
      translations: I18NTranslations(),
      locale: Locale(
        'fa',
        ['direct', 'web', 'google-play']
                .contains(CONSTANTS.FLAVOR.toLowerCase())
            ? 'dating'
            : 'social',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa"),
      ],
    );
  }
}
