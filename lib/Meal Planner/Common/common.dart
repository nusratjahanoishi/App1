import 'package:intl/intl.dart';
import 'globals.dart' as global;

String getTime(int value, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(
      DateTime.fromMillisecondsSinceEpoch(value * 60 * 1000, isUtc: true));
}

String getStringDateToOtherFormate(String dateStr,
    {String inputFormatStr = "dd/MM/yyyy hh:mm aa",
    String outFormatStr = "hh:mm a"}) {
  var format = DateFormat(outFormatStr);
  return format.format(stringToDate(dateStr, formatStr: inputFormatStr));
}

DateTime stringToDate(String dateStr, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.parse(dateStr);
}

DateTime dateToStartDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String dateToString(DateTime date, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(date);
}

List<Map<String, dynamic>> getIndexArr(String key) {
  List<Map<String, dynamic>> result = [];
  switch (key) {
    case "Breakfast":
      result = global.breakfastArr;
      break;
    case "Lunch":
      result = global.lunchArr;
      break;
    case "Dinner":
      result = global.dinnerArr;
      break;
    case "Dessert":
      result = global.dessertArr;
      break;
    default:
      result = global.breakfastArr;
      break;
  }
  return result;
}

void setIndexArr(String key, List<Map<String, dynamic>> list) {
  switch (key) {
    case "Breakfast":
      global.breakfastArr = list;
      break;
    case "Lunch":
      global.lunchArr = list;
      break;
    case "Dinner":
      global.dinnerArr = list;
      break;
    case "Dessert":
      global.dessertArr = list;
      break;
    default:
      global.breakfastArr = list;
      break;
  }
}

String getDayTitle(String dateStr, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var date = stringToDate(dateStr, formatStr: formatStr);

  if (date.isToday) {
    return "Today";
  } else if (date.isTomorrow) {
    return "Tomorrow";
  } else if (date.isYesterday) {
    return "Yesterday";
  } else {
    var outFormat = DateFormat("E");
    return outFormat.format(date);
  }
}

extension DateHelpers on DateTime {
  bool get isToday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 0;
  }

  bool get isYesterday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == -1;
  }

  bool get isTomorrow {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 1;
  }
}
