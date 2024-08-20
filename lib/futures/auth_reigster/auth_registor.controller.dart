import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AuthRegisterController extends GetxController {
  RxInt step = 0.obs;
  GlobalKey<FormBuilderState> registerFormKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep1FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep2FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep3FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep4FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep5FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep6FormKey =
      GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> registerStep7FormKey =
      GlobalKey<FormBuilderState>();
  RxBool disabled = false.obs;
  RxMap<String, List> dropdownsItems = {
    'gender': [],
    'BirthDateYear': [],
    'BirthDateMounth': [],
    'BirthDateDay': [],
    'weight': [],
    'height': [],
    'children': [],
    'maxAge': [],
    'marital': [],
    'color': [],
    'beauty': [],
    'shape': [],
    'health': [],
    'education': [],
    'living': [],
    'salary': [],
    'car': [],
    'home': [],
    'province': [],
    'religion': [],
    'marriageType': [],
  }.obs;

  Future<void> loadDropdowns() async {
    var keys = dropdownsItems.keys;

    var query = database.select(database.dropdownTable);

    query.where((row) => row.groupKey.isIn(keys));
    query.orderBy(
      [
        (row) =>
            OrderingTerm(expression: row.orderIndex, mode: OrderingMode.asc),
      ],
    );

    var result = await query.get();

    // ignore: invalid_use_of_protected_member
    var output = dropdownsItems.value;

    for (var element in result) {
      output[element.groupKey]!.add(
        DropdownMenuItem<String>(
          value: element.value,
          child: Text(element.name),
        ),
      );
    }

    dropdownsItems.value = output;
  }

  Future<void> submit() async {
    // if (!registerStep1FormKey.currentState!.saveAndValidate()) return;

    if (step < 7) {
      step.value += 1;
      return;
    }

    if (registerFormKey.currentState!.saveAndValidate() == false) return;

    try {
      disabled.value = true;

      var result = await ApiService.auth.forgot(
        username: registerFormKey.currentState!.value['phone'],
      );

      showSnackbar(message: result.message);

      disabled.value = false;
      if (result.success) {
        Get.offAndToNamed('/auth/login');
      }
    } catch (e) {
      print(e);

      disabled.value = false;
    }
  }
}
