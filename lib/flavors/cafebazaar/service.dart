import 'dart:async';
import 'dart:developer';

import 'package:chat/abstracts/flavor.abstract.dart';
import 'package:chat/flavors/cafebazaar/flutter_poolakey/lib/flutter_poolakey.dart';
import 'package:chat/models/event.model.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/event.dart';
import 'package:chat/shared/services.dart';
import 'package:flutter/services.dart';

class FlavorCafebazaar extends FlavorAbstract {
  @override
  listen() {
    event.on<EventModel>().listen((data) {
      if (data.event == EVENTS.FEEDBACK) {
        feedback();
      }
      if (data.event == EVENTS.SHOW_APP_IN_STORE) {
        showAppInStore();
      }
      if (data.event == EVENTS.UPDATE) {
        update();
      }
      if (data.event == EVENTS.PURCHASE) {
        purchase(data.value, (value) {
          Services.event.fire(
            event: EVENTS.PURCHASE_RESULT,
            value: value,
          );
        });
      }

      if (data.event == EVENTS.PURCHASE_NOT_CONSUMED) {
        listOfNotConsumed();
      }
    });
  }

  @override
  void feedback() async {
    var packageInfo = await Services.access.generatePackageInfo();

    var url = "bazaar://details?id=${packageInfo.packageName}";

    Services.launch.launch(url);
  }

  @override
  void showAppInStore() async {
    var packageInfo = await Services.access.generatePackageInfo();

    var url = "bazaar://details?id=${packageInfo.packageName}";

    Services.launch.launch(url);
  }

  @override
  void purchase(
    EventParchaseParamsModel params,
    Function(EventParchaseResultModel result) callback,
  ) async {
    connectToPoolakey(onConnect: () async {
      try {
        print(params.sku);
        print(await Services.access.generate());

        PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase(
          params.sku,
          dynamicPriceToken: params.jwt,
          payload: params.payload,
        );

        if (purchaseInfo.purchaseToken != null) {
          return callback(
            EventParchaseResultModel.success(
              params.sku,
              params.jwt,
              purchaseInfo.purchaseToken,
            ),
          );
        }

        callback(
          EventParchaseResultModel.failed(params.sku),
        );
      } on PlatformException catch (e) {
        if (e.code == "PURCHASE_CANCELLED") {
          return callback(
            EventParchaseResultModel.close(params.sku),
          );
        }

        callback(
          EventParchaseResultModel.failed(params.sku),
        );
      }
    }, onError: () {
      callback(
        EventParchaseResultModel.failed(params.sku),
      );
    });
  }

  @override
  void update() async {
    var packageInfo = await Services.access.generatePackageInfo();

    var url = "bazaar://details/modal?id=${packageInfo.packageName}";

    Services.launch.launch(url);
  }

  Future<bool> connectToPoolakey({
    Function? onConnect,
    Function? onError,
  }) async {
    Completer<bool> c = Completer<bool>();
    try {
      var rsa = Services.configs.get(key: CONSTANTS.CAFEBAZAAR_RSA);

      await FlutterPoolakey.connect(
        rsa,
        onConnectSuccess: () {
          log('[cafebazaar/service.dart] connected');
          if (onConnect != null) {
            onConnect();
          }
          c.complete(true);
        },
        onConnectFailed: () {
          log('[cafebazaar/service.dart] connect failed');
          if (onError != null) {
            onError();
          }
          c.complete(false);
        },
        onDisconnected: () {
          log('[cafebazaar/service.dart] disconnected');
          if (onError != null) {
            onError();
          }
          c.complete(false);
        },
      );
    } catch (e) {
      print(e);
      c.complete(false);
      //
    }

    return c.future;
  }

  void listOfNotConsumed() {
    connectToPoolakey(onConnect: () async {
      try {
        var result = await FlutterPoolakey.getAllPurchasedProducts();

        if (result.isNotEmpty) {
          var purchases = result.map((e) {
            return EventParchaseResultModel.success(
              e.productId,
              null,
              e.purchaseToken,
            );
          }).toList();

          Services.event.fire(
            event: EVENTS.PURCHASE_NOT_CONSUMED_LIST,
            value: purchases,
          );
        }
      } catch (e) {
        //
      }
    }, onError: () {
      //
    });
  }
}
