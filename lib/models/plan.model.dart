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
}

/**
 * "id": 4,
        "title": "بسته عضویت ویژه ۱۸۰ روزه",
        "description": "ارسال نامحدود پیام خصوصی به مدت ۱۸۰ روز",
        "sku": "VIP_180_DAY",
        "currency": "IRT",
        "category": "vip",
        "usable_days": 180,
        "price": 359000,
        "final_price": 359000,
        "discount": 0,
        "usable_count": 0
 */