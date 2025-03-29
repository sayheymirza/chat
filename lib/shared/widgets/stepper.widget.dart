import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepperWidget extends StatelessWidget {
  final int count;
  final int current;

  const StepperWidget({
    super.key,
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    var width = ((Get.width - 64) - (count * 28)) / (count - 1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          count,
          (index) {
            return Row(
              children: [
                AnimatedContainer(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= current
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (index != count - 1)
                  Container(
                    width: width,
                    height: 3,
                    color: index <= current
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
