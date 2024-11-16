import 'package:shamsi_date/shamsi_date.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatAgoChat(String value) {
  String format(int value) => value < 9 ? '0$value' : value.toString();

  var date = Jalali.fromDateTime(DateTime.parse(value));
  var today = Jalali.now();

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return '${format(date.hour)}:${format(date.minute)}';
  }

  return "${date.year}/${format(date.month)}/${format(date.day)}";
}

String formatAgoChatMessage(String value) {
  String format(int value) => value < 9 ? '0$value' : value.toString();

  var date = Jalali.fromDateTime(DateTime.parse(value));

  return "${date.year}/${format(date.month)}/${format(date.day)} ${format(date.hour)}:${format(date.minute)}";
}

String formatAgo(String value) {
  timeago.setLocaleMessages('fa', timeago.FaMessages());
  return timeago.format(DateTime.parse(value), locale: 'fa');
}
