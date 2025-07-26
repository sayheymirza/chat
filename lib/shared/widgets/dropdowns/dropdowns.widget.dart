import 'dart:developer';

import 'package:chat/shared/widgets/dropdowns/dropdowns.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'form_builder_dropdown.dart';

class DropdownsWidget extends GetView<DropdownsWidgetController> {
  final String group;
  final String? parentId;
  final String name;
  final bool sort;
  final InputDecoration decoration;
  final List<DropdownMenuItem<String>>? items;
  final FormFieldValidator<dynamic>? validator;
  final Function(Object?)? onChange;

  const DropdownsWidget({
    super.key,
    required this.name,
    required this.group,
    required this.decoration,
    this.parentId,
    this.sort = true,
    this.items,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(DropdownsWidgetController());
    FocusNode focusNode = FocusNode();

    if (items == null) {
      controller.load(group: group, parentId: parentId).then((_) {
        log('Loaded dropdown for $group about ${controller.items.length} items');
      });

      return Obx(
        () => FormBuilderDropdown<String>(
          focusNode: focusNode,
          dropdownColor: Colors.white,
          name: name,
          decoration: decoration,
          onReset: () {
            controller.load(group: group, parentId: parentId);
          },
          items: controller.items.isEmpty
              ? []
              : controller.items
                  .map((e) => e as DropdownMenuItem<String>)
                  .toList(),
          onChanged: onChange == null
              ? null
              : (value) => value == null ? null : onChange!(value),
          validator: validator,
        ),
      );
    } else {
      return FormBuilderDropdown<String>(
        focusNode: focusNode,
        dropdownColor: Colors.white,
        name: name,
        decoration: decoration,
        items: items!,
        onReset: () {
          controller.load(group: group, parentId: parentId);
        },
        onChanged: onChange == null
            ? null
            : (value) => value == null ? null : onChange!(value),
        validator: validator,
      );
    }
  }
}
