import 'package:flutter/cupertino.dart';
import 'package:flutter_bar_plugin/monitor.dart';
import 'package:flutter_bar_plugin/position.dart';

import 'flutter_bar_plugin.dart';

class BarSettings {
  final ValueNotifier<int> barSize = ValueNotifier(100);
  final ValueNotifier<String> monitorName = ValueNotifier("");
  final ValueNotifier<Position> barPosition = ValueNotifier(Position.TOP);

  final List<Monitor> monitors = [];

  static final BarSettings _singleton = BarSettings._internal();

  factory BarSettings() {
    return _singleton;
  }

  init() async {
    monitors.addAll(await FlutterBarPlugin.getMonitors);
    monitors.sort((m1, m2) => m1.x.compareTo(m2.x));
  }

  BarSettings._internal() {
    barSize.addListener(_upgradeBar);
    barPosition.addListener(_upgradeBar);
    monitorName.addListener(_upgradeBar);
  }

  _upgradeBar() async {
    final position = barPosition.value;
    final size = barSize.value;
    final monitorN = monitorName.value;

    final monitors = await FlutterBarPlugin.getMonitors;

    final monitor =
        monitors.where((element) => element.name == monitorN).toList();
    if (monitor.isEmpty) {
      print("Cannot find monitor with name $monitorN");
      return;
    }

    await FlutterBarPlugin.setStruts(position, monitor.first, size);
  }
}
