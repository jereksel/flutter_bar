
import 'package:flutter/widgets.dart';

@immutable
class Monitor {
  final String name;
  final int x;
  final int y;
  final int width;
  final int height;
  final bool primary;

  const Monitor(this.name, this.x, this.y, this.width, this.height, this.primary);

  Monitor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        x = json['x'],
        y = json['y'],
        width = json['width'],
        height = json['height'],
        primary = json['primary'];


  @override
  String toString() {
    return 'Monitor{name: $name, x: $x, y: $y, width: $width, height: $height, primary: $primary}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Monitor &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height &&
          primary == other.primary;

  @override
  int get hashCode =>
      name.hashCode ^
      x.hashCode ^
      y.hashCode ^
      width.hashCode ^
      height.hashCode ^
      primary.hashCode;
}

typedef MonitorPredicate = bool Function(Monitor);

MonitorPredicate any() {
  return (monitor) => true;
}

MonitorPredicate primary() {
  return (monitor) => monitor.primary;
}

MonitorPredicate byName(String name) {
  return (monitor) => monitor.name == name;
}