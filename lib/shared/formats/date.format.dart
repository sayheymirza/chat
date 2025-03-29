import 'package:shamsi_date/shamsi_date.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatAgoChat(String? value) {
  return formatAgo(value!);
}

String formatAgoChatMessage(String value) {
  String format(int value) => value < 9 ? '0$value' : value.toString();

  var date = Jalali.fromDateTime(DateTime.parse(value));

  // return "${date.year}/${format(date.month)}/${format(date.day)} ${format(date.hour)}:${format(date.minute)}";

  // day name day number month name year ساعت hour:minute:seconds
  return '${date.formatter.wN} ${date.day} ${date.formatter.mN} ${date.year} ساعت ${format(date.hour)}:${format(date.minute)}';
}

String formatAgo(String value) {
  try {
    timeago.setLocaleMessages('fa', timeago.FaMessages());
    var output = timeago.format(DateTime.parse(value), locale: 'fa');
    output = output.replaceAll('~', '');
    return output;
  } catch (e) {
    return '';
  }
}
