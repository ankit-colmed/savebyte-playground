extension NumExtensions on num {
  Duration get milliseconds => Duration(milliseconds: toInt());

  Duration get seconds => Duration(seconds: toInt());

  Duration get minutes => Duration(minutes: toInt());

  Duration get hours => Duration(hours: toInt());

  Duration get days => Duration(days: toInt());
}