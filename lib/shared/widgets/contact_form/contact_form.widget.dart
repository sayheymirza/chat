import 'package:chat/shared/widgets/dropdowns/dropdowns.widget.dart';
import 'package:chat/shared/widgets/form_builder_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

class ContactFormWidget extends StatelessWidget {
  final bool showEmail;
  final bool disabled;
  final GlobalKey<FormBuilderState> formKey;

  const ContactFormWidget({
    super.key,
    this.showEmail = false,
    this.disabled = false,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      enabled: !disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownsWidget(
            group: 'MessageType',
            name: 'reciver',
            decoration: const InputDecoration(
              labelText: 'دریافت کننده',
            ),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
              ],
            ),
          ),
          const Gap(20),
          FormBuilderTextField(
            name: "title",
            decoration: const InputDecoration(
              labelText: "عنوان",
            ),
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
              ],
            ),
          ),
          const Gap(20),
          if (showEmail)
            FormBuilderTextField(
              name: "email",
              decoration: const InputDecoration(
                labelText: "آدرس ایمیل",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.email(),
                ],
              ),
            ),
          if (showEmail) const Gap(20),
          FormBuilderTextField(
            name: 'description',
            decoration: const InputDecoration(
              labelText: 'توضیحات',
            ),
            minLines: 2,
            maxLines: 4,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(10),
              ],
            ),
          ),
          const Gap(20),
          const FormBuilderImage(
            name: 'image',
            labelText: "تصویری را انتخاب کنید (اختیاری)",
          )
        ],
      ),
    );
  }
}
