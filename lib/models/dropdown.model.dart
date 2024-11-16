class DropdownModel {
  int id;
  String name;
  String value;
  String groupKey;
  int orderIndex;
  String? parentId;

  DropdownModel({
    required this.id,
    required this.name,
    required this.value,
    required this.groupKey,
    required this.orderIndex,
    required this.parentId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['groupKey'] = groupKey;
    data['orderIndex'] = orderIndex;
    data['parentId'] = parentId;
    return data;
  }
}
