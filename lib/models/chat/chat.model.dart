class ChatItemModel {
  late String? id;
  late String? avatar;
  late String? fullname;
  late String? status; // deleted/left
  late String? messageType;
  late dynamic messageData;
  late int? count;
  late String? sentAt;
  late String? last;
  late String? seen; // online/recently/offline

  ChatItemModel({
    this.id,
    this.status,
    this.avatar,
    this.fullname,
    this.messageType,
    this.messageData,
    this.count,
    this.sentAt,
    this.last,
    this.seen,
  });
}
