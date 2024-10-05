import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/widgets/avatar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UserWidget extends StatefulWidget {
  final ProfileSearchModel item;

  const UserWidget({super.key, required this.item});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // showSnackbar(message: 'باز شدن صفحه پروفایل');
        Get.toNamed(
          '/profile/${widget.item.id}',
          arguments: {
            'id': widget.item.id,
            'options': true,
          },
        );
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
              url: widget.item.avatar!,
              seen: widget.item.seen!,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.item.fullname!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(6),
                      if (widget.item.verified == true)
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                  const Gap(10),
                  Text('${widget.item.age} ساله'),
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
                      Text(widget.item.city!),
                    ],
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Opacity(
                          opacity: 0,
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
                          opacity: widget.item.ad == true ? 1.0 : 0.0,
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
                          opacity: widget.item.special == true ? 1.0 : 0.0,
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
}
