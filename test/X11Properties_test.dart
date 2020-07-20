import 'dart:io';

import 'package:flutter_bar_plugin/X11Properties.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final propertyName = "_TEST_PROPERTY";

  setUp(() async {
    await Process.run("xprop", ["-root", "-remove", propertyName]);
  });

  tearDown(() async {
//    await Process.run("xprop", ["-root", "-remove", propertyName]);
  });

  test('Get single cardinal', () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "32c", "-set", propertyName, "1"]);

    final propertyListener = CardinalPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals(1));
  });

  test("Get list of 8 bit numbers", () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "8c", "-set", propertyName, "1,2,3,4"]);

    final propertyListener = IntegerArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals([1, 2, 3, 4]));
  }, skip: true);

  test("Get list of cardinals", () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "32c", "-set", propertyName, "1,2,3,4"]);

    final propertyListener = IntegerArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals([1, 2, 3, 4]));
  });

  test("Get list of UTF-8 strings", () async {
    await Process.run(
        "python", ["xproperty/xproperty.py", propertyName, "1", "2", "a", "b"]);
    final propertyListener = StringArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals(["1", "2", "a", "b"]));
  });
}
