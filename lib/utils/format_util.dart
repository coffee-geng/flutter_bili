//格式化时间（总秒数）为hh:mm:ss
String durationTransform(int second) {
  int hh = (second / 3600).truncate();
  int mm = ((second - hh * 60) / 60).truncate();
  int ss = second - hh * 3600 - mm * 60;
  String m = mm < 10 ? '0$mm' : '$mm';
  String s = ss < 10 ? '0$ss' : '$ss';
  return '$hh:$mm:$ss';
}

//格式化数字
String countFormat(int count) {
  if (count > 9999) {
    return '${(count / 10000).toStringAsFixed(2)}万';
  } else {
    return count.toString();
  }
}
