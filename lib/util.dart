import 'dart:math';

import 'package:intl/intl.dart';
import 'entity.dart';

parseStats(String text) {
  var stats = Stats(0, 0, 0);
  var p = RegExp(r"time='(.*?)';flow='(.*?)';fsele=1;fee='(.*?)'");
  try {
    var m = p.firstMatch(text.replaceAll(" ", ""));
    stats.time = int.parse(m.group(1));
    stats.flow = int.parse(m.group(2));
    stats.fee = int.parse(m.group(3));
  } catch (e) {}
  return stats;
}

double log10(double value) {
  return log(value) / log(10);
}

formatSize(num size) {
  if (size <= 0) return "0";
  var byte = size * 1024.0;
  const units = ["B", "KB", "MB", "GB", "TB"];
  var digitGroups = log10(byte) ~/ log10(1000.0);
  return NumberFormat("#,##0.##").format(byte / pow(1000, digitGroups)) + " " + units[digitGroups];
}
