import 'dart:io';

import 'package:flutter/widgets.dart';

@immutable
class MemInfo {
  final int totalRam;
  final int freeRam;
  final int availableRam;

  MemInfo(
      {@required this.totalRam,
        @required this.freeRam,
        @required this.availableRam});
}

MemInfo getMemoryInfo() {
  final memInfo = File("/proc/meminfo");

  int memTotal = -1;
  int memFree = -1;
  int memAvailable = -1;

  memInfo.readAsLinesSync().forEach((line) {
    final data =
        line.split(" ").where((element) => element.isNotEmpty).toList();

    final name = data[0];

    if (name == "MemTotal:") {
      memTotal = int.parse(data[1]);
    } else if (name == "MemFree:") {
      memFree = int.parse(data[1]);
    } else if (name == "MemAvailable:") {
      memAvailable = int.parse(data[1]);
    }
  });

  assert(memTotal != -1);
  assert(memFree != -1);
  assert(memAvailable != -1);

  return MemInfo(totalRam: memTotal, freeRam: memFree, availableRam: memAvailable);

}
