import 'package:chat/futures/purchase/futures/card-by-card.view.dart';
import 'package:chat/futures/purchase/futures/factor.step.view.dart';
import 'package:chat/futures/purchase/futures/list-plans.widget.dart';
import 'package:chat/futures/purchase/futures/support-card.widget.dart';
import 'package:chat/futures/purchase/one-step.controller.dart';
import 'package:chat/futures/purchase/purchase.controller.dart';
import 'package:chat/models/plan.model.dart';
import 'package:chat/shared/formats/number.format.dart';
import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PurchaseOneStepView extends GetView<PurchaseOneStepController> {
  const PurchaseOneStepView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PurchaseController());
    Get.put(PurchaseOneStepController());

    controller.loadPlans();

    return Obx(
      () => Scaffold(
        appBar: GradientAppBarWidget(
          back: true,
          title: controller.title.value,
          onBack: () {
            if (controller.index.value == 0) {
              Get.back();
            } else {
              controller.back();
            }
          },
        ),
        bottomNavigationBar: footer(),
        body: IndexedStack(
          index: controller.index.value,
          children: [
            plans(),
            PurchaseFactorView(),
            PurchaseCardByCardView(),
          ],
        ),
      ),
    );
  }

  Widget plans() {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            const PurchaseSupportCardWidget(),
            const Gap(12),
            ExpansionPanelList(
              elevation: 0,
              expansionCallback: (int index, bool isExpanded) {
                controller.setExpanded(isExpanded ? index + 1 : 0);
              },
              children: [
                expansion(
                  expanded: controller.expanded.value == 1,
                  icon: Image.asset('lib/app/assets/images/star.png'),
                  title: "بسته آگهی ویژه",
                  subtitle: "نمایش به عنوان آگهی ویژه در صفحه اول",
                  plans: controller.plans
                      .where((element) => element.category == "ads")
                      .toList(),
                  selectedPlans: controller.selectedPlans.value,
                ),
                expansion(
                  expanded: controller.expanded.value == 2,
                  icon: const Icon(
                    Icons.star_rate,
                    color: Colors.yellow,
                  ),
                  title: "بسته عضویت ویژه",
                  subtitle: "ارسال نامحدود پیام خصوصی",
                  plans: controller.plans
                      .where((element) => element.category == "vip")
                      .toList(),
                  selectedPlans: controller.selectedPlans.value,
                ),
                expansion(
                  expanded: controller.expanded.value == 3,
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.blue,
                  ),
                  title: "بسته پیامکی",
                  subtitle: "ارسال پیامک دعوت به گفتگو",
                  plans: controller.plans
                      .where((element) => element.category == "sms")
                      .toList(),
                  selectedPlans: controller.selectedPlans.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanel expansion({
    required bool expanded,
    required Widget icon,
    required String title,
    required String subtitle,
    required List<PlanModel> plans,
    required List<int> selectedPlans,
  }) {
    return ExpansionPanel(
      isExpanded: expanded,
      canTapOnHeader: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      headerBuilder: (context, isExpanded) => ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        child: PurchaseListPlans(
          items: plans,
          selected: selectedPlans,
          onToggle: (id) {
            controller.togglePlansById(id);
          },
        ),
      ),
    );
  }

  Widget footer() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: controller.finalSelectedPlansPrice.value == 0
            ? 0
            : Get.bottomBarHeight + Get.mediaQuery.padding.bottom,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: 0,
              right: 0,
              bottom: controller.finalSelectedPlansPrice.value == 0
                  ? Get.bottomBarHeight * -1
                  : 0,
              child: AnimatedContainer(
                height: Get.bottomBarHeight + Get.mediaQuery.padding.bottom,
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: Get.mediaQuery.padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مبلغ قابل پرداخت',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            '${formatPrice(controller.finalSelectedPlansPrice.value)} تومان',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.next();
                      },
                      style: const ButtonStyle(
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      child: const Text(
                        'مرحله بعد و پرداخت',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
