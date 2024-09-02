import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(
        right: 32,
        left: 32,
      ),
      child: Row(
        children: List.generate(
          count,
          (index) {
            return Row(
              children: [
                AnimatedContainer(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
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
                    width: 32,
                    height: 2,
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
