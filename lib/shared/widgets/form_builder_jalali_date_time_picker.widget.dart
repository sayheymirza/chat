import 'package:chat/app/shared/theme.dart';
import 'package:chat/shared/vibration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

// ignore: must_be_immutable
class FormBuilderJalaliDateTimePicker extends StatelessWidget {
  final String label;
  final String name;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final bool enabled;

  TextEditingController controller = TextEditingController();

  FormBuilderJalaliDateTimePicker({
    super.key,
    required this.label,
    required this.name,
    this.decoration = const InputDecoration(),
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String?>(
      name: name,
      validator: validator,
      builder: (field) {
        if (field.value != null) {
          controller.text = field.value!;
        }

        return TextFormField(
          enabled: enabled,
          controller: controller,
          decoration: decoration.copyWith(
            suffixIcon: const Icon(Icons.calendar_today),
            errorText: field.errorText,
          ),
          readOnly: true,
          onTap: () {
            Get.bottomSheet(
              _DialogJalaliDateTimePicker(
                label: label,
                value: field.value,
              ),
            ).then((value) {
              if (value == null) {
                var now = Jalali.now();
                value = '${now.year}/${now.month}/${now.day}';
              }

              controller.text = value;
              field.didChange(value);
            });
          },
        );
      },
    );
  }
}

class _DialogJalaliDateTimePicker extends StatefulWidget {
  final String label;
  final String? value;

  const _DialogJalaliDateTimePicker({
    required this.label,
    required this.value,
  });

  @override
  State<_DialogJalaliDateTimePicker> createState() =>
      __DialogJalaliDateTimePickerState();
}

class __DialogJalaliDateTimePickerState
    extends State<_DialogJalaliDateTimePicker> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 360,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          LinearDatePicker(
            initialDate: widget.value ?? '',
            addLeadingZero: true,
            dateChangeListener: (String selectedDate) {
              value = selectedDate;
              setState(() {});
              vibrate(duration: 35);
            },
            showDay: true, //false -> only select year & month
            labelStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: 14.0,
              color: Colors.grey.shade500,
            ),
            selectedRowStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
            unselectedRowStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16.0,
              color: Colors.grey.shade600,
            ),
            yearText: "سال",
            monthText: "ماه",
            dayText: "روز",
            showLabels: true, // to show column captions, eg. year, month, etc.
            columnWidth: 100,
            showMonthName: true,
            isJalaali: true, // false -> Gregorian
          ),
          const Spacer(),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back(result: value);
              },
              child: const Text(
                'انتخاب',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
