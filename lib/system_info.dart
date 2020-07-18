import 'dart:io';

import 'CAPI.dart';

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
