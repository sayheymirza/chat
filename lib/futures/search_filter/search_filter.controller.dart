import 'dart:developer';

import 'package:chat/models/apis/user.model.dart';
import 'package:chat/shared/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  GlobalKey<FormBuilderState> searchFilterFormKey =
      GlobalKey<FormBuilderState>();

  RxMap<String, List> dropdownsItems = {
    'marital': [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('هر وضعیتی'),
      ),
    ],
    'province': [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('همه استان ها'),
      ),
    ],
    'age': [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('هر سنی'),
      ),
    ],
  }.obs;
  RxList cities = [
    const DropdownMenuItem<String>(
      value: null,
      child: Text('همه شهر ها'),
    ),
  ].obs;

  void patchValue(ApiUserSearchFilterRequestModel filter) {
    Future.delayed(const Duration(milliseconds: 100), () {
      searchFilterFormKey.currentState!.patchValue(filter.toJson());

      // if province was not null, load cities
      if (filter.province != null) {
        setCitiesByProvider(filter.province!);
      }
    });

    log('[search_filter.controller.dart] patch value');
  }

  void submit() {
    searchFilterFormKey.currentState!.save();

    // values from form
    var values = searchFilterFormKey.currentState!.value;

    Get.back(
      result: ApiUserSearchFilterRequestModel.fromForm(
        values,
      ),
    );
  }

  void reset() {
    searchFilterFormKey.currentState!.reset();

    log('[search_filter.controller.dart] rest form value');
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

    var output = [
      const DropdownMenuItem<String>(
        value: null,
        child: Text('همه شهر ها'),
      ),
    ];

    for (var element in result) {
      output.add(
        DropdownMenuItem<String>(
          value: element.value,
          child: Text(element.name),
        ),
      );
    }

    cities.value = output;

    log('[search_filter.controller.dart] ${output.length} cities for province $value loaded');
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

    log('[search_filter.controller.dart] all dropdowns loaded');
  }
}
