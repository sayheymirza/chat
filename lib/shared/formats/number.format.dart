import 'dart:math';

import 'package:intl/intl.dart';

int formatDiscount({int price = 0, int discount = 0}) {
  return (price - ((price * discount) / 100)).toInt();
}

int formatToDiscount({int price = 0, int discount = 0}) {
  return (discount * 100) ~/ price;
}

String formatPriceDiscount({int price = 0, int discount = 0}) {
  return formatPrice(formatDiscount(price: price, discount: discount));
}

final currency = NumberFormat.currency(
  locale: 'fa',
);

String formatPrice(int price) {
  return currency.format(price).replaceAll('IRR', '');
}

int formatVersion(String version) {
  List<int> ver = version.split('.').map((e) => int.parse(e)).toList();

  var r = 0;

  for (var i = 1; i <= ver.length; i++) {
    var j = pow(10, i).toInt();
    var v = ver[ver.length - i];
    r += (v * j);
  }

  return r;
}
