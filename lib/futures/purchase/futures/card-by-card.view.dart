import 'package:chat/shared/widgets/credit_card.widget.dart';
import 'package:chat/shared/widgets/form_builder_image.widget.dart';
import 'package:chat/shared/widgets/form_builder_jalali_date_time_picker.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

class PurchaseCardByCardView extends StatelessWidget {
  final GlobalKey formKey;

  const PurchaseCardByCardView({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CreditCardWidget(),
          const Gap(50),
          const Text(
            'پس از انتقال وجه قابل پرداخت به شماره کارت ذکر شده فرم زیر را ثبت کنید تا اسرع وقت پلن مورد نظر در پروفایلتان فعال گردد.',
          ),
          const Gap(20),
          FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderJalaliDateTimePicker(
                  label: "تاریخ پرداخت",
                  name: "date",
                  decoration: const InputDecoration(
                    labelText: "تاریخ پرداخت",
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    // all fields are dropdown with empty array
                    Expanded(
                      child: FormBuilderDropdown(
                        dropdownColor: Colors.white,
                        name: 'hour',
                        decoration: const InputDecoration(
                          labelText: 'ساعت',
                        ),
                        items: List.generate(
                          24,
                          (index) => DropdownMenuItem(
                            value: '$index',
                            child: Text('$index'),
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: FormBuilderDropdown(
                        dropdownColor: Colors.white,
                        name: 'minute',
                        decoration: const InputDecoration(
                          labelText: 'دقیقه',
                        ),
                        items: List.generate(
                          60,
                          (index) => DropdownMenuItem(
                            value: '$index',
                            child: Text('$index'),
                          ),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    // all fields are dropdown with empty array
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'tracking',
                        decoration: const InputDecoration(
                          labelText: 'شماره پیگیری',
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'card',
                        decoration: const InputDecoration(
                          labelText: '۴ شماره آخر کارت',
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(
                    labelText: 'توضیحات',
                  ),
                  minLines: 2,
                  maxLines: 4,
                ),
                const Gap(16),
                FormBuilderImage(
                  name: 'image',
                  labelText: "تصویر فیش را انتخاب کنید",
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
