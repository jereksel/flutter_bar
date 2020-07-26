import 'package:flutter_bar_plugin/monitor.dart';
import 'package:flutter_bar_plugin/position.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'flutter_bar_plugin.dart';

class BarSettings {
  final BehaviorSubject<int> _barSize =
      BehaviorSubject(); // ignore: close_sinks
  final BehaviorSubject<MonitorPredicate> _monitorPredicate =
      BehaviorSubject(); // ignore: close_sinks
  final BehaviorSubject<Position> _barPosition =
      BehaviorSubject(); // ignore: close_sinks
  final BehaviorSubject<String> _barFont =
      BehaviorSubject(); // ignore: close_sinks
  final BehaviorSubject<int> _fontSize =
      BehaviorSubject(); // ignore: close_sinks

  final List<Monitor> monitors = [];

  static final BarSettings _singleton = BarSettings._internal();

  factory BarSettings() {
    return _singleton;
  }

  setBarSize(int size) {
    _barSize.value = size;
  }

  setMonitorPredicate(MonitorPredicate predicate) {
    _monitorPredicate.value = predicate;
  }

  setBarPosition(Position position) {
    _barPosition.value = position;
  }

  setBarFont(String fontName) {
    _barFont.value = fontName;
  }

  setFontSize(int size) {
    _fontSize.value = size;
  }

  Stream<int> get barSize => _barSize.stream;

  Stream<MonitorPredicate> get monitorPredicate => _monitorPredicate.stream;

  Stream<Position> get barPosition => _barPosition.stream;

  Stream<String> get barFont => _barFont.stream;

  Stream<int> get fontSize => _fontSize.stream;

  init() async {
//    monitors.addAll(await FlutterBarPlugin.getMonitors);
  }

  BarSettings._internal() {
    Rx.combineLatest3(
      _barSize,
      _barPosition,
      _monitorPredicate,
      (a, b, c) => Tuple3(a, b, c),
    ).listen((event) {
      _upgradeBar(event.item1, event.item2, event.item3);
    });
  }

  _upgradeBar(int barSize, Position barPosition,
      MonitorPredicate monitorPredicate) async {
    final monitors = await FlutterBarPlugin.getMonitors;

    final monitor = monitors.where(monitorPredicate).toList();
    if (monitor.isEmpty) {
      print("Cannot find monitor for predicate");
      return;
    }

    await FlutterBarPlugin.setStruts(barPosition, monitor.first, barSize);
  }
}
