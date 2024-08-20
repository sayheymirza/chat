import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/env.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:chat/shared/validator.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  RxBool visablePassword = false.obs;
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
  RxList cities = [].obs;

  @override
  void onInit() {
    super.onInit();

    loadDropdowns();
  }

  Future<void> setCitiesByProvider(String value) async {
    var query = database.select(database.dropdownTable);

    query.where((row) => row.groupKey.equals("city"));
    query.where((row) => row.parentId.equals(value));
    query.orderBy(
      [
        (row) =>
            OrderingTerm(expression: row.orderIndex, mode: OrderingMode.asc),
      ],
    );

    var result = await query.get();

    var output = [];

    for (var element in result) {
      output.add(
        DropdownMenuItem<String>(
          value: element.value,
          child: Text(element.name),
        ),
      );
    }

    cities.value = output;

    log('[auth_register.controller.dart] ${output.length} cities for province $value loaded');
  }

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

    log('[auth_register.controller.dart] all dropdowns loaded');
  }

  Future<void> submit() async {
    if (step.value == 0 &&
        !registerStep1FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 1 &&
        !registerStep2FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 2 &&
        !registerStep3FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 3 &&
        !registerStep4FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 4 &&
        !registerStep5FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 5 &&
        !registerStep6FormKey.currentState!.saveAndValidate()) return;
    if (step.value == 6 &&
        !registerStep7FormKey.currentState!.saveAndValidate()) return;

    if (step < 6) {
      step.value += 1;
      return;
    }

    try {
      disabled.value = true;

      var result = await ApiService.auth.register(value: value);

      showSnackbar(message: result.message);

      if (result.token != null) {
        // store token
        GetStorage().write(ENV.STORAGE_ACCESS_TOKEN, result.token);

        Get.offAllNamed('/app');
      }

      disabled.value = false;
    } catch (e) {
      print(e);

      disabled.value = false;
    }
  }

  Map<String, String?> get value {
    try {
      Map<String, String?> output = {
        "name": registerStep1FormKey.currentState!.value['name'],
        "gender": registerStep1FormKey.currentState!.value['gender'],
        "year": registerStep2FormKey.currentState!.value['year'],
        "month": registerStep2FormKey.currentState!.value['month'],
        "day": registerStep2FormKey.currentState!.value['day'],
        "marital": registerStep3FormKey.currentState!.value['marital'],
        "children": registerStep3FormKey.currentState!.value['children'],
        "maxAge": registerStep3FormKey.currentState!.value['maxAge'],
        "height": registerStep2FormKey.currentState!.value['height'],
        "weight": registerStep2FormKey.currentState!.value['weight'],
        "color": registerStep4FormKey.currentState!.value['color'],
        "shape": registerStep4FormKey.currentState!.value['shape'],
        "beauty": registerStep4FormKey.currentState!.value['beauty'],
        "health": registerStep4FormKey.currentState!.value['health'],
        "education": registerStep4FormKey.currentState!.value['education'],
        "job": registerStep5FormKey.currentState!.value['job'],
        "living": registerStep5FormKey.currentState!.value['living'],
        "salary": registerStep5FormKey.currentState!.value['salary'],
        "car": registerStep5FormKey.currentState!.value['car'],
        "home": registerStep5FormKey.currentState!.value['home'],
        "province": registerStep6FormKey.currentState!.value['province'],
        "city": registerStep6FormKey.currentState!.value['city'],
        "religion": registerStep6FormKey.currentState!.value['religion'],
        "marriageType":
            registerStep6FormKey.currentState!.value['marriageType'],
        "about": registerStep6FormKey.currentState!.value['about'],
        "phone": registerStep7FormKey.currentState!.value['phone'],
        "password": CustomValidator.convertPN2EN(
          registerStep7FormKey.currentState!.value['password'],
        ),
      };

      return output;
    } catch (e) {
      print(e);
      return {};
    }
  }
}
