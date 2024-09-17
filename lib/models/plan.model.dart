class PlanModel {
  final int id;
  final String title;
  final String description;
  final String sku;
  final String category;
  final int discount;
  final int price;
  final int finalPrice;
  final int usable_days;
  final int usable_count;

  PlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sku,
    required this.category,
    required this.discount,
    required this.price,
    required this.finalPrice,
    required this.usable_count,
    required this.usable_days,
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
      usable_count: json['usable_count'],
      usable_days: json['usable_days'],
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
    json['usable_count'] = usable_count;
    json['usable_days'] = usable_days;

    return json;
  }
}
