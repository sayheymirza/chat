import 'dart:developer';

import 'package:chat/app/apis/api.dart';
import 'package:chat/models/profile.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:chat/shared/services.dart';
import 'package:chat/shared/snackbar.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  RxInt index = 10.obs;

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
  RxList cities = [].obs;

  @override
  void onReady() {
    super.onReady();

    loadDropdowns().then((_) {
      return Future.delayed(const Duration(milliseconds: 100));
    }).then((_) {
      patchFormValueFromProfile();
    });
  }

  void patchFormValueFromProfile() {
    var profile = Services.profile.profile.value!;

    var value = {
      "name": profile.fullname,
      "year": profile.dropdowns!['year'].toString(),
      "month": profile.dropdowns!['month'].toString(),
      "day": profile.dropdowns!['day'].toString(),
      "marital": profile.dropdowns!['marital'].toString(),
      "children": profile.dropdowns!['children'].toString(),
      "maxAge": profile.dropdowns!['maxAge'].toString(),
      "height": profile.dropdowns!['height'].toString(),
      "weight": profile.dropdowns!['weight'].toString(),
      "color": profile.dropdowns!['color'].toString(),
      "shape": profile.dropdowns!['shape'].toString(),
      "beauty": profile.dropdowns!['beauty'].toString(),
      "health": profile.dropdowns!['health'].toString(),
      "education": profile.dropdowns!['education'].toString(),
      "living": profile.dropdowns!['living'].toString(),
      "salary": profile.dropdowns!['salary'].toString(),
      "car": profile.dropdowns!['car'].toString(),
      "home": profile.dropdowns!['home'].toString(),
      "province": profile.dropdowns!['province'].toString(),
      "religion": profile.dropdowns!['religion'].toString(),
      "marriageType": profile.dropdowns!['marriageType'].toString(),
      "job": profile.job,
      "about": profile.about,
    };

    formKey.currentState!.patchValue(value);

    setCitiesByProvider(profile.dropdowns!['province']).then((_) {
      return Future.delayed(const Duration(milliseconds: 100));
    }).then((_) {
      formKey.currentState!.patchValue({
        "city": profile.dropdowns!['city'].toString(),
      });
    });

    log('[profile_edit.controller.dart] patch form value from profile');
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

    log('[profile_edit.controller.dart] ${output.length} cities for province $value loaded');
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

    log('[profile_edit.controller.dart] all dropdowns loaded');
  }

  Future<void> submit() async {
    if (disabled.value) return;

    if (!formKey.currentState!.saveAndValidate()) return;

    try {
      disabled.value = true;

      var value = formKey.currentState!.value;

      var result = await ApiService.user.update(
        ProfileModel(
          fullname: value['name'],
          job: value['job'],
          about: value['about'],
          dropdowns: value,
        ),
      );

      showSnackbar(message: result.message);
      disabled.value = false;
    } catch (e) {
      disabled.value = false;
      //
    }
  }
}
