import 'package:chat/futures/purchase/futures/card-by-card.view.dart';
import 'package:chat/futures/purchase/futures/invoice.step.view.dart';
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
      () => PopScope(
        canPop: controller.index.value == 0,
        onPopInvokedWithResult: (_, __) {
          if (controller.index.value == 0) {
            Get.back(canPop: true);
          } else {
            controller.back();
          }
        },
        child: Scaffold(
          appBar: GradientAppBarWidget(
            back: true,
            title: controller.title.value,
            onBack: () {
              if (controller.index.value == 0) {
                Get.back(canPop: true);
              } else {
                controller.back();
              }
            },
            left: TextButton(
              onPressed: () {
                Get.toNamed('/page/plans');
              },
              child: const Text(
                'راهنمای بسته ها',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          bottomNavigationBar: footer(),
          body: IndexedStack(
            index: controller.index.value,
            children: [
              plans(),
              PurchaseInvoiceView(
                invoice: controller.invoice.value,
                selectedPaymentMethod: controller.selectedPaymentMethod.value,
                onSelectPaymentMethod: (String id) {
                  controller.selectPaymentMethod(id);
                },
              ),
              PurchaseCardByCardView(
                formKey: controller.cardByCardFormKey,
              ),
            ],
          ),
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
            Gap(Get.bottomBarHeight + 32),
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
        duration: const Duration(milliseconds: 300),
        height: controller.finalSelectedPlansPrice.value == 0
            ? 0
            : 72 + Get.mediaQuery.padding.bottom,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 0,
              right: 0,
              bottom: controller.finalSelectedPlansPrice.value == 0
                  ? (72 + Get.mediaQuery.padding.bottom) * -1
                  : 0,
              child: AnimatedContainer(
                height: 72 + Get.mediaQuery.padding.bottom,
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: Get.mediaQuery.padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                duration: const Duration(milliseconds: 300),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: TextStyle(
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: controller.disabled.value
                          ? null
                          : () {
                              controller.next();
                            },
                      style: ButtonStyle(
                        elevation: const WidgetStatePropertyAll(0),
                        minimumSize: const WidgetStatePropertyAll(
                          Size(160, 48),
                        ),
                        backgroundColor: controller.disabled.value
                            ? const WidgetStatePropertyAll(Colors.transparent)
                            : WidgetStatePropertyAll(Get.theme.primaryColor),
                      ),
                      child: controller.disabled.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              controller.button.value,
                              style: const TextStyle(
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
