import 'package:chat/app/apis/api.dart';
import 'package:chat/models/home.model.dart';
import 'package:chat/shared/widgets/home/card_about_welcome_plan.widget.dart';
import 'package:chat/shared/widgets/home/card_dynamic.widget.dart';
import 'package:chat/shared/widgets/home/card_earning_income.widget.dart';
import 'package:chat/shared/widgets/home/card_enable_welcome_plan.widget.dart';
import 'package:chat/shared/widgets/home/card_new_version.widget.dart';
import 'package:chat/shared/widgets/home/card_profile_need_update.widget.dart';
import 'package:chat/shared/widgets/home/home_profile_list.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // List of home components
  RxList<Widget> components = RxList.empty(growable: true);

  Future<void> fetch() async {
    try {
      var result = await ApiService.data.home();

      components.clear();

      for (var element in result) {
        switch (element.type) {
          case 'list-profile#1':
            HomeComponentListProfileV1Model data = element.data;

            components.add(
              HomeProfileListWidget(
                title: data.title,
                icon: data.icon,
                buttonText: data.buttonText,
                buttonType: data.buttonType,
                profiles: data.profiles,
                emptyText: data.emptyText,
              ),
            );
            break;

          case 'card-enable-welcome-plan#1':
            components.add(CardEnableWelcomePlanWidget());
            break;

          case 'card-about-welcome-plan#1':
            components.add(CardAboutWelcomePlanWidget());
            break;

          case 'card-earning-income#1':
            components.add(CardEarningIncomeWidget());
            break;

          case 'card-new-version#1':
            components.add(CardNewVersionWidget());
            break;

          case 'card-profile-need-update#1':
            components.add(CardProfileNeedUpdateWidget());
            break;

          case 'card-dynamic#1':
            CardDynamicV1Model data = element.data;

            components.add(
              CardDynamicWidget(
                gradientColors: data.gradientColors,
                title: data.title,
                titleColor: data.titleColor,
                subtitle: data.subtitle,
                subtitleColor: data.subtitleColor,
                buttonVisable: data.buttonVisable,
                closeable: data.closeable,
              ),
            );
            break;

          default:
        }
      }
    } catch (e) {
      //
    }
  }
}
