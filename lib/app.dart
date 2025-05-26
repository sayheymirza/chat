import 'package:chat/app/shared/i18n.dart';
import 'package:chat/app/shared/theme.dart';
import 'package:chat/pages.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/navigation_bar_height.dart';
import 'package:chat/shared/web_back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    var val = getNavigationBarHeight(context);

    if (navigationBarHeight == 0) {
      navigationBarHeight = val;
    }

    return WebBackHandler(
      child: GetMaterialApp(
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
      ),
    );
  }
}
