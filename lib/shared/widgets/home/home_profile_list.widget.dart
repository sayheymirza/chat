import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/user.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              if (icon == "one-star")
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              if (icon == "two-star")
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset('lib/app/assets/images/star.png'),
                ),
              if (icon == "fire")
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset('lib/app/assets/images/fire.png'),
                ),
              if (icon == "eye")
                const Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
              const Gap(8),
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
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(56, 32)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8),
                  ),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Colors.grey.shade400,
                    ),
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
            onTap: () {
              Get.toNamed(
                '/app/profile/${item.id}',
                arguments: {
                  'id': item.id,
                  'options': true,
                },
              );
            },
          ),
      ],
    );
  }
}
