import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PurchaseListPlans extends StatelessWidget {
  final List<PlanModel> items;
  final List<int> selected;
  final Function(int id) onToggle;

  const PurchaseListPlans({
    super.key,
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items
            .map(
              (item) => GestureDetector(
                onTap: () {
                  onToggle(item.id);
                },
                child: plan(
                  item: item,
                  selected: selected.contains(item.id),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget plan({
    required PlanModel item,
    required bool selected,
  }) {
    String? badge;

    if (item.usableDays > 0) {
      badge = '${item.usableDays} روزه';
    }

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 100,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey.shade300,
        ),
        gradient: !selected
            ? null
            : LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.pink.shade400,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : null,
                ),
              ),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red.shade100,
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
          const Gap(20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "قیمت فقط",
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                      const Gap(8),
                      if (item.discount != 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${item.discount}%',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(4),
                  if (item.discount != 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${formatPrice(item.finalPrice)} تومان',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          formatPrice(item.price),
                          style: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  if (item.discount == 0)
                    Text(
                      '${formatPrice(item.finalPrice)} تومان',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: null,
                child: Text(
                  !selected ? 'خرید این بسته' : 'انتخاب شده',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
