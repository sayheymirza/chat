class InvoicePlanModel {
  final String title;
  final int price;

  InvoicePlanModel({
    required this.title,
    required this.price,
  });
}

class PlanModel {
  final int id;
  final String title;
  final String description;
  final String sku;
  final String category;
  final int discount;
  final int price;
  final int finalPrice;
  final int usableDays;
  final int usableCount;

  PlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sku,
    required this.category,
    required this.discount,
    required this.price,
    required this.finalPrice,
    required this.usableCount,
    required this.usableDays,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sku: json['sku'],
      category: json['category'],
      discount: json['discount'],
      price: json['price'],
      finalPrice: json['finalPrice'],
      usableCount: json['usableCount'],
      usableDays: json['usableDays'],
    );
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['sku'] = sku;
    json['category'] = category;
    json['discount'] = discount;
    json['price'] = price;
    json['finalPrice'] = finalPrice;
    json['usableCount'] = usableCount;
    json['usableDays'] = usableDays;

    return json;
  }
}

class PlanInvoiceModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final int discount;
  final int price;
  final int discountPrice;
  final int finalPrice;
  final String startAt;
  final String endAt;

  PlanInvoiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.discount,
    required this.price,
    required this.discountPrice,
    required this.finalPrice,
    required this.startAt,
    required this.endAt,
  });
}
