import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserWidget extends StatelessWidget {
  final ProfileSearchModel item;
  final Function onTap;

  const UserWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Services.user.saveFromSearch(profile: item);
    var opacity = Services.user.seen(userId: item.id!);

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          children: [
            // avatar
            AvatarWidget(
              key: ValueKey(item.avatar), // اضافه کردن key بر اساس url
              url: item.avatar!,
              seen: item.seen!,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.fullname!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(6),
                      if (item.verified == true)
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.blue,
                          size: 20,
                        ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Text('${item.age} ساله'),
                      const Gap(10),
                      liking(),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 32,
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.blue,
                        size: 18,
                      ),
                      const Gap(5),
                      Text(item.city!),
                    ],
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Opacity(
                          opacity: opacity,
                          child: Icon(
                            Icons.visibility,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Opacity(
                          opacity: item.ad == true ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Opacity(
                          opacity: item.special == true ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget liking() {
    return Row(
      children: [
        Icon(
          Icons.thumb_up_alt_rounded,
          color: Colors.green,
          size: 14,
        ),
        const Gap(4),
        Text(
          (item.relationCount?.likes ?? 0).toString(),
          style: TextStyle(fontSize: 12),
        ),
        const Gap(10),
        Icon(
          Icons.thumb_down_alt_rounded,
          color: Colors.red,
          size: 14,
        ),
        const Gap(4),
        Text(
          (item.relationCount?.dislikes ?? 0).toString(),
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
