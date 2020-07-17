// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bar_plugin/monitor.dart';
import 'package:flutter_bar_plugin/position.dart';
import 'package:flutter_bar_plugin/strut.dart';

class FlutterBarPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bar_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<Monitor>> get getMonitors async {
    final List<dynamic> monitors =
        await _channel.invokeListMethod('getMonitors');

    return monitors
        .map((e) => Monitor.fromJson(Map.from(e)))
        .toList(growable: false);
  }

  static Future<void> disableTopBar() async {
    await _channel.invokeMethod("disableTopBar");
  }

  static Future<void> setStruts(
      Position position, Monitor monitor, int barSize) async {
    int x, y, width, height;
    PartialStrut struts;

    switch (position) {
      case Position.TOP:
        x = monitor.x;
        y = monitor.y;
        width = monitor.width;
        height = barSize;
        struts = PartialStrut(
            top: barSize + monitor.y, top_start_x: x, top_end_x: x + width - 1);
        break;
      case Position.BOTTOM:
        x = monitor.x;
        y = monitor.y + monitor.height - barSize;
        width = monitor.width;
        height = barSize;
        struts = PartialStrut(
            bottom: barSize, bottom_start_x: x, bottom_end_x: x + width - 1);
        break;
    }

    await _channel.invokeMethod(
        'setStruts', [x, y, width, height, struts.toStrutArray()]);
  }
}
