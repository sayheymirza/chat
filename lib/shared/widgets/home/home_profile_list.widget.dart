import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeProfileListWidget extends StatelessWidget {
  final String title;
  final String icon;
  final String buttonText;
  final String buttonType;
  final List<ProfileSearchModel> profiles;

  const HomeProfileListWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonText,
    required this.buttonType,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (icon.isNotEmpty) Container(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  Get.toNamed('/app/search/$buttonType');
                },
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(56, 32)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (var item in profiles)
          UserWidget(
            item: item,
          ),
      ],
    );
  }
}
