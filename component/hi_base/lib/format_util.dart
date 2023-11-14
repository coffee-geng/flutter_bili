//格式化时间（总秒数）为hh:mm:ss
import 'package:intl/intl.dart';

String durationTransform(int second) {
  int hh = (second / 3600).truncate();
  int mm = ((second - hh * 60) / 60).truncate();
  int ss = second - hh * 3600 - mm * 60;
  String m = mm < 10 ? '0$mm' : '$mm';
  String s = ss < 10 ? '0$ss' : '$ss';
  return '$hh:$mm:$ss';
}

//格式化数字转万
String countFormat(int count) {
  if (count > 9999) {
    return '${(count / 10000).toStringAsFixed(2)}万';
  } else {
    return count.toString();
  }
}

//日期格式化，2022-06-11 20:06:43 -> 06-11
String dateToMonthAndDay(String dateStr) {
  if (dateStr == null) return '';
  try {
    DateTime date = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('MM-dd');
    String formatted = formatter.format(date);
    return formatted;
  } on Exception catch (e) {
    return '';
  }
}
