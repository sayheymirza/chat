import 'package:chat/app/apis/api.dart';
import 'package:chat/models/home.model.dart';
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
              ),
            );
            break;
          default:
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
